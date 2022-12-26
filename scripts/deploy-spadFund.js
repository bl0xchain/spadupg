const { ethers, upgrades } = require('hardhat');

async function main () {
  const SpadFund = await ethers.getContractFactory('SpadFund');
  console.log('Deploying SpadFund...');
  const spadFund = await upgrades.deployProxy(SpadFund, ["0x6e6268c2F3b9FAd851A94602c2c100b64B6901d1"], { initializer: 'initialize' });
  await spadFund.deployed();
  console.log('SpadFund deployed to:', spadFund.address);
}

main();

// Address : 0xb1Daa2132F827Cd661Adf4074D3fF30e76eC6834