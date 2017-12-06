pragma solidity ^0.4.0;
import './Token.sol';
//import './ipfs.sol';

contract Reputation {

    using SafeMath for uint256;

    address public _agent;

    string ownerAddress;
    //contract owner is property owner
    address _owner;
    bool ownerHasRatedContractor = false;
    bool agentHasRatedContractor = false;

    Token public _repToken;

    struct Contractor {
        uint256 _repTokens;
        string _address;
        mapping(string => Job) _jobList;
    }

    struct Job {
        uint256 _bonusTime;
        address _workOrder;
        uint256 _value;
        bool _jobDone;
    }

    modifier OwnerOnly() {
        require(msg.sender == _owner);
        _;
    }

    modifier AgentOnly() {
        require(msg.sender == _agent);
            _;
    }

    modifier OwnerHasNotVoted() {
        require(ownerHasRatedContractor == false);
        _;
    }

    modifier AgentHasNotVoted() {
        require(agentHasRatedContractor == false);
        _;
    }

    modifier JobNotDone(Job job) {
        require(job._jobDone == false);
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

    function rateContractorOwner(address con, uint256 rating) OwnerOnly() OwnerHasNotVoted() {
        Contractor contractor = AngelList[con];
        if (rating > 0) {
            contractor._repTokens += 1;
        } else if (contractor._repTokens > 0) {
            contractor._repTokens -= 1;
        }
    }

    function rateContractorAgent(address con, uint256 rating) AgentOnly() AgentHasNotVoted() {
        Contractor contractor = AngelList[con];
        if (rating > 0) {
            contractor._repTokens += 1;
        } else if (contractor._repTokens > 0) {
            contractor._repTokens -= 1;
        }
    }

    //starts a job with the given contractor, if finished before bonusTime,
    //contractor receives extra reputation tokens
    function startJob(address con, uint256 bonusTime, string id) payable AgentOnly() {
        require(bonusTime > now);
        require(bytes(AngelList[con]._address).length != 0); // same as AngelList[con] != null (null doesn't exist in Solidity)
        AngelList[con]._jobList[id] = Job(bonusTime, con, msg.value, false);
        JobStarted(id, now);
    }

    //ends job, pays the worker the amount of tokens sent when the job started,
    //includes goodBad (0 for bad rating, positive for good rating)
    function endJob(address contractor, string id, uint256 rating) AgentOnly() {
        Job thisJob = AngelList[contractor]._jobList[id];
        if(thisJob._bonusTime > now) {
            AngelList[contractor]._repTokens += 1;
        }
        _repToken.mint(thisJob._value);
        contractor.transfer(thisJob._value);
        thisJob._value = 0;
        rateContractorAgent(contractor, rating);
        JobEnded(id, rating);
    }

    event JobStarted(string jobID, uint256 timeStarted);
    event JobEnded(string jobID, uint256 rating);
}
