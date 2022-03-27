require("@nomiclabs/hardhat-waffle");
//ultlity that helps the develepor to read from a local file system
const fs = require("fs");
const privateKey = fs.readFileSync(".serect").toString();
const projectId = "b63740b8a0064ff0a7960d7d7d91bc29"

module.exports = {
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {
            chainId: 1337,
        },
        mumbai: {
            url: 'https://polygon-mumbai.infura.io/v3/${projectId}',
            accounts: [privateKey]
        },
        mainnet: {
            url: 'https://polygon-mainnet.infura.io/v3/{projectId}',
            account: [privateKey]
        },
    },
    solidity: {
        version: "0.8.4",
        settings: {
            optimizer: {
                enabled: true,
                runs: 200,
            },
        },
    },
};

// // This is a sample Hardhat task. To learn how to create your own go to
// // https://hardhat.org/guides/create-task.html
// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners();

//   for (const account of accounts) {
//     console.log(account.address);
//   }
// });

// // You need to export an object to set up your config
// // Go to https://hardhat.org/config/ to learn more

// /**
//  * @type import('hardhat/config').HardhatUserConfig
//  */