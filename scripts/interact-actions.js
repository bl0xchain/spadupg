const API_KEY = process.env.BASE_SEPOLIA_API_KEY;
const API_URL = process.env.BASE_SEPOLIA_API_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0x0A4824597DAb2A97477df4b5560D5531ee416A64";

const contract = require("../artifacts/contracts/SpadActions.sol/SpadActions.json");

// Provider
// const alchemyProvider = new ethers.providers.AlchemyProvider(network="arbitrum-goerli", API_KEY);
const provider = new ethers.providers.JsonRpcProvider(API_URL);
// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, provider);
// Contract
const spadActionsContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
    console.log("Updating ModuleAddresses...");
    const tx = await spadActionsContract.setModuleAddresses("0x010FA982a0073f37cf565f690D80Cee36bd9633D", "0x8e89e73817B4583130aa838345d4Ce1383AEfd83", "0x4363064fb6E4c68C9138E225b75294Ca738c3c58");
    await tx.wait();
    console.log("Updated ModuleAddresses...");
}
main();
