const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0x6e557F271447FD2aA420cbafCdCD66eCDD5A71A8";

const contract = require("../artifacts/contracts/SpadToken.sol/SpadToken.json");

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(network="arbitrum-goerli", API_KEY);
// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
// Contract
const tokenContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
    console.log("Minting USDC...");
    const tx = await tokenContract.mint("0xa8da7eB9ED0629dE63cA5D7150a74e1AFbEfAac0", "1000000000000000000000");
    await tx.wait();
    console.log("USDC Minted...");
}
main();
