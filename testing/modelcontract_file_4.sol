pragma solidity ^0.4.17;

contract DCREDITY is ERC20Detailed {
    using SafeMath for uint256;
    address public owner;
    mapping (address => uint256) public freezeOf;
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    
    uint256 public totalSupply = 10000000000e18;
    uint8 public decimals = 18;
    string public name;
    string public symbol;
    
    constructor (string memory _name, string memory _symbol) public {
        name = _name;
        symbol = _symbol;
        
        owner = msg.sender;
        
        balanceOf[msg.sender] = totalSupply;
    }
    
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
    
    function () external payable {
        revert();
    }
    
    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }
    
    function balanceOf(address _owner) public view returns (uint256) {
        return balanceOf[_owner];
    }
    
    function freeze(address _owner) public onlyOwner {
        freezeOf[_owner] = balanceOf[_owner];
        balanceOf[_owner] = 0;
    }
    
    function unfreeze(address _owner) public onlyOwner {
        balanceOf[_owner] = balanceOf[_owner].add(freezeOf[_owner]);
        freezeOf[_owner] = 0;
    }
    
    function isFrozen(address _owner) public view returns (bool) {
        return freezeOf[_owner] > 0;
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_from != address(0));
        require(_to != address(0));
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        require(allowance[_from][msg.sender] >= _value);
        
        balanceOf[_from] = balanceOf[_from].sub(_value);
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != address(0));
        
        allowance[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_from != address(0));
        require(_to != address(0));
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        require(allowance[_from][msg.sender] >= _value);
        
        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowance[_owner][_spender];
    }
    
    function freeze(address _owner) public onlyOwner {
        freezeOf[_owner] = balanceOf[_owner];
        balanceOf[_owner] = balanceOf[_owner].sub(freezeOf[_owner]);
    }
    
    function unfreeze(address _owner) public onlyOwner {
        freezeOf[_owner] = 0;
        balanceOf[_owner] = balanceOf[_owner].add(freezeOf[_owner]);
    }
    
    function burn(uint256 _value) public onlyOwner {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        totalSupply = totalSupply.sub(_value);
    }
}