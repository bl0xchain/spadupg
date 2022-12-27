// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./SpadToken.sol";
import "./IFactory.sol";
import "./ISpad.sol";
import "./ISpadFund.sol";
import "./ISpadPitch.sol";

contract SpadActions is Initializable, PausableUpgradeable, OwnableUpgradeable {
    address private factoryAddress;
    address private fundAddress;
    address private pitchAddress;

    event SpadActivated(address spadAddress);
    event Contributed(address indexed spadAddress, address indexed contributor, uint amount);
    event PitchProposed(address indexed spadAddress, address indexed pitcher);
    event PitchReviewed(address indexed spadAddress, address indexed pitcher, bool approved);
    event InvestmentClaimed(address indexed spadAddress, address indexed contributor, uint amount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _factoryAddress) initializer public {
        __Pausable_init();
        __Ownable_init();
        factoryAddress = _factoryAddress;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function setModuleAddresses(address _fundAddress, address _pitchAddress ) public onlyOwner {
        fundAddress = _fundAddress;
        pitchAddress = _pitchAddress;
    }

    function addSpad(address spadAddress) public {
        require(msg.sender == factoryAddress, "not allowed");
        ISpadFund(fundAddress).addSpad(spadAddress);
        ISpadPitch(pitchAddress).addSpad(spadAddress);
    }

    function activateSpad(address spadAddress) public payable {
        require(ISpadFund(fundAddress).activateSpad(spadAddress, msg.sender) == true, "error");
        ISpad spad = ISpad(spadAddress);
        uint amount = (spad.target() * 10 / 100);
        if(spad.currencyAddress() != address(0)) {
            IERC20(spad.currencyAddress()).transferFrom(msg.sender, address(this), amount);
        } else {
            require(msg.value == amount, "invalid contribution");
        }
        spad.updateStatus(2);
        emit SpadActivated(spadAddress);
    }

    function contribute(address spadAddress, uint amount) public payable {
        uint currentInvestment;
        (currentInvestment, ) = ISpadFund(fundAddress).getFundData(spadAddress);
        require(ISpadFund(fundAddress).contribute(spadAddress, amount, msg.sender) == true, "error");
        ISpad spad = ISpad(spadAddress);
        if(spad.currencyAddress() != address(0)) {
            IERC20(spad.currencyAddress()).transferFrom(msg.sender, address(this), amount);
        } else {
            require(msg.value == amount, "invalid contribution");
        }
        if(currentInvestment + amount == spad.target()) {
            spad.updateStatus(4);
        }
        emit Contributed(spadAddress, msg.sender, amount);
    }

    function pitchSpad(address spadAddress, string memory name, string memory description, address tokenAddress, uint tokenAmount) public {
        require(ISpadFund(fundAddress).getContribution(spadAddress, msg.sender) == 0, "not allowed");
        require(ISpadPitch(pitchAddress).pitchSpad(spadAddress, name, description, tokenAddress, tokenAmount, msg.sender) == true, "error");
        emit PitchProposed(spadAddress, msg.sender);
    }
    
    function getPitch(address spadAddress) public view returns (string memory name, string memory description, uint8 status, address tokenAddress, uint tokenAmount) {
        return ISpadPitch(pitchAddress).getPitch(spadAddress, msg.sender);
    }

    function pitchReview(address spadAddress, address pitcher, bool approved) public {
        ISpad spad = ISpad(spadAddress);
        require(msg.sender == spad.creator(), "not allowed");
        uint pitchStatus = ISpadPitch(pitchAddress).pitchReview(spadAddress, pitcher, approved);
        require(pitchStatus > 1, "error");
        if(pitchStatus == 2) {
            if(spad.currencyAddress() != address(0)) {
                IERC20(spad.currencyAddress()).transfer(pitcher, spad.target());
            } else {
                payable(pitcher).transfer(spad.target());
            }
            spad.updateStatus(5);
        }
        emit PitchReviewed(spadAddress, pitcher, approved);
    }

    function claimPitch(address spadAddress) public {
        require(ISpadPitch(pitchAddress).claimPitch(spadAddress, msg.sender) == true, "error");
        address tokenAddress;
        uint tokenAmount;
        (tokenAddress, tokenAmount) = ISpadPitch(pitchAddress).getPitchToken(spadAddress, msg.sender);
        ISpad spad = ISpad(spadAddress);
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), tokenAmount);
        if(spad.currencyAddress() != address(0)) {
            IERC20(spad.currencyAddress()).transfer(msg.sender, spad.target());
        } else {
            payable(msg.sender).transfer(spad.target());
        }
        spad.updateStatus(5);
    }

    function claimTokens(address spadAddress) public {
        ISpad spad = ISpad(spadAddress);
        ISpadPitch spadPitch = ISpadPitch(pitchAddress);
        require(spad.status() == 5, "cannot claim");
        address tokenAddress;
        uint tokenAmount;
        address acquiredBy = spadPitch.getAcquiredBy(spadAddress);
        (tokenAddress, tokenAmount) = spadPitch.getPitchToken(spadAddress, acquiredBy);
        require(IERC20(tokenAddress).balanceOf(msg.sender) == 0, "already claimed");
        uint contribution = ISpadFund(fundAddress).getContribution(spadAddress, msg.sender);
        require(contribution > 0, "not contributor");
        uint _amount = (contribution * tokenAmount) / spad.target();
        IERC20(tokenAddress).transfer(msg.sender, _amount);
        emit InvestmentClaimed(spadAddress, msg.sender, _amount);
    }
}