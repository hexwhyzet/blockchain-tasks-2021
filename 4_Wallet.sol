pragma ton -solidity >= 0.35.0;
pragma AbiHeader expire;

contract Wallet {
    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
        require(msg.pubkey() == tvm.pubkey(), 100);
        tvm.accept();
        _;
    }

    function _processTransaction(address dest, uint128 value, bool bounce, uint16 flag) internal pure checkOwnerAndAccept {
        dest.transfer(value, bounce, flag);
    }

    function sendCrystalsIncludingFee(address dest, uint128 value) public pure checkOwnerAndAccept {
        _processTransaction(dest, value, true, 0);
    }

    function sendCrystalsPlusFee(address dest, uint128 value) public pure checkOwnerAndAccept {
        _processTransaction(dest, value, true, 1);
    }

    function sendAllCrystalsAndDestroyWallet(address dest) public pure checkOwnerAndAccept {
        _processTransaction(dest, 0, true, 160);
    }
}