const { ethers, upgrades } = require('hardhat');

async function main () {
  const SPADActions = await ethers.getContractFactory('SPADActions');
  console.log('Deploying SPADActions...');
  const spadActions = await upgrades.deployProxy(SPADActions, ["0x40F5b3BB2426df97fa9B9c567303C99B13Aa386F"], { initializer: 'initialize' });
  await spadActions.deployed();
  console.log('SPADActions deployed to:', spadActions.address);
}

main();

// Address old : 0x25AB13b8A9506Bf0aE874CfaEC1f23F3Ee42d78E
// Address : 0xC5A76703DDD390dB4C43499d546Fbc3aEcf30F04
// Address New : 0xA0c35A7f74f54023e853755834Eb036a1E71BAF1

// Address 19Dec: 0xA0758631aa7C29B86a4B1af3aeF5E8cEb135a01f
// Address 20Dec: 0x360dc6D646fBca4F184345b2573cb5c0Df1a9ec9
// Address 20Dec1: 0x8480FcB2eD77bB6DC7260e086f89Fd1B42ce4f1a