// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.17;

interface SPADInterface {

    function updateStatus(uint8 _status) external;
    function updateSpadActionController(address _actionController) external;
    function updateCurrentInvestment(uint _currentInvestment) external;
    function updatePassKey(string memory _passKey) external;

    function checkPassKey(string memory _passKey) external view returns (bool);

    function status() external view returns (uint8);
    function spadInitiator() external view returns (address);
    function target() external view returns (uint);
    function minInvestment() external view returns (uint);
    function maxInvestment() external view returns (uint);
    function currentInvestment() external view returns (uint);
    function spadToken() external view returns (address);
    function isPrivate() external view returns (bool);
    function created() external view returns (uint);
    function isUSDC() external view returns (bool);

}