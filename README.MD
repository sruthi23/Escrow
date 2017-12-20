# EscrowSale

EscrowSale is a contract which act as a third party to enable transactions between parties.
When buyer wish to buy from the "seller", buyer deposits ether to contract/escrow and seller get notified about this . once buyer receives goods/service from the seller, buyer gives confirmation. once the confirmation received arbitrator transfers the ether from contract to seller. 

## functions

`addMember(address _newadmin)`

Adds new admin/assigns admin privileges to address. This function is only accessible by creator of the contract.

`createEscrow(address _buyer,address _seller,address _arbitrator,uint _amount,bytes32 orderId)`

Set order details. _arbitrator must be admin and orderId must be unique.

`depositToEscrow(byte32 _id)`

Deposit ether into contract address only by the buyer of corresponding order. And notifies the seller about the deposit by invoking the event `NotifySeller(_id, orderdata[_id].amount, orderdata[_id].buyer)`

`buyerConfirmation(byte32 _id)`

Once the service received by the seller, buyer gives the confirmation by calling the event NotifyConfirmation.

`finalizeOrder(byte32 _id)`
Arbitrator transfers the ether from contract to seller address only the confirmation about delivery of service confirmed.
