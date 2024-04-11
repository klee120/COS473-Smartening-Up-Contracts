pragma solidity ^0.4.17;

contract Legends_of_Crypto is ERC20Detailed {
    using SafeMath for uint256;
    string public constant name = "Legends of Crypto";
    string public constant symbol = "LOCG";
    uint8 public constant decimals = 18;
    uint256 public totalSupply = 150e18;
    address payable private owner;
    
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor () public {
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    function findOnePercentb() public view returns (uint256) {
        uint256 _ts = totalSupply;
        uint256 _onePercent = _ts.div(100);
        return _onePercent;
    }

    function burn(uint256 _amount) public {
        require(_amount <= balances[msg.sender]);
        
        totalSupply = totalSupply.sub(_amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        emit Transfer(msg.sender, address(0), _amount);
    }
    
    function burnFrom(address _from, uint256 _amount) public {
        require(_amount <= balances[_from]);
        require(_amount <= allowed[_from][msg.sender]);

        totalSupply = totalSupply.sub(_amount);
        balances[_from] = balances[_from].sub(_amount);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
        emit Transfer(_from, address(0), _amount);
    }
    
    function multiTransfer(address[] calldata _to, uint256[] calldata _value) public {
        for (uint i = 0; i < _to.length; i++) {
            transfer(_to[i], _value[i]);
        }
    }
}