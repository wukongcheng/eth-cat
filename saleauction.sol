pragma solidity ^0.4.18;

contract ERC20 {
    function totalSupply() public constant returns (uint supply);
    function balanceOf( address who ) public constant returns (uint value);
    function allowance( address owner, address spender ) public constant returns (uint _allowance);

    function transfer( address to, uint value) public returns (bool ok);
    function transferFrom( address from, address to, uint value) public returns (bool ok);
    function approve( address spender, uint value ) public returns (bool ok);
    function transferByAuction(address src, address dst, uint wad) public returns (bool ok);
    function getCFO() external returns (address);

    event Transfer( address indexed from, address indexed to, uint value);
    event Approval( address indexed owner, address indexed spender, uint value);
}  

contract ERC721 {
    // Required methods
    function totalSupply() public view returns (uint256 total);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function ownerOf(uint256 _tokenId) external view returns (address owner);
    function approve(address _to, uint256 _tokenId) external;
    function transfer(address _to, uint256 _tokenId) external;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;

    // Events
    event Approval(address owner, address approved, uint256 tokenId);
}

contract Ownable {
  address public owner;

  function Ownable() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }
}

contract GeneScience {
    function random() internal view returns (uint256) ;
    function getBitMask(uint8[] index) internal pure returns (bytes32);
    function mixGenes(uint256 genes1, uint256 genes2) external view returns (uint256);
    function getCoolDown(uint256 genes) external view returns (uint16) ;
    function variation(uint32 attID, bytes32 genes) internal view returns (bytes32);
}

contract KittyAccessControl {
    
    event ContractUpgrade(address newContract);

    // The addresses of the accounts (or contracts) that can execute actions within each roles.
    address public ceoAddress;
    address public cfoAddress;
    address public cooAddress;

    // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
    bool public paused = false;

    /// @dev Access modifier for CEO-only functionality
    modifier onlyCEO() {
        require(msg.sender == ceoAddress);
        _;
    }

    /// @dev Access modifier for CFO-only functionality
    modifier onlyCFO() {
        require(msg.sender == cfoAddress);
        _;
    }

    /// @dev Access modifier for COO-only functionality
    modifier onlyCOO() {
        require(msg.sender == cooAddress);
        _;
    }

    modifier onlyCLevel() {
        require(msg.sender == cooAddress || msg.sender == ceoAddress || msg.sender == cfoAddress);
        _;
    }

    function KittyAccessControl() public {
        ceoAddress = msg.sender;
    }

    function setCEO(address _newCEO) external onlyCEO {
        require(_newCEO != address(0));

        ceoAddress = _newCEO;
    }

    function setCFO(address _newCFO) external onlyCEO {
        require(_newCFO != address(0));

        cfoAddress = _newCFO;
    }

    function setCOO(address _newCOO) external onlyCEO {
        require(_newCOO != address(0));

        cooAddress = _newCOO;
    }

    /*** Pausable functionality adapted from OpenZeppelin ***/
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    modifier whenPaused {
        require(paused);
        _;
    }

    function pause() external onlyCLevel whenNotPaused {
        paused = true;
    }

    function unpause() public onlyCEO whenPaused {
        // can't unpause if contract was upgraded
        paused = false;
    }
}

contract KittyBase is KittyAccessControl {
    /*** EVENTS ***/
    event Birth(address owner, uint256 kittyId, uint256 matronId, uint256 sireId, uint256 genes);
    event Transfer(address from, address to, uint256 tokenId);

    
    struct Kitty {
        uint256 genes;
        uint64 birthTime;
        uint64 cooldownEndBlock;
        uint32 matronId;
        uint32 sireId;
        uint32 siringWithId;
        uint16 cooldownIndex;
        uint16 generation;
    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal;
    function _createKitty(uint256 _matronId,uint256 _sireId,uint256 _generation,uint256 _genes,address _owner) internal returns (uint);
    function setSecondsPerBlock(uint256 secs) external;
}

contract KittyOwnership is KittyBase, ERC721 {

    function _owns(address _claimant, uint256 _tokenId) public view returns (bool);
    function _approvedFor(address _claimant, uint256 _tokenId) public view returns (bool);
    function _approve(uint256 _tokenId, address _approved) internal;
    function balanceOf(address _owner) public view returns (uint256 count);
    function transfer(address _to,uint256 _tokenId) external;
    function approve(address _to,uint256 _tokenId) external;
    function transferFrom(address _from,address _to,uint256 _tokenId) external;
    function totalSupply() public view returns (uint);
    function ownerOf(uint256 _tokenId) external view returns (address owner);
    function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens);
    function _memcpy(uint _dest, uint _src, uint _len) private pure ;
    function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private pure returns (string);
    function getSireAllowedTo(uint256 _tokenId) external view returns (address allowed);
    function getKitty(uint256 _tokenId) external view returns (
        uint256 genes,
        uint256 birthTime,
        uint256 cooldownEndBlock,
        uint256 matronId,
        uint256 sireId,
        uint256 siringWithId,
        uint256 cooldownIndex,
        uint256 generation
    );
    function createKitty(
        uint256 _matronId,
        uint256 _sireId,
        uint256 _generation,
        uint256 _genes,
        address _owner
    ) external returns (uint);
    function setSaleAuctionAddress(address _address) external;
    function createGen0Kitty(uint256 _genes, address _owner) external returns (uint);
    function setSireAllowedTo(uint256 _tokenId, address _address) external;
    function setSiringWithId(uint256 _tokenId, uint32 _siringWithId) external;
    function isReadyToBreed(uint256 _tokenId) external view returns (bool);
    function setCooldownEndBlock(uint256 _tokenId, uint64 _blocknum) external;
    function setBreedTimes(uint256 _tokenId, uint16 _breedTimes) external;
    function deleteSireAllowedTo(uint256 _tokenId) external;
    function deleteSiringWithId(uint256 _tokenId) external;
    function testGene() external view returns (uint256);
}

contract ClockAuctionBase {

    // Represents an auction on an NFT
    struct Auction {
        // Current owner of NFT
        address seller;
        // Price (in wei) at beginning of auction
        uint128 startingPrice;
        // Price (in wei) at end of auction
        uint128 endingPrice;
        // Duration (in seconds) of auction
        uint64 duration;
        // Time when auction started
        // NOTE: 0 if this auction has been concluded
        uint64 startedAt;
    }

    ERC721 public nonFungibleContract;
    ERC20 public niuTokenContract;
    address public kittycore;

    // Map from token ID to their corresponding auction.
    mapping (uint256 => Auction) tokenIdToAuction;

    event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
    event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
    event AuctionCancelled(uint256 tokenId);

    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
    }

    function _escrow(address _owner, uint256 _tokenId) internal {
        nonFungibleContract.transferFrom(_owner, this, _tokenId);
    }

    function _transfer(address _receiver, uint256 _tokenId) internal {
        nonFungibleContract.transfer(_receiver, _tokenId);
    }

    function _addAuction(uint256 _tokenId, Auction _auction) internal {
        require(_auction.duration >= 1 minutes);

        tokenIdToAuction[_tokenId] = _auction;

        AuctionCreated(
            uint256(_tokenId),
            uint256(_auction.startingPrice),
            uint256(_auction.endingPrice),
            uint256(_auction.duration)
        );
    }

    function _cancelAuction(uint256 _tokenId, address _seller) internal {
        _removeAuction(_tokenId);
        _transfer(_seller, _tokenId);
        AuctionCancelled(_tokenId);
    }

    function _bid(uint256 _tokenId, uint256 _bidAmount)
        internal
        returns (uint256)
    {
        require(niuTokenContract.balanceOf(msg.sender) >= _bidAmount);

        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));

        uint256 price = _currentPrice(auction);
        require(_bidAmount >= price);

        address seller = auction.seller;

        _removeAuction(_tokenId);

        uint256 fee = uint256(_bidAmount * 3 / 80);
        niuTokenContract.transferByAuction(msg.sender, seller, _bidAmount - fee);
        niuTokenContract.transferByAuction(msg.sender, niuTokenContract.getCFO(), fee);

        AuctionSuccessful(_tokenId, _bidAmount, msg.sender);

        return _bidAmount;
    }

    function _removeAuction(uint256 _tokenId) internal {
        delete tokenIdToAuction[_tokenId];
    }

    function _isOnAuction(Auction storage _auction) internal view returns (bool) {
        return (_auction.startedAt > 0);
    }

    function _currentPrice(Auction storage _auction)
        internal
        view
        returns (uint256)
    {
        uint256 secondsPassed = 0;

        if (now > _auction.startedAt) {
            secondsPassed = now - _auction.startedAt;
        }

        return _computeCurrentPrice(
            _auction.startingPrice,
            _auction.endingPrice,
            _auction.duration,
            secondsPassed
        );
    }

    function _computeCurrentPrice(
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration,
        uint256 _secondsPassed
    )
        internal
        pure
        returns (uint256)
    {
        if (_secondsPassed >= _duration) {
            return _endingPrice;
        } else {
            int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
            int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
            int256 currentPrice = int256(_startingPrice) + currentPriceChange;

            return uint256(currentPrice);
        }
    }
}

contract ClockAuction is ClockAuctionBase {

    function cancelAuction(uint256 _tokenId)
        external
    {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        address seller = auction.seller;
        require(msg.sender == seller);
        _cancelAuction(_tokenId, seller);
    }

    function getAuction(uint256 _tokenId)
        external
        view
        returns
    (
        address seller,
        uint256 startingPrice,
        uint256 endingPrice,
        uint256 duration,
        uint256 startedAt
    ) {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        return (
            auction.seller,
            auction.startingPrice,
            auction.endingPrice,
            auction.duration,
            auction.startedAt
        );
    }

    function isOnAuction(uint256 _tokenId)
        external
        view
        returns (bool) 
    {
        Auction storage auction = tokenIdToAuction[_tokenId];
        return _isOnAuction(auction);
    }

    function getCurrentPrice(uint256 _tokenId)
        external
        view
        returns (uint256)
    {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        return _currentPrice(auction);
    }

}

contract SaleClockAuction is ClockAuction {

    // Tracks last 5 sale price of gen0 kitty sales
    uint256 public gen0SaleCount;
    uint256[5] public lastGen0SalePrices;

    function setERC721Address(address _nftAddress) external {
        nonFungibleContract = ERC721(_nftAddress);
    }

    function setERC20Address(address _erc20Address) external {
        niuTokenContract = ERC20(_erc20Address);
    }

    function setKittyCoreAddress(address _address) external{
        kittycore = _address;
    }

    function testAuction() external pure returns (uint256) {
        return 1000;
    }

    function createAuction(
        uint256 _tokenId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration,
        address _seller
    )
        external
    {
        require(_startingPrice == uint256(uint128(_startingPrice)));
        require(_endingPrice == uint256(uint128(_endingPrice)));
        require(_duration == uint256(uint64(_duration)));

        require(msg.sender == kittycore);
        _escrow(_seller, _tokenId);
        Auction memory auction = Auction(
            _seller,
            uint128(_startingPrice),
            uint128(_endingPrice),
            uint64(_duration),
            uint64(now)
        );
        _addAuction(_tokenId, auction);
    }

    function bid(uint256 _tokenId, uint256 _price)
        external
    {
        // _bid verifies token ID size
        address seller = tokenIdToAuction[_tokenId].seller;

        require(seller != address(0));
        require(msg.sender != seller);

        uint256 price = _bid(_tokenId, _price);
        _transfer(msg.sender, _tokenId);

        // If not a gen0 auction, exit
        if (seller == address(nonFungibleContract)) {
            // Track gen0 sale prices
            lastGen0SalePrices[gen0SaleCount % 5] = price;
            gen0SaleCount++;
        }
    }

    function averageGen0SalePrice() external view returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < 5; i++) {
            sum += lastGen0SalePrices[i];
        }
        return sum / 5;
    }

}