pragma solidity ^0.4.14;


contract EscrowSale {
	struct OrderDetails{
		address buyer;
		address seller;
		address arbitrator;
		uint amount;
		bool status;
		bool used;
		uint8 recieved;

	}
	address public creator;
	mapping(bytes32 => OrderDetails)public orderdata;
	mapping(address => bool) public adminlist;

	function EscrowSale() public {
		creator = msg.sender;
	}

	modifier onlyCreator {  // only creator of contract is allowed to add admin
		if (msg.sender == creator)
		_;
	}
	
	event NotifySeller(bytes32 orderid, uint _amount, address _buyer);
	event NotifyConfirmation(bytes32 orderid,address _seller, address _buyer);
	event NotifyForPayback(bytes32 orderid, uint _amount, address _buyer, address _seller);
	event CreateEscrow(bool adminlist);
	event DepositToEscrow(address sender,address buyer,uint value,uint amount);
	event BuyerConfirmation(address sender,address buyer,uint8 recieved);
	event Finalize(address sender,address arbitrator,uint8 recieved,uint amount,uint value);
	event Refund(address sender,address buyer,uint8 recieved,bool status);
	event PaybackToBuyer(address sender,address arbitrator,uint8 recieved,bool status);




	function addMember(address _newadmin) public onlyCreator returns(bool){
		require(!adminlist[_newadmin]);
		adminlist[_newadmin] = true;
		return true;
	}

	function createEscrow(address _buyer,
		address _seller,
		address _arbitrator,
		uint _amount,
		bytes32 orderId) public{
		address a = _arbitrator;
		CreateEscrow(adminlist[a]);
		require(!orderdata[orderId].used);
		require(adminlist[_arbitrator] == true);
		OrderDetails memory sd;
		sd.buyer = _buyer;
		sd.seller = _seller;
		sd.arbitrator = _arbitrator;
		sd.amount = _amount;
		sd.used = true;

		orderdata[orderId] = sd;
	}

	function depositToEscrow(bytes32 _id) public payable returns(uint) {
		DepositToEscrow(msg.sender,orderdata[_id].buyer,msg.value,orderdata[_id].amount);
		require(!orderdata[_id].status == true);
		require(msg.sender == orderdata[_id].buyer);
		require(msg.value == orderdata[_id].amount);

		orderdata[_id].status = true; 
		creator.transfer(msg.value);
		NotifySeller(_id, orderdata[_id].amount, orderdata[_id].buyer);
		
	}

	function buyerConfirmation(bytes32 _id) public {
		BuyerConfirmation(msg.sender,orderdata[_id].buyer,orderdata[_id].recieved);
		require(msg.sender == orderdata[_id].buyer);
		require(orderdata[_id].recieved == 0);

		orderdata[_id].recieved = 1;
		NotifyConfirmation(_id,orderdata[_id].seller,orderdata[_id].buyer);
	}

	function finalizeOrder(bytes32 _id) public payable {
		Finalize(msg.sender,orderdata[_id].arbitrator,orderdata[_id].recieved,orderdata[_id].amount,msg.value);
		require(msg.sender == orderdata[_id].arbitrator);
		require(orderdata[_id].recieved == 1);
		require(orderdata[_id].amount == msg.value);

		orderdata[_id].recieved = 2;
		orderdata[_id].seller.transfer(orderdata[_id].amount);
	}

	function refund(bytes32 _id) public {
		Refund(msg.sender,orderdata[_id].buyer,orderdata[_id].recieved,orderdata[_id].status);
		require(msg.sender == orderdata[_id].buyer);
		require(orderdata[_id].status == true && orderdata[_id].recieved == 0);
		NotifyForPayback(_id,orderdata[_id].amount, orderdata[_id].buyer,orderdata[_id].seller);
	}

	function paybackToBuyer(bytes32 _id) public payable {
		PaybackToBuyer(msg.sender,orderdata[_id].arbitrator,orderdata[_id].recieved,orderdata[_id].status);
		require(msg.sender == orderdata[_id].arbitrator);  
		require(orderdata[_id].status == true && orderdata[_id].recieved == 0);

		orderdata[_id].recieved = 3;
		orderdata[_id].buyer.transfer(orderdata[_id].amount);
	}
}