pragma solidity ^0.4.17;

contract legendary_tkn is ERC721, ERC721Enumerable, Ownable {
  using Strings for uint256;
  string public baseTokenURI;

  uint256 public presaleMintPrice = 1500000000000000;
  uint256 public publicMintPrice = 1500000000000000;
  uint8 public maxPerTx = 5;
  uint8 public maxSupply = 100;
  bool public paused = false;
  mapping(address => uint8) public presaleWhitelist;
  uint public presaleSupply = 0;
  uint public publicSupply = 0;
  string public notWhitelisted = "Address not whitelisted for presale";
  string public maxPerTxReached = "Max NFTs per Transaction Exceeded";
  string public soldOut = "Sold Out";
  string public pausedString = "Contract Paused";
  string public baseURI;

  constructor(string memory baseURI) ERC721("Legendary K-Noids", "LTKN") {
    setBaseURI(baseURI);
  }

  function setBaseURI(string memory baseURI) public onlyOwner {
    baseTokenURI = baseURI;
  }

  function setPresaleMintPrice(uint256 _presaleMintPrice) public onlyOwner {
    presaleMintPrice = _presaleMintPrice;
  }

  function setPublicMintPrice(uint256 _publicMintPrice) public onlyOwner {
    publicMintPrice = _publicMintPrice;
  }

  function setMaxPerTx(uint8 _maxPerTx) public onlyOwner {
    maxPerTx = _maxPerTx;
  }

  function setMaxSupply(uint8 _maxSupply) public onlyOwner {
    maxSupply = _maxSupply;
  }

  function setNotWhitelisted(address _addr, uint8 _mintAmount) public onlyOwner {
    presaleWhitelist[_addr] = _mintAmount;
  }

  function withdraw() public onlyOwner {
    payable(msg.sender).call{value: address(this).balance}("");
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }

  function setMaxSupply(uint8 _maxSupply) public onlyOwner {
    maxSupply = _maxSupply;
  }

  function setBaseURI(string memory baseURI) public onlyOwner {
    baseTokenURI = baseURI;
  }

  function setPublicSale(bool _state) public onlyOwner {
    publicSupply = _state ? 0 : 10000;
  }

  function setPresale(bool _state) public onlyOwner {
    presale = _state;
  }

  function setPrice(uint256 _price) public onlyOwner {
    presaleMintPrice = _price;
  }

  function setNotWhitelisted(address _addr) public onlyOwner {
    notWhitelisted = _addr;
  }

  function setMaxPerTx(uint8 _maxPerTx) public onlyOwner {
    maxPerTx = _maxPerTx;
  }

  function setMaxSupply(uint8 _maxSupply) public onlyOwner {
    maxSupply = _maxSupply;
  }

  function setBaseURI(string memory _newURI) public onlyOwner {
    baseTokenURI = _newURI;
  }

  function setPaused(bool _state) public onlyOwner {
    paused = _state;
  }

  function setURI(string memory _newURI) public onlyOwner {
    baseURI = _newURI;
  }

  function setMaxPrice(uint256 _newMaxPrice) public onlyOwner {
    publicMaxPrice = _newMaxPrice;
  }

  function setBaseTokenURI(string memory _newURI) public onlyOwner {
    baseTokenURI = _newURI;
  }

  function setPresale(bool _state) public onlyOwner {
    presale = _state;
  }

  function setMaxPerTx(uint8 _maxPerTx) public onlyOwner {
    maxPerTx = _maxPerTx;
  }

  function setMaxSupply(uint8 _maxSupply) public onlyOwner {
    maxSupply = _maxSupply;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }

  function unpause(bool _state) public onlyOwner {
    paused = _state;
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
    string memory currentBaseURI = _isPresale(tokenId) ? baseTokenURI : baseTokenURI;
    return bytes(currentBaseURI).length > 0
      ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
      : "";
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseTokenURI;
  }

  function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
    super._beforeTokenTransfer(from, to, tokenId);
  }

  function _baseURIextended() internal view virtual override returns (string memory) {
    return baseTokenURI;
  }
}