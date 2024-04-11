pragma solidity ^0.4.17;

contract OKEXTOKEN {
    string public name = "EXTOKEN";
    string public symbol = "0KB";
    uint8 public decimals = 4;
    
    uint256 public totalSupply = 90000000000 * 10**uint256(decimals); // 90 billion tokens
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed burner, uint256 value);

    address public owner;

    function OKEXTOKEN() public {
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function transfer(address _to, uint256 _value) public {
        require(_to != address(0), "Cannot transfer to zero address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) public {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public {
        require(_to != address(0), "Cannot transfer to zero address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
    }

    function burn(uint256 _value) public {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance to burn");
        
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        
        emit Burn(msg.sender, _value);
    }

    function burnFrom(address _from, uint256 _value) public {
        require(balanceOf[_from] >= _value, "Insufficient balance to burn");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        
        balanceOf[_from] -= _value;
        totalSupply -= _value;
        
        allowance[_from][msg.sender] -= _value;
        emit Burn(_from, _value);
    }
}