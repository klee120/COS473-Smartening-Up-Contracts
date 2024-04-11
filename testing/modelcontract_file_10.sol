pragma solidity ^0.4.17;

contract EtchedNFT1155 is ERC1155, ERC1155Storage, ERC2981, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public royaltyRate; // in percentage
    uint256 public constant MAX_ROYALTIES = 10;
    address public owner; // contract owner

    constructor() ERC1155("https://ipfs.io/ipfs/QmUUXUQnqP9E8d9tYbP3jVZmbCj7n3YxuUq6N2TJ/") {
        owner = msg.sender;
        _tokenIds.increment();
        _safeMint(owner, _tokenIds.current());
        setRoyalties(5);
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
            : "";
    }

    function royaltyInfo(address, uint256) public view returns (bool, uint256) {
        return (true, royaltyRate);
    }

    function setRoyalties(address payable[] calldata recipients, uint256[] calldata amountBps) public onlyOwner {
        require(recipients.length == amountBps, "Royalty array length mismatch");
        for (uint256 i = 0; i < recipients.length; i++) {
            _setRoyalties(recipients[i], amountBps[i]);
        }
    }

    function withdraw() public onlyOwner {
        owner.transfer(address(this).balance);
    }

    function setRoyalties(uint256 _royaltyRate) public onlyOwner {
        require(_royaltyRate <= 100, "Royalty rate must be less than or equal to 100");
        royaltyRate = _royaltyRate;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    // Airdrop is done via this function
    function airdrop(address[] calldata to, uint256[] calldata amountBps) public onlyOwner {
        require(to.length == amountBps, "Address array length mismatch");
        for (uint256 i = 0; i < to.length; i++) {
            _mint(to[i], _tokenIds.current());
            _setRoyalties(to[i], amountBps[i]);
        }
    }

    // Individual Minting
    function mint(address _to) public payable returns (uint256) {
        uint256 supply = totalSupply();
        require(_to != address(0), "'_to' address has to be set");
        require(supply + 1 <= 10000, "Maximum 10,000 tokens can ever exist");
        _mint(_to, supply + 1);
        _tokenIds.increment();
        return supply + 1;
    }

    // Batch Minting
    function mintBatch(address[] calldata to, uint256[] calldata amountBps) public payable returns (uint256) {
        require(to.length == amountBps, "Address array length mismatch");
        for (uint256 i = 0; i < to.length; i++) {
            mint(to[i], 1);
        }
        return _tokenIds.current();
    }
}