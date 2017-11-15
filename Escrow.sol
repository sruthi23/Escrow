pragma solidity 0.4.0;


contract AdminSetUp {
    address private creator = msg.sender;
    address[] private adminlist;
    uint public count;

    modifier onlyCreator {
        if (msg.sender == creator)
            _;
    }
    /*struct Adminstruct {
        address _admin;
        bool arbiter;
    }*/

    function addMember(address _newadmin)public onlyCreator() {
        adminlist.push(_newadmin);
        count = adminlist.length();
    }

}


contract Escrow is AdminSetUp {
    address private buyer;
    address private seller;
    bool private sellerflag;
    bool private buyerflag;

    function Escrow(address _seller, address _buyer) public {
        seller = _seller;
        buyer = _buyer;
    }

    function payToArbiter(uint _amount, address _arbiter) public {
        for (uint8 i = 0; i < count; i++) {
            uint f = 0;
            if (adminlist[i] == _arbiter) {
                f = 1;
                exit;
            }
        }
        if (msg.sender == seller && f == 1) {
            _arbiter.transfer(_amount);
        }
    }

    function payToSeller(uint _amount, bool flag) public {
        if (sellerflag == true) {
            if (msg.sender == buyer) {
                seller.transfer(_amount);
            }
        }
        if (flag == true) {
            selfdestruct(seller);
        }
    }

    function confirm() public {
        if (msg.sender == buyer) {
            buyerflag = true;
            payToSeller(0, buyerflag);
        }
    }
}
