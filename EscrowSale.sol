pragma solidity 0.4.18;


contract AdminSetUp {   // contract for adding new admin
    address private creator = msg.sender;
    address[] public adminlist;
    uint public count;

    modifier onlyCreator {  // only creator of contract is allowed to add admin

        if (msg.sender == creator)
            _;
    }

    function addNewAdmin(address _newadmin) public onlyCreator returns (uint) {
        adminlist.push(_newadmin);
        count = adminlist.length;
        return count;
    }

}


contract Escrow is AdminSetUp {

    address public buyer;       //address of buyer
    address public seller;      //address of seller
    address public arbitrator;
    uint public f = 0;

    event NotifySeller(uint amount, address seller);      // triggered when buyer pays to arbitrator


    bool private approval = false;
    uint public amount = 0;

    function saleFunction(address _seller, address _buyer, address _arbitrator, uint _amount) public payable {     // function for paying arbiter

        seller = _seller;
        buyer = _buyer;


        for (uint8 i = 0; i < count; i++) {

            if (adminlist[i] == _arbitrator) {      // checking whether the requested arbitrator is admin
                arbitrator = _arbitrator;
                amount = _amount;
                f = 1;
                break;
            }
        }


        if (msg.sender == buyer && f == 1) {
            approval = true;
            arbitrator.transfer(msg.value);
        }
        if (approval == true) {
            NotifySeller(amount, buyer);
        }

    }

    function payback() public payable {

        if (msg.sender == buyer || msg.sender == arbitrator) {
            seller.transfer(msg.value);
        }
    }


}


contract EscrowSale is Escrow {
    struct SaleData {
        address buyer;
        address seller;
        address arbitrator;
        uint amount;

    }

    uint public c = 0;

    mapping(uint => SaleData)public sale;

    function saleSetting(address _seller, address _arbitrator, uint _amount) public {

        sale[c].buyer = msg.sender;
        sale[c].seller = _seller;
        sale[c].arbitrator = _arbitrator;
        sale[c].amount = _amount;

        address sender = sale[c].seller;
        address receiver = sale[c].buyer;
        address arbitrator = sale[c].arbitrator;
        uint amount = sale[c].amount;
        c++;
        saleFunction(sender, receiver, arbitrator, amount);


    }

}
