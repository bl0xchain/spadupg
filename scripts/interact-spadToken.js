const API_KEY = process.env.API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const CONTRACT_ADDRESS = "0x02C09a7507Cab98Bffae5720Fa6fEf81f6Aa7Fe4";

const contract = require("../artifacts/contracts/SpadToken.sol/SpadToken.json");

// Provider
const alchemyProvider = new ethers.providers.AlchemyProvider(network="goerli", API_KEY);
// Signer
const signer = new ethers.Wallet(PRIVATE_KEY, alchemyProvider);
// Contract
const tokenContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);

async function main() {
    console.log("Minting Tokens...");
    const tx = await tokenContract.mint("0xFe2aA7B0aF149Df874A8923Cd09a694044E120ed", "1000000000000000000000");
    await tx.wait();
    console.log("Tokens Minted...");
}
main();
