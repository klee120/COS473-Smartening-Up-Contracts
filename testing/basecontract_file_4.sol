pragma solidity 0.4.17;

interface ERC20Detailed {
    function name() external view returns (string);
    function symbol() external view returns (string);
    function decimals() external view returns (uint8);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }
}

contract DCREDITY is ERC20Detailed {
    using SafeMath for uint256;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    address private _owner;

    mapping(address => uint256) private _balanceOf;
    mapping(address => uint256) private _freezeOf;
    mapping(address => mapping(address => uint256)) private _allowance;

    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Freeze(address indexed from, uint256 value);
    event Unfreeze(address indexed from, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() public {
        _name = "DCREDITY";
        _symbol = "DCR";
        _decimals = 18;
        _totalSupply = 10 * 10**9 * 10**uint256(_decimals);
        _owner = msg.sender;
        _balanceOf[_owner] = _totalSupply;
        emit Transfer(address(0), _owner, _totalSupply);
    }

    function name() public view returns (string) {
        return _name;
    }

    function symbol() public view returns (string) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balanceOf[owner];
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowance[owner][spender];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0));
        require(value <= _balanceOf[msg.sender]);

        _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(value);
        _balanceOf[to] = _balanceOf[to].add(value);

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0));
        require(value <= _balanceOf[from]);
        require(value <= _allowance[from][msg.sender]);

        _balanceOf[from] = _balanceOf[from].sub(value);
        _balanceOf[to] = _balanceOf[to].add(value);
        _allowance[from][msg.sender] = _allowance[from][msg.sender].sub(value);

        emit Transfer(from, to, value);
        return true;
    }

    function burn(uint256 value) public {
        require(value <= _balanceOf[msg.sender]);
        
        _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(value);
        _totalSupply = _totalSupply.sub(value);

        emit Burn(msg.sender, value);
        emit Transfer(msg.sender, address(0), value);
    }

    function freeze(uint256 value) public {
        require(value <= _balanceOf[msg.sender]);
        
        _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(value);
        _freezeOf[msg.sender] = _freezeOf[msg.sender].add(value);

        emit Freeze(msg.sender, value);
    }

    function unfreeze(uint256 value) public {
        require(value <= _freezeOf[msg.sender]);

        _freezeOf[msg.sender] = _freezeOf[msg.sender].sub(value);
        _balanceOf[msg.sender] = _balanceOf[msg.sender].add(value);

        emit Unfreeze(msg.sender, value);
    }

    function multiTransfer(address[] recipients, uint256[] values) public {
        require(recipients.length == values.length);

        for (uint256 i = 0; i < recipients.length; i++) {
            transfer(recipients[i], values[i]);
        }
    }

    function setTokenCost(uint256 cost) public onlyOwner {
        // Implement your logic for setting token cost here
    }
}