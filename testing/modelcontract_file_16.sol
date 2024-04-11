pragma solidity ^0.4.17;

contract LobsterBeachClubGenomeProvable is VRFConsumerBase {
    using Counters for Counters.Counter;

    Counters.Counter private _requestIds;

    uint256 publicaleftMintFreeMintRs;
    uint256 publicaleftMintRs;

    uint8[6] private notRevealedTraits;

    IERC721 public lobsters;

    bytes32 public constant LOBSTER_GENOME_PROVABILITY = keccak256("LobsterBeachClubGenomeProvable");

    uint256 public publicaleftFreeMintFreeMintRs;
    uint256 publicaleftFreeMintRs;

    Counters.Counter private freeMintIds;

    uint public publicMintingFreeMintRs;
    uint publicMintingFee;

    constructor(bytes32 _baseURI, bytes32 _notRevealedBaseURI)  ERC721("LobsterBeachClub", "LOBSTER") VRFConsumerBase(_baseURI, _notRevealedBaseURI) {
        require(_baseURI != "", "ERC721: invalid base URI");
        require(_notRevealedBaseURI != "", "ERC721: invalid not revealed base URI");
        lobsterBaseURIextended = _baseURI;
        lobsterNotRevealedBaseURIextended = _notRevealedBaseURIextended;
        publicaleftMintFreeMintRs = 5000;
        publicaleftMintRs = 50000;

        publicSaleSupply = 100;
        publicMintingFreeMintRs = 1000;
    }

    function setPublicSaleState(bool newState) public onlyOwner {
        publicSaleActive = newState;
    }

    function setSalesStart(uint256 _publicSaleStart) public onlyOwner {
        publicSaleStart = _publicSaleStart;
    }

    function setPublicSaleEnd(uint256 _publicSaleEnd) public onlyOwner {
        publicSaleEnd = _publicSaleEnd;
    }

    function setPublicSaleMaxMint(uint256 _publicSaleMaxMint) public onlyOwner {
        publicSaleMaxMint = _publicSaleMaxMint;
    }

    function setPublicSaleMaxCap(uint256 _publicSaleMaxCap) public onlyOwner {
        publicSaleMaxCap = _publicSaleMaxCap;
    }

    function setRevealState(bool _state) public onlyOwner {
        notRevealedTraits = _state;
    }

    function setReveal(bool _state) public onlyOwner {
        notRevealedTraits = _state;
    }

    function setRevealDate(uint256 _date) public onlyOwner {
        publicSaleStart = _date;
    }

    function setPublicSaleState(bool _state) public onlyOwner {
        publicSaleActive = _state;
    }

    function setPublicSalePrice(uint256 _price) public onlyOwner {
        publicSalePrice = _price;
    }

    function setPresaleDate(uint256 _presaleStart) public onlyOwner {
        presaleStart = _presaleStart;
    }

    function setURI(string memory _notRevealedBaseURI) public onlyOwner {
        lobsterNotRevealedBaseURIextended = _notRevealedBaseURI;
    }

    function withdraw() public onlyOwner {
        address owner = address(this);
        uint256 balance = owner.balance;
        payable(msg.sender).transfer(balance);
    }
}
