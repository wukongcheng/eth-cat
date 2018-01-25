pragma solidity ^0.4.18;

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

contract ClockAuctionBase {

    struct Auction {
        address seller;
        uint128 startingPrice;
        uint128 endingPrice;
        uint64 duration;
        uint64 startedAt;
    }

    event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
    event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
    event AuctionCancelled(uint256 tokenId);

    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool);
    function _escrow(address _owner, uint256 _tokenId) internal;
    function _transfer(address _receiver, uint256 _tokenId) internal;
    function _addAuction(uint256 _tokenId, Auction _auction) internal ;
    function _cancelAuction(uint256 _tokenId, address _seller) internal ;
    function _bid(uint256 _tokenId, uint256 _bidAmount)
        internal
        returns (uint256);
    function _removeAuction(uint256 _tokenId) internal ;
    function _isOnAuction(Auction storage _auction) internal view returns (bool) ;

    function _currentPrice(Auction storage _auction)
        internal
        view
        returns (uint256);

    function _computeCurrentPrice(
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration,
        uint256 _secondsPassed
    )
        internal
        pure
        returns (uint256);
}

contract ClockAuction is ClockAuctionBase {

    function cancelAuction(uint256 _tokenId) external;
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
    );

    function isOnAuction(uint256 _tokenId)
        external
        view
        returns (bool);
    function getCurrentPrice(uint256 _tokenId) external view returns (uint256);

}

contract SaleClockAuction is ClockAuction {
    function setERC721Address(address _nftAddress) external;
    function setERC20Address(address _erc20Address) external;
    function setKittyCoreAddress(address _address) external;
    function testAuction() external pure returns (uint256);
    function createAuction(
        uint256 _tokenId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration,
        address _seller
    ) external;
    function bid(uint256 _tokenId, uint256 _price) external;
    function averageGen0SalePrice() external view returns (uint256);

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

    /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
    /// @param _newCEO The address of the new CEO
    function setCEO(address _newCEO) external onlyCEO {
        require(_newCEO != address(0));

        ceoAddress = _newCEO;
    }

    /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
    /// @param _newCFO The address of the new CFO
    function setCFO(address _newCFO) external onlyCEO {
        require(_newCFO != address(0));

        cfoAddress = _newCFO;
    }

    /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
    /// @param _newCOO The address of the new COO
    function setCOO(address _newCOO) external onlyCEO {
        require(_newCOO != address(0));

        cooAddress = _newCOO;
    }

    /*** Pausable functionality adapted from OpenZeppelin ***/

    /// @dev Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS paused
    modifier whenPaused {
        require(paused);
        _;
    }

    /// @dev Called by any "C-level" role to pause the contract. Used only when
    ///  a bug or exploit is detected and we need to limit damage.
    function pause() external onlyCLevel whenNotPaused {
        paused = true;
    }

    /// @dev Unpauses the smart contract. Can only be called by the CEO, since
    ///  one reason we may pause the contract is when CFO or COO accounts are
    ///  compromised.
    /// @notice This is public rather than external so it can be called by
    ///  derived contracts.
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

contract KittyBreeding is KittyAccessControl {
    event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndBlock);

    function setGeneScienceAddress(address _address)  external;
    function setKittyOwnership(address _address) external;
    function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool);
    function _triggerCooldown(uint256 _tokenId) internal;
    function approveSiring(address _addr, uint256 _sireId) external;
    function _isReadyToGiveBirth(uint32 siringWithId, uint64 cooldownEndBlock) private view returns (bool);
    function isPregnant(uint256 _kittyId) public view returns (bool);
    function _isValidMatingPair(
        uint256 _matronId,
        uint256 _sireId
    ) private view returns(bool);
    function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId) external view returns (bool);
    function canBreedWith(uint256 _matronId, uint256 _sireId) external view returns(bool);
    function _breedWith(uint256 _matronId, uint256 _sireId) public;
    function breedWithAuto(uint256 _matronId, uint256 _sireId) external;
    function giveBirth(uint256 _matronId) external returns(uint256);
}

contract KittyAuction is KittyAccessControl {

    KittyOwnership public kittyOwnership;
    KittyBreeding public kittyBreeding;
    SaleClockAuction public saleAuction;
    //SiringClockAuction public siringAuction;
    
    function setKittyOwnership(address _address) external onlyCEO {
        KittyOwnership candidateContract = KittyOwnership(_address);
        kittyOwnership = candidateContract;
    }
    
    function setBreeding(address _address) external onlyCEO {
        KittyBreeding candidateContract = KittyBreeding(_address);
        kittyBreeding = candidateContract;
    }
    
    function setSaleAuctionAddress(address _address) external onlyCEO {
        SaleClockAuction candidateContract = SaleClockAuction(_address);
        saleAuction = candidateContract;
    }

    // function setSiringAuctionAddress(address _address) external onlyCEO {
    //     SiringClockAuction candidateContract = SiringClockAuction(_address);
    //     siringAuction = candidateContract;
    // }

    /// @dev Put a kitty up for auction.
    ///  Does some ownership trickery to create auctions in one tx.
    function createSaleAuction(
        uint256 _kittyId,
        uint256 _startingPrice,
        uint256 _endingPrice,
        uint256 _duration
    )
        external
    {
        require(kittyOwnership._owns(msg.sender, _kittyId));
        require(!kittyBreeding.isPregnant(_kittyId));
        require(!saleAuction.isOnAuction(_kittyId));

        saleAuction.createAuction(
            _kittyId,
            _startingPrice,
            _endingPrice,
            _duration,
            msg.sender
        );
    }

    /// @dev Put a kitty up for auction to be sire.
    ///  Performs checks to ensure the kitty can be sired, then
    ///  delegates to reverse auction.
    // function createSiringAuction(
    //     uint256 _kittyId,
    //     uint256 _startingPrice,
    //     uint256 _endingPrice,
    //     uint256 _duration
    // )
    //     external
    //     whenNotPaused
    // {
    //     // Auction contract checks input sizes
    //     // If kitty is already on any auction, this will throw
    //     // because it will be owned by the auction contract.
    //     require(kittyOwnership._owns(msg.sender, _kittyId));
    //     require(kittyOwnership.isReadyToBreed(_kittyId));
    //     require(!siringAuction.isOnAuction(_kittyId));
    //     kittyOwnership.approve(siringAuction,_kittyId);
    //     // Siring auction throws if inputs are invalid and clears
    //     // transfer and sire approval after escrowing the kitty.
    //     siringAuction.createAuction(
    //         _kittyId,
    //         _startingPrice,
    //         _endingPrice,
    //         _duration,
    //         msg.sender
    //     );
    // }

    /// @dev Completes a siring auction by bidding.
    ///  Immediately breeds the winning matron with the sire on auction.
    /// @param _sireId - ID of the sire on auction.
    /// @param _matronId - ID of the matron owned by the bidder.
    // function bidOnSiringAuction(
    //     uint256 _sireId,
    //     uint256 _matronId,
    //     uint256 _price
    // )
    //     external
    //     payable
    //     whenNotPaused
    // {
    //     // Auction contract checks input sizes
    //     require(kittyOwnership._owns(msg.sender, _matronId));
    //     require(kittyOwnership.isReadyToBreed(_matronId));
    //     require(kittyBreeding._canBreedWithViaAuction(_matronId, _sireId));

    //     // Define the current price of the auction.
    //     uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
    //     require(_price >= currentPrice);

    //     // Siring auction will throw if the bid fails.
    //     siringAuction.bid(_sireId, _matronId, _price);
    //     kittyBreeding._breedWith(uint32(_matronId), uint32(_sireId));
    // }
}

/// @title all functions related to creating kittens
contract KittyMinting is KittyAuction {

    // Limits the number of cats the contract owner can ever create.
    uint256 public constant PROMO_CREATION_LIMIT = 5000;
    uint256 public constant GEN0_CREATION_LIMIT = 45000;

    // Constants for gen0 auctions.
    uint256 public constant GEN0_STARTING_PRICE = 500;
    uint256 public constant GEN0_AUCTION_DURATION = 1 days;

    // Counts the number of cats the contract owner has created.
    uint256 public promoCreatedCount = 0;
    uint256 public gen0CreatedCount = 0;

    /// @dev we can create promo kittens, up to a limit. Only callable by COO
    /// @param _genes the encoded genes of the kitten to be created, any value is accepted
    /// @param _owner the future owner of the created kittens. Default to contract COO
    function createPromoKitty(uint256 _genes, address _owner) external {
        address kittyOwner = _owner;
        if (kittyOwner == address(0)) {
             kittyOwner = cooAddress;
        }
        require(promoCreatedCount < PROMO_CREATION_LIMIT);

        promoCreatedCount++;
        kittyOwnership.createKitty(0, 0, 0, _genes, kittyOwner);
    }

    function testKittyOwnership() external view returns (uint256) {
        return kittyOwnership.testGene();
    }

    function testSaleAuction() external view returns (uint256) {
        return saleAuction.testAuction();
    }
    
    function testParam() external view returns (uint256) {
        return gen0CreatedCount;
    }

    function testCreateAuction(uint256 kittyId) external {
        saleAuction.createAuction(
            kittyId,
            5000,
            20,
            99999,
            address(this)
        );
    }

    function getKittyOwnership() external view returns (address) {
        return address(kittyOwnership);
    }

    /// @dev Creates a new gen0 kitty with the given genes
    function createGen0Kitty(uint256 _genes) external {
        require(gen0CreatedCount < GEN0_CREATION_LIMIT);
        gen0CreatedCount++;

        kittyOwnership.createGen0Kitty(_genes, cooAddress);
    }

    function createGen0SaleAuction(uint256 _kittyId) external onlyCOO
    {
        require(kittyOwnership._owns(msg.sender, _kittyId));

        var (,,,,,,,generation) = kittyOwnership.getKitty(_kittyId);
        require(generation == 0);

        saleAuction.createAuction(
            _kittyId,
            _computeNextGen0Price(),
            0,
            GEN0_AUCTION_DURATION,
            address(this)
        );

    }

    /// @dev Computes the next gen0 auction starting price, given
    ///  the average of the past 5 prices + 50%.
    function _computeNextGen0Price() internal view returns (uint256) {
        uint256 avePrice = saleAuction.averageGen0SalePrice();

        // Sanity check to ensure we don't overflow arithmetic
        require(avePrice == uint256(uint128(avePrice)));

        uint256 nextPrice = avePrice + (avePrice / 2);

        // We never auction for less than starting price
        if (nextPrice < GEN0_STARTING_PRICE) {
            nextPrice = GEN0_STARTING_PRICE;
        }

        return nextPrice;
    }
}


/// @title CryptoKitties: Collectible, breedable, and oh-so-adorable cats on the Ethereum blockchain.
/// @author Axiom Zen (https://www.axiomzen.co)
/// @dev The main CryptoKitties contract, keeps track of kittens so they don't wander around and get lost.
contract KittyCore is KittyMinting {

    // Set in case the core contract is broken and an upgrade is required
    address public newContractAddress;

    /// @notice Creates the main CryptoKitties smart contract instance.
    function KittyCore() public {
        // Starts paused.
        // paused = true;

        // the creator of the contract is the initial CEO
        ceoAddress = msg.sender;

        // the creator of the contract is also the initial COO
        cooAddress = msg.sender;
    }

    /// @dev Used to mark the smart contract as upgraded, in case there is a serious
    ///  breaking bug. This method does nothing but keep track of the new contract and
    ///  emit a message indicating that the new address is set. It's up to clients of this
    ///  contract to update to the new contract address in that case. (This contract will
    ///  be paused indefinitely if such an upgrade takes place.)
    /// @param _v2Address new address
    function setNewAddress(address _v2Address) external onlyCEO whenPaused {
        // See README.md for updgrade plan
        newContractAddress = _v2Address;
        ContractUpgrade(_v2Address);
    }


}