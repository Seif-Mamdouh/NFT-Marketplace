// const hre = require("hardhat");

// async function main() {
//   const NFTMarket = await hre.ethers.getContractFactory("NFTMarket");
//   const nftMarket = await NFTMarket.deploy("Hello, Hardhat!");

//   await naftMarket.deployed();

//   console.log("Greeter deployed to:", greeter.address);
// }

// // We recommend this pattern to be able to use async/await everywhere
// // and properly handle errors.
// main()
//   .then(() => process.exit(0))
//   .catch((error) => {
//     console.error(error);
//     process.exit(1);
//   });

const hre = require("hardhat");
const fs = require("fs");

async function main() {
  const NFTMarket = await hre.ethers.getContractFactory("NFTMarket");
  const nftMarket = await NFTMarket.deploy();
  await nftMarket.deployed();
  console.log("nftMarket deployed to:", nftMarket.address);


  fs.writeFileSync(
    "./config.js",
    `
  export const marketplaceAddress = "${nftMarket.address}"
  `
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });