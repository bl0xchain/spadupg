const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0x35FaC56F5A2A53bEdC56c078fD5E24b269F7f073";

const contract = require("../artifacts/contracts/Factory.sol/Factory.json");

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(network="goerli", API_KEY);
// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
// Contract
const spadFactoryContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
    console.log("Updating the SpadActionAddress...");
    const tx = await spadFactoryContract.setActionsAddress("0x6e6268c2F3b9FAd851A94602c2c100b64B6901d1");
    await tx.wait();
    console.log("Updated the SpadActionAddress...");
}
main();
