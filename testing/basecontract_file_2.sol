pragma solidity 0.4.17;

import "./ERC721.sol";
import "./ERC721Enumerable.sol";
import "./ERC721Burnable.sol";
import "./Ownable.sol";
import "./SafeMath.sol";
import "./Counters.sol";

contract GrouchyTigerCubs is ERC721, ERC721Enumerable, ERC721Burnable, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 private _mintingCost;
    string private _baseTokenURI;

    constructor() ERC721("GrouchyTigerCubs", "GTC") {
        _mintingCost = 0.1 ether;
        _baseTokenURI = "https://api.grouchytigercubs.com/token/";
    }

    function _baseURI() internal view returns (string) {
        return _baseTokenURI;
    }

    function setMintingCost(uint256 cost) public onlyOwner {
        _mintingCost = cost;
    }

    function mintingCost() public view returns (uint256) {
        return _mintingCost;
    }

    function ownerWithdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        address(owner()).transfer(balance);
    }

    function safeMint(address to) public payable {
        require(msg.value >= _mintingCost, "Insufficient Ether sent for minting");
        _safeMint(to, _tokenIdCounter.current());
        _tokenIdCounter.increment();
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}