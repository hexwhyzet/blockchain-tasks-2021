pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import './6_GameObject.sol';
import './6_BaseStationInterface.sol';

contract MilitaryUnit is GameObject {
    address public base;
    uint private power;

    constructor(address _base) public {
        BaseStationInterface(_base).addUnit(address(this));
        base = _base;
    }

    function getPower() public returns(uint) {
        return power;
    }

    function setPower(uint newPower) internal {
        tvm.accept();
        power = newPower;
    }

    function attack(address unit) public {
        tvm.accept();
        MilitaryUnit(unit).receiveAttack(power);
    }

    function baseDie() public {
        tvm.accept();
        die();
    }
}
