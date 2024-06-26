const { ethers, upgrades } = require('hardhat');

const API_URL = process.env.BASE_SEPOLIA_API_URL;
const PRIVATE_KEY = process.env.NEW_PRIVTE_KEY;

const provider = new ethers.providers.JsonRpcProvider(API_URL);
const signer = new ethers.Wallet(PRIVATE_KEY, provider);

const factoryJSON = require("../artifacts/contracts/Factory.sol/Factory.json");
const actionsJSON = require("../artifacts/contracts/SpadActions.sol/SpadActions.json");

async function main() {
    // const DaiToken = await ethers.getContractFactory('SpadToken');
    // console.log('Deploying Dai Stablecoin...');
    // const daiToken = await DaiToken.deploy("Dai Stablecoin", "DAI", 18);
    // console.log('Dai Stablecoin deployed to:', daiToken.address);

    // const UsdcToken = await ethers.getContractFactory('SpadToken');
    // console.log('Deploying USDC...');
    // const usdcToken = await UsdcToken.deploy("USD Coin", "USDC", 6); 
    // console.log('USDC deployed to:', usdcToken.address);

    const Factory = await ethers.getContractFactory('Factory');
    console.log('Deploying Factory...');
    const factory = await upgrades.deployProxy(Factory, [], { initializer: 'initialize' });
    await factory.deployed();
    console.log('Factory deployed to:', factory.address);

    const spadFactoryContract = new ethers.Contract(factory.address, factoryJSON.abi, signer);

    // console.log("Adding USDC currency...");
    // const tx1 = await spadFactoryContract.updateValidCurrency(usdcToken.address, true);
    // await tx1.wait();
    // console.log("USDC currency added.");

    // console.log("Adding DAI currency...");
    // const tx2 = await spadFactoryContract.updateValidCurrency(daiToken.address, true);
    // await tx2.wait();
    // console.log("DAI currency added.");

    const SpadActions = await ethers.getContractFactory('SpadActions');
    console.log('Deploying SpadActions...');
    const spadActions = await upgrades.deployProxy(SpadActions, [factory.address], { initializer: 'initialize' });
    await spadActions.deployed();
    console.log('SpadActions deployed to:', spadActions.address);

    console.log("Updating the SpadActionAddress...");
    const tx3 = await spadFactoryContract.setActionsAddress(spadActions.address);
    await tx3.wait();
    console.log("Updated the SpadActionAddress...");

    const spadActionsContract = new ethers.Contract(spadActions.address, actionsJSON.abi, signer);

    const SpadFund = await ethers.getContractFactory('SpadFund');
    console.log('Deploying SpadFund...');
    const spadFund = await upgrades.deployProxy(SpadFund, [spadActions.address], { initializer: 'initialize' });
    await spadFund.deployed();
    console.log('SpadFund deployed to:', spadFund.address);

    const SpadPitch = await ethers.getContractFactory('SpadPitch');
    console.log('Deploying SpadPitch...');
    const spadPitch = await upgrades.deployProxy(SpadPitch, [spadActions.address], { initializer: 'initialize' });
    await spadPitch.deployed();
    console.log('SpadPitch deployed to:', spadPitch.address);

    const Privacy = await ethers.getContractFactory('Privacy');
    console.log('Deploying Privacy...');
    const privacy = await upgrades.deployProxy(Privacy, [spadActions.address], { initializer: 'initialize' });
    await privacy.deployed();
    console.log('Privacy deployed to:', privacy.address);

    console.log("Updating ModuleAddresses...");
    const tx4 = await spadActionsContract.setModuleAddresses(spadFund.address, spadPitch.address, privacy.address);
    await tx4.wait();
    console.log("Updated ModuleAddresses...");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exitCode = 1;
    });