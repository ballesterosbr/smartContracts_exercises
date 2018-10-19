var IDcard = artifacts.require("./IDcard.sol");

module.exports = function(deployer) {
  deployer.deploy(IDcard);
};
