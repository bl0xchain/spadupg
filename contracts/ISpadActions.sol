// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ISpadActions {
    function addSpad(address spadAddress, string memory passKey) external;
}