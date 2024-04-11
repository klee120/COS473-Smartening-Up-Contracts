pragma solidity ^0.4.17;

contract V1Phunks is ERC721, Ownable {
	using Counters for Counters.Counter;
	using SafeMath for uint256;
	string public constant tokenURIPrefix = "ipfs://";
	uint8 public constant MAX_PER_MINT = 10;
	uint256 public constant MAX_SUPPLY = 10000;
	uint256 public constant MAX_RESERVED_MINTS = 500;
	uint256 public constant PUBLIC_PRICE = 15000000000000;
	
	uint256 public FREE_STAGE_MINTING = 250;
	uint256 public RESERVE_MINTING = 500;
	uint256 public MAX_RESERVED_MINTS = 500;
	uint256 public HARD_CAP = 10000;
	bool public paused;

    Counters.Counter private _tokenIds;

    mapping(address => bool) private _reserved;

    constructor() ERC721("V1 Phunks", "V1") {
        paused = false;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        return tokenURIPrefix;
    }

    function setTokenURI(string memory _tokenURIPrefix) public onlyOwner {
        require(paused, "V1Punks: Contract is not paused");
        tokenURIPrefix = _tokenURIPrefix;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function setPrice(uint256 _newPrice) public onlyOwner {
        PUBLIC_PRICE = _newPrice;
    }

    function setFreeMintingStage(uint256 _newFreeMinting) public onlyOwner {
        FREE_STAGE_MINTING = _newFreeMinting;
    }

    function setReserveMinting(uint256 _newReserveMinting) public onlyOwner {
        RESERVE_MINTING = _newReserveMinting;
    }

    function setHardcap(uint256 _newHardcap) public onlyOwner {
        HARD_CAP = _newHardcap;
    }

    function setMaxPerMint(uint256 _newMaxPerMint) public onlyOwner {
        MAX_PER_MINT = _newMaxPerMint;
    }

    function setTokenURI(uint256 _tokenId, string memory _newUri) public onlyOwner {
        _setTokenURI(_tokenId, _newUri);
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).call{value: address(this).balance}("");
    }

    function reserve(address[] calldata _addresses) public onlyOwner {

        for (uint256 i = 0; i < _addresses.length; i++) {
            if (_tokenIds.current() >= MAX_RESERVED_MINTS) {
                break;
            }

            _mint(_addresses[i], _tokenIds.current());
        }
    }

    function totalSupply() public view virtual returns (uint256) {
        return _tokenIds.current();
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function setPrice(uint256 _newPrice) public onlyOwner {
        PUBLIC_PRICE = _newPrice;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        return tokenURIPrefix;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return tokenURIPrefix;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Contract) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Base) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}