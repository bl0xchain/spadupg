// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ISpad.sol";

contract SpadFund is Pausable, Ownable {
    address private actionsAddress;
    mapping(address => SpadData) spads;

    struct SpadData {
        bool exists;
        mapping (address => uint) investments;
        uint currentInvestment;
        uint investorCount;
        mapping (address => bool) claimedInvestment;
        string passKey;
    }

    // event SpadActivated(address spadAddress);
    // event Contributed(address indexed spadAddress, address indexed contributor, uint amount);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(address _actionsAddress) {
        actionsAddress = _actionsAddress;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    modifier onlyActions() {
        require(msg.sender == actionsAddress, "not actions");
        _;
    }

    function addSpad(address spadAddress) public onlyActions {
        require(spads[spadAddress].exists == false, "already exists");
        SpadData storage spadData = spads[spadAddress];
        spadData.exists = true;
    }

    function getSpad(address spadAddress) internal view returns (ISpad) {
        require(spads[spadAddress].exists == true, "not found");
        return ISpad(spadAddress);
    }

    function activateSpad(address spadAddress, address creator) public onlyActions returns (bool) {
        ISpad spad = getSpad(spadAddress);
        require(spad.status() == 1, "cannot activate");
        require(creator == spad.creator(), "not allowed");
        // spad.updateStatus(2);
        uint target = spad.target();
        uint amount = (target * 10 / 100);

        SpadData storage spadData = spads[spadAddress];
        
        spadData.investments[creator] = amount;
        spadData.investorCount = 1;
        spadData.currentInvestment = amount;
        
        return true;
    }

    function contribute(address spadAddress, uint amount, address contributor) public onlyActions returns (bool) {
        ISpad spad = getSpad(spadAddress);
        SpadData storage spadData = spads[spadAddress];
        uint effectiveInvestment = spadData.currentInvestment + amount;
        uint target = spad.target();
        require(effectiveInvestment <= target, "target overflow");
        require(spadData.investorCount <= 99, "investor overflow");
        require(spad.maxInvestment() >= (spadData.investments[contributor] + amount), "max investment overflow");
        if(target - spadData.currentInvestment >= spad.minInvestment()) {
            require((spadData.investments[contributor] + amount) >= spad.minInvestment(), "min investment underflow");
        }
        
        // if(spad.currencyAddress() != address(0)) {
        //     IERC20(spad.currencyAddress()).transferFrom(msg.sender, address(this), amount);
        // } else {
        //     require(msg.value == amount, "invalid contribution");
        // }

        if(spadData.investments[contributor] == 0) {
            spadData.investorCount++;
        }
        spadData.investments[contributor] = spadData.investments[contributor] + amount;
        spadData.currentInvestment = effectiveInvestment;
        // if(effectiveInvestment == target) {
        //     spad.updateStatus(4);
        // }
        // emit Contributed(spadAddress, msg.sender, amount);
        return true;
    }

    function getContribution(address spadAddress, address contributor) public view returns (uint) {
        SpadData storage spadData = spads[spadAddress];
        return spadData.investments[contributor];
    }

    function getFundData(address spadAddress) public view returns (uint currentInvestment, uint investorCount) {
        SpadData storage spadData = spads[spadAddress];
        return (spadData.currentInvestment, spadData.investorCount);
    }

    function isInvestmentClaimed(address spadAddress, address contributor) public view returns (bool) {
        SpadData storage spadData = spads[spadAddress];
        return spadData.claimedInvestment[contributor];
    }

    function claimInvestment(address spadAddress, address contributor) public onlyActions returns (bool) {
        SpadData storage spadData = spads[spadAddress];
        require(spadData.claimedInvestment[contributor] == false, "already claimed");
        spadData.claimedInvestment[contributor] = true;
        return true;
    }
}