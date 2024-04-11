pragma solidity ^0.4.17;

contract Page is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string public collectionName;
    string public collectionSymbol;
    string public baseURI;

    uint256 public price = 0.01 ether;
    uint256 public maxSupply = 10000;
    uint256 public maxMintPerTx = 10;
    uint256 public chapterCount;
    uint256 public baseTokenId;
    mapping(address => uint8) public collaborators;

    constructor(string memory _name, string memory _symbol, string memory _initBaseURI) ERC721(_name, _symbol) {
        require(bytes(_initBaseURI).length > 0, "Base URI is not set");

        collectionName = _name;
        collectionSymbol = _symbol;
        baseURI = _initBaseURI;
        chapterCount = 1;
        baseTokenId = 1;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function mintPage(uint256 _numberOfTokens) public payable {
        require(_tokenIds.current() < maxSupply, "All pages have been minted");
        require(_numberOfTokens > 0, "You need to mint at least 1 Page");
        require(_numberOfTokens <= maxMintPerTx, "You can only mint 10 pages at a time");
        require(price * _numberOfTokens <= msg.value, "Ether sent with this transaction is not correct");

        for (uint256 i = 0; i < _numberOfTokens; ++i) {
            _safeMint(msg.sender, _tokenIds.current());
            _tokenIds.increment();
        }

        payable(owner()).transfer(msg.value);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function setPrice(uint256 _newPrice) public onlyOwner {
        price = _newPrice;
    }

    function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
        maxSupply = _newMaxSupply;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setChapterBaseURI(string memory _newChapterBaseURI) public onlyOwner {
        baseTokenId = 1;
        baseURI = _newChapterBaseURI;
    }

    function setMaxMintPerTx(uint256 _newMaxMintPerTx) public onlyOwner {
        maxMintPerTx = _newMaxMintPerTx;
    }

    function setChapterOpenings(uint256[] calldata _newChapterOpenings) public onlyOwner {
        for (uint256 i = 0; i < _newChapterOpenings.length; ++i) {
            chapterOpenings[i] = _newChapterOpenings[i];
        }
    }

    function setCollaborator(address _collaborator, uint8 _percentage) public onlyOwner {
        collaborators[_collaborator] = _percentage;
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}