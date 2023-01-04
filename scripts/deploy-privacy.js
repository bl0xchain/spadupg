const { ethers, upgrades } = require('hardhat');

async function main () {
  const Privacy = await ethers.getContractFactory('Privacy');
  console.log('Deploying Privacy...');
  const privacy = await upgrades.deployProxy(Privacy, ["0x6e6268c2F3b9FAd851A94602c2c100b64B6901d1"], { initializer: 'initialize' });
  await privacy.deployed();
  console.log('Privacy deployed to:', privacy.address);
}

main();

// Address : 0x5725a126E67230bdCEcE997BBaCE45A4BF72138E