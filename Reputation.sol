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

    struct Job {
        uint256 _bonusTime;
        Contractor _workOrder;
        uint256 _value;
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
    function setAgent(address agent) OwnerOnly {
        _agent = agent;
    }

    //only implement if the agent should have reputation as well
    function rateAgent() OwnerOnly() {
        //agent rep ++
    }

    function rateContractor(Contractor con) OwnerOnly() {
        if(msg.value > 0) {
            con._repTokens += 1;
        } else if (con._repTokens > 0) {
            con._repTokens -= 1;
        }
    }

    function rateContractor(Contractor con, uint256 rating) {
        if(rating > 0) {
            con._repTokens += 1;
        } else if (con._repTokens > 0) {
            con._repTokens -= 1;
        }
    }


    //starts a job with the given contractor, if finished before bonusTime,
    //contractor receives extra reputation tokens
    function startJob(Contractor con, uint256 bonusTime) payable AgentOnly() {
        require(bonusTime > now);
        require(AngelList[con].length != 0); // same as AngelList[con] != null (null doesn't exist in Solidity)
        Job thisJob = Job(con, bonusTime, msg.value);
        JobStarted(thisJob, now);
    }

    //ends job, pays the worker the amount of tokens sent when the job started,
    //includes goodBad (0 for bad rating, positive for good rating)
    function endJob(Job job, uint256 rating) AgentOnly() {
        if(job._bonusTime > now) {
            job._workOrder._repTokens += 1;
        }
        _repToken.mint(job._value);
        job._workOrder.transfer(job._value);
        job._value = 0;
        rateContractor(job._workOrder, rating);
        JobEnded(job, rating);

    }

    event JobStarted(Job job, uint256 timeStarted);
    event JobEnded(Job job, uint256 rating);
}
