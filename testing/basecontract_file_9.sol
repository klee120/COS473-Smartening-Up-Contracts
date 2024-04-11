pragma solidity ^0.4.17;

import "./ERC1155.sol";
import "./Ownable.sol";
import "./ERC1155Burnable.sol";

contract Yggdrasil is ERC1155, Ownable, ERC1155Burnable {
    string public baseTokenURI;
    uint256 private totalTokensMinted;
    uint256 private totalTokensBurned;
    
    address public relayerAddress;
    address public anthroWalletAddress;

    constructor(string _baseTokenURI) public {
        baseTokenURI = _baseTokenURI;
    }

    function totalSupply() public view returns (uint256) {
        return totalTokensMinted - totalTokensBurned;
    }

    function setRelayerAddress(address _relayerAddress) public onlyOwner {
        relayerAddress = _relayerAddress;
    }

    function setAnthroWalletAddress(address _anthroWalletAddress) public onlyOwner {
        anthroWalletAddress = _anthroWalletAddress;
    }

    function mintBatch(address _to, uint256[] _ids, uint256[] _amounts, bytes _data) public onlyOwner {
        _mintBatch(_to, _ids, _amounts, _data);
        totalTokensMinted += _ids.length;
    }

    function transferToBacker(address _backer, uint256 _id, uint256 _amount) public {
        require(msg.sender == owner || msg.sender == relayerAddress, "Unauthorized");
        safeTransferFrom(anthroWalletAddress, _backer, _id, _amount, "");
    }

    function burn(uint256 _id, uint256 _amount) public {
        _burn(msg.sender, _id, _amount);
        totalTokensBurned += _amount;
    }
}