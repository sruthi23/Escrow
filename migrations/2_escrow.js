var EscrowSale = artifacts.require('./EscrowSale.sol');

module.exports = function(deployer) {
  deployer.deploy(EscrowSale);
};
