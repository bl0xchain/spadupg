const { ethers } = require('hardhat');

async function main () {
  const SpadToken = await ethers.getContractFactory('SpadToken');
  console.log('Deploying Dai Stablecoin...');
  const token = await SpadToken.deploy("Dai Stablecoin", "DAI", 18); 
  console.log('Dai Stablecoin deployed to:', token.address);
}

main();

// Address : 0x02C09a7507Cab98Bffae5720Fa6fEf81f6Aa7Fe4
// Arbitrum goerli: 0x02adaF2718cdc07503d66212f9EE850C813638EC
// Base Sepolia : 0x7c47218ef2ccd72eEE1bda89eE1Af17E1e85626c
// Arbitrum Sepolia : 0x06b5298e145c7b2f06cEE3c1Aab2f7f4eAd39BcD