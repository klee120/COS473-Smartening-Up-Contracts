pragma solidity 0.4.17;

contract ERC20Interface {
    function totalSupply() public view returns (uint256);
    function balanceOf(address tokenOwner) public view returns (uint256 balance);
    function transfer(address to, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a);
        return c;
    }
    
    function safeSub(uint a, uint b) internal pure returns (uint) {
        require(b <= a);
        return a - b;
    }
}

contract CrymCoin is ERC20Interface, SafeMath {
    string public constant name = "CrymCoin";
    string public constant symbol = "CRYM";
    uint8 public constant decimals = 8;
    uint256 public constant initialSupply = 1000000 * 10**uint(decimals);
    
    address public owner;
    uint256 public totalSupply;
    uint256 public rate;
    bool public isCrowdsaleActive;
    
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    constructor(uint256 _rate) public {
        owner = msg.sender;
        totalSupply = initialSupply;
        balances[owner] = totalSupply;
        rate = _rate;
        isCrowdsaleActive = true;
    }
    
    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }
    
    function transfer(address to, uint tokens) public returns (bool) {
        require(tokens <= balances[msg.sender]);
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    
    function transferFrom(address from, address to, uint tokens) public returns (bool) {
        require(tokens <= balances[from]);
        require(tokens <= allowed[from][msg.sender]);
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
    
    function approve(address spender, uint tokens) public returns (bool) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function allowance(address tokenOwner, address spender) public view returns (uint256) {
        return allowed[tokenOwner][spender];
    }
    
    function () public payable {
        require(isCrowdsaleActive);
        uint tokens = msg.value * rate;
        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
        totalSupply = safeAdd(totalSupply, tokens);
        owner.transfer(msg.value);
        emit Transfer(address(0), msg.sender, tokens);
    }
    
    function startCrowdsale() public onlyOwner {
        isCrowdsaleActive = true;
    }
    
    function endCrowdsale() public onlyOwner {
        isCrowdsaleActive = false;
    }
    
    function changeRate(uint256 _newRate) public onlyOwner {
        rate = _newRate;
    }
    
    function burnUnsoldTokens() public onlyOwner {
        require(!isCrowdsaleActive);
        totalSupply = safeSub(totalSupply, balances[owner]);
        balances[owner] = 0;
    }
}