const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0x6e6268c2F3b9FAd851A94602c2c100b64B6901d1";

const contract = require("../artifacts/contracts/SpadActions.sol/SpadActions.json");

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(network="goerli", API_KEY);
// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
// Contract
const spadActionsContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
    console.log("Updating ModuleAddresses...");
    const tx = await spadActionsContract.setModuleAddresses("0xb1Daa2132F827Cd661Adf4074D3fF30e76eC6834", "0x071555BdD27A365F0b0697CFA35a78357F67A87B");
    await tx.wait();
    console.log("Updated ModuleAddresses...");
}
main();
