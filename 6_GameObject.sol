pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import './6_GameObjectInterface.sol';

contract GameObject is GameObjectInterface {
    
    uint private health;
    uint private armor;

    function receiveAttack(uint value) external override {
        tvm.accept();
        if (value > armor) {
            uint damage = value - armor;
            if (damage >= health) {
                health = 0;
            } else {
                health -= damage;
            }
        }
        if (isDead()) {
            die();
        }
    }

    function getHealth() public returns(uint) {
        return health;
    }

    function getArmor() public returns(uint) {
        return armor;
    }

    function setHealth(uint newHealth) internal {
        tvm.accept();
        health = newHealth;
    }

    function setArmor(uint newArmor) internal {
        tvm.accept();
        armor = newArmor;
    }

    function isDead() private returns(bool) {
        return health == 0;
    }

    function die() virtual internal {
        tvm.accept();
        withdrawFundsAndTerminate(msg.sender);
    }

    function withdrawFundsAndTerminate(address dest) internal {
        tvm.accept();
        dest.transfer(0, true, 160);
    }
}
