pragma solidity ^0.4.0;
import './Token.sol';

contract Reputation {

    using SafeMath for uint256;

    address public _agent;

    string ownerAddress;
    //contract owner is property owner
    address _owner;

    Token public _repToken;

    struct Contractor {
        uint256 _reputation;
        string _address;
    }

    modifier OwnerOnly() {
        require(msg.sender == _owner);
        _;
    }

    modifier AgentOnly() {
        require(msg.sender == _agent);
            _;
    }

    mapping(address => Contractor) AngelList;

    function Reputation() {
        _owner = msg.sender;
        _repToken = new Token();
    }

    //only the agent can add new contractors, adds by address
    //address should hold
    function AddToList(address contractor, string addy) AgentOnly {
        _repToken.mint(5);
        AngelList[contractor] = Contractor(5, addy);
        contractor.transfer(5);
    }

    //app front end can be designed to post suggested agents
    //with their rep scores (if used) and ethereum addresses
    function setAgent() OwnerOnly(address agent) {
        _agent = agent;
    }

    //only implement if the agent should have reputation as well
    function rateAgent() OwnerOnly() {
        //agent rep ++
    }

    function rateContractor(Contractor con) OwnerOnly() {
        if(msg.value > 0) {
            con._repTokens += 1;
        } else if (con._repTokens > 0){
            con._repTokens -= 1;
        }
    }
}
