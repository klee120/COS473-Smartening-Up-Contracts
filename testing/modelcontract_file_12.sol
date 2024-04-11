pragma solidity ^0.4.17;

contract Goofballs is ERC721Enumerable, Ownable, ReentrancyGuard {
    using Strings for uint256;
    string public constant SYMBOL = "GOOF";
    string public constant _baseTokenURI = "https://ipfs.io/ipfs/QmP3UfZU4Gm9UUD9p2T3Lj9ecTj2k2RTf6Hj1B2b9jy9";

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant INITIAL_DROP = 2000;
    uint256 public constant TOKEN_PRICE = 0.03 ether;
    uint256 public constant BLOCKS_PER_DAY = 96;
    uint256 public constant MAX_MINT = 10;
    uint256 public constant MAX_PURCHASE = 30;
    address public constant GOOFBALL_MINTER = 0x5FbDBB8C82F3c4eB1aeb3ee5e6Ce3c7E8f1D648;

    mapping (address => uint256) private _mintedPerDay;
    mapping (address => uint256) private _mintedToday;

    // Whitelist user's OpenSea proxy to enable gas-free trading.
    mapping (address => bool) private _proxyCheck;

    constructor() ERC721("Goofballs", "GOOF") {}

    // Whitelist proxy contracts for easy trading.
    function setProxy(address proxyAddress, bool status) public onlyOwner {
        _proxyCheck[proxyAddress] = status;
    }

    function mint(uint256 numberOfTokens) public payable nonReentrant {
        require(_mintedToday[msg.sender] + numberOfTokens <= INITIAL_DROP, "Exceeded max goofballs/day");
        require(_mintedPerDay[msg.sender] < MAX_MINT, "Exceeded max goofballs");
        require(TOKEN_PRICE * numberOfTokens <= msg.value, "Ether sent with this transaction is not correct");
        require(numberOfTokens <= MAX_PURCHASE, "Exceeded max purchase amount per transaction");
        require(_mintedToday[msg.sender] + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max goofballs");
        require(!_proxyCheck[msg.sender], "Proxy is not allowed");
        require(balanceOf(msg.sender) >= numberOfTokens, "Insufficient balance");

        (bool success, ) = payable(GOOFBALL_MINTER).call{value: TOKEN_PRICE * numberOfTokens}("");
        require(success, "Address: unable to send value, recipient may have revert");
        mintedPerDay[msg.sender] += numberOfTokens;
        for (uint256 i = 0; i < numberOfTokens; ++i) {
            _safeMint(msg.sender, _mintedPerDay[msg.sender]);
        }
    }

    function reserve(address _to, uint256 numberOfTokens) public onlyOwner {
        require(numberOfTokens <= MAX_SUPPLY, "Exceeded max supply of Goofballs");
        require(_mintedToday[_to] + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max goofballs");
        require(_mintedPerDay[_to] <= MAX_MINT, "Exceeded max goofball mints per day");
        require(_mintedToday[_to] <= MAX_SUPPLY, "Purchase would exceed max goofballs");
        require(_proxyCheck[_to], "Address: not eligible to mint");
        require(balanceOf(_to) >= numberOfTokens, "Insufficient balance");

        mintedPerDay[_to] += numberOfTokens;
        for (uint256 i = 0; i < numberOfTokens; ++i) {
            _safeMint(_to, _mintedPerDay[_to]);
        }
    }

    function mintReserved(address _to, uint256 numberOfTokens) public payable onlyOwner {
        require(numberOfTokens <= MAX_SUPPLY, "Exceeded max supply of Goofballs");
        require(_mintedToday[_to] + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max goofballs");
        require(_mintedPerDay[_to] <= MAX_MINT, "Exceeded max goofball mints per day");
        require(_mintedToday[_to] <= MAX_SUPPLY, "Purchase would exceed max goofballs");
        require(_proxyCheck[_to], "Address: not eligible to mint");
        require(balanceOf(_to) >= numberOfTokens, "Insufficient balance");

        mintedPerDay[_to] += numberOfTokens;
        for (uint256 i = 0; i < numberOfTokens; ++i) {
            _safeMint(_to, _mintedPerDay[_to]);
        }
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).call{value: address(this).balance}("");
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory currentBaseURI = _baseTokenURI;
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
            : "";
    }
}