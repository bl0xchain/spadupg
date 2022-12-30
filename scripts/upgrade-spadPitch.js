const { ethers, upgrades } = require('hardhat');

async function main() {
    const SpadPitch = await ethers.getContractFactory("SpadPitch");
    const pitch = await upgrades.upgradeProxy("0x071555BdD27A365F0b0697CFA35a78357F67A87B", SpadPitch);
    console.log("SpadPitch upgraded");
}
  
main();