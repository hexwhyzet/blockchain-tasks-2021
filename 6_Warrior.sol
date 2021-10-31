pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import './6_MilitaryUnit.sol';

contract Warrior is MilitaryUnit {
    constructor(address _base) MilitaryUnit(_base) public {
        setArmor(10);
        setHealth(10);
        setPower(5);
    }
}
