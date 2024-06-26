const { ethers } = require('hardhat');

async function main () {
  const SpadToken = await ethers.getContractFactory('SpadToken');
  console.log('Deploying USDC...');
  const token = await SpadToken.deploy("USD Coin", "USDC", 6); 
  console.log('USDC deployed to:', token.address);
}

main();

// Address : 0x02C09a7507Cab98Bffae5720Fa6fEf81f6Aa7Fe4
// Arbitrum goerli: 0x6e557F271447FD2aA420cbafCdCD66eCDD5A71A8
// Base Sepolia : 0xe5DFE95BBA0Af61345558DA82B62627C3876C202
// Arbitrum Sepolia : 0x40Bf6C107CAb17181ec2Aa2959BEE028b4698ee1