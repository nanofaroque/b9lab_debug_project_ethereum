pragma solidity ^0.4.5;


contract PiggyBank {
    address owner;

    uint248 public balance;
    /**
     * tracker to detect the contract is active or not
     */
    bool public isActive;

    event LogFundsReceived(address sender, uint amount);

    event LogFundsSent(address receiver, uint amount);

    event LogKill(address killer);

    function piggyBank() public payable {
        owner = msg.sender;
        balance += uint248(msg.value);
        LogFundsReceived(msg.sender, msg.value);
    }

    function() payable public {
        require(isActive==true);
        require(msg.sender == owner);
        balance += uint248(msg.value);
        isActive = true;
        LogFundsReceived(msg.sender, msg.value);
    }

    function kill(address killer) public {
        require(killer != owner);
        selfdestruct(owner);
        isActive = false;
        LogKill(killer);
    }
}