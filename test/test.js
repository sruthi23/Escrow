var TestEscrowSale = artifacts.require("EscrowSale");
//var assert = require('assert');

contract('EscrowSale',function(accounts){
	it("adding admin",function(){
		return TestEscrowSale.deployed().then(function(instance){
			return instance.addMember.call(accounts[0]);
		});
	});

	it("placing order",function(){
		var arbitrator = accounts[0];

		return TestEscrowSale.deployed().then(function(instance){
			//return instance.adminlist[accounts[0]];
			var b = instance.adminlist[arbitrator];

			//assert(b == true,"true");
		});
		
	});

	it("createEscrow",function(){
		var buyer = accounts[1];
		var seller = accounts[2];
		var arbitrator = accounts[0];

		return TestEscrowSale.deployed().then(function(instance){
			return instance.createEscrow.call(buyer,seller,arbitrator,100,101);
		});
	});
})