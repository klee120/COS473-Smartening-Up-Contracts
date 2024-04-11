pragma solidity ^0.4.17;

contract GrouchyTigerCubs is ERC721, ERC721Enumerable, ERC721Burnable {
    uint256 public cost = 0.05 ether;
    string private _baseURIextended;

    bytes32 public constant PROVENANCE = keccak256("PROVENANCE"));

    uint256 public _tokenIdCounter;

    constructor() ERC721("Grouchy Tiger Cubs", "GTC") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setBaseURI(string memory __newBaseURI) public onlyOwner {
        _baseURIextended = __newBaseURI;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public onlyOwner {
        _setTokenURI(tokenId, _tokenURI);
    }

    function setProvenance() public onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        return tokenOfOwnerByIndex(owner, index);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
            : "";
    }
}