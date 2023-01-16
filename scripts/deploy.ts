import { ethers,upgrades } from "hardhat";

async function main() {

  const Contract = await ethers.getContractFactory("EasySendCrypto");
  const instance = await upgrades.deployProxy(Contract,[10, "0xd710C48977aEA6dC5AA281b80A37A45901373814"],{initializer:'initialize'});
  // const rain = await upgrades.deployProxy(RT, { initializer: 'initialize' });
  
  await instance.deployed();

  console.log("Contract deployed to:", instance.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// npx hardhat run scripts/deploy.ts --network goerli 

// npx hardhat verify --network goerli 
