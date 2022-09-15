import { Signer } from "@ethersproject/abstract-signer";
import { task } from "hardhat/config";

task("deploy", "Prints the list of accounts", async (params, hre) => {
  const accounts: Signer[] = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(await account.getAddress());
  }
});
