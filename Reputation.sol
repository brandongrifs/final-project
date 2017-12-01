pragma solidity ^0.4.0;


contract Reputation {

    address public _agent;
    string ownerAddress;
    address _owner;

    struct Contractor {
        uint _repTokens;
        string _address;
    }

    modifier OwnerOnly() {
        if(msg.sender == _owner){
            _;
        }
    }

    modifier AgentOnly() {
        if(msg.sender == _agent){
            _;
        }
    }

    mapping(address => Contractor) AngelList;

    function AddToList() AgentOnly() {
        // AngelList[address] = new Contractor ... 
    }

    function findAgent() OwnerOnly() {

    }

    function rateAgent() OwnerOnly() {
        //agent rep ++
    }

    function rateContractor(Contractor con) OwnerOnly() {
        if(msg.value > 0) {
            con._repTokens = 1;
        } else {
            con._repTokens = 0;
        }
    }

    function Reputation(address agent){
        _owner = msg.sender;
        _agent = agent;

    }
}
