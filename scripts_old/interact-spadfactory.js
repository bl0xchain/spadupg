const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0x40F5b3BB2426df97fa9B9c567303C99B13Aa386F";

const contract = require("../artifacts/contracts/SPADFactory.sol/SPADFactory.json");

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(network="goerli", API_KEY);
// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
// Contract
const spadFactoryContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
    console.log("Updating the SpadActionAddress...");
    const tx = await spadFactoryContract.setSpadActionAddress("0x8480FcB2eD77bB6DC7260e086f89Fd1B42ce4f1a");
    await tx.wait();
    console.log("Updated the SpadActionAddress...");
}
main();
