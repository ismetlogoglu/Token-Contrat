pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address from, address to, uint value) external returns (bool success);
    function approve(address spender, uint value) external returns (bool success);
    function transfer(address to, uint value) external returns (bool success);
    function balanceOf(address account) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract MyToken is IERC20 {
    string public name;
    uint public totalSupply;
    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

    constructor(string memory _name, uint _totalSupply) {
        name = _name;
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address to, uint value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        require(to != address(0), "Invalid address");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);

        return true;
    }

    function approve(address spender, uint value) public returns (bool) {
        require(spender != address(0), "Invalid address");

        allowance[msg.sender][spender] = value;

        emit Approval(msg.sender, spender, value);

        return true;
    }

    function transferFrom(address from, address to, uint value) public returns (bool) {
        require(from != address(0), "Invalid address");
        require(to != address(0), "Invalid address");
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Insufficient allowance");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);

        return true;
    }

    function balanceOf(address account) public view override returns (uint) {
        return balanceOf[account];
    }

    function allowance(address owner, address spender) public view override returns (uint) {
        return allowance[owner][spender];
    }
}
