const { ethers, upgrades } = require('hardhat');

async function main () {
  const SpadActions = await ethers.getContractFactory('SpadActions');
  console.log('Deploying SpadActions...');
  const spadActions = await upgrades.deployProxy(SpadActions, ["0x35FaC56F5A2A53bEdC56c078fD5E24b269F7f073"], { initializer: 'initialize' });
  await spadActions.deployed();
  console.log('SpadActions deployed to:', spadActions.address);
}

main();

// Address : 0x6e6268c2F3b9FAd851A94602c2c100b64B6901d1