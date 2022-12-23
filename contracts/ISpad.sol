// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ISpad {
    
    function name() external returns (string memory);
    function symbol() external returns (string memory);
    function creator() external returns (address);
    function status() external returns (uint8);
    function created() external returns (uint);
    function currencyAddress() external returns (address);
    function target() external returns (uint);
    function currentInvestment() external returns (uint);
    function minInvestment() external returns (uint);
    function maxInvestment() external returns (uint);

    function updateStatus(uint8 _status) external;
}