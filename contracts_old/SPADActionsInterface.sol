// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.17;

interface SPADActionsInterface {
    function getContribution(address _spadAddress, address _contributor) external view returns (uint);
    function addSpad(address _spadAddress, address _currencyAddress, address _spadInitiator) external;
    function updateSpadPitchFee(uint _fee) external;
}