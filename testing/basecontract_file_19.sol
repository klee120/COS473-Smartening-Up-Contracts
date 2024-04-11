pragma solidity 0.4.17;

interface ERC721Enumerable {
    // ERC721Enumerable interface functions
}

contract Ownable {
    // Ownable contract functions
}

contract AshesOfLight is ERC721Enumerable, Ownable {
    // State variables
    string public baseURI;
    uint256 public mintPrice;
    uint256 public maxMintPerTx;
    uint256 public maxMintPerAddress;
    uint256 public totalSupplyCap;
    bool public paused;

    // Mapping to store reveal status of each token
    mapping(uint256 => bool) public revealStatus;

    // Mapping to store whitelist status for each address
    mapping(address => bool) public whitelist;

    // Mapping to store reward status for each address
    mapping(address => bool) public rewards;

    // Events
    event Mint(address indexed minter, uint256 amount);
    event Reveal(uint256 indexed tokenId);
    event WhitelistUpdated(address indexed addr, bool status);
    event RewardUpdated(address indexed addr, bool status);
    event Pause(bool status);

    // Constructor
    constructor() public {
        // Initialize contract with default values
        baseURI = "";
        mintPrice = 0.1 ether;
        maxMintPerTx = 5;
        maxMintPerAddress = 20;
        totalSupplyCap = 1000;
        paused = false;
    }

    // Modifiers
    modifier notPaused() {
        require(!paused, "Minting is paused");
        _;
    }

    // Function to mint NFTs
    function mint(uint256 amount) external payable notPaused {
        // Implement minting logic
    }

    // Function to update reveal status of NFT
    function updateRevealStatus(uint256 tokenId) external onlyOwner {
        // Implement reveal status update
    }

    // Function to update whitelist status of an address
    function updateWhitelistStatus(address addr, bool status) external onlyOwner {
        // Implement whitelist status update
    }

    // Function to update reward status of an address
    function updateRewardStatus(address addr, bool status) external onlyOwner {
        // Implement reward status update
    }

    // Function to pause/unpause minting
    function togglePause() external onlyOwner {
        paused = !paused;
        emit Pause(paused);
    }

    // Function to withdraw contract balance
    function withdraw(address receiver) external onlyOwner {
        // Implement withdrawal logic
    }

    // Other functions as per the requirements

    // Implement base URI management, ownership utilities, security considerations, and economic model as specified
}