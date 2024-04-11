pragma solidity 0.4.17;

import "./ERC20Detailed.sol";
import "./SafeMath.sol";

contract ANTIHYPE is ERC20Detailed {
    using SafeMath for uint256;

    uint256 private _totalSupply = 10000 * (10 ** uint256(decimals()));
    address private _owner;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only owner can call this function");
        _;
    }

    constructor(address owner) ERC20Detailed("ANTIHYPE Token", "ANTIHYPE", 18) public {
        _owner = owner;
        _balances[owner] = _totalSupply;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _executeTransfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount);
        _executeTransfer(sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _allowances[msg.sender][spender] = amount;
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _allowances[msg.sender][spender] = _allowances[msg.sender][spender].add(addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _allowances[msg.sender][spender] = _allowances[msg.sender][spender].sub(subtractedValue);
        return true;
    }

    function multiTransfer(address[] recipients, uint256[] amounts) public returns (bool) {
        require(recipients.length == amounts.length, "Recipient count does not match amount count");
        for (uint256 i = 0; i < recipients.length; i++) {
            _executeTransfer(msg.sender, recipients[i], amounts[i]);
        }
        return true;
    }

    function multiTransferEqualAmount(address[] recipients, uint256 amount) public returns (bool) {
        for (uint256 i = 0; i < recipients.length; i++) {
            _executeTransfer(msg.sender, recipients[i], amount);
        }
        return true;
    }

    function withdrawUnclaimedTokens(address token) public onlyOwner {
        ERC20Detailed tokenContract = ERC20Detailed(token);
        uint256 unclaimedTokens = tokenContract.balanceOf(address(this));
        require(tokenContract.transfer(_owner, unclaimedTokens), "Token transfer failed");
    }

    function _executeTransfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(_balances[sender] >= amount, "Insufficient balance");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
    }
}