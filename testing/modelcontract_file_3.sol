pragma solidity ^0.4.17;

contract ANTIHYPE is ERC20Detailed {
    using SafeMath for uint256;
    
    string public name;
    string public symbol;
    uint8  public decimals;
    uint256 public totalSupply;

    address public owner;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    constructor() public {
        name = "ANTIHYPE Token";
        symbol = "ANTIHYPE";
        decimals = 18;
        owner = msg.sender;
        totalSupply = 10000 * 10 ** uint(decimals); 
    }

    function _executeTransfer(address _from, address _to, uint256 _value) internal {
        require(_from != address(0));
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= balances[address(this)]);
        
        balances[_from] = (balances[_from]).sub(_value);
        balances[_to] = (balances[_to]).add(_value);
        emit Transfer(_from, _to, _value);
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }
    
    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != address(0));
        
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        
        return true;
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        
        _executeTransfer(msg.sender, _to, _value);
        
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_from != address(0));
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        
        _executeTransfer(_from, _to, _value);
        allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_value);
        balances[_from] = (balances[_from]).sub(_value);
        balances[_to] = (balances[_to]).add(_value);
        emit Transfer(_from, _to, _value);
        
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
        require(_spender != address(0);
        
        allowed[msg.sender][_spender] = (allowed[msg.sender][_spender]).add(_addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
        require(_spender != address(0);
        
        allowed[msg.sender][_spender] = (allowed[msg.sender][_spender]).sub(_subtractedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        
        return true;
    }

    function withdrawUnclaimedTokens(address _tokenAddress) public onlyOwner returns (bool) {
        require(_tokenAddress != address(0), "ERC20: transfer to the zero address");
        
        uint256 _contractBalance = IERC20(_tokenAddress).balanceOf(address(this));
        require(_contractBalance > 0, "ERC20: contract has no tokens");
        
        IERC20(_tokenAddress).transfer(owner, _contractBalance);
        return true;
    }

    function setOwner(address _owner) public onlyOwner {
        owner = _owner;
    }
}