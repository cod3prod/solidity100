const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");


module.exports = buildModule("MyToken", (m) => {
  const myToken = m.contract("MyToken");

  return { myToken };
});
