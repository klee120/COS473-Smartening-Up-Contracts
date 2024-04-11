pragma solidity ^0.4.17;

contract CrymCoin is Ownable, ERC20Interface {
    using SafeMath for uint256;
    string public name = "CrymCoin";
    string public symbol = "CRYM";
    uint8 public decimals = 8;
    uint256 public totalSupply = 100000000 * 1 ether;
    
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    bool public crowdsaleActive = false;
    
    uint256 public rate;
    uint256 public startDate;
    uint256 public endDate;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor() public {
        rate = 80000000;
        startDate = 1538353200;
        endDate = 1541030400;
        balanceOf[msg.sender] = totalSupply;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert();
        _;
    }

    function setRate(uint256 _rate) public onlyOwner {
        rate = _rate;
    }
    
    function setCrowdsale(bool _crowdsaleActive) public onlyOwner {
        crowdsaleActive = _crowdsaleActive;
    }
    
    function crowdsaleOpen() public view returns (bool) {
        if (crowdsaleActive == true) {
            if (now > startDate && now < endDate) {
                return true;
            }           

            return false;
        }    }

    function crowdsaleEnded() public view returns (bool) {
        if (now > endDate || balanceOf[msg.sender] <= 0) {
            return true;
        }
        
        return false;
    }

    function endCrowdsale() public onlyOwner {
        require (crowdsaleActive == true);
        crowdsaleActive = false;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balanceOf[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value);
		require(balanceOf[_to] + _value >= balanceOf[_to]);
	 balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
		emit Transfer(msg.sender, _to, _value);
		return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(balanceOf[_from] >= _value);
		require(allowance[_from][msg.sender] >= _value);
        allowance[_from][msg.sender] -= _value;
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function burn(uint256 _value) public onlyOwner {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }
}