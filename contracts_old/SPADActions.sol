// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./SPADInterface.sol";

contract SPADActions is Initializable {
    address spadFactoryAddress;
    mapping(address => SPADMeta) spads;
    mapping(address => address[]) investedSpads;
    mapping(address => address[]) initiatedSpads;

    // spad status = 1:PENDING, 2:LIVE, 3:EXPIRED, 4:CLOSED, 5:ACQUIRED

    struct SPADMeta {
        bool exists;
        mapping (address => uint) investments;
        // mapping(address => bool) claimed;
        mapping(address => Pitch) pitches;
        uint currentInvestment;
        address[] pitchers;
        uint investorCount;
        address acquiredBy;
        address currencyAddress;
    }

    struct Pitch {
        string name;
        string description;
        uint8 status; // 0:invalid, 1:proposed, 2:approved, 3:rejected, 4:selected
        address tokenAddress;
        uint tokenAmount;
    }

    event SpadAdded(address indexed spadAddress);
    event SpadActivated(address indexed spadAddress);
    event Contributed(address indexed spadAddress, address indexed contributor, uint amount);
    event PitchProposed(address indexed spadAddress, address indexed pitcher);
    event PitchReviewed(address indexed spadAddress, address indexed pitcher, bool approved);
    // event InvestmentClaimed(address indexed spadAddress, address indexed contributor, uint amount);

    function initialize(address _spadFactoryAddress) public initializer {
        spadFactoryAddress = _spadFactoryAddress;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function getInvestorCount(address _spadAddress) public view returns (uint) {
        SPADMeta storage spadMeta = spads[_spadAddress];
        return spadMeta.investorCount;
    }

    function getAcquiredBy(address _spadAddress) public view returns (address) {
        SPADMeta storage spadMeta = spads[_spadAddress];
        return spadMeta.acquiredBy;
    }

    function addSpad(address _spadAddress, address _currencyAddress, address _spadInitiator) public {
        require(msg.sender == spadFactoryAddress, "not allowed");
        require(spads[_spadAddress].exists == false, "already exists");
        SPADMeta storage spadMeta = spads[_spadAddress];
        spadMeta.exists = true;
        spadMeta.currencyAddress = _currencyAddress;
        initiatedSpads[_spadInitiator].push(_spadAddress);
        emit SpadAdded(_spadAddress);
    }

    function getSpad(address _spadAddress) internal view returns (SPADInterface) {
        require(spads[_spadAddress].exists == true, "not found");
        return SPADInterface(_spadAddress);
    }

    function activate(address _spadAddress, string memory _description) public payable {
        SPADInterface spad = getSpad(_spadAddress);
        
        require(spad.status() == 1, "cannot activate");
        require(msg.sender == spad.spadInitiator(), "not allowed");
        uint target = spad.target();
        uint amount = (target * 10 / 100);
        
        
        SPADMeta storage spadMeta = spads[_spadAddress];

        if(spadMeta.currencyAddress != address(0)) {
            IERC20Upgradeable(spadMeta.currencyAddress).transferFrom(msg.sender, address(this), amount);
        } else {
            require(msg.value == amount, "invalid contribution");
        }

        if(spad.isPrivate()) {
            require(bytes(_description).length > 0, "description needed");
            Pitch storage pitch = spadMeta.pitches[msg.sender];
            pitch.name = "Pitch from SPAD Initiator";
            pitch.description = _description;
            pitch.status = 2; // approved
            spadMeta.pitchers.push(msg.sender);
        }
        spadMeta.investments[msg.sender] = (target * 10 / 100);
        spadMeta.investorCount = 1;
        spad.updateCurrentInvestment(spadMeta.investments[msg.sender]);
        spadMeta.currentInvestment = spadMeta.investments[msg.sender];
        spad.updateStatus(2);

        emit SpadActivated(_spadAddress);
    }

    function contribute(address _spadAddress, uint _amount, string memory _passKey) public payable {
        SPADInterface spad = getSpad(_spadAddress);
        require(spad.checkPassKey(_passKey), "incorrect passkey");
        uint currentInvestment = spad.currentInvestment();
        uint target = spad.target();
        require((currentInvestment + _amount) <= target, "target overflow");
        SPADMeta storage spadMeta = spads[_spadAddress];
        require(spadMeta.investorCount <= 99, "investor overflow");
        require(spad.maxInvestment() >= (spadMeta.investments[msg.sender] + _amount), "max investment overflow");
        if(target - currentInvestment >= spad.minInvestment()) {
            require((spadMeta.investments[msg.sender] + _amount) >= spad.minInvestment(), "min investment underflow");
        }
        
        if(spadMeta.currencyAddress != address(0)) {
            IERC20Upgradeable(spadMeta.currencyAddress).transferFrom(msg.sender, address(this), _amount);
        } else {
            require(msg.value == _amount, "invalid contribution");
        }

        if(spadMeta.investments[msg.sender] == 0) {
            spadMeta.investorCount++;
            investedSpads[msg.sender].push(_spadAddress);
        }
        spadMeta.investments[msg.sender] = spadMeta.investments[msg.sender] + _amount;
        currentInvestment += _amount;
        spad.updateCurrentInvestment(currentInvestment);
        spadMeta.currentInvestment = currentInvestment;
        if(currentInvestment == target) {
            if(spad.isPrivate()) {
                if(spadMeta.currencyAddress != address(0)) {
                    IERC20Upgradeable(spadMeta.currencyAddress).transfer(spad.spadInitiator(), spad.target());
                } else {
                    payable(spad.spadInitiator()).transfer(spad.target());
                }
                spad.updateStatus(5);
                spadMeta.acquiredBy = spad.spadInitiator();
            } else {
                spad.updateStatus(4);
            }
        }
        emit Contributed(_spadAddress, msg.sender, _amount);
    }

    function getContribution(address _spadAddress, address _contributor) public view returns (uint) {
        SPADMeta storage spadMeta = spads[_spadAddress];
        return spadMeta.investments[_contributor];
    }

    function getPitchesCount(address _spadAddress) public view returns (uint) {
        require(spads[_spadAddress].exists == true, "not found");
        SPADMeta storage spadMeta = spads[_spadAddress];
        return spadMeta.pitchers.length;
    }

    function getPitchers(address _spadAddress) public view returns (address[] memory) {
        require(spads[_spadAddress].exists == true, "not found");
        SPADMeta storage spadMeta = spads[_spadAddress];
        return spadMeta.pitchers;
    }

    function pitchSpad(address _spadAddress, string memory _name, string memory _description, address _tokenAddress, uint _tokenAmount) public {
        SPADInterface spad = getSpad(_spadAddress);
        // require(spad.checkPassKey(_passKey), "incorrect passkey");
        require(spad.status() == 4, "cannot pitch");
        SPADMeta storage spadMeta = spads[_spadAddress];
        require(spadMeta.investments[msg.sender] == 0, "cannot pitch");
        require(spadMeta.pitches[msg.sender].status == 0, "already pitched");
        if(_tokenAddress != address(0)) {
            require(IERC20Upgradeable(_tokenAddress).totalSupply() > 0, "invalid token");
        }
        // token.transferFrom(msg.sender, address(this), spadPitchFee);
        Pitch storage pitch = spadMeta.pitches[msg.sender];
        pitch.name = _name;
        pitch.description = _description;
        pitch.status = 1; // proposed
        pitch.tokenAddress = _tokenAddress;
        pitch.tokenAmount = _tokenAmount;
        spadMeta.pitchers.push(msg.sender);
        emit PitchProposed(_spadAddress, msg.sender);
    }

    function getPitch(address _spadAddress) public view returns (string memory name, string memory description, uint8 status, address tokenAddress, uint tokenAmount) {
        SPADMeta storage spadMeta = spads[_spadAddress];
        Pitch memory pitch = spadMeta.pitches[msg.sender];
        return (pitch.name, pitch.description, pitch.status, pitch.tokenAddress, pitch.tokenAmount);
    }

    function pitchReview(address _spadAddress, address _pitcher, bool _approved) public {
        SPADInterface spad = getSpad(_spadAddress);
        require(msg.sender == spad.spadInitiator(), "not allowed");
        SPADMeta storage spadMeta = spads[_spadAddress];
        require(spadMeta.pitches[_pitcher].status == 1, "invalid/already pitched");
        Pitch storage pitch = spadMeta.pitches[_pitcher];
        if(_approved) {
            if(pitch.tokenAddress != address(0)) {
                pitch.status = 2;
                if(spadMeta.currencyAddress != address(0)) {
                    IERC20Upgradeable(spadMeta.currencyAddress).transfer(_pitcher, spad.target());
                } else {
                    payable(_pitcher).transfer(spad.target());
                }
                spad.updateStatus(5);
                spadMeta.acquiredBy = _pitcher;
            } else {
                pitch.status = 4;
            }
        } else {
            pitch.status = 3;
        }
        emit PitchReviewed(_spadAddress, _pitcher, _approved);
    }

    function claimPitch(address _spadAddress) public {
        SPADInterface spad = getSpad(_spadAddress);
        SPADMeta storage spadMeta = spads[_spadAddress];
        Pitch storage pitch = spadMeta.pitches[msg.sender];
        require(pitch.status == 4, "not allowed");
        IERC20Upgradeable(pitch.tokenAddress).transferFrom(msg.sender, address(spad), pitch.tokenAmount);
        pitch.status = 2;
        if(spadMeta.currencyAddress != address(0)) {
            IERC20Upgradeable(spadMeta.currencyAddress).transfer(msg.sender, spad.target());
        } else {
            payable(msg.sender).transfer(spad.target());
        }
        spad.updateStatus(5);
        spadMeta.acquiredBy = msg.sender;
    }

    // function claimInvestment(address _spadAddress) public {
    //     SPADInterface spad = getSpad(_spadAddress);
    //     require(spad.status() == 5, "cannot claim");
    //     SPADMeta storage spadMeta = spads[_spadAddress];
    //     require(spadMeta.investments[msg.sender] > 0, "cannot claim");
    //     require(spadMeta.claimed[msg.sender] == false, "already claimed");
    //     // IERC20Upgradeable spadToken = IERC20Upgradeable(spad.spadToken());
    //     uint _amount = (spadMeta.investments[msg.sender] * spad.totalSupply()) / spad.target();
    //     spad.transferFrom(address(this), msg.sender, _amount);
    //     spadMeta.claimed[msg.sender] = false;
    //     emit InvestmentClaimed(_spadAddress, msg.sender, _amount);
    // }

    // function isInvestmentClaimed(address _spadAddress) public view returns (bool) {
    //     SPADMeta storage spadMeta = spads[_spadAddress];
    //     require(spadMeta.investments[msg.sender] > 0, "cannot claim");
    //     return spadMeta.claimed[msg.sender];
    // }

    function getInvestedSpads() public view returns (address[] memory) {
        return investedSpads[msg.sender];
    }

    function getInitiatedSpads() public view returns (address[] memory) {
        return initiatedSpads[msg.sender];
    }
}