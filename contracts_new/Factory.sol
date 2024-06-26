// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./Spad.sol";
import "./ISpadActions.sol";

contract Factory is Pausable, Ownable {
    address spadImplementation;
    address actionsAddress;
    mapping(string => bool) existingSymbols;
    address[] public spads;
    mapping (address => bool) validCurrencies;
    mapping (address => bool) validSpads;

    event SpadCreated(address indexed initiator, address spadAddress);
    event SpadPrivateCreated(address indexed initiator, address spadAddress);
    
    constructor() {
        // validCurrencies[0x9c94b31734027AE4c60A7C4cD3c2cF2A5e5e684e] = true;
        // validCurrencies[0xDE91D97721A2635adea1674732c86977953A0746] = true;
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
        existingSymbols[_symbol] = true;
        if(_currencyAddress != address(0)) {
            require(validCurrencies[_currencyAddress] == true, "invalid currency");
        }
        
        Spad spad = new Spad(_name, _symbol, msg.sender, _target, _minInvestment, _maxInvestment, _currencyAddress, actionsAddress);
        spads.push(address(spad));
        validSpads[address(spad)] = true;
        ISpadActions(actionsAddress).addSpad(address(spad), passKey);
        if(keccak256(abi.encodePacked(passKey)) != keccak256(abi.encodePacked(""))) {
            emit SpadPrivateCreated(msg.sender, address(spad));
        } else {
            emit SpadCreated(msg.sender, address(spad));
        }
    }

}