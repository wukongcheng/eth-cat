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

contract SiringClockAuction is ClockAuction {

    function setKittyCoreAddress(address _address) external;
    function cancelAuction(uint256 _tokenId) external;
    function createAuction(uint256 _tokenId,uint256 _startingPrice,uint256 _endingPrice,uint256 _duration,address _seller) external;
    function bid(uint256 _sireId, uint256 _matronId, uint256 _price) external returns(uint256);
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

    /*** DATA TYPES ***/
    struct Kitty {
        // The Kitty's genetic code is packed into these 256-bits, the format is
        // sooper-sekret! A cat's genes never change.
        uint256 genes;
        uint64 birthTime;
        uint64 cooldownEndBlock;
        uint32 matronId;
        uint32 sireId;
        uint32 siringWithId;
        uint16 cooldownIndex;
        uint16 generation;
        uint16 breedTimes;
    }

    Kitty[] kitties;
    mapping (uint256 => address) public kittyIndexToOwner;
    mapping (address => uint256) ownershipTokenCount;
    mapping (address => uint256[]) ownershipTokens;
    mapping (uint256 => address) public kittyIndexToApproved;
    mapping (uint256 => address) public sireAllowedToAddress;
    
    SaleClockAuction public saleAuction;
    SiringClockAuction public siringAuction;
    GeneScience public geneScience;

    function setGeneScienceAddress(address _address) external {
        geneScience = GeneScience(_address);
    }

    function _transfer(address _from, address _to, uint256 _tokenId)  internal {
        // Since the number of kittens is capped to 2^32 we can't overflow this
        ownershipTokenCount[_to]++;
        ownershipTokens[_to].push(_tokenId);

        // transfer ownership
        kittyIndexToOwner[_tokenId] = _to;
        // When creating new kittens _from is 0x0, but we can't account that address.
        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
            for(uint32 i=0; i<ownershipTokens[_from].length; i++) {
                if(ownershipTokens[_from][i] == _tokenId) {
                    delete ownershipTokens[_from][i];
                    break;
                }
            }
            
            // once the kitten is transferred also clear sire allowances
            delete sireAllowedToAddress[_tokenId];
            // clear any previously approved ownership exchange
            delete kittyIndexToApproved[_tokenId];
        }
        // Emit the transfer event.
        Transfer(_from, _to, _tokenId);
    }

    function _createKitty(
        uint256 _matronId,
        uint256 _sireId,
        uint256 _generation,
        uint256 _genes,
        address _owner
    )
        internal returns (uint)
    {
        require(_matronId == uint256(uint32(_matronId)));
        require(_sireId == uint256(uint32(_sireId)));
        require(_generation == uint256(uint16(_generation)));

        // The cooldown is decided by genes
        uint16 cooldownIndex = geneScience.getCoolDown(_genes);
        //uint16 cooldownIndex = 5;
        
        Kitty memory _kitty = Kitty({
            genes: _genes,
            birthTime: uint64(now),
            cooldownEndBlock: 0,
            matronId: uint32(_matronId),
            sireId: uint32(_sireId),
            siringWithId: 0,
            cooldownIndex: cooldownIndex,
            generation: uint16(_generation),
            breedTimes: uint16(0)
        });
        
        kitties.push(_kitty);
        uint256 newKittenId = kitties.length - 1;

        // It's probably never going to happen, 4 billion cats is A LOT, but
        // let's just be 100% sure we never let this happen.
        require(newKittenId == uint256(uint32(newKittenId)));

        // emit the birth event
        Birth(
            _owner,
            newKittenId,
            uint256(_kitty.matronId),
            uint256(_kitty.sireId),
            _kitty.genes
        );

        // This will assign ownership, and also emit the Transfer event as
        // per ERC721 draft
        _transfer(0, _owner, newKittenId);

        return newKittenId;
    }

    function createKitty(
        uint256 _matronId,
        uint256 _sireId,
        uint256 _generation,
        uint256 _genes,
        address _owner
    )
        external 
        returns (uint) 
    {
        return _createKitty(_matronId, _sireId, _generation, _genes, _owner);
    }
}

contract KittyOwnership is KittyBase, ERC721 {

    string public constant name = "ETH-CAT";
    string public constant symbol = "EC";
    address public kittycore;
    SaleClockAuction public saleAuction;

    function KittyOwnership() public {
        ceoAddress = msg.sender;
        cooAddress = msg.sender;
    }

    function setKittyCoreAddress(address _address) external {
        kittycore = _address;
    }

    function setSaleAuctionAddress(address _address) external {
        saleAuction = SaleClockAuction(_address);
    }
    
    function _owns(address _claimant, uint256 _tokenId) public view returns (bool) {
        return kittyIndexToOwner[_tokenId] == _claimant;
    }
    function _approvedFor(address _claimant, uint256 _tokenId) public view returns (bool) {
        return kittyIndexToApproved[_tokenId] == _claimant;
    }
    function _approve(uint256 _tokenId, address _approved) internal {
        kittyIndexToApproved[_tokenId] = _approved;
    }

    function balanceOf(address _owner) public view returns (uint256 count) {
        return ownershipTokenCount[_owner];
    }
    
    function transfer(
        address _to,
        uint256 _tokenId
    )
        external
    {
        require(_to != address(0));
        require(_to != address(this));
        require(_to != address(saleAuction));
        require(_to != address(siringAuction));

        // You can only send your own cat.
        require(_owns(msg.sender, _tokenId) || msg.sender == kittycore);

        // Reassign ownership, clear pending approvals, emit Transfer event.
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(
        address _to,
        uint256 _tokenId
    )
        external
    {
        // Only an owner can grant transfer approval.
        require(_owns(msg.sender, _tokenId) || msg.sender == kittycore);

        // Register the approval (replacing any previous approval).
        _approve(_tokenId, _to);

        // Emit approval event.
        Approval(msg.sender, _to, _tokenId);
    }


    function approveToSaleAuction(uint256 _tokenId) external 
    {
        require(_owns(msg.sender, _tokenId));
        _approve(_tokenId, address(saleAuction));
        Approval(msg.sender, address(saleAuction), _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    )
        external
    {
        require(_to != address(0));
        require(_to != address(this));
        // Check for approval and valid ownership
        require(_approvedFor(msg.sender, _tokenId));
        require(_owns(_from, _tokenId));

        // Reassign ownership (also clears pending approvals and emits Transfer event).
        _transfer(_from, _to, _tokenId);
    }

    function totalSupply() public view returns (uint) {
        return kitties.length - 1;
    }

    function ownerOf(uint256 _tokenId)
        external
        view
        returns (address owner)
    {
        owner = kittyIndexToOwner[_tokenId];
        require(owner != address(0));
    }

    function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
        uint256 tokenCount = balanceOf(_owner);

        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 totalCats = totalSupply();
            uint256 resultIndex = 0;

            // We count on the fact that all cats have IDs starting at 1 and increasing
            // sequentially up to the totalCat count.
            uint256 catId;

            for (catId = 1; catId <= totalCats; catId++) {
                if (kittyIndexToOwner[catId] == _owner) {
                    result[resultIndex] = catId;
                    resultIndex++;
                }
            }

            return result;
        }
    }

    function getSireAllowedTo(uint256 _tokenId) external view returns (address allowed) {
        allowed = sireAllowedToAddress[_tokenId];
        require(allowed != address(0));
    }
    
    function setSireAllowedTo(uint256 _tokenId, address _address) external {
        require(_address != address(0));
        sireAllowedToAddress[_tokenId] = _address;
    }

    function deleteSireAllowedTo(uint256 _tokenId) external {
        delete sireAllowedToAddress[_tokenId];
    }

    function createGen0Kitty(
        uint256 _genes,
        address _owner
    )
        external
        returns (uint)
    {
        uint256 kittyId = _createKitty(0, 0, 0, _genes, _owner);
        _approve(kittyId, address(saleAuction));

        return kittyId;
    }

    function getKitty(uint256 _tokenId) external view returns (
        uint256 genes,
        uint256 birthTime,
        uint256 cooldownEndBlock,
        uint256 matronId,
        uint256 sireId,
        uint256 siringWithId,
        uint256 cooldownIndex,
        uint256 generation
    ) {
        Kitty storage kit = kitties[_tokenId];
        
        cooldownIndex = uint256(kit.cooldownIndex);
        cooldownEndBlock = uint256(kit.cooldownEndBlock);
        siringWithId = uint256(kit.siringWithId);
        birthTime = uint256(kit.birthTime);
        matronId = uint256(kit.matronId);
        sireId = uint256(kit.sireId);
        generation = uint256(kit.generation);
        genes = kit.genes;
    }
    
    function setSiringWithId(uint256 _tokenId, uint32 _siringWithId) external {
        Kitty storage kit = kitties[_tokenId];
        kit.siringWithId = _siringWithId;
    }
    
    function setCooldownEndBlock(uint256 _tokenId, uint64 _blocknum) external {
        Kitty storage kit = kitties[_tokenId];
        kit.cooldownEndBlock = _blocknum;
    }
    
    function setBreedTimes(uint256 _tokenId, uint16 _breedTimes) external {
        Kitty storage kit = kitties[_tokenId];
        kit.breedTimes = _breedTimes;
    }

    function isReadyToBreed(uint256 _tokenId) external view returns (bool) {
        require(_tokenId > 0);
        Kitty storage _kit = kitties[_tokenId];
        return (_kit.siringWithId == 0) && (_kit.cooldownEndBlock <= uint64(block.number));
    }
    
    function deleteSiringWithId(uint256 _tokenId) external {
        Kitty storage _kit = kitties[_tokenId];
        delete _kit.siringWithId;
    }
    
    function getHisFirstKitty(address account)
        external
        view
        returns (
        uint256 tokenId,
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    ) {
        if(ownershipTokens[account].length > 0) {
            tokenId = ownershipTokens[account][0];
            Kitty storage kit = kitties[tokenId];

            isGestating = (kit.siringWithId != 0);
            isReady = (kit.cooldownEndBlock <= block.number);
            cooldownIndex = uint256(kit.cooldownIndex);
            nextActionAt = uint256(kit.cooldownEndBlock);
            siringWithId = uint256(kit.siringWithId);
            birthTime = uint256(kit.birthTime);
            matronId = uint256(kit.matronId);
            sireId = uint256(kit.sireId);
            generation = uint256(kit.generation);
            genes = kit.genes;
        }
    }

    function testGene() external view returns (uint16) {
        return geneScience.getCoolDown(256);
        //return 22;
    }
}