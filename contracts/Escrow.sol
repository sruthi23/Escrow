pragma solidity ^0.4.14;


contract AdminSetUp {   			  // contract for adding new admin
	address private creator = msg.sender;
	address[] public adminlist;
	uint public count;

	modifier onlyCreator { 			 // only creator of contract is allowed to add admin
		if (msg.sender == creator)
		_;
	}

	function addNewAdmin(address _newadmin)public onlyCreator() {
		adminlist.push(_newadmin);
		count = adminlist.length;
	}

}


contract Escrow is AdminSetUp {
	address private buyer;    	    //address of buyer
	address private seller;   	   //address of seller
	address private arbitrator;

	event NotifySeller(uint _amount, address _seller); // triggered when buyer pays to arbitrator


	bool private approval = false;
	uint public amount = 0;

	function Escrow(address _seller) public {

		seller = _seller;
		buyer = msg.sender;
	}

	function payToArbitrator(uint _amount, address _arbitrator) public {   // function for paying arbiter
		uint f = 0;
		for (uint8 i = 0; i < count; i++) {
			if (adminlist[i] == _arbitrator) { 		// checking whether the requested arbitrator is admin
				arbitrator = _arbitrator;
				f = 1;
				break;
			}
		}
		if (msg.sender == buyer && f == 1) {
			approval = true;
			amount = _amount;
			_arbitrator.transfer(_amount);
		}
		if (approval == true) {
			NotifySeller(amount, buyer);
		}


	}

	function confirm() public {  			//buyer confirms once receives the goods
		if (msg.sender == buyer || msg.sender == arbitrator) {
			payback();
		}
	}

	function payback() public {   			// arbitrator payback to seller ones it get confirmation of receiving goods from buyer
		if (msg.sender == buyer || msg.sender == arbitrator) {
			seller.transfer(amount);
		}
	}
}
