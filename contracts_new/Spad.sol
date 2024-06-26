// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract Spad is Pausable, Ownable {
    address public actionsAddress;
    string public name;
    string public symbol;
    address public creator;
    uint8 public status; // 1:PENDING, 2:LIVE, 3:EXPIRED, 4:CLOSED, 5:ACQUIRED
    uint public created;
    address public currencyAddress;
    uint public target;
    uint public minInvestment;
    uint public maxInvestment;

    event StatusUpdated(uint8 status);

    constructor(string memory _name, string memory _symbol, address _creator, uint _target, uint _minInvestment, uint _maxInvestment, address _currencyAddress, address _actionsAddress) {
        name = _name;
        symbol = _symbol;
        creator = _creator;
        target = _target;
        minInvestment = _minInvestment;
        maxInvestment = _maxInvestment;
        currencyAddress = _currencyAddress;
        actionsAddress = _actionsAddress;
        status = 1;
        created = block.timestamp;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    modifier onlyActions() {
        require(msg.sender == actionsAddress, "invalid access");
        _;
    }

    function updateStatus(uint8 _status) public onlyActions {
        status = _status;
        emit StatusUpdated(_status);
    }

}