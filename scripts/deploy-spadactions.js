const { ethers, upgrades } = require('hardhat');

async function main () {
  const SPADActions = await ethers.getContractFactory('SPADActions');
  console.log('Deploying SPADActions...');
  const spadActions = await upgrades.deployProxy(SPADActions, ["0x555e75EEb0520d8e3FCcfC5ad178620cb88Ce59d"], { initializer: 'initialize' });
  await spadActions.deployed();
  console.log('SPADActions deployed to:', spadActions.address);
}

main();

// Address : 0x25AB13b8A9506Bf0aE874CfaEC1f23F3Ee42d78E