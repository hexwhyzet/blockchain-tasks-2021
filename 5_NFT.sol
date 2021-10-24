pragma ton -solidity >= 0.35.0;
pragma AbiHeader expire;

contract NFT {
    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    struct Token {
        string buildingName;
        uint blockX; // in range [0, 10)
        uint blockY; // in range [0, 10)
        uint height;
    }

    Token[] tokens;
    mapping(uint => uint) tokenToOwner;
    mapping(uint => int) tokenToPrice;
    uint[] arr;

    modifier checkKey(uint key) {
        require(key < tokens.length, 104, "Invalid key.");
        _;
    }

    modifier checkTokenOwner(uint key) {
        require(msg.pubkey() == tokenToOwner[key], 105, "You are not the owner of token");
        _;
    }

    modifier checkHeight(uint height) {
        require(height > 0, 106, "Height can not be negative");
        _;
    }

    function mintToken(string buildingName, uint blockX, uint blockY, uint height) public {
        require((0 <= blockX) && (blockX < 10) && (0 <= blockY) && (blockY < 10), 101,
            "Invalid building coordinates. Must be in range [0, 10).");
        for (Token token : tokens) {
            require((token.blockX != blockX) || (token.blockY != blockY), 102, "Invalid building coordinates. This place is already taken.");
            require(token.buildingName != buildingName, 103, "This building name is already taken.");
        }
        tvm.accept();
        tokens.push(Token(buildingName, blockX, blockY, height));
        tokenToOwner[tokens.length - 1] = msg.pubkey();
        tokenToPrice[tokens.length - 1] = - 1;
    }


    function getTokensList() public returns (Token[]) {
        return tokens;
    }

    function getTokenOwner(uint key) public checkKey(key) returns (uint) {
        return tokenToOwner[key];
    }

    function getDescription(uint key) public checkKey(key) returns (Token) {
        return tokens[key];
    }

    function changeHeight(uint key, uint newHeight) public checkKey(key) checkTokenOwner(key) checkHeight(newHeight) {
        tvm.accept();
        tokens[key].height = newHeight;
    }

    function changeOwner(uint key, uint newOwner) public checkKey(key) checkTokenOwner(key) {
        tvm.accept();
        tokenToOwner[key] = newOwner;
    }

    function setPrice(uint key, int newPrice) public checkKey(key) checkTokenOwner(key) {
        tvm.accept();
        tokenToPrice[key] = newPrice;
    }

    function getPrice(uint key) public checkKey(key) returns (int){
        require(tokenToPrice[key] != - 1, 106, "This building is not for sale.");
        return tokenToPrice[key];
    }

    function removeFromSale(uint key) public checkKey(key) checkTokenOwner(key) {
        tvm.accept();
        tokenToPrice[key] = - 1;
    }
}
