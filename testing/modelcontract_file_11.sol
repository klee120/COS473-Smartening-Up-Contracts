pragma solidity ^0.4.17;

contract Ghost_Core_Finance is ERC20Detailed, Ownable {
    event MinterAdded(address indexed _minter);

    uint256 private _totalSupply = 100000000000000000000000000;
    string internal _name = "Ghost Core Finance";
    string internal _symbol = "GHCO";
    uint8 internal _decimals = 18;
    string internal _standard = "ERC20Detailed 0.1"; // implementation of the ERC20Detailed standard

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowed;
    mapping(address => bool) private minters;

    constructor() public {
        addMinter(msg.sender);
    }

    function addMinter(address _minter) public onlyOwner {
        minters[_minter] = true;
        emit MinterAdded(_minter);
    }

    function findOnePercent(uint256 _value) internal pure returns (uint256 result) {
        uint256 roundValue = _roundValue(_value, 1);
        uint256 onePercent = roundValue.mul(1).div(100);
        return onePercent;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return _balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= _balances[msg.sender]);

        _balances[msg.sender] = _balances[msg.sender].sub(_value);
        _balances[_to] = _balances[_to].add(_value);

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_from != address(0));
        require(_to != address(0));
        require(_value <= _balances[_from]);
        require(_value <= _allowed[_from][msg.sender]);

        _balances[_from] = _balances[_from].sub(_value);
        _balances[_to] = _balances[_to].add(_value);
        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
        
        emit Transfer(_from, _to, _value);

        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != address(0));

        _allowed[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return _allowed[_owner][_spender];
    }

    function burn(uint256 _value) public returns (bool) {
        require(_value <= _balances[msg.sender]);

        _balances[msg.sender] = _balances[msg.sender].sub(_value);
        _totalSupply = _totalSupply.sub(_value);
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) public returns (bool) {
        require(_from != address(0));
        require(_value <= _balances[_from]);
        require(_value <= _allowed[_from][msg.sender]);

        _balances[_from] = _balances[_from].sub(_value);
        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
        _totalSupply = _totalSupply.sub(_value);
        emit Transfer(_from, address(0), _value);

        return true;
    }
}