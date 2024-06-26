const { ethers, upgrades } = require('hardhat');

async function main () {
  const Privacy = await ethers.getContractFactory('Privacy');
  console.log('Deploying Privacy...');
  const privacy = await upgrades.deployProxy(Privacy, ["0x0A4824597DAb2A97477df4b5560D5531ee416A64"], { initializer: 'initialize' });
  await privacy.deployed();
  console.log('Privacy deployed to:', privacy.address);
}

main();

// Address : 0x5725a126E67230bdCEcE997BBaCE45A4BF72138E
// Aritrum Goerli : 0x9a7E234163b225FA5D09D1EEDF122c1F99dc391A
// Base Sepolia : 0x4363064fb6E4c68C9138E225b75294Ca738c3c58
// Arbitrum Sepolia : 0x9cB990F4f05dd537947987b87791fd176F0F333C