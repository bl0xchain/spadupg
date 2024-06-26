// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./SpadToken.sol";
import "./ISpad.sol";

contract SpadPitch is Pausable, Ownable {
    address private actionsAddress;
    mapping(address => SpadData) spads;

    struct SpadData {
        bool exists;
        mapping(address => Pitch) pitches;
        address[] pitchers;
        address acquiredBy;
    }

    struct Pitch {
        string name;
        string description;
        uint8 status; // 0:invalid, 1:proposed, 2:approved, 3:rejected, 4:selected
        address tokenAddress;
        uint tokenAmount;
    }

    event PitchProposed(address indexed spadAddress, address indexed pitcher);
    event PitchReviewed(address indexed spadAddress, address indexed pitcher, bool approved);

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

    function pitchSpad(address spadAddress, string memory name, string memory description, address tokenAddress, uint tokenAmount, address pitcher) public onlyActions returns (bool) {
        SpadData storage spadData = spads[spadAddress];
        require(spadData.pitches[pitcher].status == 0, "already pitched");
        require(tokenAmount > 0, "token amount should be more than 0");
        if(tokenAddress != address(0)) {
            require(IERC20(tokenAddress).totalSupply() > 0, "invalid token");
        }
        Pitch storage pitch = spadData.pitches[pitcher];
        pitch.name = name;
        pitch.description = description;
        pitch.status = 1; // proposed
        pitch.tokenAddress = tokenAddress;
        pitch.tokenAmount = tokenAmount;
        spadData.pitchers.push(pitcher);
        return true;
    }

    function getPitch(address spadAddress, address pitcher) public view returns (string memory name, string memory description, uint8 status, address tokenAddress, uint tokenAmount) {
        SpadData storage spadData = spads[spadAddress];
        Pitch memory pitch = spadData.pitches[pitcher];
        return (pitch.name, pitch.description, pitch.status, pitch.tokenAddress, pitch.tokenAmount);
    }

    function pitchReview(address spadAddress, address pitcher, bool approved) public onlyActions returns (uint8) {
        ISpad spad = getSpad(spadAddress);
        // require(msg.sender == spad.creator(), "not allowed");
        SpadData storage spadData = spads[spadAddress];
        require(spadData.pitches[pitcher].status == 1, "invalid/already pitched");
        Pitch storage pitch = spadData.pitches[pitcher];
        if(approved) {
            if(pitch.tokenAddress == address(0)) {
                pitch.status = 2;
                spadData.acquiredBy = pitcher;
                
                // Create token for distribution;
                SpadToken token = new SpadToken(spad.name(), spad.symbol(), 18);
                pitch.tokenAddress = address(token);
                token.mint(address(actionsAddress), pitch.tokenAmount);
            } else {
                pitch.status = 4;
            }
        } else {
            pitch.status = 3;
        }
        emit PitchReviewed(spadAddress, pitcher, approved);
        return pitch.status;
    }

    function getPitchToken(address spadAddress, address pitcher) public view onlyActions returns (address, uint) {
        SpadData storage spadData = spads[spadAddress];
        Pitch storage pitch = spadData.pitches[pitcher];
        return (pitch.tokenAddress, pitch.tokenAmount);
    }

    function claimPitch(address spadAddress, address pitcher) public onlyActions returns (bool) {
        SpadData storage spadData = spads[spadAddress];
        Pitch storage pitch = spadData.pitches[pitcher];
        require(pitch.status == 4, "not allowed");
        pitch.status = 2;
        spadData.acquiredBy = pitcher;
        return true;
    }

    function getAcquiredBy(address spadAddress) public view returns (address) {
        SpadData storage spadData = spads[spadAddress];
        return spadData.acquiredBy;
    }
}