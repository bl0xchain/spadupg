const { ethers, upgrades } = require('hardhat');

async function main () {
  const Factory = await ethers.getContractFactory('Factory');
  console.log('Deploying Factory...');
  const factory = await upgrades.deployProxy(Factory, [], { initializer: 'initialize' });
  await factory.deployed();
  console.log('Factory deployed to:', factory.address);
}

main();

// Address : 0x35FaC56F5A2A53bEdC56c078fD5E24b269F7f073
// Arbitrum Goerli : 0x06B12aac28f12964b5840B98a985dB0178Ca3579
// Base Sepolia : 0x568Ac336121bbbB51ca9c5913614b158C7Fda33F
// Arbitrum Sepolia : 0x44a9E0060080Ae4b20d9Cf112C31838d3F05D009