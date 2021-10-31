pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import './6_GameObject.sol';
import './6_MilitaryUnit.sol';

contract BaseStation is GameObject, BaseStationInterface {
    address[] public units;

    function getUnits() public returns(address[]) {
        return units;
    }

    function addUnit(address unit) external override {
        tvm.accept();
        units.push(unit);
    }

    function removeUnit(address unit) external override {
        tvm.accept();
        bool met = false;
        for (uint i = 0; i < units.length - 1; i++) {
            if (units[i] == unit) met = true;
            if (met) units[i] = units[i + 1];
        }
        units.pop();
    }

    function die() internal override {
        tvm.accept();
        for (uint i = units.length - 1; i >= 0; i--) {
            MilitaryUnit(units[i]).baseDie();
            this.removeUnit(units[i]);
        }
        address withdrawAccount = msg.sender;
        withdrawFundsAndTerminate(withdrawAccount);
    }
}
