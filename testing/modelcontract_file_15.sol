pragma solidity ^0.4.17;

contract FloydiesGenerative is ERC721, ERC721Enumerable, Pausable, Ownable, RoyaltiesV2Impl {
	using Counters for Counters.Counter;
	using Strings for uint256;
    
    uint256 public mintingPrice = 60000000 * 10 ** 18; // 0.06 ETH
    uint256 public totalSupplyCap = 5000; // 5000 Max Floydies
    string public baseURI;

    bool public paused = false;
    mapping (address => bool) public minted;

    constructor() ERC721("Floydies Generative", "Floydies Generative") {}

    // Pause contract in case of an emergency
    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    // Withdraw contract balance in ETH to the owner
    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Mint a Floydie
    function mintFloydie(uint256 _count) public payable {
        require(!paused, "Contract is Paused");
        require(_count <= 10, "Minting Floydies is capped to 10 per transaction");
        require(totalSupply() + _count <= totalSupplyCap, "Purchase would exceed max supply of Floydies");
        
        for (uint256 i; i < _count; i++) {
            _safeMint(msg.sender, totalSupply() + 1);
            minted[msg.sender] = true;
        }
    }

    // Pause all token approval (if approved) / unpauses all token approvals (if not approved)
    function setApprovalForAll(address _spender, bool _state) public {
        require(_spender != address(0), "ERC721: approve to the zero address");
        require(_state != minted[msg.sender], "ERC721: approval to current approver revoked");
        require(_state != _state[_spender], "ERC721: approval to current approver revoked");
        
        _state[_spender] = _state;
        emit ApprovalForAll(_spender, _state);
    }

    function setBaseURI(string memory _newURI) public onlyOwner {
        baseURI = _newURI;
    }

    // Royalty info
    function royaltyInfo(address, uint256) public view returns (address, uint256)) {
        return LibPart.royaltiesInfoByTokenId(address(this), _tokenIds.current());
    }

    // Pause contract
    function pause(bool state) public onlyOwner {
        paused = state;
    }

    // Unpause contract
    function unpause(bool state) public onlyOwner {
        paused = state;
    }
}