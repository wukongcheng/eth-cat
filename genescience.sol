pragma solidity ^0.4.18;

contract Variation {
    function variation(uint32 attID, bytes32 genes) external view returns (bytes32);   
}

contract GeneScience {

    uint32 public constant ATTRIBUTE_NUM = 21;
    uint public _startTime;
    address public _ceo;

    Variation public _variation;
    mapping (uint32 => uint8[]) public _attribute;
    mapping (uint32 => uint8[]) _attribute_mixrule;
    
    function GeneScience() public {
        _startTime = now;
        _ceo = msg.sender;
        
        _attribute[0] = [47];                               // 是否EXCLUSIVE
        _attribute[1] = [117];                              // 是否FANCY
        _attribute[2] = [107,101,12,8];                     // FANCY属性
        _attribute[3] = [58,10];                            // EXCLUSIVE属性
        _attribute[4] = [124,113,97,95,93,87,76,61,60,36,33,30,28,17]; // BODY
        _attribute[5] = [127,119,84,66,57,27,26,22,4];      // TAIL
        _attribute[6] = [128,125,120,100,99,68,56,46,6];    // PRIMARY COLOR
        _attribute[7] = [118,114,88,80,79,41,40,2,1];       // SECONDARY COLOR
        _attribute[8] = [129,126,86,65,52,49,44,42,34,21];  // PATTERN TYPE
        _attribute[9] = [123,122,111,102,90,64,54,53,38];   // PATTERN COLOR
        _attribute[10] = [89,85,81,72,67,50,32,23,19];      // EYE TYPE
        _attribute[11] = [116,110,103,77,35,29,24,15,9,3];  // EYE COLOR / BACKGROUND COLOR
        _attribute[12] = [98,74,73,71,70,59,48,45,39];      // MOUTH
        _attribute[13] = [109,96,91,75,31,25,20,16,0];      // BEARD
        _attribute[14] = [108,105,82,63,62,55,51,43,13,5];  // ACCESSORIES
        _attribute[15] = [115,112,106,94,69];               // 生育能力
        _attribute[16] = [18,7];                            // 性格
        _attribute[17] = [92,78];                           // 速度
        _attribute[18] = [104,37];                          // 智商
        _attribute[19] = [83,14];                           // 体力
        _attribute[20] = [121,11];                          // 技能
        
        _attribute_mixrule[0] = [3];
        _attribute_mixrule[1] = [6];
        _attribute_mixrule[2] = [1,2];
        _attribute_mixrule[3] = [1,2];
        _attribute_mixrule[4] = [1,2];
        _attribute_mixrule[5] = [5];
        _attribute_mixrule[6] = [1,2];
        _attribute_mixrule[7] = [1,2];
        _attribute_mixrule[8] = [1,2];
        _attribute_mixrule[9] = [1,2];
        _attribute_mixrule[10] = [1,2];
        _attribute_mixrule[11] = [1,2];
        _attribute_mixrule[12] = [1,2];
        _attribute_mixrule[13] = [5];
        _attribute_mixrule[14] = [6];
        _attribute_mixrule[15] = [1,2];
        _attribute_mixrule[16] = [1,2];
        _attribute_mixrule[17] = [1,2];
        _attribute_mixrule[18] = [1,2];
        _attribute_mixrule[19] = [1,2];
        _attribute_mixrule[20] = [1,2];
    }

    function setVariation(address _address) external {
        require(msg.sender == _ceo);

        Variation candidateContract = Variation(_address);
        _variation = candidateContract;
    }
    
    function random() public view returns (uint256) {
    	return uint256(keccak256(block.difficulty, now, block.blockhash(block.number - 1), _startTime));
    }

    function getAttriPos(uint8 index) external view returns (uint8[]) {
        require(index < ATTRIBUTE_NUM);
        return _attribute[index];
    }

    // index begin with 0
    function getBitMask(uint8[] index) internal pure returns (bytes32) {
    	bytes32 r = 0x0;
    	for(uint32 i=0; i<index.length; i++) {
    	    bytes32 t = bytes32(0x1) << index[i];
    	    r = r | t;
    	}
		return r;
    }

    function mixGenes(uint256 genes1, uint256 genes2) external view returns (uint256) {
    	bytes32 a = bytes32(genes1);
		bytes32 b = bytes32(genes2);

		bytes32 r = 0x0;
		for(uint32 i=0; i<ATTRIBUTE_NUM; i++) {
			bytes32 mask = getBitMask(_attribute[i]);

			bytes32 ma = mask & a;
			bytes32 mb = mask & b;
			bytes32 mixed;

			if(_attribute_mixrule[i].length == 2) {
			    uint256 rule = random() % 2 + 1;
			    if(rule == 1) {
			        mixed = ma;
			    } else {
			        mixed = mb;
			    }
			} else if(_attribute_mixrule[i][0] == 3) {
			    // all is 0, do nothing
			} else if(_attribute_mixrule[i][0] == 5) {
			    mixed = ma | mb;
			} else if(_attribute_mixrule[i][0] == 6) {
			    mixed = ma & mb;
			}

			mixed = _variation.variation(i, mixed);
			r = r | mixed;
		}
		
		return uint256(r);
    }

    function getCoolDown(uint256 genes) external view returns (uint16) {
        bytes32 a = bytes32(genes);
        uint8[] storage pos = _attribute[15];
        uint16 firstPos = 5;

    	for(uint16 i=0; i<pos.length; i++) {
    		if((bytes32(0x1) << pos[i]) & a > 0) {
    			firstPos = i;
    			break;
    		}
    	}

        return firstPos;
    }
    
}

