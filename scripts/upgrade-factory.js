const { ethers, upgrades } = require('hardhat');

async function main() {
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await upgrades.upgradeProxy("0x35FaC56F5A2A53bEdC56c078fD5E24b269F7f073", Factory);
    console.log("Factory upgraded");
}
  
main();