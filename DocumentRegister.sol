pragma solidity ^0.4.15;

/*********************************************************************************
 *********************************************************************************
 *
 * Name of the project: IPFS Documents registration service
 * Author: Juan Livingston 
 *
 *********************************************************************************
 ********************************************************************************/

 /* New ERC20 contract interface */

contract ERC20Basic {
	uint256 public totalSupply;
	function balanceOf(address who) constant returns (uint256);
	function transfer(address to, uint256 value) returns (bool);
	event Transfer(address indexed from, address indexed to, uint256 value);
}


// Interface for Storage
contract GlobalStorageMultiId { 
	uint256 public regPrice;
	function registerUser(bytes32 _id) payable returns(bool);
	function changeAddress(bytes32 _id , address _newAddress) returns(bool);
	function setUint(bytes32 _id , bytes32 _key , uint _data , bool _overwrite) returns(bool);
	function getUint(bytes32 _id , bytes32 _key) constant returns(uint);
	event Error(string _string);
	event RegisteredUser(address _address , bytes32 _id);
	event ChangedAdd(bytes32 _id , address _old , address _new);
}

contract UpgDocs {
	function confirm(bytes32 _storKey) returns(bool);
	event DocsUpgraded(address _oldAddress,address _newAddress);
}

// The Token
contract RegDocuments {
	string public version;
	address public admin;
	address public owner;
	uint public price;
	bool registered;
	address storageAddress;
	bytes32 public storKey;

	GlobalStorageMultiId public Storage;

	event RegDocument(address indexed from, string hash);
	event DocsUpgraded(address _oldAddress,address _newAddress);

	// Modifiers

	modifier onlyAdmin() {
		if ( msg.sender != admin && msg.sender != owner ) revert();
		_;
	}

	modifier onlyOwner() {
		if ( msg.sender != owner ) revert();
		_;
	}


	// Constructor
	function RegDocuments() {     
		price = 0.02 ether;  
		admin = msg.sender;        
		owner = msg.sender;
		version = "v0.2";
		storageAddress = 0xabc66b985ce66ba651f199555dd4236dbcd14daa; // Kovan
		// storageAddress = 0xb94cde73d07e0fcd7768cd0c7a8fb2afb403327a; // Rinkeby
		// storageAddress = 0x8f49722c61a9398a1c5f5ce6e5feeef852831a64; // Mainnet
		Storage = GlobalStorageMultiId(storageAddress);
	}


	// GlobalStorage functions
	// ----------------------------------------

	function getStoragePrice() onlyAdmin constant returns(uint) {
		return Storage.regPrice();
	}

	function registerDocs(bytes32 _storKey) onlyAdmin payable {
		// Register key with IntelligentStorage
		require(!registered); // It only does it one time
		uint _value = Storage.regPrice();
		storKey = _storKey;
		Storage.registerUser.value(_value)(_storKey);
		registered = true;
	}

	function upgradeDocs(address _newAddress) onlyAdmin {
		// This is to update token to a new address and transfer ownership of Storage to the new address
		UpgDocs newDocs = UpgDocs(_newAddress);
		require(newDocs.confirm(storKey));
		Storage.changeAddress(storKey,_newAddress);
		_newAddress.send(this.balance);
	}

	function confirm(bytes32 _storKey) returns(bool) {
		// This is called from older version, to register key for IntelligentStorage
		require(!registered);
		storKey = _storKey;
		registered = true;
		DocsUpgraded(msg.sender,this);
		return true;
	}

	function changePrice(uint _newPrice) onlyAdmin {
		price = _newPrice;
	}

	// Admin functions
	// -------------------------------------

	function changeOwner(address _newOwnerAddress) onlyOwner returns(bool){
		owner = _newOwnerAddress;
		return true;
	}

	function changeAdmin(address _newAdmin) onlyOwner returns(bool) {
		admin = _newAdmin;
		return true;
	}

	function sendToken(address _token,address _to , uint _value) onlyOwner returns(bool) {
		// To send ERC20 tokens sent accidentally
		ERC20Basic Token = ERC20Basic(_token);
		require(Token.transfer(_to, _value));
		return true;
	}


	// Main functions
	// -----------------------------------------------------

	function payService() payable returns(bool) {
		uint a = Storage.getUint(storKey,bytes32(msg.sender));
		if ( a > 0 ) {
			if ( msg.value > 0 ) {
				msg.sender.send(msg.value);
				}
			return true;
			}
		require(msg.value == price);
		Storage.setUint(storKey , bytes32(msg.sender) , msg.value , true);
		return true;
	}

	function getBalance(address _address) constant returns(uint) {
		return Storage.getUint(storKey,bytes32(msg.sender));
	}

	function regDoc(address _address, string _hash) onlyAdmin returns (bool success) {
		uint a = Storage.getUint(storKey , bytes32(_address));
		require(a>0);
		Storage.setUint(storKey , bytes32(_address) , 0 , true);
		owner.send(a);
		RegDocument(_address, _hash);
		return true;
		}

	function refund(address _address) onlyAdmin returns(bool success) {
		_address.send(Storage.getUint(storKey , bytes32(msg.sender)));
		Storage.setUint(storKey , bytes32(msg.sender) , 0 , true);
		return true;
	}

	function getPrice() constant returns(uint) {
		return price;
	}

}
