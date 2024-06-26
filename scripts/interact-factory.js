const API_KEY = process.env.BASE_SEPOLIA_API_KEY;
const API_URL = process.env.BASE_SEPOLIA_API_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0x568Ac336121bbbB51ca9c5913614b158C7Fda33F";

const { ethers } = require("hardhat");
const contract = require("../artifacts/contracts/Factory.sol/Factory.json");

// Provider
// const alchemyProvider = new ethers.providers.AlchemyProvider(network="base-sepolia", API_KEY);
const provider = new ethers.providers.JsonRpcProvider(API_URL);
// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, provider);
// Contract
const spadFactoryContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
    console.log("Updating the SpadActionAddress...");
    const tx = await spadFactoryContract.setActionsAddress("0x0A4824597DAb2A97477df4b5560D5531ee416A64");
    await tx.wait();
    console.log("Updated the SpadActionAddress...");
}
main();
