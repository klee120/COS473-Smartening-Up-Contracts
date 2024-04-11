pragma solidity ^0.4.17;

contract Yggdrasil is ERC1155, Ownable, ERC1155Burnable {
    string public relayerAddress;
    string public anthroWalletAddress;
    uint public totalSupply;

    constructor() ERC1155("ipfs://[QmUJ5nEYXu6Kb5a3KYc3mrtz24V7Pn3UQr2a") {
        relayerAddress = msg.sender;
        anthroWalletAddress = 0x2b9e5F12D1ff833fF5EEeC47e531c7B3B662c3F;
        totalSupply = 100;
    }

    function setRelayerAddress(string memory _relayerAddress) public onlyOwner {
        relayerAddress = _relayerAddress;
    }

    function setAnthroWalletAddress(string memory _anthroWalletAddress) public onlyOwner {
        anthroWalletAddress = _anthroWalletAddress;
    }

    function mintBatch(address to, uint amount) public payable {
        require(amount > 0, "Need to mint at least 1 NFT");
        require(amount <= 10, "Can only mint 10 NFTs at a time");
        require(totalSupply + amount <= 100, "Exceeded maximum token supply");
        require(to != address(0), "Can't mint to address 0");

        // Mint NFT
        for (uint i = 0; i < amount; i++) {
            _safeMint(to, i, "");
        }
        totalSupply += amount;
        balanceOf[to] += amount;
    }

    function burn(uint amount) public onlyOwner {
        require(amount <= balanceOf[msg.sender]);
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
    }

    function totalSupply() public view returns (uint) {
        return totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint) {
        return balanceOf[_owner];
    }

    function transferToBacker(address _to, uint amount) public onlyOwner {
        require(amount <= balanceOf[msg.sender]);
        require(amount > 0);
        require(_to != address(0));

        // Transfer NFT
        _safeMint(_to, totalSupply, "");
        totalSupply += amount;
        balanceOf[_to] += amount;
    }

    function transferToAnthro(address _to, uint amount) public onlyOwner {
        require(amount <= balanceOf[msg.sender]);
        require(amount > 0);
        require(_to != address(0));

        // Transfer NFT to AnthroWallet
        _safeMint(_to, amount, "");
        totalSupply += amount;
        balanceOf[_to] += amount;
    }

    function setTotalSupply(uint _totalSupply) public onlyOwner {
        totalSupply = _totalSupply;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        string memory baseURI = _baseURI();

        return bytes(baseURI).length > 0
            ? string(abi.encodePacked(baseURI, tokenId.toString()))
            : "";
    }
}