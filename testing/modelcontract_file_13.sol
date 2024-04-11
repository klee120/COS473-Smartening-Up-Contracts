pragma solidity ^0.4.17;

contract WStakingRewards is ReentrancyGuard, IERC1155Wrapper {
    address public token;
    uint256 public rate;
    uint public constant stakingRewardsDelay = 10 minutes;
    uint public stakingRewardsDuration = 24 hours;
    uint public totalRewards;

    constructor(address _token) {
        token = _token;
        rate = 1000000000000000000;
    }

    function wrapAndStake(address _token, uint256 _amount) external payable {
        require(_token == token && _token != address(0), "WStakingRewards: Invalid token");
        require(_amount > 0, "WStakingRewards: Invalid amount");

        totalRewards = totalRewards + _amount;
        require(totalRewards <= 2100000000000000000, "WStakingRewards: Reward cap hit");
        require(token.balanceOf(msg.sender) >= _amount, "WStakingRewards: Insufficient funds");

        token.transferFrom(msg.sender, address(this), _amount);

        if (_token.balanceOf(address(this)) >= stakingRewardsDelay) {
            uint256 _lastReward = _token.balanceOf(address(this));
            uint256 _now = block.timestamp;

            if (_now >= _lastReward + stakingRewardsDuration) {
                _lastReward = _now;
                _amount = ((_now - _lastReward) / stakingRewardsDuration) * rate;
           }
       }

        token.transfer(msg.sender, _amount);
    }

    function unwrap(uint256 _amount) external nonReentrant {
        require(_amount > 0, "WStakingRewards: Invalid amount");

        if (_amount == 0) {
            _amount = token.balanceOf(address(this));
        }

        uint256 _now = block.timestamp;
        uint256 _wrappingRate = rate;

        if (_wrappingRate > 0) {
            uint256 _lastReward = _lastReward;
            uint256 _nowReward = _now >= _lastReward + stakingRewardsDuration) ? _wrappingRate : 0;
            uint256 _max = _lastReward + stakingRewardsDuration > 2100000000000000000 ? 2100000000000000000 : (_lastReward + stakingRewardsDuration)) - _now;
            uint256 _acc = (_max < _amount) ? _max : _amount;
            totalRewards = totalRewards + _acc;

            _lastReward = _now;
        }
    }

    function burn(uint256 _amount) external onlyOwner {
        require(_amount <= 2100000000000000000, "WStakingRewards: Burnt cap hit");
        token.transfer(address(0), _amount);
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).call{value: address(this).balance}("");
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(token), "ERC1155Metadata: Nonexistent token");
        string memory baseUri = _baseUri;
        return bytes(baseUri).length > 0
            ? string(abi.encodePacked(baseUri, tokenId.toString(), ".json"))
            : "";
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseUri = baseURI;
    }

    function setStakingRewardRate(uint256 _rate) public onlyOwner {        
        rate = _rate;
    }

    function setStakingRewardsDelay(uint256 _delay) public onlyOwner {        
        stakingRewardsDelay = _delay;
    }

    function setStakingRewardsDuration(uint256 _duration) public onlyOwner {
        stakingRewardsDuration = _duration;
    }

    function setTotalRewardsCap(uint256 _cap) public onlyOwner {
        totalRewards = _cap;
    }

    function setToken(address _token) public onlyOwner {
        token = _token;
    }

    function getTotalRewardsCap() public view returns (uint256) {
        return totalRewards;
    }

    function getTokenBalance(address _owner) public view returns (uint256) {
        return token.balanceOf(_owner);
    }

    function withdrawToken(address payable _to, uint256 _amount) public onlyOwner {
        require(_to != address(0), "WStakingRewards: Invalid address");
        require(_amount > 0, "WStakingRewards: Invalid amount");

        token.transfer(_to, _amount);
    }

    function withdraw() public payable onlyOwner {
        payable(msg.sender).call{value: address(this).balance}("");
    }

    function updateRate(uint256 _rate) public onlyOwner {
        rate = _rate;
    }

    function updateStakingRewardsDelay(uint256 _delay) public onlyOwner {
        stakingRewardsDelay = _delay;
    }

    function updateStakingRewardsDuration(uint256 _duration) public onlyOwner {
        stakingRewardsDuration = _duration;
    }

    function updateMaxRewardsCap(uint256 _cap) public onlyOwner {
        totalRewards = _cap;
    }

    function updateMaxRewardsCap(uint256 _cap) public onlyOwner {
        totalRewards = _cap;
    }
}