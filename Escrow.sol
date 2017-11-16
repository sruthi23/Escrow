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
    bool private sellerflag = false;  // value changes to true when seller sends money to escrow
    bool private buyerflag = false;  // will be true when buyer receives goods from buyer

    function Escrow(address _seller, address _buyer) public {
        seller = _seller;
        buyer = _buyer;
    }

    function payToArbiter(uint _amount, address _arbiter) public { // function for paying arbiter
        uint f = 0;
        for (uint8 i = 0; i < count; i++) {
            if (adminlist[i] == _arbiter) { // checking whether the requested arbiter is admin
                f = 1;
                break;
            }
        }
        if (msg.sender == seller && f == 1) { //seller sending money to arbitet
            _arbiter.transfer(_amount);
        }
    }

    function payToSeller(uint _amount) public {
        if (sellerflag == true) {     // buyer sends money to seller only if seller payed to arbiter
            if (msg.sender == buyer) {
                seller.transfer(_amount);
            }
        }

    }

    function confirm() public {
        if (msg.sender == buyer) {
            buyerflag = true;
            payback();
        }
    }

    function payback() public {   // arbiter payback to seller ones it get confirmation of receiving goods from buyer
        if (msg.sender == buyer && buyerflag == true) {
            selfdestruct(seller);
        }
    }
}
