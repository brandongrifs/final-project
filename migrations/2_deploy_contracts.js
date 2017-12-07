var Reputation = artifacts.require("./Reputation.sol");
var Token = artifacts.require("./Token.sol");

module.exports = function(deployer) {
	deployer.deploy(Reputation);
	deployer.deploy(Token);
	//how to make this deploy work?
//	deployer.deploy(Crowdsale);
};
