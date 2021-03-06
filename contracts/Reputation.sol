pragma solidity ^0.4.0;
import './Token.sol';
//import './ipfs.sol';

contract Reputation {

    using SafeMath for uint256;

    address public _agent;

    string ownerAddress;
    //contract owner is property owner
    address public _owner;

    Token public _repToken;

    struct Contractor {
        address _contractor;
        string _address;
        mapping(string => Job) _jobList;
    }

    struct Job {
        uint256 _bonusTime;
        address _workOrder;
        uint256 _value;
        bool _jobDone;
        bool ownerHasRatedContractor;
        bool agentHasRatedContractor;
    }

    modifier OwnerOnly() {
        require(msg.sender == _owner);
        _;
    }

    modifier AgentOnly() {
        require(msg.sender == _agent);
            _;
    }


    modifier JobNotDone(Job job) {
        require(job._jobDone == false);
        _;
    }

    function Reputation() {
        _owner = msg.sender;
        _repToken = new Token();
    }

    mapping(address => Contractor) public AngelList;

    //only the agent can add new contractors, adds by address
    //address should hold
    function AddToList(address contractor, string addy) AgentOnly {
        _repToken.mint(5);
        AngelList[contractor] = Contractor(contractor, addy);
        _repToken.transfer(contractor, 5);
    }

    //app front end can be designed to post suggested agents
    //with their rep scores (if used) and ethereum addresses
    function setAgent(address agent) OwnerOnly {
        _agent = agent;
    }

    //possibly add a function to timeout after a certain time after the job has elapsed,
    //no longer allowing owner to take tokesn (_repToken.decreaseApproval)
    function rateContractorOwner(address con, uint256 rating, string id) OwnerOnly() {
        require(AngelList[con]._jobList[id]._jobDone && !AngelList[con]._jobList[id].ownerHasRatedContractor);

        if (rating > 0) {
            _repToken.mint(1);
            _repToken.transfer(con, 1);
        } else if (_repToken.balanceOf(con) > 0) {
            _repToken.transferFrom(con, _owner, 1);
            _repToken.burn(1);
        }

        if (_repToken.allowance(this, con) > 0) {
            _repToken.decreaseApproval(con, this, 1);
        }
        AngelList[con]._jobList[id].ownerHasRatedContractor = true;
    }

    function rateContractorAgent(address con, uint256 rating, string id) {
        require(AngelList[con]._jobList[id]._jobDone && !AngelList[con]._jobList[id].agentHasRatedContractor);
        if (rating > 0) {
            _repToken.mint(1);
            _repToken.transfer(con, 1);
        } else if (_repToken.balanceOf(con) > 0) {
            _repToken.transferFrom(con, _agent, 1);
            _repToken.burn(1);
        }
        AngelList[con]._jobList[id].agentHasRatedContractor = true;
    }

    //starts a job with the given contractor, if finished before bonusTime,
    //contractor receives extra reputation tokens
    function startJob(address con, uint256 bonusTime, string id) payable AgentOnly() {
        require(bonusTime > 0);
        require(AngelList[con]._contractor != address(0));
        AngelList[con]._jobList[id] = Job(bonusTime + now, con, msg.value, false, false, false);
        JobStarted(id, now);
        _repToken.approve(con, this, 2);
    }

    //ends job, pays the worker the amount of tokens sent when the job started,
    //includes goodBad (0 for bad rating, positive for good rating)
    function endJob(address contractor, string id, uint256 rating) AgentOnly() {
        if(AngelList[contractor]._jobList[id]._bonusTime > now) {
            _repToken.mint(1);
            _repToken.transfer(contractor, 1);
        }
        AngelList[contractor]._jobList[id]._jobDone = true;

        _repToken.mint(AngelList[contractor]._jobList[id]._value);
        contractor.transfer(AngelList[contractor]._jobList[id]._value);
        AngelList[contractor]._jobList[id]._value = 0;

        rateContractorAgent(contractor, rating, id);
        JobEnded(id, rating);
    }

    event JobStarted(string jobID, uint256 timeStarted);
    event JobEnded(string jobID, uint256 rating);
}
