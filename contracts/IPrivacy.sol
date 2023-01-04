// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IPrivacy {
    function addSpad(address spadAddress, string memory passKey) external;
    function isPrivate(address spadAddress) external view returns (bool);
    function isPasswordMatch(address spadAddress, string memory passKey) external view returns (bool);
}