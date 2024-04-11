pragma solidity ^0.4.17;

contract DegenerateDachshunds is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public DEGENERATE_DACHSHUNDS_PROVENANCE = "0x7F3B1BB1e1A1e3BF5cb4cD7";
    string public BaseURI;

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MAX_PER_MINT = 20;
    uint256 public price = 0.01 ether;
    bool public saleIsActive = false;

    constructor() ERC721("DegenerateDachshunds", "DEGENERATE DACHSHUNDS") {}

    function reserveNfts(address to, uint256 numberOfDachshunds) public onlyOwner {
        uint256 supply = totalSupply();
        require(supply + numberOfDachshunds <= MAX_SUPPLY, "Purchase would exceed maximum supply of Dachshunds");
        for (uint256 i = 0; i < numberOfDachshunds; i++) {
            _mintSingleNft(to);
        }
    }

    function mintNft(uint256 numberOfDachshunds) public payable {
        uint256 supply = totalSupply();
        require(saleIsActive, "Sale is not active"); // Sale is not yet active
        require(supply + numberOfDachshunds <= MAX_SUPPLY, "Purchase would exceed maximum supply of Dachshunds");
        require(numberOfDachshunds <= MAX_PER_MINT, "Only 20 Dachshunds can be minted per transaction");
        require(price * numberOfDachshunds <= msg.value, "Ether sent with this transaction is not correct");

        for (uint256 i = 0; i < numberOfDachshunds; i++) {
            _mintSingleNft(msg.sender);
        }
    }

    function _mintSingleNft(address to) private {
        uint256 newItemId = _tokenIds.current();
        _safeMint(to, newItemId);
        _tokenIds.increment();
    }

    function withdraw() public onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function setPrice(uint256 newPrice) public onlyOwner {
        price = newPrice;
    }

    function setSaleState(bool newState) public onlyOwner {
        saleIsActive = newState;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        BaseURI = baseURI;
    }

    function setProvenance(string memory provenance) public onlyOwner {
        DEGENERATE_DACHSHUN_PROVENANCE = provenance;
    }

    function setMaxPerMint(uint256 maxPerMint) public onlyOwner {
        MAX_PER_MINT = maxPerMint;
    }

    function setMaxSupply(uint256 maxSupply) public onlyOwner {
        MAX_SUPPLY = maxSupply;
    }

    function setStage(bool newState) public onlyOwner {
        saleIsActive = newState;
    }

    function setDachshundsURI(string memory dachshundsURI) public onlyOwner {
        BaseURI = dachshundsURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return BaseURI;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Base) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(address owner, uint256 tokenId) internal override(ERC721, ERC721Base) {
        super._burn(owner, tokenId);
    }

    // 100% royalty
    function royaltyInfo(address, uint256) public view returns (address) {
        return owner();
    }
}