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
    function init_attribute() external;
    function init_mixrule() external;
    function init_rate() external;
    function init_rate_distribution() external;
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
        uint256 generation,
        uint256 breedTimes
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
    function approveToSaleAuction(uint256 _tokenId) external;
    function setSiringAuctionAddress(address _address) external;
    function approveToSiringAuction(uint256 _tokenId) external;
}

contract KittyBreeding is KittyAccessControl {

    event Pregnant(address owner, uint256 matronId, uint256 sireId, uint256 cooldownEndBlock);

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

    /*** CONSTANTS ***/
    uint32[6] public cooldowns = [
        uint32(10 minutes),
        uint32(1 hours),
        uint32(4 hours),
        uint32(16 hours),
        uint32(2 days),
        uint32(7 days)
    ];

    uint256 public secondsPerBlock = 15;
    uint256 public pregnantKitties;
    KittyOwnership public kittyOwnership;
    GeneScience public geneScience;

    function KittyBreeding() public {
        ceoAddress = msg.sender;
    }

    function setGeneScienceAddress(address _address)  external onlyCEO {
        GeneScience candidateContract = GeneScience(_address);
        geneScience = candidateContract;
    }

    function setKittyOwnership(address _address) external onlyCEO {
        KittyOwnership candidateContract = KittyOwnership(_address);
        kittyOwnership = candidateContract;
    }
    
    function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
        address matronOwner = kittyOwnership.ownerOf(_matronId);
        address sireOwner = kittyOwnership.ownerOf(_sireId);

        // Siring is okay if they have same owner, or if the matron's owner was given
        // permission to breed with this sire.
        return (matronOwner == sireOwner || kittyOwnership.getSireAllowedTo(_sireId) == matronOwner);
    }

    function _triggerCooldown(uint256 _tokenId) internal {
        var (,,,,,cooldownIndex,,,breedTimes) = kittyOwnership.getKitty(_tokenId);

        // Compute an estimation of the cooldown time in blocks (based on current cooldownIndex).
        uint64 blocknum = uint64(cooldowns[cooldownIndex] / secondsPerBlock);
        blocknum = blocknum + uint64(breedTimes) * (blocknum / 5);

        kittyOwnership.setCooldownEndBlock(_tokenId, uint64(blocknum + block.number));
        kittyOwnership.setBreedTimes(_tokenId, uint16(breedTimes) + 1);
    }

   function approveSiring(address _addr, uint256 _sireId)
        external
    {
        require(kittyOwnership._owns(msg.sender, _sireId));
        kittyOwnership.setSireAllowedTo(_sireId, _addr);
    }

    /// @dev Checks to see if a given Kitty is pregnant and (if so) if the gestation
    ///  period has passed.
    function _isReadyToGiveBirth(uint32 siringWithId, uint64 cooldownEndBlock) private view returns (bool) {
        return (siringWithId != 0) && (cooldownEndBlock <= uint64(block.number));
    }

    /// @dev Checks whether a kitty is currently pregnant.
    /// @param _kittyId reference the id of the kitten, any user can inquire about it
    function isPregnant(uint256 _kittyId)
        public
        view
        returns (bool)
    {
        require(_kittyId > 0);
        // A kitty is pregnant if and only if this field is set
        var (,,,,,siringWithId,,,) = kittyOwnership.getKitty(_kittyId);
        return siringWithId != 0;
    }

    function _isValidMatingPair(
        uint256 _matronId,
        uint256 _sireId
    )
        private
        view
        returns(bool)
    {
        // A Kitty can't breed with itself!
        if (_matronId == _sireId) {
            return false;
        }

        var (,,,matron_matronId,matron_sireId,,,,) = kittyOwnership.getKitty(_matronId);
        // Kitties can't breed with their parents.
        if (matron_matronId == _sireId || matron_sireId == _sireId) {
            return false;
        }
        var (,,,sire_matronId,sire_sireId,,,,) = kittyOwnership.getKitty(_sireId);
        if (sire_matronId == _matronId || sire_sireId == _matronId) {
            return false;
        }

        // We can short circuit the sibling check (below) if either cat is
        // gen zero (has a matron ID of zero).
        if (sire_matronId == 0 || matron_matronId == 0) {
            return true;
        }

        // Kitties can't breed with full or half siblings.
        if (sire_matronId == matron_matronId || sire_matronId == matron_sireId) {
            return false;
        }
        if (sire_sireId == matron_matronId || sire_sireId == matron_sireId) {
            return false;
        }

        // Everything seems cool! Let's get DTF.
        return true;
    }

    function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
        external view returns (bool)
    {
        return _isValidMatingPair(_matronId, _sireId);
    }

    function canBreedWith(uint256 _matronId, uint256 _sireId)
        external
        view
        returns(bool)
    {
        require(_matronId > 0);
        require(_sireId > 0);
        
        return _isValidMatingPair(_matronId, _sireId) &&
            _isSiringPermitted(_sireId, _matronId);
    }

    /// @dev Internal utility function to initiate breeding, assumes that all breeding
    ///  requirements have been checked.
    function _breedWith(uint256 _matronId, uint256 _sireId) internal {

        // Mark the matron as pregnant, keeping track of who the sire is.
        kittyOwnership.setSiringWithId(_matronId, uint32(_sireId));

        // Trigger the cooldown for both parents.
        _triggerCooldown(_sireId);
        _triggerCooldown(_matronId);

        // Clear siring permission for both parents. This may not be strictly necessary
        // but it's likely to avoid confusion!
        kittyOwnership.deleteSireAllowedTo(_matronId);
        kittyOwnership.deleteSireAllowedTo(_sireId);

        // Every time a kitty gets pregnant, counter is incremented.
        pregnantKitties++;

        // Emit the pregnancy event.
        var (,,cooldownEndBlock,,,,,,) = kittyOwnership.getKitty(_matronId);
        Pregnant(kittyOwnership.ownerOf(_matronId), _matronId, _sireId, cooldownEndBlock);

        //giveBirth(_matronId);
    }

    /// @notice Breed a Kitty you own (as matron) with a sire that you own, or for which you
    ///  have previously been given Siring approval. Will either make your cat pregnant, or will
    ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
    /// @param _matronId The ID of the Kitty acting as matron (will end up pregnant if successful)
    /// @param _sireId The ID of the Kitty acting as sire (will begin its siring cooldown if successful)
    function breedWithAuto(uint256 _matronId, uint256 _sireId)
        external
    {
        // Caller must own the matron.
        require(kittyOwnership._owns(msg.sender, _matronId));

        require(_isSiringPermitted(_sireId, _matronId));

        // Make sure matron isn't pregnant, or in the middle of a siring cooldown
        require(kittyOwnership.isReadyToBreed(_matronId));

        // Make sure sire isn't pregnant, or in the middle of a siring cooldown
        require(kittyOwnership.isReadyToBreed(_sireId));

        // Test that these cats are a valid mating pair.
        require(_isValidMatingPair(
            _matronId,
            _sireId
        ));

        // All checks passed, kitty gets pregnant!
        _breedWith(_matronId, _sireId);
    }

  
    function giveBirth(uint256 _matronId, address winner)
        internal
        returns(uint256)
    {
        var (matron_genes,matron_birthTime,matron_cooldownEndBlock,,,matron_siringWithId,,matron_generation,) = kittyOwnership.getKitty(_matronId);
        // Check that the matron is a valid cat.
        require(matron_birthTime != 0);
        // Check that the matron is pregnant, and that its time has come!
        require(_isReadyToGiveBirth(uint32(matron_siringWithId),uint64(matron_cooldownEndBlock)));

        var (sireId_matron_genes,,,,,,,sireId_generation,) = kittyOwnership.getKitty(matron_siringWithId);

        // Determine the higher generation number of the two parents
        uint16 parentGen = uint16(matron_generation);
        if (sireId_generation > matron_generation) {
            parentGen = uint16(sireId_generation);
        }

        // Call the sooper-sekret gene mixing operation.
        uint256 childGenes = geneScience.mixGenes(matron_genes, sireId_matron_genes);

        // Make the new kitten!
        uint256 kittenId = kittyOwnership.createKitty(_matronId, matron_siringWithId, parentGen + 1, childGenes, winner);

        // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
        // set is what marks a matron as being pregnant.)
        kittyOwnership.deleteSiringWithId(_matronId);

        // Every time a kitty gives birth counter is decremented.
        pregnantKitties--;

        // return the new kitten's ID
        return kittenId;
    }
}