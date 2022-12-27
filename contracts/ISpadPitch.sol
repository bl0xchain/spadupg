// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ISpadPitch {
    function addSpad(address spadAddress) external;
    function pitchSpad(address spadAddress, string memory name, string memory description, address tokenAddress, uint tokenAmount, address pitcher) external returns (bool);
    function getPitch(address spadAddress, address pitcher) external view returns (string memory name, string memory description, uint8 status, address tokenAddress, uint tokenAmount);
    function pitchReview(address spadAddress, address pitcher, bool approved) external returns (uint8);
    function getPitchToken(address spadAddress, address pitcher) external view returns (address, uint);
    function claimPitch(address spadAddress, address pitcher) external returns (bool);
    function getAcquiredBy(address spadAddress) external returns (address);
}