const { ethers, upgrades } = require('hardhat');

async function main() {
    const SpadFund = await ethers.getContractFactory("SpadFund");
    const fund = await upgrades.upgradeProxy("0xb1Daa2132F827Cd661Adf4074D3fF30e76eC6834", SpadFund);
    console.log("SpadFund upgraded");
}
  
main();