// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IFactory {
    function IsValidSpad(address spadAddress) external view returns (bool);
}