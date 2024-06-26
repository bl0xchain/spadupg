const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0x02adaF2718cdc07503d66212f9EE850C813638EC";

const contract = require("../artifacts/contracts/SpadToken.sol/SpadToken.json");

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(network="arbitrum-goerli", API_KEY);
// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
// Contract
const tokenContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
    console.log("Minting USDC...");
    const tx = await tokenContract.mint("0xa8da7eB9ED0629dE63cA5D7150a74e1AFbEfAac0", "100000000000000000000000");
    await tx.wait();
    console.log("USDC Minted...");
}
main();
