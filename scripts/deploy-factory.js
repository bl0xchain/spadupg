const { ethers, upgrades } = require('hardhat');

async function main () {
  const Factory = await ethers.getContractFactory('Factory');
  console.log('Deploying Factory...');
  const factory = await upgrades.deployProxy(Factory, [], { initializer: 'initialize' });
  await factory.deployed();
  console.log('Factory deployed to:', factory.address);
}

main();

// Address : 0x35FaC56F5A2A53bEdC56c078fD5E24b269F7f073