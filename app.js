// const constants = require("../../config/constants");
const Web3 = require("web3");
const web3 = new Web3("https://data-seed-prebsc-1-s1.binance.org:8545");
const Tx = require("ethereumjs-tx").Transaction;
const common = require("ethereumjs-common");
const { abi, address } = require("./contract");

//env·Î »©¾ßÇÔ.
const MYADDRESS = "0x96f11110A68BFe68bA419f6D60217aab699ab044";
// eslint-disable-next-line no-undef
const privateKey = Buffer.from(
  "f28817e12f50e30b66f19d2e013ac632edf385ee6b37df46889dc81b6b61c21e",
  "hex"
);

const chain = common.default.forCustomChain(
  "mainnet",
  {
    name: "bnb",
    networkId: 97,
    chainId: 97,
  },
  "petersburg"
);

  async function test() {
    const contract = await new web3.eth.Contract(abi, address);
    const data = await contract.methods
      .mint("0x96f11110A68BFe68bA419f6D60217aab699ab044", 100, "killbsc", 100)
      .encodeABI();
    console.log(data);
    const txCount = await web3.eth.getTransactionCount(MYADDRESS);

    const txObject = {
      nonce: web3.utils.toHex(txCount),
      to: address,
      data,
      gasLimit: web3.utils.toHex(3000000),
      gasPrice: web3.utils.toHex(web3.utils.toWei("20", "gwei")),
    };

    const tx = new Tx(txObject, { common: chain });
    tx.sign(privateKey);
    const serializedTx = tx.serialize();
    const txhash = await web3.eth.sendSignedTransaction(
      "0x" + serializedTx.toString("hex")
    );
    console.log(txhash);

    const xx = await contract.methods.uri(0).call();
    console.log(xx);
  }
