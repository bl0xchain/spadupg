const { ethers, upgrades } = require('hardhat');

async function main() {
    const SpadActions = await ethers.getContractFactory("SpadActions");
    const actions = await upgrades.upgradeProxy("0x6e6268c2F3b9FAd851A94602c2c100b64B6901d1", SpadActions);
    console.log("SpadActions upgraded");
}
  
main();