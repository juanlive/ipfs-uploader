# ipfs-uploader

IPFS Document System

Address del contrato en Kovan:
0x8466a631fa00c781ec22e8559941ce91fe9133e7

Admin / Owner:
0xfb509f6900d0326520c8f88e8f12c83459a199ec
PK: 8acf6e57ba0d5b9421ebc3fe701210e6a5fdbf07dc886de9c2dcc5faf4ffc3ad

Admin y owner tienen los mismos derechos de uso. 
Owner recibirá los pagos enviados por los usuarios.


ABI al final.

Este contrato es utilizado en conjunto por una dApp que envía los documentos a la red IPFS.
Implementa el sistema Intelligent Storage para almacenamiento de balances.


Main functions

getPrice()
Devuelve el precio a pagar por cada documento a subir. Este valor puede ser mostrado en pantalla al cargar la página.

payService()
Función a llamar para pagar por el servicio. 
Debe ser acompañada del valor indicado por getPrice()
Puede ser llamada luego de soltar el documento en drop area, y antes de subirlo (luego de presionar el botón upload).
La tx debe ser firmada por el usuario (a través de su MetaMask).
El pago irá dirigido a admin, que podrá usar parte de ese pago para pagar el gas de la siguiente transacción (regDoc).
Si ya existe un pago anterior que no fue procesado, el contrato le devolverá al cliente el monto sobrante.
La función devuelve “true” si el pago fue aceptado o si ya existía un pago sin procesar.

regDoc(address _address , string _hash)
Función a llamar luego de subir el documento.
_address es la address del cliente. _hash es el hash devuelto por IPFS.
La tx debe ser firmada por el admin (a través de Infura).



Solidity events

RegDocument(_address, _hash)
Por cada documento registrado con regDoc(), se creará el correspondiente evento.



Extra functions

getBalance(address)
Devuelve cantidad depositada por esa address.

refund(address)
Reenvía dinero depositado que no fue utilizado por el usuario. Debe ser llamado por “admin”.

changePrice(uint)
Change price of the service.



Administrative functions (onlyAdmin)

changeOwner(address)
Change owner address

changeAdmin(address)
Change admin address.

sendToken(address _token,address _to, uint _value)
Send any token accidentally sent to the contract.



Upgrade functions

To replace actual contract for a new version that continues using the same storage.

upgradeDocs(address)
The address should contain a deployed contract of a new version with the function “confirm” to accept the key to manage storage.



Initializing functions

Once deployed for first time, the contract can be manually initialized, or initialized through a upgradeDocs from the previous contract version. Initialization consists in a registration at Intelligent Storage. The manual initialization is as follows:

getStoragePrice()
Retrieves the amount to pay in uints for the registration service at Intelligent Storage

registerDocs(bytes32 _storKey)
This function should be called from admin or owner. It should contain the value retrieved with the previous function. _storKey can be any bytes32 value that has been never used at Intelligent Storage. It could be created from a string with a unique value.



ABI: 

[{"constant":true,"inputs":[],"name":"getStoragePrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_token","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"sendToken","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_newAddress","type":"address"}],"name":"upgradeDocs","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"payService","outputs":[{"name":"","type":"bool"}],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[],"name":"version","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"storKey","outputs":[{"name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"},{"name":"_hash","type":"string"}],"name":"regDoc","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_storKey","type":"bytes32"}],"name":"registerDocs","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[{"name":"_storKey","type":"bytes32"}],"name":"confirm","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newAdmin","type":"address"}],"name":"changeAdmin","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"price","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newPrice","type":"uint256"}],"name":"changePrice","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_newOwnerAddress","type":"address"}],"name":"changeOwner","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"Storage","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"admin","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_address","type":"address"}],"name":"getBalance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"refund","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":false,"name":"hash","type":"string"}],"name":"RegDocument","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"_oldAddress","type":"address"},{"indexed":false,"name":"_newAddress","type":"address"}],"name":"DocsUpgraded","type":"event"}]


