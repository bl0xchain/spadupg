const { ethers, upgrades } = require('hardhat');

async function main () {
  const SpadFund = await ethers.getContractFactory('SpadFund');
  console.log('Deploying SpadFund...');
  const spadFund = await upgrades.deployProxy(SpadFund, ["0x0A4824597DAb2A97477df4b5560D5531ee416A64"], { initializer: 'initialize' });
  await spadFund.deployed();
  console.log('SpadFund deployed to:', spadFund.address);
}

main();

// Address : 0xb1Daa2132F827Cd661Adf4074D3fF30e76eC6834
// Arbitrum Goerli : 0x5c68B994Aa960063A0fc74B4c00995024183DbcF
// Base Sepolia : 0x010FA982a0073f37cf565f690D80Cee36bd9633D
// Arbitrum Sepolia : 0x511677496Fc1947D2e3C59F5aCd9F726799E46D3