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
kittycore = web3.eth.contract(...).at("0x6b2f86804f9464e9ab684edb7706b5ff5709f6ac");

kittyownership = web3.eth.contract(...).at("0x25cbcc6852397a25d32f5c543ef8347468d9d663");

kittybreeding = web3.eth.contract(...).at("0x4bb9ae4b88d91830e66b4a3d08add5be6a64997e");

saleAuction = web3.eth.contract(...).at("0x9851d10171a861142c96488896d9428fe0033cde");

siringAuction = web3.eth.contract(...).at("0x4ba0c2687a46dbbafeb73a930ff18eac47518e75");

ckToken = web3.eth.contract(...).at("0x12e239ae3b2ebd8ea26e1769b1bc62c1671345ff");

gene = web3.eth.contract(...).at("0x4b08d945a402823a0818067faa0041a6d6ca5167");

```

### 为不同合约之间的相互调用设置相应的合约地址：

#### kittycore

```
kittycore.setKittyOwnership.sendTransaction("0x25cbcc6852397a25d32f5c543ef8347468d9d663", {from:eth.accounts[0], gas:900000});

kittycore.setBreeding.sendTransaction(kittybreedingAddress, {from:eth.accounts[0], gas:900000});

kittycore.setSaleAuctionAddress.sendTransaction(saleAuctionAddress, {from:eth.accounts[0], gas:900000});

kittycore.setSiringAuctionAddress.sendTransaction(siringAuctionAddress, {from:eth.accounts[0], gas:900000});

```

#### kittyownership

```

kittyownership.setGeneScienceAddress.sendTransaction("0x4b08d945a402823a0818067faa0041a6d6ca5167", {from:eth.accounts[0], gas:900000});

kittyownership.setKittyCoreAddress.sendTransaction("0x0ce4607e0767ddc0c5f54dd371d61028ed4f0d81", {from:eth.accounts[0], gas:900000});

```

#### kittybreeding

```

kittybreeding.setGeneScienceAddress.sendTransaction(geneScienceAddress, {from:eth.accounts[0], gas:900000});

kittybreeding.setKittyOwnership.sendTransaction(kittyownershipAddress, {from:eth.accounts[0], gas:900000});

```

#### saleAuction

```
saleclockauction.setERC721Address.sendTransaction(kittyownershipAddress, {from:eth.accounts[0], gas:900000});

saleclockauction.setERC20Address.sendTransaction(ckTokenAddress, {from:eth.accounts[0], gas:900000});

```

#### siringAuction

```
siringclockauction.setERC721Address.sendTransaction(kittyownershipAddress, {from:eth.accounts[0], gas:900000});

siringclockauction.setERC20Address.sendTransaction(ckTokenAddress, {from:eth.accounts[0], gas:900000});

siringclockauction.setKittyBreedingAddress.sendTransaction(kittybreedingAddress, {from:eth.accounts[0], gas:900000});

```

#### ckToken

```

cktoken.setSaleAuctionAddress.sendTransaction(saleAuctionAddress, {from:eth.accounts[0], gas:900000});

cktoken.setSiringAuctionAddress.sendTransaction(siringAuctionAddress, {from:eth.accounts[0], gas:900000});

```



## 创建并赠送营销猫

```

genescience.getCoolDown(256);
kittyownership.setGeneScienceAddress.sendTransaction("0x81e88424fd42e414e1a2c959751537516d4bb836", {from:eth.accounts[0], gas:9000000});
kittyownership.testGene();
kittyownership.createKitty.sendTransaction(0, 0, 0, 256, 0, {from:eth.accounts[0], gas:9000000});
kittyownership.getKitty(0);

kittycore.setKittyOwnership.sendTransaction("0xede430c53047a83c3351b00a4454de719314cb32", {from:eth.accounts[0], gas:9000000});
kittycore.testKittyOwnership();

kittycore.createPromoKitty.sendTransaction(2222, eth.accounts[0], {from:eth.accounts[0], gas:9000000});
kittyownership.getHisFirstKitty(eth.accounts[0]);
kittyownership.transfer.sendTransaction(eth.accounts[1], 1, {from:eth.accounts[0], gas:9000000});
kittyownership.getHisFirstKitty(eth.accounts[1]);

```

## 创建并上架销售初代猫

```

kittycore.createGen0Kitty.sendTransaction(258, {from:eth.accounts[0], gas:9000000});
kittyownership.getKitty(2);
kittycore.createGen0SaleAuction.sendTransaction(2, {from:eth.accounts[0], gas:9000000});
saleclockauction.getAuction(2);

```

## 上架售卖流程

```

kittybreeding.setGeneScienceAddress.sendTransaction("0x95e12e95e30cccd40f3be76e4fd4b3104285da9f", {from:eth.accounts[0], gas:9000000});
kittybreeding.setKittyOwnership.sendTransaction("0xd455cb06768b64bb1741acb83af69166dcea56e5", {from:eth.accounts[0], gas:900000});
kittybreeding.isPregnant(1)

kittycore.setBreeding.sendTransaction("0x0de43ad61c0ee5d4ef0f7aa01261f23db1a77f85", {from:eth.accounts[0], gas:900000});
kittycore.createPromoKitty.sendTransaction(266, eth.accounts[0], {from:eth.accounts[0], gas:900000});

kittyownership.approveToSaleAuction.sendTransaction(1, {from:eth.accounts[0], gas:9000000});
kittycore.createSaleAuction.sendTransaction(1,2000,20,99999,  {from:eth.accounts[0], gas:9000000});
saleclockauction.getAuction(1);

```

## 下架售卖流程

```

saleclockauction.cancelAuction.sendTransaction(1, {from:eth.accounts[0], gas:9000000});
saleAuction.getAuction(1);

```

## 购买流程

```

saleAuction.bid.sendTransaction(2, 20000, {from:eth.accounts[0], gas:9000000});

```

## 上架配育服务流程

```

kittycore.createSiringAuction.sendTransaction(2,20000,20, 999999, {from:eth.accounts[0], gas:9000000});

siringAuction.getAuction(2);

```

## 下架配育服务流程

```

siringAuction.cancelAuction.sendTransaction(2, {from:eth.accounts[0], gas:9000000});

siringAuction.getAuction(2);

```

## 购买配育服务

```

kittycore.bidOnSiringAuction.sendTransaction(2, 1, 20000, {from:eth.accounts[0], gas:9000000});

kittyownership.getKitty(3);

```

# Test Logs

```
genescience = web3.eth.contract(...).at("0x4b08d945a402823a0818067faa0041a6d6ca5167");
kittyownership = web3.eth.contract(...).at("0x44c3dd246d11587dbb8acdbdcefddc2a2fda35e3");
kittycore = web3.eth.contract(...).at("0x0d7130fdbcfd4a8e1ec89e57cb255c51a3eb25e5");
saleclockauction = web3.eth.contract(...).at("0xf676df5d4a52d73ed1e1351e1691a64d4ef30b79");
kittybreeding = web3.eth.contract(...).at("0x6d6112758ec8f5e4637deb749b2ce468487b3043");
ckToken = web3.eth.contract(...).at("0xf458a25d3eb5e2d22bf37d4e02f1fd2257b13b06");

siringAuction = web3.eth.contract(...).at("0x4ba0c2687a46dbbafeb73a930ff18eac47518e75");


genescience.getCoolDown(256);
genescience.init_attribute.sendTransaction({from:eth.accounts[0], gas:9000000});
kittyownership.setGeneScienceAddress.sendTransaction("0x4b08d945a402823a0818067faa0041a6d6ca5167", {from:eth.accounts[0], gas:9000000});
kittyownership.testGene();
kittyownership.createKitty.sendTransaction(0, 0, 0, 256, 0, {from:eth.accounts[0], gas:9000000});
kittyownership.getKitty(0);

kittycore.setKittyOwnership.sendTransaction("0x44c3dd246d11587dbb8acdbdcefddc2a2fda35e3", {from:eth.accounts[0], gas:9000000});
kittycore.testKittyOwnership();
kittycore.getKittyOwnership();

kittycore.createPromoKitty.sendTransaction(256, eth.accounts[0], {from:eth.accounts[0], gas:900000});
kittyownership.getHisFirstKitty(eth.accounts[0]);
kittyownership.transfer.sendTransaction(eth.accounts[1], 1, {from:eth.accounts[0], gas:900000});
kittyownership.getHisFirstKitty(eth.accounts[1]);

kittyownership.setKittyCoreAddress.sendTransaction("0x0d7130fdbcfd4a8e1ec89e57cb255c51a3eb25e5", {from:eth.accounts[0], gas:9000000});
kittycore.setSaleAuctionAddress.sendTransaction("0xf676df5d4a52d73ed1e1351e1691a64d4ef30b79", {from:eth.accounts[0], gas:9000000});
kittyownership.setSaleAuctionAddress.sendTransaction("0xf676df5d4a52d73ed1e1351e1691a64d4ef30b79", {from:eth.accounts[0], gas:9000000});

saleclockauction.testAuction();
kittycore.testSaleAuction();
kittycore._computeNextGen0Price();
kittycore.testParam();
kittycore.testCreateAuction.sendTransaction(7, {from:eth.accounts[0], gas:9000000});

saleclockauction.setERC721Address.sendTransaction("0x44c3dd246d11587dbb8acdbdcefddc2a2fda35e3", {from:eth.accounts[0], gas:9000000});
saleclockauction.setKittyCoreAddress.sendTransaction("0x0d7130fdbcfd4a8e1ec89e57cb255c51a3eb25e5", {from:eth.accounts[0], gas:9000000});

saleclockauction.getAuction(0);
saleclockauction.isOnAuction(1);
saleclockauction.averageGen0SalePrice();

kittycore.createGen0Kitty.sendTransaction(258, {from:eth.accounts[0], gas:9000000});
kittyownership.getKitty(2);
kittycore.createGen0SaleAuction.sendTransaction(2, {from:eth.accounts[0], gas:9000000});
saleclockauction.getAuction(2);

kittybreeding.setGeneScienceAddress.sendTransaction("0x4b08d945a402823a0818067faa0041a6d6ca5167", {from:eth.accounts[0], gas:9000000});
kittybreeding.setKittyOwnership.sendTransaction("0x44c3dd246d11587dbb8acdbdcefddc2a2fda35e3", {from:eth.accounts[0], gas:900000});
kittybreeding.isPregnant(1)

kittycore.setBreeding.sendTransaction("0x6d6112758ec8f5e4637deb749b2ce468487b3043", {from:eth.accounts[0], gas:900000});
kittycore.createPromoKitty.sendTransaction(257, eth.accounts[0], {from:eth.accounts[0], gas:900000});

---------------------------------------------------------

kittycore.createPromoKitty.sendTransaction(258, eth.accounts[0], {from:eth.accounts[0], gas:900000});
kittyownership.getKitty(4);
kittyownership.approveToSaleAuction.sendTransaction(2, {from:eth.accounts[0], gas:9000000});
kittyownership._owns(eth.accounts[0], 2)
kittyownership.approveOf(2)

kittycore.createSaleAuction.sendTransaction(2,2000,20,99999,  {from:eth.accounts[0], gas:9000000});
saleclockauction.getAuction(2);

saleclockauction.cancelAuction.sendTransaction(1, {from:eth.accounts[0], gas:9000000});

cktoken.setSaleAuctionAddress.sendTransaction("0xf676df5d4a52d73ed1e1351e1691a64d4ef30b79", {from:eth.accounts[0], gas:9000000});
cktoken.transfer.sendTransaction(eth.accounts[1], 10000000, {from:eth.accounts[0], gas:9000000});
cktoken.balanceOf(eth.accounts[1]);

saleclockauction.setERC20Address.sendTransaction("0xf458a25d3eb5e2d22bf37d4e02f1fd2257b13b06", {from:eth.accounts[0], gas:9000000});
saleclockauction.bid.sendTransaction(2, 92000, {from:eth.accounts[1], gas:9000000});
saleclockauction.getAuction(2);


```