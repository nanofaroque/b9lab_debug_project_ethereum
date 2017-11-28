pragma solidity ^0.4.6;


contract Splitter {
    /**
    * Address of the owner
    */
    address public owner;

    /**
    * Mapper for address to balances
    */
    mapping (address => uint) public balances;

    /**
    * tracker to detect the contract is active or not
    */
    bool public isActive;

    /**
    * Log when split has been sent
    */
    event LogSplitSent(address indexed from, address add1, address add2, uint256 amount);

    /**
    * Log withdrawal
    */
    event LogWithdrawal(address indexed caller, uint256 amount);

    /**
    * Log when contract is killed
    */
    event LogKilled();

    /**
    * Constructor
    */
    function Splitter() public {
        owner = msg.sender;
        isActive = true;
    }

    function split(address address1, address address2)
    public
    payable returns (bool){
        // value has to be above 1
        require(msg.value > 1);
        // Check the addresses was set
        assert(address1 != address(0));
        assert(address2 != address(0));
        assert(isActive);
        // split the balances
        balances[address1] += msg.value / 2;
        balances[address2] += msg.value / 2;
        // remainder will go to owner
        if (msg.value % 2 > 0)
        balances[msg.sender] += 1;
        LogSplitSent(msg.sender, address1, address2, msg.value);
        return true;
    }

    function claim() public payable returns (bool){
        require(balances[msg.sender] > 0);
        uint toSend = balances[msg.sender];
        balances[msg.sender] = 0;
        bool isSuccess = msg.sender.send(toSend);
        if (isSuccess) {
            LogWithdrawal(msg.sender, toSend);
        }
        else {
            balances[msg.sender] = toSend;
        }
        return isSuccess;
    }

    function kill() public returns (bool){
        require(msg.sender == owner);
        isActive = false;
        LogKilled();
        return true;
    }

    function() public {
        throw;
    }
}
