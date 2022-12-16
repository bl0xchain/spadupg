const { ethers, upgrades } = require('hardhat');

async function main () {
  const SPADActions = await ethers.getContractFactory('SPADActions');
  console.log('Deploying SPADActions...');
  const spadActions = await upgrades.deployProxy(SPADActions, ["0x0eA97e9f0FFDa7e9f58dfF7AACEB70d8F19FD85E"], { initializer: 'initialize' });
  await spadActions.deployed();
  console.log('SPADActions deployed to:', spadActions.address);
}

main();

// Address old : 0x25AB13b8A9506Bf0aE874CfaEC1f23F3Ee42d78E
// Address : 0xC5A76703DDD390dB4C43499d546Fbc3aEcf30F04