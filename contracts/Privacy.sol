// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Privacy is Initializable, OwnableUpgradeable {
    address private actionsAddress;
    mapping(address => SpadData) spads;

    struct SpadData {
        bool exists;
        string passKey;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address _actionsAddress) initializer public {
        __Ownable_init();
        actionsAddress = _actionsAddress;
    }

    modifier onlyActions() {
        require(msg.sender == actionsAddress, "not actions");
        _;
    }

    function addSpad(address spadAddress, string memory passKey) public onlyActions {
        require(spads[spadAddress].exists == false, "already exists");
        SpadData storage spadData = spads[spadAddress];
        spadData.exists = true;
        spadData.passKey = passKey;
    }

    function isPrivate(address spadAddress) public view returns (bool) {
        SpadData storage spadData = spads[spadAddress];
        if(keccak256(abi.encodePacked(spadData.passKey)) != keccak256(abi.encodePacked(""))) {
            return true;
        } else {
            return false;
        }
    }

    function isPasswordMatch(address spadAddress, string memory passKey) public view returns (bool) {
        SpadData storage spadData = spads[spadAddress];
        if(keccak256(abi.encodePacked(spadData.passKey)) == keccak256(abi.encodePacked(passKey))) {
            return true;
        } else {
            return false;
        }
    }
}