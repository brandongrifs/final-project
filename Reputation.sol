pragma solidity ^0.4.0;


contract Reputation {

    address public _agent;
    String ownerAddress;
    address _owner;

    struct Contractor {
        uint _repTokens;
        String _address;
    }

    modifier OwnerOnly() {
        if(msg.sender == owner){
            _;
        }
    }

    mapping(address => Contractor) AngelList;

    function AddToList()


    function Reputation(address agent){
        _owner = msg.sender;
        _agent = agent;

    }
}
