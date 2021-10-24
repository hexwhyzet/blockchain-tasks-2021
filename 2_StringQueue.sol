pragma ton -solidity >= 0.35.0;
pragma AbiHeader expire;

contract StringQueue {
    struct Queue {
        string[] data;
        uint front;
        uint back;
    }

    Queue q;

    function length() internal view returns (uint) {
        return q.back - q.front;
    }

    function push(string input_data) internal {
        q.data.push(input_data);
        q.back = q.back + 1;
    }

    function pop() internal returns (string r) {
        r = q.data[q.front];
        delete q.data[q.front];
        q.front = q.front + 1;
    }
}