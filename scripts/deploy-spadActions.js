const { ethers, upgrades } = require('hardhat');

async function main () {
  const SpadActions = await ethers.getContractFactory('SpadActions');
  console.log('Deploying SpadActions...');
  const spadActions = await upgrades.deployProxy(SpadActions, ["0x568Ac336121bbbB51ca9c5913614b158C7Fda33F"], { initializer: 'initialize' });
  await spadActions.deployed();
  console.log('SpadActions deployed to:', spadActions.address);
}

main();

// Address : 0x6e6268c2F3b9FAd851A94602c2c100b64B6901d1
// Arbitrum Goerli : 0x404F8A0B7066402F2a6210d4b3A94B810E794AFD
// Base Sepolia : 0x0A4824597DAb2A97477df4b5560D5531ee416A64
// Arbitrum Sepolia : 0xe5DFE95BBA0Af61345558DA82B62627C3876C202