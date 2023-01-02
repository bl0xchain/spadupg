// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "./Spad.sol";
import "./ISpadActions.sol";

contract Factory is Initializable, PausableUpgradeable, OwnableUpgradeable {
    address spadImplementation;
    address actionsAddress;
    mapping(string => bool) existingSymbols;
    address[] public spads;
    mapping (address => bool) validCurrencies;
    mapping (address => bool) validSpads;

    event SpadCreated(address indexed initiator, address spadAddress);
    
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __Pausable_init();
        __Ownable_init();
        validCurrencies[0x98339D8C260052B7ad81c28c16C0b98420f2B46a] = true;
        validCurrencies[0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844] = true;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function updateValidCurrency(address _currencyAddress, bool _isValid) public onlyOwner {
        validCurrencies[_currencyAddress] = _isValid;
    }

    function setActionsAddress(address _actionsAddress) public onlyOwner {
        actionsAddress = _actionsAddress;
    }

    function IsValidSpad(address spadAddress) public view returns (bool) {
        return validSpads[spadAddress];
    }

    function createSpad(string memory _name, string memory _symbol, uint _target, uint _minInvestment, uint _maxInvestment, address _currencyAddress, string memory passKey) public {
        require(existingSymbols[_symbol] == false, "duplicate symbol");
        if(_currencyAddress != address(0)) {
            require(validCurrencies[_currencyAddress] == true, "invalid currency");
        }
        existingSymbols[_symbol] = true;
        spadImplementation = address(new Spad());
        ERC1967Proxy proxy = new ERC1967Proxy(
            spadImplementation,
            abi.encodeWithSelector(Spad(address(0)).initialize.selector, _name, _symbol, msg.sender, _target, _minInvestment, _maxInvestment, _currencyAddress, actionsAddress)
        );
        spads.push(address(proxy));
        validSpads[address(proxy)] = true;
        ISpadActions(actionsAddress).addSpad(address(proxy), passKey);
        emit SpadCreated(msg.sender, address(proxy));
    }

}