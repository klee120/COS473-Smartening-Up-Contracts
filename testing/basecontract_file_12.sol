pragma solidity 0.4.17;

interface ERC721 {
    function ownerOf(uint256 tokenId) external view returns (address);
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
    function approve(address to, uint256 tokenId) external;
    function transfer(address to, uint256 tokenId) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
}

interface ERC721Enumerable {
    function totalSupply() external view returns (uint256);
    function tokenByIndex(uint256 index) external view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
    function ownerOf(uint256 tokenId) external view returns (address);
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract ReentrancyGuard {
    bool private _notEntered;

    function ReentrancyGuard() internal {
        _notEntered = true;
    }

    modifier nonReentrant() {
        require(_notEntered);
        _notEntered = false;
        _;
        _notEntered = true;
    }
}

contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function renounceOwnership() public onlyOwner {
        _transferOwnership(address(0));
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Goofballs is ERC721, ERC721Enumerable, Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    constructor(uint256 _maxSupply, uint256 _initialDrop, string _baseTokenURI) public {
        maxSupply = _maxSupply;
        initialDrop = _initialDrop;
        baseTokenURI = _baseTokenURI;
    }

    uint256 public maxSupply;
    uint256 public initialDrop;
    string public baseTokenURI;
    uint256 public totalSupply;
    uint256 public reservedSupply;
    uint256 public mintPrice;
    uint256 public maxPurchase;
    bool public isSaleActive;
    address public reservedMinter;

    mapping (uint256 => address) private _tokenOwners;
    mapping (address => uint256) private _tokenBalances;

    modifier saleActive {
        require(isSaleActive, "Sale is not active");
        _;
    }

    function setSaleActive(bool _state) external onlyOwner {
        isSaleActive = _state;
    }

    function setMintPrice(uint256 _price) external onlyOwner {
        mintPrice = _price;
    }

    function setMaxPurchase(uint256 _max) external onlyOwner {
        maxPurchase = _max;
    }

    function mint(uint256 _quantity) external payable saleActive nonReentrant {
        require(_quantity > 0 && _quantity <= maxPurchase, "Invalid quantity");
        require(totalSupply.add(_quantity) <= maxSupply, "Exceeds total supply");
        require(msg.value >= mintPrice.mul(_quantity), "Insufficient Ether sent");

        // Mint logic
        // Implement your minting logic here

        totalSupply = totalSupply.add(_quantity);
    }

    function reserveMint(address _to, uint256 _quantity) external onlyOwner {
        require(reservedMinter != address(0), "Reserved minter not set");
        require(_quantity > 0 && reservedSupply.add(_quantity) <= maxSupply, "Invalid quantity");

        // Reserved minting logic
        // Implement your reserved minting logic here

        reservedSupply = reservedSupply.add(_quantity);
    }

    function withdraw() external onlyOwner {
        // Withdrawal logic
        // Implement your withdrawal logic here
    }

    // Other ERC721 and ERC721Enumerable functions to be implemented according to the standards

    // Implement ERC721 and ERC721Enumerable functions
}