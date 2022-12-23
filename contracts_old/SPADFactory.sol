// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.17;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "./SPAD.sol";
import "./SPADActionsInterface.sol";

contract SPADFactory is Initializable, OwnableUpgradeable {
    address spadImplementation;
    SPAD spad;
    address spadActionAddress;
    mapping(string => bool) existingSymbols;
    address[] public spads;
    mapping (address => bool) validCurrencies;

    event SPADCreated(address indexed initiator, address spadAddress);
    event SpadActionAddressUpdated(address spadActionAddress);
    event validCurrencyUpdated(address currencyAddress, bool isValid);

    function initialize() public initializer {
        __Ownable_init();
        validCurrencies[0x98339D8C260052B7ad81c28c16C0b98420f2B46a] = true;
        validCurrencies[0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844] = true;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function updateValidCurrency(address _currencyAddress, bool _isValid) public onlyOwner {
        validCurrencies[_currencyAddress] = _isValid;
        emit validCurrencyUpdated(_currencyAddress, _isValid);
    }

    function setSpadActionAddress(address _spadActionAddress) public onlyOwner {
        spadActionAddress = _spadActionAddress;
        emit SpadActionAddressUpdated(spadActionAddress);
    }

    function getSpadCount() public view returns (uint) {
        return spads.length;
    }

    function createSpad(string memory _name, string memory _symbol, uint _totalSupply, uint _target, uint _minInvestment, uint _maxInvestment, string memory _passKey, address _currencyAddress) public {
        require(existingSymbols[_symbol] == false, "duplicate symbol");
        if(_currencyAddress != address(0)) {
            require(validCurrencies[_currencyAddress] == true, "invalid currency");
        }
        existingSymbols[_symbol] = true;
        spadImplementation = address(new SPAD());
        ERC1967Proxy proxy = new ERC1967Proxy(
            spadImplementation,
            abi.encodeWithSelector(SPAD(address(0)).initialize.selector, _name, _symbol, _totalSupply, msg.sender, _target, _minInvestment, _maxInvestment, _passKey, _currencyAddress, spadActionAddress)
        );
        spad = SPAD(address(proxy));
        spads.push(address(spad));

        SPADActionsInterface(spadActionAddress).addSpad(address(spad), _currencyAddress, msg.sender);
        emit SPADCreated(msg.sender, address(spad));
    }
}