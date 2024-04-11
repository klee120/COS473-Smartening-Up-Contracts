pragma solidity 0.4.17;

import "./ERC721.sol";
import "./ERC721Enumerable.sol";
import "./Pausable.sol";
import "./Ownable.sol";
import "./RoyaltiesV2Impl.sol";
import "./Counters.sol";

contract FloydiesGenerative is ERC721, ERC721Enumerable, Pausable, Ownable, RoyaltiesV2Impl {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 private constant MAX_MINT_PER_TX = 10;
    uint256 private constant MAX_SUPPLY = 5000;
    uint256 private constant MINT_PRICE = 0.006 ether;
    string private _baseTokenURI;

    struct RoyaltyInfo {
        address recipient;
        uint256 value;
    }

    mapping(uint256 => RoyaltyInfo[]) private _royalties;

    constructor(string memory baseTokenURI) {
        _baseTokenURI = baseTokenURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function mintFloydies(uint256 quantity) external payable whenNotPaused {
        require(quantity > 0, "Quantity cannot be zero");
        require(quantity <= MAX_MINT_PER_TX, "Exceeds max mint per transaction");
        require(_tokenIdCounter.current() + quantity <= MAX_SUPPLY, "Exceeds max supply");
        require(msg.value == quantity * MINT_PRICE, "Incorrect Ether value");

        for (uint256 i = 0; i < quantity; i++) {
            _safeMint(msg.sender, _tokenIdCounter.current());
            _tokenIdCounter.increment();
        }
    }

    function setRoyalties(uint256 tokenId, LibPart.Part[] calldata _fees) external onlyOwner {
        _saveRoyalties(tokenId, _fees);
    }

    function getRoyalties(uint256 tokenId) external view returns (LibPart.Part[] memory) {
        return _royalties[tokenId];
    }

    function pauseContract() external onlyOwner {
        _pause();
    }

    function unpauseContract() external onlyOwner {
        _unpause();
    }

    function withdrawBalance(address payable recipient) external onlyOwner {
        recipient.transfer(address(this).balance);
    }
}