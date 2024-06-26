const { ethers } = require('hardhat');

async function main () {
  const SpadToken = await ethers.getContractFactory('SpadToken');
  console.log('Deploying SpadToken...');
  const token = await SpadToken.deploy("Socios Coin", "SCS", 18); 
  console.log('SpadToken deployed to:', token.address);
}

main();

// Address : 0x02C09a7507Cab98Bffae5720Fa6fEf81f6Aa7Fe4