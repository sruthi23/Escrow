pragma solidity 0.4.0;


contract AdminSetUp {   // contract for adding new admin
    address private creator = msg.sender;
    address[] public adminlist;
    uint public count;

    modifier onlyCreator {  // only creator of contract is allowed to add admin
        if (msg.sender == creator)
            _;
    }

    function addMember(address _newadmin)public onlyCreator() {
        adminlist.push(_newadmin);
        count = adminlist.length;
    }

}


contract Escrow is AdminSetUp {
    address private buyer;    //address of buyer
    address private seller;   //address of seller
    address private arbiter;
  //  bool private sellerflag = false;  // value changes to true when seller sends money to escrow
    //bool private buyerflag = false;  // will be true when buyer receives goods from buyer

    event NotifySeller(uint _amount, address _seller); // triggered when buyer pays to arbitrator


    bool private approval = false;
    uint public amount = 0; 

    function Escrow(address _seller, address _buyer) public {
        seller = _seller;
        buyer = _buyer;
    }

    function payToArbiter(uint _amount, address _arbiter) public { // function for paying arbiter
        uint f = 0;
        for (uint8 i = 0; i < count; i++) {
            if (adminlist[i] == _arbiter) { // checking whether the requested arbitrator is admin
                arbiter = _arbiter;
                f = 1;
                break;
            }
        }
        if (msg.sender == buyer && f == 1) {
            approval = true;
            amount = _amount;
            _arbiter.transfer(_amount);
        }
        if (approval == true) {
            NotifySeller(amount, buyer);
        }


    }

    function confirm() public {
        if (msg.sender == buyer || msg.sender == arbiter) {
            payback();
        }
    }

    function payback() public {   // arbiter payback to seller ones it get confirmation of receiving goods from buyer
        if (msg.sender == buyer || msg.sender == arbiter) {
            selfdestruct(seller);
        }
    }
}
