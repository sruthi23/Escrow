pragma solidity ^0.4.14;

contract AdminSetUp {  
	
	address public creator;
	mapping(address => bool) public adminlist;

	modifier onlyCreator {  // only creator of contract is allowed to add admin
		if (msg.sender == creator)
		_;
	}
	
	function AdminSetUp() public{
		creator = msg.sender;
	}

	function addMember(address _newadmin) public onlyCreator returns(bool){
		require(!adminlist[_newadmin]);
		adminlist[_newadmin] = true;
		return true;
	}
}


contract Escrow is AdminSetUp {
	address public buyer;       //address of buyer
	address public seller;      //address of seller
	address public arbitrator;
	uint f = 0;
	
	event NotifySeller(uint _amount, address _seller);      // triggered when buyer pays to arbitrator
	event success();


	uint private status = 0;
	uint public amount = 0; 

	function saleFunction(address _seller, address _buyer,address _arbitrator, uint _amount) payable public{     // function for paying arbiter
		
		seller = _seller;
		buyer = _buyer;
		
		require(adminlist[_arbitrator] == true);
		arbitrator = _arbitrator;
		amount = _amount;
		f=1;
		
		if (msg.sender == buyer && f == 1) {
			status =1;
			//arbitrator.transfer(msg.value);
			creator.transfer(msg.value);
		}
		if (status == 1) {
			NotifySeller(amount, buyer);
		}

	}


	function payback() payable public {
		if (msg.sender == arbitrator) {
			require(status == 1);
			status = 2;
			seller.transfer(msg.value);
		}
		
		if(status == 2){
			
			success();
			
		}
		
	}
	

	
}


contract EscrowSale is Escrow{
	
	
	struct OrderDetails{
		address buyer;   
		address seller;
		address arbitrator;
		uint amount;
		bool used;
		
	}
	//uint c = 1;
	bytes32 public orderId;

	
	mapping(bytes32 => OrderDetails)public orderdata;
	
	
	
	function orderSetting(address _seller, address _arbitrator, bytes32 key) public payable {
		
		orderId = key;
		
		require(!orderdata[orderId].used);
		
		OrderDetails memory sd;
		sd.buyer = msg.sender;
		sd.seller = _seller;
		sd.arbitrator = _arbitrator;
		sd.amount = msg.value;
		sd.used =true;
		
		orderdata[orderId] = sd;
	}
	
	
	function check(bytes32 _id) public returns(bool) 
	{
		if(msg.sender == orderdata[_id].seller && msg.sender == orderdata[_id].arbitrator)
		{
			return false;
		}
		
		return true;
	}
	
	
	function order(bytes32 id) payable public{
		
		require(check(id));
		saleFunction(orderdata[id].seller,orderdata[id].buyer,orderdata[id].arbitrator,orderdata[id].amount);
	}
	
	
}