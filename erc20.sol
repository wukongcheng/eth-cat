pragma solidity ^0.4.18;


contract ERC20 {
    function totalSupply() public constant returns (uint supply);
    function balanceOf( address who ) public constant returns (uint value);
    function allowance( address owner, address spender ) public constant returns (uint _allowance);

    function transfer( address to, uint value) public returns (bool ok);
    function transferFrom( address from, address to, uint value) public returns (bool ok);
    function approve( address spender, uint value ) public returns (bool ok);
    function transferByAuction(address src, address dst, uint wad) public returns (bool ok);

    event Transfer( address indexed from, address indexed to, uint value);
    event Approval( address indexed owner, address indexed spender, uint value);
}    
    
/// @dev The uint of balance is 0.01 Token
contract CKToken is ERC20 {

    address _cfo;
    mapping (address => uint256) _balances;
    uint256 _supply;
    mapping (address => mapping (address => uint256)) _approvals;

    address  _saleAuction;
    address  _siringAuction;
    
    function CKToken (uint256 supply) public {
        _cfo = msg.sender;

        _balances[_cfo] = supply;
        _supply = supply;
    }

    modifier onlyCFO() {
        require(msg.sender == _cfo);
        _;
    }

    function setSaleAuctionAddress(address _address) external onlyCFO {
        _saleAuction = _address;
    }

    function setSiringAuctionAddress(address _address) external onlyCFO {
        _siringAuction = _address;
    }
    
    function totalSupply() public constant returns (uint256) {
        return _supply;
    }

    function balanceOf(address src) public constant returns (uint256) {
        return _balances[src];
    }
    
    function allowance(address src, address guy) public constant returns (uint256) {
        return _approvals[src][guy];
    }
    
    function transfer(address dst, uint wad) public returns (bool) {
        assert(_balances[msg.sender] >= wad);
        
        _balances[msg.sender] = _balances[msg.sender] - wad;
        _balances[dst] = _balances[dst] + wad;
        
        Transfer(msg.sender, dst, wad);
        
        return true;
    }
    
    function transferByAuction(address src, address dst, uint wad) public returns (bool) {
        assert(msg.sender == _saleAuction || msg.sender == _siringAuction);
        assert(_balances[src] >= wad);
        
        _balances[src] = _balances[src] - wad;
        _balances[dst] = _balances[dst] + wad;
        
        Transfer(src, dst, wad);
        
        return true;
    }

    function transferFrom(address src, address dst, uint wad) public returns (bool) {
        assert(_balances[src] >= wad);
        assert(_approvals[src][msg.sender] >= wad);
        
        _approvals[src][msg.sender] = _approvals[src][msg.sender] - wad;
        _balances[src] = _balances[src] - wad;
        _balances[dst] = _balances[dst] + wad;
        
        Transfer(src, dst, wad);
        
        return true;
    }
    
    function approve(address guy, uint256 wad) public returns (bool) {
        _approvals[msg.sender][guy] = wad;
        
        Approval(msg.sender, guy, wad);
        
        return true;
    }

}