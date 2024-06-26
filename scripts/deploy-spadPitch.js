const { ethers, upgrades } = require('hardhat');

async function main () {
  const SpadPitch = await ethers.getContractFactory('SpadPitch');
  console.log('Deploying SpadPitch...');
  const spadPitch = await upgrades.deployProxy(SpadPitch, ["0x0A4824597DAb2A97477df4b5560D5531ee416A64"], { initializer: 'initialize' });
  await spadPitch.deployed();
  console.log('SpadPitch deployed to:', spadPitch.address);
}

main();

// Address : 0x071555BdD27A365F0b0697CFA35a78357F67A87B
// Arbitrum Goerli : 0x83a7480D975D11524dab44B2A32c7aee301D403e
// Base Sepolia : 0x8e89e73817B4583130aa838345d4Ce1383AEfd83
// Arbitrum Sepolia : 0xEEb01fC61670693c6faF29709b6bc4c1f3A65d69