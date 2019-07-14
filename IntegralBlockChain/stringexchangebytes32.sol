pragma solidity  >0.4.23 <0.7.0;

contract Utils{
//string类型转化为bytes类型
function stringToBytes32 (string memory source) view internal returns(bytes32 result)  {

	assembly{

		result := mload(add(source,32))
	}	
}
 //bytse32转化为string类型
 function byte32ToString (bytes32 X) view internal returns(string)  {
 	bytes memory bytesSting = new bytes(32);
 	uint charCount = 0;
 	for(uint j=0;j<32;j++){
 		byte char = byte(bytes32(uint(x) * 2 ** (8*j)));
 		if(char != 0){
 			bytesSting[charCount] = char;
 			charCount++;
 		}
 	}
 	
 }


}

