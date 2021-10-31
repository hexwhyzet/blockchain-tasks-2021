pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import './6_MilitaryUnit.sol';

contract Archer is MilitaryUnit {
    constructor() MilitaryUnit(base) public {
        setArmor(5);
        setHealth(10);
        setPower(10);
    }
}
