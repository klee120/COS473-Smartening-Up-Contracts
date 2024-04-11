pragma solidity ^0.4.17;

import "./ERC20Detailed.sol";
import "./SafeMath.sol";
import "./Ownable.sol";

contract Ghost_Core_Finance is ERC20Detailed, Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    constructor(address initialOwner) ERC20Detailed("Ghost Core Finance", "GHCO", 18) public {
        _totalSupply = 1000000 * (10 ** uint256(decimals()));
        _balances[initialOwner] = _totalSupply;
        emit Transfer(address(0), initialOwner, _totalSupply);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(value <= _balances[msg.sender], "ERC20: transfer amount exceeds balance");

        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(value <= _balances[from], "ERC20: transfer amount exceeds balance");
        require(value <= _allowed[from][msg.sender], "ERC20: transfer amount exceeds allowance");

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        emit Transfer(from, to, value);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function burn(uint256 value) public {
        _burn(msg.sender, value);
    }

    function burnFrom(address from, uint256 value) public {
        _burn(from, value);
    }

    function _burn(address account, uint256 value) internal {
        require(value <= _balances[account], "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    function findOnePercent(uint256 value) public view returns (uint256) {
        uint256 onePercent = value.mul(1).div(100);
        return onePercent;
    }
}