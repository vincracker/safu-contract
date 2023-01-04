import { ethers } from "hardhat";

async function main() {
  const Contract = await ethers.getContractFactory("EasySendCrypto");
  const instance = await Contract.deploy(10, "0xd710C48977aEA6dC5AA281b80A37A45901373814");

  await instance.deployed();

  console.log("Contract deployed to:", instance.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// npx hardhat run scripts/deploy.ts --network goerli 

// npx hardhat verify --constructor-args arguments.js --network goerli 0x08b774778c21495aDB473245822682e82f6Bc631
