pragma solidity ^0.4.17;

contract OKEXTOKEN is ERC20 {
    using SafeMath for uint;

    string public name = "EXTOKEN";
    string public symbol = "0KB";
    uint public decimals = 4;
    uint public totalSupply = 90000000000 * 1 ether;
    address public admin;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;

    event Transfer(address indexed from, address indexed to, uint value);
    event Burn(address indexed from, uint value);

    constructor() public {
        admin = msg.sender;
    }

    function burnFrom(address _from, uint _value) public returns (bool success) {
        require(balances[_from] >= _value && _value >= 0);
        balances[_from] = balances[_from].sub(_value);
        totalSupply = totalSupply.sub(_value);
        emit Burn(_from, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        require(balances[msg.sender] >= _value && _value > 0);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        require(balances[_from] >= _value && _value > 0);
        require(balances[_to] >= 0);
        require(allowed[_from][msg.sender] >= _value && _value > 0);
        require(_from != address(0) && _to != address(0));
        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) public returns (bool success) {
        require (_value > 0);
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        require(_owner != address(0) && _spender != address(0));
        return allowed[_owner][_spender];
    }

    function transferFromAny(address _from, address _to, uint _value) public returns (bool success) {
        require(balances[_from] >= _value && _value > 0);
        require(allowed[_from][msg.sender] >= _value && _value > 0);
        require(balances[_to] >= 0);
        require(_from != address(0) && _to != address(0));
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function transferToAny(address _to, uint _value) public returns (bool success) {
        require(balances[msg.sender] >= _value && _value > 0);
        require(balances[_to] >= 0);
        require(msg.sender != address(0) && _to != address(0));
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function batchTransfer(address[] _receivers, uint _value) public {
        for (uint i = 0; i < _receivers.length; i++) {
            transfer(_receivers[i], _value);
        }
    }

    function totalBurned() public view returns (uint total_Burned) {
        total_Burned = totalSupply - balances[address(0)];
        return total_Burned;
    }

    function withdraw() public returns (bool success) {
        require(msg.sender == admin);
        admin.transfer(address(this).balance);
        return true;
    }
}