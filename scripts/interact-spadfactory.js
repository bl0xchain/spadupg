const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0x555e75EEb0520d8e3FCcfC5ad178620cb88Ce59d";

const contract = require("../artifacts/contracts/SPADFactory.sol/SPADFactory.json");

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(network="goerli", API_KEY);
// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
// Contract
const spadFactoryContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
    console.log("Updating the SpadActionAddress...");
    const tx = await spadFactoryContract.setSpadActionAddress("0x25AB13b8A9506Bf0aE874CfaEC1f23F3Ee42d78E");
    await tx.wait();
    console.log("Updated the SpadActionAddress...");
}
main();
