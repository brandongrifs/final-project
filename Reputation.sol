pragma solidity ^0.4.0;
import './Token.sol';

contract Reputation {

    using SafeMath for uint256;

    address public _agent;
    string ownerAddress;
    //contract owner is property owner
    address _owner;

    struct Contractor {
        uint256 _repTokens;
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

    //only the agent can add new contractors, adds by address
    //address should hold
    function AddToList() AgentOnly() {

        // AngelList[address] = new Contractor ... 
    }

    //app front end can be designed to post suggested agents
    //with their rep scores (if used) and ethereum addresses
    function setAgent() OwnerOnly(address agent) {
        _agent = agent;
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
