pragma solidity 0.4.17;

import "./ERC1155.sol";
import "./ERC165Storage.sol";
import "./IERC2981.sol";
import "./Ownable.sol";
import "./Counters.sol";

contract EtchedNFT1155 is ERC1155, ERC165Storage, IERC2981, Ownable {
    using Counters for Counters.Counter;

    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => address) private _creators;
    mapping(uint256 => uint256) private _totalSupplies;
    mapping(address => bool) private _mintingPermissions;

    uint256 private _globalRoyaltyRate;

    Counters.Counter private _tokenIds;

    constructor() public {
        _globalRoyaltyRate = 10; // 10% royalty rate
        _tokenIds.increment(); // Reserve token ID 0 for future use
        _tokenIds.increment(); // Reserve token ID 1 for airdrop
        _tokenIds.increment(); // Reserve token ID 2 for airdrop

        _creators[1] = address(0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF); // Predefined creator for token ID 1
        _creators[2] = address(0xB0bB0bB0bB0bB0B0bb0B0bB0bB0bB0B0B0Bb0B0b); // Predefined creator for token ID 2
    }

    function setGlobalRoyaltyRate(uint256 rate) external onlyOwner {
        _globalRoyaltyRate = rate;
    }

    function setMinterPermission(address minter, bool permission) external onlyOwner {
        _mintingPermissions[minter] = permission;
    }

    function totalSupply(uint256 tokenId) external view returns (uint256) {
        return _totalSupplies[tokenId];
    }

    function uri(uint256 tokenId) external view returns (string) {
        return _tokenURIs[tokenId];
    }

    function airdrop(address[] recipients) external onlyOwner {
        require(recipients.length <= 100, "Exceeds maximum airdrop recipients");

        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], 1, 1, "");
            _mint(recipients[i], 2, 1, "");
        }
    }

    function mint(address to, uint256 tokenId, uint256 amount, string memory tokenURI) external {
        require(_mintingPermissions[msg.sender], "Caller is not a minter");
        
        _mint(to, tokenId, amount, "");
        _tokenURIs[tokenId] = tokenURI;
        _creators[tokenId] = msg.sender;
        _totalSupplies[tokenId] += amount;
    }

    function mintBatch(address[] to, uint256[] tokenIds, uint256[] amounts, string[] tokenURIs) external {
        require(_mintingPermissions[msg.sender], "Caller is not a minter");
        require(to.length == tokenIds.length && to.length == amounts.length && to.length == tokenURIs.length, "Invalid input lengths");

        for (uint256 i = 0; i < to.length; i++) {
            _mint(to[i], tokenIds[i], amounts[i], "");
            _tokenURIs[tokenIds[i]] = tokenURIs[i];
            _creators[tokenIds[i]] = msg.sender;
            _totalSupplies[tokenIds[i]] += amounts[i];
        }
    }

    function royaltyInfo(uint256 tokenId, uint256 value) external view returns (address receiver, uint256 royaltyAmount) {
        receiver = _creators[tokenId];
        royaltyAmount = (value * _globalRoyaltyRate) / 100;
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }
}