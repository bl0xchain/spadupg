const { ethers, upgrades } = require('hardhat');

async function main() {
    const SPADFactory = await ethers.getContractFactory("SPADFactory");
    const factory = await upgrades.upgradeProxy("0x555e75EEb0520d8e3FCcfC5ad178620cb88Ce59d", SPADFactory);
    console.log("SPADFactory upgraded");
}
  
main();