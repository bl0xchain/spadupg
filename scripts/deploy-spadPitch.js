const { ethers, upgrades } = require('hardhat');

async function main () {
  const SpadPitch = await ethers.getContractFactory('SpadPitch');
  console.log('Deploying SpadPitch...');
  const spadPitch = await upgrades.deployProxy(SpadPitch, ["0x6e6268c2F3b9FAd851A94602c2c100b64B6901d1"], { initializer: 'initialize' });
  await spadPitch.deployed();
  console.log('SpadPitch deployed to:', spadPitch.address);
}

main();

// Address : 0x071555BdD27A365F0b0697CFA35a78357F67A87B