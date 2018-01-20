pragma solidity ^0.4.18;

contract GeneScience {
    function random() public view returns (uint256);
    function getBitMask(uint8[] index) internal pure returns (bytes32);
    function mixGenes(uint256 genes1, uint256 genes2) external view returns (uint256);
    function getCoolDown(uint256 genes) external view returns (uint16);
    function getAttriPos(uint8 index) external view returns (uint8[]);
}


contract Variation {

    uint32 public constant ATTRIBUTE_NUM = 21;
    address public _ceo;
    GeneScience public _geneScience;
    
    mapping (uint32 => uint8) _variation_rate;						// 千分之几
    mapping (uint32 => uint16[]) _variation_rate_distribution;		// 万分之几
    
    function Variation() public {
        _ceo = msg.sender;
        
        _variation_rate[0] = 0;
        _variation_rate[1] = 1;
        _variation_rate[2] = 100;
        _variation_rate[3] = 0;
        _variation_rate[4] = 10;
        _variation_rate[5] = 100;
        _variation_rate[6] = 10;
        _variation_rate[7] = 100;
        _variation_rate[8] = 100;
        _variation_rate[9] = 100;
        _variation_rate[10] = 100;
        _variation_rate[11] = 100;
        _variation_rate[12] = 100;
        _variation_rate[13] = 100;
        _variation_rate[14] = 200;
        _variation_rate[15] = 100;
        _variation_rate[16] = 100;
        _variation_rate[17] = 100;
        _variation_rate[18] = 100;
        _variation_rate[19] = 100;
        _variation_rate[20] = 100;

        _variation_rate_distribution[0] = [10000,0];                              // 是否EXCLUSIVE
        _variation_rate_distribution[1] = [10000,0];                              // 是否FANCY
        _variation_rate_distribution[2] = [2500,2500,2500,2500];                     	// FANCY属性
        _variation_rate_distribution[3] = [3000,4000,3000];                           // EXCLUSIVE属性
        _variation_rate_distribution[4] = [10,50,140,400,800,1000,1600,2000,1600,1000,800,400,140,50,10]; 	// BODY
        _variation_rate_distribution[5] = [20,150,830,1600,2400,2400,1600,830,150,20];      // TAIL
        _variation_rate_distribution[6] = [20,150,830,1600,2400,2400,1600,830,150,20];    	// PRIMARY COLOR
        _variation_rate_distribution[7] = [20,150,830,1600,2400,2400,1600,830,150,20];      // SECONDARY COLOR
        _variation_rate_distribution[8] = [14,105,581,1120,1680,3000,1680,1120,581,105,14];  	// PATTERN TYPE
        _variation_rate_distribution[9] = [20,150,830,1600,2400,2400,1600,830,150,20];   	// PATTERN COLOR
        _variation_rate_distribution[10] = [20,150,830,1600,2400,2400,1600,830,150,20];     // EYE TYPE
        _variation_rate_distribution[11] = [14,105,581,1120,1680,3000,1680,1120,581,105,14];  	// EYE COLOR / BACKGROUND COLOR
        _variation_rate_distribution[12] = [20,150,830,1600,2400,2400,1600,830,150,20];     // MOUTH
        _variation_rate_distribution[13] = [20,150,830,1600,2400,2400,1600,830,150,20];     // BEARD
        _variation_rate_distribution[14] = [900,900,900,900,900,900,900,900,900,900,1000];  			// ACCESSORIES
        _variation_rate_distribution[15] = [1000,1000,3000,3000,1000,1000];               	// 生育能力
        _variation_rate_distribution[16] = [3000,4000,3000];                          // 性格
        _variation_rate_distribution[17] = [3000,4000,3000];                          // 速度
        _variation_rate_distribution[18] = [3000,4000,3000];                          // 智商
        _variation_rate_distribution[19] = [3000,4000,3000];                          // 体力
        _variation_rate_distribution[20] = [3000,4000,3000];                          // 技能
    }

    function setGenescience(address _address) external {
        require(msg.sender == _ceo);

        GeneScience candidateContract = GeneScience(_address);
        _geneScience = candidateContract;
    }

    function variation(uint8 attID, bytes32 genes) external view returns (bytes32) {
    	uint32 rate = _variation_rate[attID];
    	if((_geneScience.random() % 1000) >= rate)
    		return genes;

    	uint8[] storage pos = _geneScience.getAttriPos(attID);
    	uint16 firstPos = 257;

    	for(uint16 i=0; i<pos.length; i++) {
    		if((bytes32(0x1) << pos[i]) & genes > 0) {
    			firstPos = i;
    			break;
    		}
    	}

    	uint16[] storage rate_distribution = _variation_rate_distribution[attID];
    	
    	uint16 rd = uint16(_geneScience.random() % 10000);
    	uint16 total = 10000 - rate_distribution[firstPos];
    	uint16 begin = 0;
    	uint16 variation_attr = firstPos;
		for(i=0; i<pos.length; i++) {
			if(i == firstPos)
				continue;

			uint16 end = uint16((rate_distribution[i] * 10000) / total + begin);
			if(rd >= begin && rd < end) {
				variation_attr = i;
				break;
			}

			begin = end;
		}

		return bytes32(0x0) | (bytes32(0x1) << pos[variation_attr]);
    }
    
}

