# 合约结构

### 合约实体及继承调用关系：

![](http://chuantu.biz/t6/207/1516087862x-1566657699.png)

总共5个合约文件，需要编译部署其中的CKToken、KittyCore、GeneScience、SaleClockAuction、SiringClockAuction。使用CEO的私钥账户部署合约，部署后记下各自的得到的合约地址。

### 如何部署：

使用[Remix - Solidity IDE](http://sol.51xnsd.com/#optimize=false&version=soljson-v0.4.19+commit.c4cbbb05.js)在线编译，将sol文件内容拷贝到文本框中，右侧compile tab页下选择所需编译的合约，点击“Details”, 在弹出的页面中拷贝“WEB3DEPLOY”里的内容。如：
```
var genescienceContract = web3.eth.contract([{"constant":true,"inputs":[{"name":"genes1","type":"uint256"},{"name":"genes2","type":"uint256"}],"name":"mixGenes","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ATTRIBUTE_NUM","outputs":[{"name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_startTime","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]);

var genescience = genescienceContract.new(
   {
     from: web3.eth.accounts[0], 
     data: '0x606060405234156200001057600080fd5b42600081905550602060405190810160405280602f60ff16815250600160008063ffffffff1681526020019081526020016000209060016200005492919062001e46565b50602060405190810...', 
     gas: '4700000'
   }, function (e, contract){
    console.log(e, contract);
    if (typeof contract.address !== 'undefined') {
         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
    }
 })

```

进入Geth 命令行，解锁账户，开启挖矿，部署合约。如：
```
geth --datadir "~/eth/cryptokitty" --verbosity "6" --networkid "345235" --ipcpath "~/eth/cryptokitty/geth.ipc" --rpc --rpcapi "db,eth,net,personal,web3" --port 4146 --rpcport 8101 --gasprice "0" --nodiscover console 2>> ~/eth/cryptokitty/01.log

personal.unlockAccount(eth.accounts[0])

miner.start(2);

```

部署合约即把上述“WEB3DEPLOY”的内容黏贴到console中并回车,部署成功后得到：

```

> null [object Object]
Contract mined! address: 0x25cbcc6852397a25d32f5c543ef8347468d9d663 transactionHash: 0x9c597cbe70adccee96e8492429347f25b7519a6a57a0f191f9f33a5f277ca075

```
