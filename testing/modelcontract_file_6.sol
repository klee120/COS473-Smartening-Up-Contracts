pragma solidity ^0.4.17;

contract PACLEXAction is ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 public price = 0.05 ether;
    uint256 public maxMintsPerLeaf = 1;
    uint256 public maxLeavesPerNode = 3;
    uint256 public maxSupply = 3000;
    string public baseTokenURI;
    string public defaultMetadata;

    address public pacDao = 0x19e6b8e3F7D39Df0bE1e3E8A4B14aEE8a7D1Fdb;
    address public lexDao = 0x7c3FDe0169e3f06A3e028B429EEfCf6A7160Ef7;
    address public artist = 0x2aBD70bF5a4BcF2e41F1D69d2301eeD6eCa2c41;
    uint8 public artistMints = 0;
    uint8 public pacDaomints = 0;
    uint8 public lexDaomints = 0;

    bytes32 public constant MERKLE_ROOT = 0x6f9d7463c7a44e8d3a9b8b7f4cfb8e1c7e77e4f4c1a1bcb1a8c0bba0c7a5;

    constructor() ERC721("PACLEXAction", "PACLEX") {
        setBaseURI("https://gateway.pinata.cloud/ipfs/QmdXUzvBqUvz9MEc3JYcY8QY1yjW1YnPBKJUh1VJHj/");
        setDefaultMetadata("PACLEX Action", "IPFS");
        setContractURI("https://gateway.pinata.cloud/ipfs/Qme1U4U5b9X5TnWDQvKVJ3F5BqrCmWJtJdXn4a5nF2/");
    }

    function mint(address _addr, bytes32[] calldata _proof) external payable {
        require(msg.value >= price * _proof.length);
        require(_proof.length <= maxSupply - _tokenIds.current());
        require(pacDaomints + lexDaomints <= maxSupplyPerLeaf);

        if (msg.value > 0) {
            if (_tokenIds.current() > 3) {
                uint256 half = price / 2;
                if (msg.value > half) {
                    payable(msg.sender).transfer(half);
                    payable(artist).transfer(half);
                }            }
        }

        for (uint256 i = 0; i < _proof.length; ++i) {
            require(_proof[i] != 0);
        }

        bytes32 leaf = keccak256(abi.encodePacked(_addr));
        bytes32 node = leaf;
        bool exists = false;
        for (uint256 i = 0; i < maxLeavesPerNode; ++i) {
            node = keccak256(abi.encodePacked(node, keccak256(abi.encodePacked(_addr))));
            if (node == leaf && !exists) {
                exists = true;
                _mint(_addr, _tokenIds.current());
                _tokenIds.increment();
            }
        }
    }

    function withdraw() external onlyOwner {
        (bool result, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(result, "Address: unable to send value, recipient may have reverted");
    }

    function updateRoot(bytes32 _newRoot) external onlyOwner {
        MERKLE_ROOT = _newRoot;
    }

    function updateBaseTokenUri(string calldata _newUri) external onlyOwner {
        baseTokenURI = _newUri;
    }

    function updateDefaultMetadata(string calldata _newMetadata) external onlyOwner {
        defaultMetadata = _newMetadata;
    }

    function setPrice(uint256 _newPrice) external onlyOwner {
        price = _newPrice;
    }

    function setTokenURI(bytes32 _tokenId, string calldata _newUri) external onlyOwner {
        _setTokenURI(_tokenId, _newUri);
    }

    function setDefaultMetadata(string calldata _newMetadata) external onlyOwner {
        defaultMetadata = _newMetadata;
    }

    function setContractURI(string calldata _contractURI) external onlyOwner {
        contractURI = _contractURI;
    }

    function updateMaxMintsPerLeaf(uint8 _newMaxMintsPerLeaf) external onlyOwner {
        maxMintsPerLeaf = _newMaxMintsPerLeaf;
    }

    function maxSupplyPerLeafNode(uint8 _newMaxSupplyPerLeafNode) external onlyOwner {
        maxSupplyPerLeafNode = _newMaxSupplyPerLeafNode;
    }

    function setmaxLeavesPerNode(uint8 _newMaxLeavesPerNode) external onlyOwner {
        maxLeavesPerNode = _newMaxLeavesPerNode;
    }

    function setBaseURI(string calldata _baseTokenURI) external onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    function setDefaultMetadata(string calldata _newMetadata) external onlyOwner {
        defaultMetadata = _newMetadata;
    }

    function setRoot(string calldata _newRoot) external onlyOwner {
        MERKLE_ROOT = _newRoot;
    }

    function setDefaultPrice(uint256 _newPrice) external onlyOwner {
        price = _newPrice;
    }

    function setDefaultMaxSupplyPerLeafNode(uint8 _newMaxSupplyPerLeafNode) external onlyOwner {
        maxSupplyPerLeafNode = _newMaxSupplyPerLeafNode;
    }

    function setDefaultMaxLeavesPerNode(uint8 _newMaxLeavesPerNode) external onlyOwner {
        maxLeavesPerNode = _newMaxLeavesPerNode;
    }

    function setDefaultMetadata(string calldata _newMetadata) external onlyOwner {
        defaultMetadata = _newMetadata;
    }

    function setContractURI(string calldata _contractURI) external onlyOwner {
        contractURI = _contractURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory currentBaseURI = _isBaseTokenURISet() ? baseTokenURI : "";
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
            : defaultMetadata;
    }

    function updateMaxSupplyPerLeafNode(uint8 _newMaxSupplyPerLeafNode) external onlyOwner {
        maxSupplyPerLeafNode = _newMaxSupplyPerLeafNode;
    }

    function updateMaxMintsPerLeaf(uint8 _newMaxMintsPerLeaf) external onlyOwner {
        maxMintsPerLeafNode = _newMaxMintsPerLeafNode;
    }

    function updateMaxSupplyPerLeafNode(uint8 _newMaxSupplyPerLeafNode) external onlyOwner {
        maxSupplyPerLeafNode = _newMaxSupplyPerLeafNode;
    }

    function updateMaxSupply(uint8 _newMaxSupply) external onlyOwner {
        maxSupply = _newMaxSupply;
    }

    function updatePrice(uint256 _newPrice) external onlyOwner {
        price = _newPrice;
    }

    function withdrawAll() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function _isBaseTokenURISet() internal view virtual override returns (bool) {
        return bytes(baseTokenURI).length > 0;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function updateMaxMintsPerLeaf(uint8 _maxMintsPerLeaf) public onlyOwner {
        maxMintsPerLeafNode = _maxMintsPerLeaf;
    }

    function updateMaxSupplyPerLeafNode(uint8 _maxSupplyPerLeafNode) public onlyOwner {
        maxSupplyPerLeafNode = _maxSupplyPerLeafNode;
    }

    function updateMaxSupply(uint8 _newMaxSupply) public onlyOwner {
        maxSupply = _newMaxSupply;
    }

    function updatePrice(uint256 _newPrice) public onlyOwner {
        price = _newPrice;
    }
}