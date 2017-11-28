pragma solidity ^0.4.5;

contract WarehouseI {
    function ship(uint id, address customer)
    public
    returns (bool handled);
}


contract Store {
    address public wallet;
    WarehouseI warehouse;
    event LogPurchase(uint parchaseItemId);

    function Store(address _wallet, address _warehouse) public {
        wallet = _wallet;
        warehouse = WarehouseI(_warehouse);
    }

    function purchase(uint id) public payable returns (bool success)  {
        if(!wallet.send(msg.value)){
            return false;
        }
        LogPurchase(id);
        return warehouse.ship(id, msg.sender);
    }
}