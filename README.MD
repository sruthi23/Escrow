# EscrowSale

EscrowSale is a contract which act as a third party to enable transactions between parties.
When buyer wish to buy from the "seller", buyer deposits ether to contract/escrow and seller get notified about this . once buyer receives goods/service from the seller, buyer gives confirmation. once the confirmation received arbitrator transfers the ether from contract to seller.

## Available functions

1. `addMember(address _newadmin)`
   Adds new admin/assigns admin privileges to address. This function is only accessible by creator of the contract.

2. `createEscrow(address _buyer,address _seller,address _arbitrator,uint _amount,bytes32 orderId)`
   Set order details. `_arbitrator` must be admin and orderId must be unique.

3. `depositToEscrow(byte32 _id)`
   Deposit ether into contract address only by the buyer of corresponding order. And notifies the seller about the deposit by invoking the event `NotifySeller(_id, orderdata[_id].amount, orderdata[_id].buyer)`

4. `buyerConfirmation(byte32 _id)`
   Once the service received by the seller, buyer gives the confirmation by calling the event NotifyConfirmation.

5. `finalizeOrder(byte32 _id)`
   Arbitrator transfers the ether from contract to seller address only the confirmation about delivery of service confirmed.

6. `refund(bytes32 _id)`
   In case service is not received, buyer can notify to refund only if the buyer deposited the ether into contract.

7. `paybackToBuyer(bytes32 _id)`
   When the refund request received, then the arbitrator paybacks the deposited ether to buyer.

8. `depositToEscrow(byte32 _id)` , `finalizeOrder(byte32 \_id)` and `paybackToBuyer(bytes32 _id)` payable functions since we are dealing with transactions here. Depositing ether into contract and transferring ether from contract to seller or buyer.
