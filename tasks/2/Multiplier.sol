pragma ton -solidity >= 0.35.0;
pragma AbiHeader expire;

contract Multiplier {

    uint public product = 1;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function add(uint value) public {
        require(1 <= value && value <= 10, 103, "Value should be in range from 1 to 10");
        tvm.accept();
        product *= value;
    }
}