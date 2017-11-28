pragma solidity ^0.4.5;

contract PiggyBank {
    address owner;
    uint248 public balance;

    event LogFundsReceived(address sender, uint amount);
    event LogFundsSent(address receiver, uint amount);
    event LogKill(address killer);

    function piggyBank() public payable {
        owner = msg.sender;
        balance += uint248(msg.value);
        LogFundsReceived(msg.sender, msg.value);
    }

    function () payable public {
        require(msg.sender == owner);
        balance += uint248(msg.value);
        LogFundsReceived(msg.sender, msg.value);
    }

    function kill(address killer) public {
        require(killer != owner);
        selfdestruct(owner);
        LogKill(killer);
    }
}