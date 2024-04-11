pragma solidity ^0.4.17;

import "./ERC20.sol";
import "./MinterRole.sol";

contract Bitfex_Token is ERC20, MinterRole {
    string public name;
    string public symbol;
    uint8 public decimals;

    constructor(string _name, string _symbol, uint8 _decimals) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function mint(address account, uint256 amount) public onlyMinter {
        _mint(account, amount);
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function burnFrom(address account, uint256 amount) public {
        _burnFrom(account, amount);
    }

    function tokenName() public view returns (string) {
        return name;
    }

    function tokenSymbol() public view returns (string) {
        return symbol;
    }

    function tokenDecimals() public view returns (uint8) {
        return decimals;
    }
}