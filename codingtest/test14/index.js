const { Web3 } = require("web3");
const { abi } = require("./abi");
const dotenv = require("dotenv");
dotenv.config();

const web3 = new Web3(process.env.PROVIDER);
const account = web3.eth.accounts.privateKeyToAccount(process.env.PRIVATE_KEY);
web3.eth.accounts.wallet.add(account);

const c_addr = "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D";
const contract = new web3.eth.Contract(abi, c_addr);

contract.events.Transfer({
  filter: { from: "0xA4bEA1Ceaae170aC22011De1AE8fF139D6cFeeee" },
  function(event) {
    console.log(event);
  },
});
