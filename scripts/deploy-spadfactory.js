const { ethers, upgrades } = require('hardhat');

async function main () {
  const SPADFactory = await ethers.getContractFactory('SPADFactory');
  console.log('Deploying SPADFactory...');
  const factory = await upgrades.deployProxy(SPADFactory, [], { initializer: 'initialize' });
  await factory.deployed();
  console.log('SPADFactory deployed to:', factory.address);
}

main();

// Address old : 0x555e75EEb0520d8e3FCcfC5ad178620cb88Ce59d
// Address : 0x0eA97e9f0FFDa7e9f58dfF7AACEB70d8F19FD85E