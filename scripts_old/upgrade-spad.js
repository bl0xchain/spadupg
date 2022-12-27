const { ethers, upgrades } = require('hardhat');

async function main() {
    const SPAD = await ethers.getContractFactory("SPAD");
    const actions = await upgrades.upgradeProxy("0x3a9ae31580ace6daa5de3d790ebc11944e137cc2", SPAD);
    console.log("SPAD upgraded");
}
  
main();