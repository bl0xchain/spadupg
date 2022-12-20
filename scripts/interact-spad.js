const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0xD130B8Ecd20E6dFd9CF7A489E77015e18Fe353FA";

const contract = require("../artifacts/contracts/SPAD.sol/SPAD.json");

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(network="goerli", API_KEY);
// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
// Contract
const spadContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
    console.log("Updating the SpadActionAddress...");
    const tx = await spadContract.setSpadActionAddress("0xA0c35A7f74f54023e853755834Eb036a1E71BAF1");
    await tx.wait();
    console.log("Updated the SpadActionAddress...");
}
main();
