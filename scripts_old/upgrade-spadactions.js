const { ethers, upgrades } = require('hardhat');

async function main() {
    const SPADActions = await ethers.getContractFactory("SPADActions");
    const actions = await upgrades.upgradeProxy("0xA0c35A7f74f54023e853755834Eb036a1E71BAF1", SPADActions);
    console.log("SPADActions upgraded");
}
  
main();