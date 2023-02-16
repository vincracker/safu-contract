import { ethers,upgrades } from "hardhat";
const hre = require("hardhat");

async function main() {
  
  const erc20 = await ethers.getContractFactory("ERC20");
  const erc20Instance = await erc20.deploy("testErc20", "erc");
  console.log("ERC20 deployed to:", erc20Instance.address);

  const stableCoinInstance = await erc20.deploy("StableCoin", "SC");
  console.log("Stable Coin deployed to:", stableCoinInstance.address);

  const Contract = await ethers.getContractFactory("EasySendCrypto");
  // const instance = await Contract.deploy(10, "0x99dbB9D1A7FFd38467F94443a9dEe088c6AB34B9");

  const instance = await upgrades.deployProxy(Contract,[50, "0xd710C48977aEA6dC5AA281b80A37A45901373814",ethers.utils.parseEther('1000'),],{initializer:'initialize'});
  
  await instance.deployed();
  console.log("Contract deployed to:", instance.address);


  // await instance.deployTransaction.wait(5);
  // try {
  //   await hre.run("verify:verify", {
  //     address: instance.address,
  //     contract: "contracts/Safu.sol:EasySendCrypto",
  //     constructorArguments:[10, "0x99dbB9D1A7FFd38467F94443a9dEe088c6AB34B9"]
  // })
  // } catch (error) {
  //   console.log(error);
  // }


}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// npx hardhat run scripts/deploy.ts --network goerli 

// npx hardhat verify --network goerli 
// npx hardhat verify --network goerli --constructor-args arguments.js 0xac8fd2b19032C37232A8d1A5ad612E52092EB12c
