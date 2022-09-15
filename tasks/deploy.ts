import { task } from "hardhat/config";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

task("deploy")
  .addParam("socketRegistry", "Address of socket registry")
  .setAction(async ({ socketRegistry }, hre) => {
    const signers: SignerWithAddress[] = await hre.ethers.getSigners();
    const commandCenterFactory = await hre.ethers.getContractFactory(
      "CommandCenter"
    );
    const commandCenter = await commandCenterFactory
      .connect(signers[0])
      .deploy(socketRegistry);
    await commandCenter.deployed();
    console.log("Command Center deployed to: ", commandCenter.address);
  });
