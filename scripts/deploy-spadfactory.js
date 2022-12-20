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
// Address new : 0x2069af29514cEfd27b508A3382cd34082B64Fe9C

// Address 19Dec : 0x6b9D9B928434c602B95a7868101BA19D7c84f20c
// Address 20Dec : 0xe3D7921a031B74512B16F53cdDfB949779834082
// Address 20Dec1 : 0x40F5b3BB2426df97fa9B9c567303C99B13Aa386F