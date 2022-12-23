// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.17;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./SPADActionsInterface.sol";

contract SPAD is OwnableUpgradeable, ERC20Upgradeable {
    uint public target;
    uint public currentInvestment;
    uint public minInvestment;
    uint public maxInvestment;
    address public spadInitiator;
    uint8 public status; // 1:PENDING, 2:LIVE, 3:EXPIRED, 4:CLOSED, 5:ACQUIRED
    string private passKey;
    bool public isPrivate;
    address spadActionController;
    address public currencyAddress;
    uint public created;
    uint8 private decimal;
    uint public totalTokens;

    event StatusUpdated(uint8 status);
    event CurrentInvestmentUpdated(uint investment);
    event InvestmentClaimed(address indexed contributor, uint amount);

    function initialize(string memory name, string memory symbol, uint _totalSupply, address _spadInitiator, uint _target, uint _minInvestment, uint _maxInvestment, string memory _passKey, address _currencyAddress, address _spadActionController) public initializer {
        __ERC20_init(name, symbol);
        __Ownable_init();
        
        target = _target;
        minInvestment = _minInvestment;
        maxInvestment = _maxInvestment;
        spadInitiator = _spadInitiator;
        spadActionController = _spadActionController;
        passKey = _passKey;
        if(_currencyAddress != address(0)) {
            decimal = IERC20MetadataUpgradeable(_currencyAddress).decimals();
        } else {
            decimal = 18;
        }
        // _mint(_spadActionController, _totalSupply);
        totalTokens = _totalSupply;
        if(keccak256(abi.encodePacked(_passKey)) != keccak256(abi.encodePacked(""))) {
            isPrivate = true;
        }
        currencyAddress = _currencyAddress;
        status = 1;
        created = block.timestamp;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function decimals() public view virtual override returns (uint8) {
        return decimal;
    }

    function checkPassKey(string memory _passKey) public view returns (bool) {
        return (keccak256(abi.encodePacked(_passKey)) == keccak256(abi.encodePacked(passKey)));
    }

    function isController() internal view {
        require(msg.sender == spadActionController, "not allowed");
    }

    function updateStatus(uint8 _status) public {
        isController();
        status = _status;
        emit StatusUpdated(_status);
    }

    function updateCurrentInvestment(uint _currentInvestment) public {
        isController();
        currentInvestment = _currentInvestment;
        emit CurrentInvestmentUpdated(currentInvestment);
    }

    function claimTokens() public {
        require(status == 5, "cannot claim");
        require(balanceOf(msg.sender) == 0, "already claimed");
        uint contribution = SPADActionsInterface(spadActionController).getContribution(address(this), msg.sender);
        require(contribution > 0, "cannot claim");
        uint _amount = (contribution * totalTokens) / target;
        _mint(msg.sender, _amount);
        emit InvestmentClaimed(msg.sender, _amount);
    }
}