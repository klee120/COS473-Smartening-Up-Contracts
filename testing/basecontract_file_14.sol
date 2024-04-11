pragma solidity ^0.4.17;

import "./ERC721.sol";
import "./ERC721Enumerable.sol";
import "./ERC721URIStorage.sol";
import "./Pausable.sol";
import "./Ownable.sol";

contract legendary_tkn is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable {
    
    uint256 public constant maxSupply = 100;
    uint256 public mintPrice = 0.15 ether;
    uint256 public totalMinted;
    string private baseURI;
    
    mapping(address => uint256) public presaleAllowance;
    mapping(address => bool) public presaleWhitelist;
    bool public presaleActive;
    bool public publicSaleActive;
    
    modifier duringPresale {
        require(presaleActive, "Presale is not active");
        require(presaleWhitelist[msg.sender], "Address not whitelisted for presale");
        require(presaleAllowance[msg.sender] > 0, "Address has no presale allowance");
        _;
    }
    
    modifier duringPublicSale {
        require(publicSaleActive, "Public sale is not active");
        _;
    }
    
    function togglePresale(bool _status) external onlyOwner {
        presaleActive = _status;
    }
    
    function togglePublicSale(bool _status) external onlyOwner {
        publicSaleActive = _status;
    }
    
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }
    
    function setMintPrice(uint256 _newPrice) public onlyOwner {
        mintPrice = _newPrice;
    }
    
    function whitelistAddress(address _addr, uint256 _allowance) public onlyOwner {
        presaleWhitelist[_addr] = true;
        presaleAllowance[_addr] = _allowance;
    }
    
    function mint() public payable duringPublicSale {
        require(totalMinted < maxSupply, "Token supply reached its limit");
        require(msg.value >= mintPrice, "Insufficient funds sent");
        
        _internalMint(msg.sender);
    }
    
    function presaleMint() public payable duringPresale {
        require(totalMinted < maxSupply, "Token supply reached its limit");
        require(msg.value >= mintPrice, "Insufficient funds sent");
        require(presaleAllowance[msg.sender] > 0, "Address has no presale allowance");
        
        presaleAllowance[msg.sender]--;
        _internalMint(msg.sender);
    }
    
    function withdrawBalance() public onlyOwner {
        address payable ownerAddr = address(uint160(owner()));
        ownerAddr.transfer(address(this).balance);
    }
    
    function _internalMint(address _to) internal {
        uint256 tokenId = totalMinted + 1;
        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, string(abi.encodePacked(baseURI, tokenId.toString())));
        totalMinted++;
    }
}