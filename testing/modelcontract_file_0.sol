pragma solidity ^0.4.17;

contract Bitfex_Token is ERC20, MinterRole {
    uint8 private _decimals;
    string private _name;
    string private _symbol;

    mapping(address => bool) private _minters;

    constructor(string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    // Get the token balance for account `tokenOwner`
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balanceOf(tokenOwner);
    }

    // Transfer the balance from token owner's account to `to` account
    function transfer(address to, uint tokens) public returns (bool success) {
        return transferFrom(to, tokens);
    }

    // Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account
    function approve(address spender, uint tokens) public returns (bool success) {
        require(spender != address(0), "ERC20: approve to the zero address");
        _minters[spender] = true;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // Transfer `tokens` from the `from` account to the `to` account
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        require(from != address(0), "ERC20: transfer from or to the zero address");
        require(to != address(0), "ERC20: transfer to or from the zero address");
        require(_balances[from] >= tokens, "ERC20: transfer amount exceeds balance");
        require(allowance(from, msg.sender) >= tokens, "ERC20: transfer amount exceeds allowance");
        require(_minters[msg.sender], "ERC20: sender does not have minter role");
        require(_balances[to] + tokens >= _balances[to]);
        
        _balances[from] -= tokens;
        _balances[to] += tokens;
        _allowed[from][msg.sender] -= tokens;
        _mint(from, tokens);
        return true;
    }

    // Destroy tokens for `account`
    function burn(address account, uint tokens) public returns (bool success) {
        require(account != address(0), "ERC20: burn from the zero address");
        require(_balances[account] >= tokens, "ERC20: burn amount exceeds balance");
        
        _balances[account] -= tokens;
        _totalSupply -= tokens;
        emit Transfer(account, address(0), tokens);
        return true;
    }

    // Destroy tokens from other account and approve `spender` to transferFrom(...) `tokens` from the token owner's account
    function burnFrom(address account, uint tokens) public returns (bool success) {
        require(account != address(0), "ERC20: burn from the zero address");
        require(_balances[account] >= tokens, "ERC20: burn amount exceeds balance");
        require(_allowed[account][msg.sender] >= tokens, "ERC20: transfer amount exceeds allowance");
        
        _balances[account] -= tokens;
        _allowed[account][msg.sender] -= tokens;
        _totalSupply -= tokens;
        emit Transfer(account, address(0), tokens);
        return true;
    }
}
