pragma solidity ^0.4.17;

import "./ERC721.sol";
import "./Ownable.sol";
import "./SafeMath.sol";
import "./Counters.sol";

contract V1Phunks is ERC721, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    uint256 constant MAX_SUPPLY = 10000;
    uint256 constant MAX_PER_MINT = 10;
    uint256 constant FREE_STAGE_MINTING = 250;
    uint256 constant PUBLIC_PRICE = 15000000000000000; // 0.015 ETH in Wei
    uint256 constant MAX_RESERVED_MINTS = 500;

    Counters.Counter private _tokenIdCounter;
    mapping(address => uint256) private _reservedMints;
    bool private _paused;
    string private _baseTokenURI;

    event TokenMinted(address indexed owner, uint256 indexed tokenId, uint256 timestamp);
    event ContractPaused(bool paused);
    event PriceChanged(uint256 newPrice);

    modifier whenNotPaused() {
        require(!_paused, "Contract is paused");
        _;
    }

    function setBaseTokenURI(string memory baseTokenURI) public onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

    function _baseURI() internal view returns (string memory) {
        return _baseTokenURI;
    }

    function pauseContract() public onlyOwner {
        _paused = true;
        emit ContractPaused(true);
    }

    function unpauseContract() public onlyOwner {
        _paused = false;
        emit ContractPaused(false);
    }

    function changePrice(uint256 newPrice) public onlyOwner {
        PUBLIC_PRICE = newPrice;
        emit PriceChanged(newPrice);
    }

    function reserveTokens(address recipient, uint256 amount) public onlyOwner {
        require(_tokenIdCounter.current().add(amount) <= MAX_SUPPLY, "Exceeds MAX_SUPPLY");
        require(_reservedMints[recipient].add(amount) <= MAX_RESERVED_MINTS, "Exceeds MAX_RESERVED_MINTS");

        for (uint256 i = 0; i < amount; i++) {
            _reservedMints[recipient]++;
            _safeMint(recipient, _tokenIdCounter.current());
            emit TokenMinted(recipient, _tokenIdCounter.current(), now);
            _tokenIdCounter.increment();
        }
    }

    function mint() public payable whenNotPaused {
        uint256 totalSupply = _tokenIdCounter.current();

        require(totalSupply < MAX_SUPPLY, "MAX_SUPPLY reached");
        require(msg.value >= PUBLIC_PRICE, "Insufficient funds");

        if (totalSupply < FREE_STAGE_MINTING) {
            require(totalSupply.add(MAX_PER_MINT) <= FREE_STAGE_MINTING, "Exceeds FREE_STAGE_MINTING");
        } else {
            require(totalSupply.add(MAX_PER_MINT) <= MAX_SUPPLY, "Exceeds MAX_SUPPLY");
        }

        for (uint256 i = 0; i < MAX_PER_MINT; i++) {
            if (totalSupply < FREE_STAGE_MINTING) {
                _safeMint(msg.sender, _tokenIdCounter.current());
            } else {
                _safeMint(msg.sender, _tokenIdCounter.current());
                msg.sender.transfer(msg.value.sub(PUBLIC_PRICE));
            }
            emit TokenMinted(msg.sender, _tokenIdCounter.current(), now);
            _tokenIdCounter.increment();
            totalSupply++;
        }
    }

    function withdrawBalance() public onlyOwner {
        address payable owner = address(uint160(owner()));
        owner.transfer(address(this).balance);
    }

    // Additional functions can be added as needed based on the requirements
}