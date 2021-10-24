pragma ton -solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskManager {
    struct Task {
        string name;
        uint creationDate;
        bool isCompleted;
        bool isDeleted;
    }

    uint8 private tasksCreated;
    uint8 public openedTasks;
    mapping(uint8 => Task) private tasks;

    function push(string taskName) internal returns (uint8) {
        tasks[tasksCreated++] = Task(taskName, now, false, false);
        ++openedTasks;
        return tasksCreated - 1;
    }

    function pop(uint8 key) internal {
        closeTask(key);
        tasks[key].isDeleted = true;
    }

    function closeTask(uint8 key) internal {
        if (!tasks[key].isCompleted) {
            --openedTasks;
            tasks[key].isCompleted = true;
        }
    }

    function get(uint8 key) internal view returns (Task) {
        return tasks[key];
    }

    function addTask(string taskName) public returns (uint8) {
        tvm.accept();
        return push(taskName);
    }

    modifier IsKeyValid(uint8 key) {
        require(key < tasksCreated, 101, "Key doesn't exist");
        _;
    }

    modifier IsNotDeleted(uint8 key) {
        require(!get(key).isDeleted, 102, "Specified task is already deleted");
        _;
    }

    modifier IsNotCompleted(uint8 key) {
        require(!get(key).isCompleted, 103, "Specified task is already completed");
        _;
    }

    function deleteTask(uint8 key) public IsKeyValid(key) IsNotDeleted(key) {
        tvm.accept();
        pop(key);
    }

    function markCompleted(uint8 key) public IsKeyValid(key) IsNotCompleted(key) {
        tvm.accept();
        closeTask(key);
    }

    function getDescription(uint8 key) public view IsKeyValid(key) IsNotDeleted(key) returns (Task) {
        tvm.accept();
        return get(key);
    }

    struct ListElement {
        uint8 key;
        string name;
    }

    function getOpenedTasks() public view returns (ListElement[]) {
        ListElement[] res;
        for (uint8 i = 0; i < tasksCreated; i++) {
            if (!get(i).isCompleted) {
                res.push(ListElement(i, get(i).name));
            }
        }
        return res;
    }
}