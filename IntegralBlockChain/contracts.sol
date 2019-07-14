pragma solidity  >0.4.23 <0.7.0;

contract AdminContract{


address owner;//合约的拥有者银行
uint issuedScoreAmout;//银行已经发行的积分总数
uint settledScoreAmount;//银行已经清算的积分总数


struct Customer {
	address customerAddr;//客户地址
	bytes32 password;//客户密码
	uint scoreAmount;//积分余额
	bytes32[] buyGoods;//购买的商品数组	
}
struct Merchant {
	address merchantAddr;//商户地址
	bytes32 password;//客户密码
	uint scoreAmount;//积分余额
	bytes32[] sellGoods;//发布商品的数组
}

struct Good {
	address goodAddr;//商品ID
	uint price;//商品价格
	address belong;//属于哪个商户address
}

mapping (address => Customer) customer; //根据客户的地址查找某个客户
mapping (address => Merchant) merchant; //根据商户的地址查找某个商户
mapping (bytes32 => Good) good; //根据商品ID查找该件商品

address[] customers;//已注册的客户数组
address[] merchants; //已注册的商户数组
bytes32[] goods;//已上线的商品数组

function Score() {
	owner = msg.sender;
}
//注册一个客户
event NewCustomer(address sender,bool isSuccess,string message );
function newCustomer (address _customerAddr,string _password){
	//判断客户是否注册
	if(!isCustomerAlreadyRegister(_customerAddr)){
		//没有注册
		customer[_customerAddr].customerAddr = _customerAddr;
		customer[_customerAddr].password = stringToBytes32(_password);
	customers.push(_customerAddr);
		NewCustomer(msg.sender,true,"注册成功");
		return;
	}else{
		NewCustomer(msg.sender,false,"账户已注册");
		return;
	}
}
//注册一个商户
event NewMerchat(address sender,bool isSuccess,string message);
function newMerchant (address _merchantAddr,string _password) {
	//判断商户是否注册
	if(!isMerchantAlreadyRegister(_merchantAddr)){
		//还未注册
		merchant[_merchantAddr].merchantAddr = _merchantAddr;
		merchant[_merchantAddr].password = stringToBytes32(_password);
		merchants.push(_merchantAddr);
		NewMerchat(msg.sender,true,"注册成功");
		return;
	}else{
		NewMerchat(msg.sender,false,"该账户已经注册");
		return;
	}
}
//判断一个客户是否已经注册
function isCustomerAlreadyRegister(address _customerAddr) internal returns(bool) {
	for(uint i = 0;i<customer.length;i++){
		if(customers[i] == _customerAddr){
			return true;
		}
	}
	return false;	
}
//判断一个商户是否已经注册
function isMerchantAlreadyRegister (address _merchantAddr) internal returns(bool) {
	for(uint i=0;i<merchants.length;i++){
		if(merchants[i] == _merchantAddr){
			return true;
		}
	}
	return false;

}
//查询用户密码
function getCustomerPassword (address _customerAddr) view returns(bool,bytes32) {
	//判断用户是否注册
	if(isCustomerAlreadyRegister(_customerAddr)){
		return (true,customer[_customerAddr].password);
	}else{
		return(false,"");
	}
}
//查询商户密码
function getMerchantPassword (address _merchantAddr) view returns(bool,bytes32) {
	//判断商户是否注册
	if(isCustomerAlreadyRegister(_merchantAddr)){
		return(true,Merchant[_merchantAddr].password);
	}else{
		return(false,"");
	}
}

//银行发送积分给客户,只能被银行调用,只能发送给客户
event SendScoreToCustomer(address sender,string message);
function sendScoreToCustomer (address _receiver,uint _amout){
	if(isCustomerAlreadyRegister(_receiver)){
		//已经注册
		issuedScoreAmout += _amout;
		customer[_receiver].scoreAmount += _amout;
		SendScoreToCustomer(msg.sender,"发行积分成功");
		return;
	}else{
		//还没注册
		SendScoreToCustomer(msg.sender,"该账户未注册,发行积分失败");
		return;
	}	
}


//两个账户转让积分,任意两个账户之间都可以转让,客户商户都调用该方法
//sendertype表示调用者0表示用户1表示商户
event TransFerScoreToAnother(address sender,string message);
function transFerScoreToAnother (uint _senderType,address _sender,address _receiver,uint _amount){
	string memory message;
	if(!isCustomerAlreadyRegister(_receiver)&& !isMerchantAlreadyRegister(_receiver)){
		//目的账户不存在
		TransFerScoreToAnother(msg.sender,"目的账户不存在,请确认后再转让!");
		return;
	}
	if(_senderType == 0 ){
		if(customer[_sender].scoreAmount >= _amout){
			customer[_sender].scoreAmount -= _amout;
			if(isCustomerAlreadyRegister(_receiver)){
				//目的地址是客户
				customer[_receiver].scoreAmount += _amout;
			}else{
				merchant[_receiver].scoreAmount += _amout;
			}
			TransFerScoreToAnother(msg.sender,"积分转让成功");
			return;
		}else{
			TransFerScoreToAnother(msg.sender,"你的积分余额不足,转让失败");
			return;
		}
	}else{
		//商户装让
		if(merchant[_sender].scoreAmount >= _amout){
			merchant[_sender].scoreAmount -= _amout;
			if(isCustomerAlreadyRegister(_receiver)){
				//目的地址是客户
				customer[_receiver].scoreAmount += _amout;
			}else{
				merchant[_receiver].scoreAmount += _amout;
			}
			TransFerScoreToAnother(msg.sender,"积分转让成功");
			return;
		}else{
			TransFerScoreToAnother(msg.sender,"你的积分余额不足,装让失败!");
			return;
		}
	}
	
}


}



