const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0x0eA97e9f0FFDa7e9f58dfF7AACEB70d8F19FD85E";

const contract = require("../artifacts/contracts/SPADFactory.sol/SPADFactory.json");

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(network="goerli", API_KEY);
// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
// Contract
const spadFactoryContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
    console.log("Updating the SpadActionAddress...");
    const tx = await spadFactoryContract.setSpadActionAddress("0xC5A76703DDD390dB4C43499d546Fbc3aEcf30F04");
    await tx.wait();
    console.log("Updated the SpadActionAddress...");
}
main();
