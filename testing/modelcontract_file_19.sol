pragma solidity ^0.4.17;

contract AshesOfLight is ERC721Enumerable, Ownable {
    uint256 public cost = 0.1 ether;
    uint256 public supplyCap = 10000;
    string public baseURI;

    bool public paused = false;

    mapping(address => uint8) public maxPerAddress;
    mapping(address => mapping(address => uint8)) public whitelists;
    mapping(address => uint8) public rewards;
    uint256 public maxWhitelistsPerAddress = 5;
    
    constructor() ERC721("Ashes Of Light", "LIGHT") {
        setBaseURI("ipfs://");
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }
    
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }
    
    function setSupplyCap(uint256 _newSupplyCap) public onlyOwner {
        supplyCap = _newSupplyCap;
    }

    function setmaxPerAddress(uint8 _newMaxPerAddress) public onlyOwner {
        maxPerAddress[msg.sender] = _newMaxPerAddress;
    }

    function setmaxWhitelistsPerAddress(uint8 _newMaxWhitelistsPerAddress) public onlyOwner {
        maxWhitelistsPerAddress[msg.sender] = _newMaxWhitelistsPerAddress;
    }

    function setmaxPerAddressPublicMinting(uint8 _newPublicMinting) public onlyOwner {
        maxPerAddressPublicMinting[msg.sender] = _newPublicMinting;
    }

    function mint(uint8 _numberOfTokens) public payable {
        require(!paused, "AshesOfLight: minting is paused");
        require(_numberOfTokens > 0, "AshesOfLight: You need to purchase at least 1 NFT");
        require(_numberOfTokens <= maxPerAddress[msg.sender], "AshesOfLight: You have exceeded maximum tokens for this purchase");
        require(_numberOfTokens <= maxWhitelistsPerAddress[msg.sender], "AshesOfLight: Max 5 NFTs on this address");
        require(supplyCap >= totalSupply(_numberOfTokens), "AshesOfLight: Sold out");
        
        if (baseURI != "") {
            for (uint8 i = 0; i < _numberOfTokens; i++) {
                _safeMint(msg.sender, totalSupply(_numberOfTokens) + i);
            }
        }        else {
            for (uint8 i = 0; i < _numberOfTokens; i++) {
                _safeMint(msg.sender, totalSupply(_numberOfTokens) + i);
            }
        }
        
        supplyCap -= totalSupply(_numberOfTokens);
    }

    function reveal(bool _state) public onlyOwner {
      require(baseURI != "", "AshesOfLight: Reveals are not configured yet");
      paused = _state;
    }

    function totalSupply() public view returns (uint256) {
      return supplyCap;
    }
}