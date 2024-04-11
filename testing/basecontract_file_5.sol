pragma solidity 0.4.17;

import "./Ownable.sol";
import "./ERC721.sol";
import "./SafeMath.sol";
import "./Counters.sol";

contract DegenerateDachshunds is Ownable, ERC721 {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    uint256 public constant MAX_SUPPLY = 1000;
    uint256 public constant MAX_PER_MINT = 5;

    bool public saleIsActive;
    uint256 public price;
    string public baseTokenURI;
    
    Counters.Counter private _tokenIdCounter;

    constructor(string memory _baseTokenURI) {
        baseTokenURI = _baseTokenURI;
    }

    function reserveNfts(address _to, uint256 _amount) public onlyOwner {
        require(_tokenIdCounter.current().add(_amount) <= MAX_SUPPLY, "Exceeds maximum supply");
        
        for (uint256 i = 0; i < _amount; i++) {
            _mintSingleNft(_to);
        }
    }

    function mintNft(uint256 _amount) public payable {
        require(saleIsActive, "Sale is not active");
        require(_amount > 0 && _amount <= MAX_PER_MINT, "Invalid amount to mint");
        require(msg.value >= price.mul(_amount), "Insufficient payment");
        require(_tokenIdCounter.current().add(_amount) <= MAX_SUPPLY, "Exceeds maximum supply");

        for (uint256 i = 0; i < _amount; i++) {
            _mintSingleNft(msg.sender);
        }
    }

    function _mintSingleNft(address _to) private {
        uint256 newTokenId = _tokenIdCounter.current();
        _mint(_to, newTokenId);
        _tokenIdCounter.increment();
    }

    function setSaleState(bool _state) public onlyOwner {
        saleIsActive = _state;
    }

    function setPrice(uint256 _newPrice) public onlyOwner {
        price = _newPrice;
    }

    function setBaseTokenURI(string memory _newBaseTokenURI) public onlyOwner {
        baseTokenURI = _newBaseTokenURI;
    }

    function withdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}