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
    const tx = await tokenContract.mint("0x31471ad280a8E4C2F3A24B7eaeE6E78C005fE48d", "100000000000000000000");
    await tx.wait();
    console.log("Tokens Minted...");
}
main();
