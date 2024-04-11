pragma solidity ^0.4.17;

import "./ERC721Enumerable.sol";
import "./SafeMath.sol";

contract PACLEXAction is ERC721Enumerable {
    using SafeMath for uint256;

    address public constant PAC_DAO = 0x123...; // PAC DAO wallet address
    address public constant LEX_DAO = 0x456...; // LexDAO wallet address
    address public constant ARTIST = 0x789...; // Artist wallet address

    bytes32 public merkleRoot;
    string public baseURI;

    uint256 public constant MAX_MINTS_PER_LEAF = 2;
    uint256 public totalMinted;

    address public owner;
    address public beneficiary;

    mapping(address => uint256) public mintCount;
    mapping(address => bool) public mintedSpecialNFTs;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(string _baseURI, bytes32 _merkleRoot) public {
        baseURI = _baseURI;
        merkleRoot = _merkleRoot;
        owner = msg.sender;
        beneficiary = msg.sender;
    }

    function mint(uint256 tokenId, bytes32[] proof) public {
        require(verifyProof(proof), "Invalid proof");
        require(totalMinted < MAX_SUPPLY, "Mint cap reached");

        _mint(msg.sender, tokenId);
        totalMinted = totalMinted.add(1);
        mintCount[msg.sender] = mintCount[msg.sender].add(1);

        if (!mintedSpecialNFTs[ARTIST] && mintCount[msg.sender] == 1) {
            _mint(ARTIST, totalSupply() + 1);
            mintedSpecialNFTs[ARTIST] = true;
        }

        if (!mintedSpecialNFTs[PAC_DAO] && mintCount[msg.sender] == 2) {
            _mint(PAC_DAO, totalSupply() + 1);
            mintedSpecialNFTs[PAC_DAO] = true;
        }

        if (!mintedSpecialNFTs[LEX_DAO] && mintCount[msg.sender] == 3) {
            _mint(LEX_DAO, totalSupply() + 1);
            mintedSpecialNFTs[LEX_DAO] = true;
        }
    }

    function verifyProof(bytes32[] proof) private view returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(msg.sender));
        bytes32 currentHash;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 parentHash = proof[i];

            if (hash < parentHash) {
                currentHash = keccak256(abi.encodePacked(hash, parentHash));
            } else {
                currentHash = keccak256(abi.encodePacked(parentHash, hash));
            }

            hash = currentHash;
        }

        return hash == merkleRoot;
    }

    function updateRoot(bytes32 newRoot) public onlyOwner {
        merkleRoot = newRoot;
    }

    function withdraw() public onlyOwner {
        beneficiary.transfer(address(this).balance);
    }

    function setTokenURI(uint256 tokenId, string tokenURI) public onlyOwner {
        // Function to set token URI
    }

    function setDefaultMetadata(string metadata) public onlyOwner {
        // Function to set default metadata
    }

    function setContractURI(string contractURI) public onlyOwner {
        // Function to set contract URI
    }
}