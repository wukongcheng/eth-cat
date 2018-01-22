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


# Test Plan

> 以下测试步骤基于geth console环境进行

## 初始化

### 根据各个合约部署后的地址以及ABI创建各自的访问代理对象：

```
kittycore = web3.eth.contract(...).at("0xb9bc498e7711aca691c86db8a4369eb60949e922");

kittyownership = web3.eth.contract(...).at("0xb9bc498e7711aca691c86db8a4369eb60949e922");

kittybreeding = web3.eth.contract(...).at("0xb9bc498e7711aca691c86db8a4369eb60949e922");

saleAuction = web3.eth.contract(...).at("0xb9bc498e7711aca691c86db8a4369eb60949e922");

siringAuction = web3.eth.contract(...).at("0xcaaa498e7711aca691aca69a4369eb601aca69aa");

ckToken = web3.eth.contract(...).at("0xcafsfdsf69sdfdfdfdf369dsfcewrt434bdfg");

gene = web3.eth.contract(...).at("0xcerdvsdfa69sdfsdffdf369dsf3dt434bdfg");

```

### 为不同合约之间的相互调用设置相应的合约地址：

#### kittycore

```
kittycore.setKittyOwnership.sendTransaction(kittyownershipAddress, {from:eth.accounts[0], gas:900000});

kittycore.setBreeding.sendTransaction(kittybreedingAddress, {from:eth.accounts[0], gas:900000});

kittycore.setSaleAuctionAddress.sendTransaction(saleAuctionAddress, {from:eth.accounts[0], gas:900000});

kittycore.setSiringAuctionAddress.sendTransaction(siringAuctionAddress, {from:eth.accounts[0], gas:900000});

```

#### kittyownership

```

kittyownership.setGeneScienceAddress.sendTransaction(geneScienceAddress, {from:eth.accounts[0], gas:900000});

kittyownership.setKittyCoreAddress.sendTransaction(kittycoreAddress, {from:eth.accounts[0], gas:900000});

```

#### kittybreeding

```

kittybreeding.setGeneScienceAddress.sendTransaction(geneScienceAddress, {from:eth.accounts[0], gas:900000});

kittybreeding.setKittyOwnership.sendTransaction(kittyownershipAddress, {from:eth.accounts[0], gas:900000});

```

#### saleAuction

```
saleAuction.setERC721Address.sendTransaction(kittyownershipAddress, {from:eth.accounts[0], gas:900000});

saleAuction.setERC20Address.sendTransaction(ckTokenAddress, {from:eth.accounts[0], gas:900000});

```

#### siringAuction

```
siringAuction.setERC721Address.sendTransaction(kittyownershipAddress, {from:eth.accounts[0], gas:900000});

siringAuction.setERC20Address.sendTransaction(ckTokenAddress, {from:eth.accounts[0], gas:900000});

siringAuction.setKittyBreedingAddress.sendTransaction(kittybreedingAddress, {from:eth.accounts[0], gas:900000});

```

#### ckToken

```

ckToken.setSaleAuctionAddress.sendTransaction(saleAuctionAddress, {from:eth.accounts[0], gas:900000});

ckToken.setSiringAuctionAddress.sendTransaction(siringAuctionAddress, {from:eth.accounts[0], gas:900000});

```



## 创建并赠送营销猫

```

kittycore.createPromoKitty.sendTransaction(256, eth.accounts[0], {from:eth.accounts[0], gas:900000});

kittyownership.getHisFirstKitty(eth.accounts[0]);

kittyownership.transfer.sendTransaction(eth.accounts[1], 1, {from:eth.accounts[0], gas:900000});

```

## 创建并上架销售初代猫

```

kittycore.createGen0Auction.sendTransaction(256, {from:eth.accounts[0], gas:900000});

saleAuction.getAuction(1);

```

## 上架售卖流程

```

kittycore.createSaleAuction.sendTransaction(2,20000,20, 999999, {from:eth.accounts[0], gas:900000});

saleAuction.getAuction(2);

```

## 下架售卖流程

```

saleAuction.cancelAuction.sendTransaction(2, {from:eth.accounts[0], gas:900000});

saleAuction.getAuction(2);

```

## 购买流程

```

saleAuction.bid.sendTransaction(2, 20000, {from:eth.accounts[0], gas:900000});

```

## 上架配育服务流程

```

kittycore.createSiringAuction.sendTransaction(2,20000,20, 999999, {from:eth.accounts[0], gas:900000});

siringAuction.getAuction(2);

```

## 下架配育服务流程

```

siringAuction.cancelAuction.sendTransaction(2, {from:eth.accounts[0], gas:900000});

siringAuction.getAuction(2);

```

## 购买配育服务

```

kittycore.bidOnSiringAuction.sendTransaction(2, 1, 20000, {from:eth.accounts[0], gas:900000});

kittyownership.getKitty(3);

```
