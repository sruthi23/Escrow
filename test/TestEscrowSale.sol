pragma solidity ^0.4.14;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EscrowSale.sol";


contract TestEscrowSale{

	//	address ad = address(0XE74AADED62B40C3CBAE50A51DE3A38A86F98F62A);
	address arbitrator = 0xe74aaded62b40c3cbae50a51de3a38a86f98f62a;
	address buyer = 0x3e6ab67186ff88580732d24f9319bf63400a552b;
	address seller = 0x2ff7f49bab425623175f25c26265a9576ec890c6;
	uint amount = 100;
	bytes32 oid = '11';
	address arb = 0xe74aaded62b40c3cbae50a51de3a38a86f98f62a;

	EscrowSale es = EscrowSale(DeployedAddresses.EscrowSale());

	function testaddMember() public{
		es.addMember(arbitrator);
	}

	function testcreateEscrow() public{

		es.createEscrow(buyer,seller,arb,amount,oid);
		
	} 

	/* function testdepositToEscrow(){

		} */

	}