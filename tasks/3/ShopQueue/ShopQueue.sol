pragma ton -solidity >= 0.35.0;
pragma AbiHeader expire;

import "./StringQueue.sol";

contract ShopQueue {
    function addPerson(string name) public {
        tvm.accept();
        push(name);
    }

    function servePerson() public returns (string) {
        require(length() > 0, 101, "Queue is empty");
        tvm.accept();
        return pop();
    }
}
