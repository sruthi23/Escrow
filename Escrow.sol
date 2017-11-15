pragma solidity ^0.4.0;
contract Adminsetup{

  struct adminstruct {
    address _admin;
    bool arbiter;

  }

  adminstruct[] public adminlist;

  function addAdmin(address _newadmin,bool flag) public{

    adminstruct memory m;
    m._admin=_newadmin;
    m.arbiter= flag;
    adminlist.push(m);
  }

  address admin = msg.sender;

  modifier onlyAdmin{
    require(msg.sender==admin);
    _;

  }
  function newAdmin(address _newadmin) public
  onlyAdmin{

    admin = _newadmin;
  }


}

contract Arbitersetup is Adminsetup{
  address arbiter;
  function Arbitersetup(address _arbiter) public{
    if(msg.sender==admin){
      arbiter = _arbiter;
    }
  }
}

contract Escrow is Adminsetup, Arbitersetup{
  address buyer;
  address seller;
  bool sellerflag = false;
  bool buyerflag = false;
  function Escrow(address _seller,address _buyer)public{
    seller = _seller;
    buyer = _buyer;
  }

  function payToSeller(uint _amount,bool flag) public{
    if(sellerflag == true)
    {
      if(msg.sender == buyer){
        seller.transfer(_amount);
      }
    }
    if(flag == true){
      selfdestruct(seller);
    }
  }

  function confirm() public{
    if(msg.sender == buyer){
      buyerflag = true;
      payToSeller(0,buyerflag);
    }
  }
}
