// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ISpadFund {
    function addSpad(address spadAddress, string memory passKey) external;
    function activateSpad(address spadAddress, address creator) external returns (bool);
    function contribute(address spadAddress, uint amount, address contributor) external returns (bool);
    function getContribution(address spadAddress, address contributor) external view returns (uint);
    function getFundData(address spadAddress) external view returns (uint currrentInvestment, uint investorCount);
    function isInvestmentClaimed(address spadAddress, address contributor) external view returns (bool);
    function claimInvestment(address spadAddress, address contributor) external returns (bool);
    function isPrivate(address spadAddress) external view returns (bool);
    function isPasswordMatch(address spadAddress, string memory passKey) external view returns (bool);
}