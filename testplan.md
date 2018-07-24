
# Test Plan

> 以下测试步骤基于geth console环境进行

## 初始化

### 根据各个合约部署后的地址以及ABI创建各自的访问代理对象：

```
genescience = web3.eth.contract(...).at("0xede430c53047a83c3351b00a4454de719314cb32");
kittyownership = web3.eth.contract(...).at("0x81e88424fd42e414e1a2c959751537516d4bb836");   
kittycore = web3.eth.contract(...).at("0x602c663aa8a6cd84564b681f8fdfa8bd4c50c272");
saleclockauction = web3.eth.contract(...).at("0x44e826416769a61d0a5bfa21bc046cd3ef7644dd");
kittybreeding = web3.eth.contract(...).at("0x6d6112758ec8f5e4637deb749b2ce468487b3043");
ckToken = web3.eth.contract(...).at("0xf458a25d3eb5e2d22bf37d4e02f1fd2257b13b06");
siringclockauction = web3.eth.contract(...).at("0xb895e1b38b09603563d9a18a03ca3a8e6c0fd61b");



cktoken.setSaleAuctionAddress.sendTransaction("0x44e826416769a61d0a5bfa21bc046cd3ef7644dd", {from:eth.accounts[0], gas:900000});
cktoken.setSiringAuctionAddress.sendTransaction("0xb895e1b38b09603563d9a18a03ca3a8e6c0fd61b", {from:eth.accounts[0], gas:900000});

kittycore.setKittyOwnership.sendTransaction("0x81e88424fd42e414e1a2c959751537516d4bb836", {from:eth.accounts[0], gas:900000});
kittycore.setSaleAuctionAddress.sendTransaction("0x44e826416769a61d0a5bfa21bc046cd3ef7644dd", {from:eth.accounts[0], gas:900000});
kittycore.setBreeding.sendTransaction("0x25cbcc6852397a25d32f5c543ef8347468d9d663", {from:eth.accounts[0], gas:900000});
kittycore.setSiringAuctionAddress.sendTransaction("0xb895e1b38b09603563d9a18a03ca3a8e6c0fd61b", {from:eth.accounts[0], gas:900000});

kittyownership.setGeneScienceAddress.sendTransaction("0xede430c53047a83c3351b00a4454de719314cb32", {from:eth.accounts[0], gas:900000});
kittyownership.setKittyCoreAddress.sendTransaction("0x602c663aa8a6cd84564b681f8fdfa8bd4c50c272", {from:eth.accounts[0], gas:900000});
kittyownership.setSaleAuctionAddress.sendTransaction("0x44e826416769a61d0a5bfa21bc046cd3ef7644dd", {from:eth.accounts[0], gas:900000});
kittyownership.setSiringAuctionAddress.sendTransaction("0xb895e1b38b09603563d9a18a03ca3a8e6c0fd61b", {from:eth.accounts[0], gas:900000});

kittybreeding.setGeneScienceAddress.sendTransaction("0xede430c53047a83c3351b00a4454de719314cb32", {from:eth.accounts[0], gas:900000});
kittybreeding.setKittyOwnership.sendTransaction("0x81e88424fd42e414e1a2c959751537516d4bb836", {from:eth.accounts[0], gas:900000});

genescience.init_attribute.sendTransaction({from:eth.accounts[0], gas:4500000});
genescience.init_mixrule.sendTransaction({from:eth.accounts[0], gas:4500000});
genescience.init_rate.sendTransaction({from:eth.accounts[0], gas:4500000});
genescience.init_rate_distribution.sendTransaction({from:eth.accounts[0], gas:4500000});

genescience.fiveDValue(256, true, 16)

saleclockauction.setERC721Address.sendTransaction("0x81e88424fd42e414e1a2c959751537516d4bb836", {from:eth.accounts[0], gas:900000});
saleclockauction.setERC20Address.sendTransaction("0x12946f221be479162aec506dbccf8075bd331166", {from:eth.accounts[0], gas:900000});
saleclockauction.setKittyCoreAddress.sendTransaction("0x602c663aa8a6cd84564b681f8fdfa8bd4c50c272", {from:eth.accounts[0], gas:900000});

siringclockauction.setKittyCoreAddress.sendTransaction("0x602c663aa8a6cd84564b681f8fdfa8bd4c50c272",{from:eth.accounts[0], gas:900000});
siringclockauction.setERC721Address.sendTransaction("0x81e88424fd42e414e1a2c959751537516d4bb836",{from:eth.accounts[0], gas:900000});
siringclockauction.setERC20Address.sendTransaction("0x12946f221be479162aec506dbccf8075bd331166",{from:eth.accounts[0], gas:900000});
siringclockauction.setKittyBreedingAddress.sendTransaction("0x25cbcc6852397a25d32f5c543ef8347468d9d663",{from:eth.accounts[0], gas:900000});

```


## 创建并赠送营销猫

```

kittyownership.testGene();
kittycore.testKittyOwnership();
kittycore.getKittyOwnership();

kittycore.createPromoKitty.sendTransaction(256, eth.accounts[0], {from:eth.accounts[0], gas:900000});
kittyownership.getHisFirstKitty(eth.accounts[0]);
kittyownership.transfer.sendTransaction(eth.accounts[1], 0, {from:eth.accounts[0], gas:900000});
kittyownership.getHisFirstKitty(eth.accounts[1]);


```

## 创建并上架销售初代猫

```

kittycore.createGen0Kitty.sendTransaction(260, {from:eth.accounts[0], gas:9000000});
kittyownership.getKitty(1);
kittycore.createGen0SaleAuction.sendTransaction(5, {from:eth.accounts[0], gas:9000000});
saleclockauction.getAuction(5);

```

## 上架售卖流程

```

saleclockauction.getAuction(4);
saleclockauction.isOnAuction(0);
kittycore.testSaleAuction();
kittybreeding.isPregnant(0);
kittyownership.ownerOf(0);


kittycore.createPromoKitty.sendTransaction(262, eth.accounts[0], {from:eth.accounts[0], gas:900000});
kittyownership.approveToSaleAuction.sendTransaction(7, {from:eth.accounts[0], gas:9000000});
kittyownership.approveOf(7);
kittycore.createSaleAuction.sendTransaction(7,2000,20,99999,  {from:eth.accounts[0], gas:9000000});
saleclockauction.getAuction(7);

```

## 下架售卖流程

```

saleclockauction.cancelAuction.sendTransaction(6, {from:eth.accounts[0], gas:9000000});
saleclockauction.getAuction(6);

```

## 购买流程

```

cktoken.transfer.sendTransaction(eth.accounts[1], 10000000, {from:eth.accounts[0], gas:9000000});
cktoken.balanceOf(eth.accounts[1]);
personal.unlockAccount(eth.accounts[1])
saleclockauction.bid.sendTransaction(7, 92000, {from:eth.accounts[1], gas:9000000});
saleclockauction.getAuction(7);
kittyownership.ownerOf(7);

```

## 上架配育服务流程

```

kittyownership.ownerOf(6);
kittyownership.approveToSiringAuction.sendTransaction(6, {from:eth.accounts[0], gas:900000});
kittyownership.approveOf(6)

kittycore.createSiringAuction.sendTransaction(6,2000,20,99999,{from:eth.accounts[0], gas:900000});
siringclockauction.getAuction(6)

```

## 下架配育服务流程

```

siringclockauction.cancelAuction.sendTransaction(6, {from:eth.accounts[0], gas:9000000});
siringclockauction.getAuction(6);

```

## 购买配育服务

```

personal.unlockAccount(eth.accounts[1])
kittyownership.approveToSiringAuction.sendTransaction(7, {from:eth.accounts[1], gas:900000});
kittyownership.approveOf(7)
cktoken.transfer.sendTransaction(eth.accounts[1], 1000000, {from:eth.accounts[0], gas:900000});

siringclockauction.bid.sendTransaction(6,7, 2000, {from:eth.accounts[1], gas:900000});
siringclockauction.isOnAuction(6);
kittyownership.getSireAllowedTo(6);
siringclockauction.breed.sendTransaction(6,{from:eth.accounts[1], gas:900000});
kittyownership.getKitty(7);

siringclockauction.giveBirth.sendTransaction(3,{from:eth.accounts[1], gas:900000});

```

# Test Logs

```
**Start to test, add by liuhaoyang**


cktokenAddress = 0xdb90f4d1d43128433eba6e74c0a8099830349f82
kittycoreAddress = 0x2a5bcfe73a626b41ead4de61501e6aac1d0f589a
kittyownershipAddress = 0xc4daf7c37e7192c22801ca19488abbec4933fcf8
kittybreedingAddress = 0x4fb73dd69db5966e835c325aa2ce496e8eb861ae
genescienceAddress = 0xd73a02b84fb5a4f03f874575e8c719a62862a3cb
saleclockauctionAddress = 0x53cf83084c3f1b276be3a218f07fc2cb88b0553f
siringAuctionAddress = 0x2ea07ff7e328378a6d5444691510ba4d7ff2d7f5

cktoken = web3.eth.contract([{"constant":false,"inputs":[{"name":"guy","type":"address"},{"name":"wad","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setSiringAuctionAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"src","type":"address"},{"name":"dst","type":"address"},{"name":"wad","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setSaleAuctionAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"src","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getCFO","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"dst","type":"address"},{"name":"wad","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"bidder","type":"address"},{"name":"seller","type":"address"},{"name":"price","type":"uint256"},{"name":"fee","type":"uint256"}],"name":"transferByAuction","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"src","type":"address"},{"name":"guy","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"supply","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"}]).at("0xdb90f4d1d43128433eba6e74c0a8099830349f82");
kittycore = web3.eth.contract([{"constant":true,"inputs":[],"name":"cfoAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"promoCreatedCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ceoAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_kittyId","type":"uint256"}],"name":"createGen0SaleAuction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"GEN0_STARTING_PRICE","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setSiringAuctionAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"GEN0_AUCTION_DURATION","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"siringAuction","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newCEO","type":"address"}],"name":"setCEO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setBreeding","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"kittyOwnership","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newCOO","type":"address"}],"name":"setCOO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setKittyOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_kittyId","type":"uint256"},{"name":"_startingPrice","type":"uint256"},{"name":"_endingPrice","type":"uint256"},{"name":"_duration","type":"uint256"}],"name":"createSaleAuction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"unpause","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"testSaleAuction","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_kittyId","type":"uint256"},{"name":"_startingPrice","type":"uint256"},{"name":"_endingPrice","type":"uint256"},{"name":"_duration","type":"uint256"}],"name":"createSiringAuction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_genes","type":"uint256"}],"name":"createGen0Kitty","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_newCFO","type":"address"}],"name":"setCFO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"testKittyOwnership","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_genes","type":"uint256"},{"name":"_owner","type":"address"}],"name":"createPromoKitty","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"paused","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"GEN0_CREATION_LIMIT","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setSaleAuctionAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"kittyBreeding","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"pause","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"kittyId","type":"uint256"}],"name":"testCreateAuction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"cooAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getKittyOwnership","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"PROMO_CREATION_LIMIT","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"testParam","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"saleAuction","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"gen0CreatedCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"newContract","type":"address"}],"name":"ContractUpgrade","type":"event"}]).at("0x2a5bcfe73a626b41ead4de61501e6aac1d0f589a");
kittyownership = web3.eth.contract([{"constant":true,"inputs":[],"name":"cfoAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"approve","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"ceoAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setSiringAuctionAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"siringAuction","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"transferFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setGeneScienceAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_newCEO","type":"address"}],"name":"setCEO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"breeding","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"approveToSaleAuction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"},{"name":"_blocknum","type":"uint64"}],"name":"setCooldownEndBlock","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_newCOO","type":"address"}],"name":"setCOO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"testGene","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"unpause","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"sireAllowedToAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"kittyIndexToApproved","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newCFO","type":"address"}],"name":"setCFO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_claimant","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"_approvedFor","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"},{"name":"_breedTimes","type":"uint16"}],"name":"setBreedTimes","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_matronId","type":"uint256"},{"name":"_sireId","type":"uint256"},{"name":"_generation","type":"uint256"},{"name":"_genes","type":"uint256"},{"name":"_owner","type":"address"},{"name":"_gen0","type":"bool"}],"name":"createKitty","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"paused","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"ownerOf","outputs":[{"name":"owner","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setSaleAuctionAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"count","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setKittyCoreAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"deleteSireAllowedTo","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"pause","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"tokensOfOwner","outputs":[{"name":"ownerTokens","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"account","type":"address"}],"name":"getHisFirstKitty","outputs":[{"name":"tokenId","type":"uint256"},{"name":"isGestating","type":"bool"},{"name":"isReady","type":"bool"},{"name":"cooldownIndex","type":"uint256"},{"name":"nextActionAt","type":"uint256"},{"name":"siringWithId","type":"uint256"},{"name":"birthTime","type":"uint256"},{"name":"matronId","type":"uint256"},{"name":"sireId","type":"uint256"},{"name":"generation","type":"uint256"},{"name":"genes","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"getSireAllowedTo","outputs":[{"name":"allowed","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"kittyIndexToOwner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"transfer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"deleteSiringWithId","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"cooAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_genes","type":"uint256"},{"name":"_owner","type":"address"}],"name":"createGen0Kitty","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"approveToSiringAuction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"isReadyToBreed","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"getKitty5DValue","outputs":[{"name":"character","type":"uint256"},{"name":"speed","type":"uint256"},{"name":"iq","type":"uint256"},{"name":"physical","type":"uint256"},{"name":"skill","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_claimant","type":"address"},{"name":"_tokenId","type":"uint256"}],"name":"_owns","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setBreedingAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"saleAuction","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"getKitty","outputs":[{"name":"genes","type":"uint256"},{"name":"birthTime","type":"uint256"},{"name":"cooldownEndBlock","type":"uint256"},{"name":"matronId","type":"uint256"},{"name":"sireId","type":"uint256"},{"name":"siringWithId","type":"uint256"},{"name":"cooldownIndex","type":"uint256"},{"name":"generation","type":"uint256"},{"name":"breedTimes","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"geneScience","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"kittycore","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"},{"name":"_siringWithId","type":"uint32"}],"name":"setSiringWithId","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"},{"name":"_address","type":"address"}],"name":"setSireAllowedTo","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"approveOf","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"owner","type":"address"},{"indexed":false,"name":"approved","type":"address"},{"indexed":false,"name":"tokenId","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"owner","type":"address"},{"indexed":false,"name":"kittyId","type":"uint256"},{"indexed":false,"name":"matronId","type":"uint256"},{"indexed":false,"name":"sireId","type":"uint256"},{"indexed":false,"name":"genes","type":"uint256"}],"name":"Birth","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"from","type":"address"},{"indexed":false,"name":"to","type":"address"},{"indexed":false,"name":"tokenId","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"newContract","type":"address"}],"name":"ContractUpgrade","type":"event"}]).at("0xc4daf7c37e7192c22801ca19488abbec4933fcf8");
kittybreeding = web3.eth.contract([{"constant":true,"inputs":[],"name":"cfoAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ceoAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_matronId","type":"uint256"},{"name":"_sireId","type":"uint256"}],"name":"giveBirthBySelf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"pregnantKitties","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_kittyId","type":"uint256"}],"name":"isPregnant","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setGeneScienceAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"siringaction","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_matronId","type":"uint256"},{"name":"_sireId","type":"uint256"},{"name":"_owner","type":"address"}],"name":"giveBirthByAuction","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_newCEO","type":"address"}],"name":"setCEO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"kittyOwnership","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newCOO","type":"address"}],"name":"setCOO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setKittyOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"unpause","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_matronId","type":"uint256"},{"name":"_sireId","type":"uint256"}],"name":"canBreedWith","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_sireId","type":"uint256"}],"name":"approveSiring","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_newCFO","type":"address"}],"name":"setCFO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"paused","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_matronId","type":"uint256"},{"name":"_sireId","type":"uint256"}],"name":"breedSelfKitty","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_matronId","type":"uint256"},{"name":"_sireId","type":"uint256"}],"name":"_canBreedWithViaAuction","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"secondsPerBlock","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"pause","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setSiringAction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"cooldowns","outputs":[{"name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"cooAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"geneScience","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_matronId","type":"uint256"},{"name":"_sireId","type":"uint256"}],"name":"breedWithAuto","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"owner","type":"address"},{"indexed":false,"name":"matronId","type":"uint256"},{"indexed":false,"name":"sireId","type":"uint256"},{"indexed":false,"name":"cooldownEndBlock","type":"uint256"}],"name":"Pregnant","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"newContract","type":"address"}],"name":"ContractUpgrade","type":"event"}]).at("0x4fb73dd69db5966e835c325aa2ce496e8eb861ae");
genescience = web3.eth.contract([{"constant":false,"inputs":[],"name":"init_attribute","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"genes","type":"uint256"},{"name":"gen0","type":"bool"},{"name":"attID","type":"uint8"}],"name":"fiveDValue","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"genes","type":"uint256"}],"name":"getCoolDown","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"genes1","type":"uint256"},{"name":"genes2","type":"uint256"}],"name":"mixGenes","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"init_rate_distribution","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"ATTRIBUTE_NUM","outputs":[{"name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"init_rate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"init_mixrule","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"_startTime","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]).at("0xd73a02b84fb5a4f03f874575e8c719a62862a3cb");
saleclockauction = web3.eth.contract([{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"},{"name":"_startingPrice","type":"uint256"},{"name":"_endingPrice","type":"uint256"},{"name":"_duration","type":"uint256"},{"name":"_seller","type":"address"}],"name":"createAuction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"kittyOwnership","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"isOnAuction","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_erc20Address","type":"address"}],"name":"setERC20Address","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"niuTokenContract","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"lastGen0SalePrices","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"},{"name":"_price","type":"uint256"}],"name":"bid","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"testAuction","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"pure","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setKittyCoreAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"getAuction","outputs":[{"name":"seller","type":"address"},{"name":"startingPrice","type":"uint256"},{"name":"endingPrice","type":"uint256"},{"name":"duration","type":"uint256"},{"name":"startedAt","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"gen0SaleCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"cancelAuction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_nftAddress","type":"address"}],"name":"setERC721Address","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"getCurrentPrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"nonFungibleContract","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"averageGen0SalePrice","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"kittycore","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"tokenId","type":"uint256"},{"indexed":false,"name":"startingPrice","type":"uint256"},{"indexed":false,"name":"endingPrice","type":"uint256"},{"indexed":false,"name":"duration","type":"uint256"}],"name":"AuctionCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"tokenId","type":"uint256"},{"indexed":false,"name":"totalPrice","type":"uint256"},{"indexed":false,"name":"winner","type":"address"}],"name":"AuctionSuccessful","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"tokenId","type":"uint256"}],"name":"AuctionCancelled","type":"event"}]).at("0x53cf83084c3f1b276be3a218f07fc2cb88b0553f");
siringAuction = web3.eth.contract([{"constant":true,"inputs":[],"name":"cfoAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_sireId","type":"uint256"}],"name":"getAuctionWinner","outputs":[{"name":"seller","type":"address"},{"name":"winner","type":"address"},{"name":"matronId","type":"uint256"},{"name":"price","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"ceoAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setKittyBreedingAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_newCEO","type":"address"}],"name":"setCEO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"},{"name":"_startingPrice","type":"uint256"},{"name":"_endingPrice","type":"uint256"},{"name":"_duration","type":"uint256"},{"name":"_seller","type":"address"}],"name":"createAuction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_sireId","type":"uint256"},{"name":"_matronId","type":"uint256"},{"name":"_price","type":"uint256"}],"name":"bid","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"kittyOwnership","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newCOO","type":"address"}],"name":"setCOO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"isOnAuction","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"unpause","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_erc20Address","type":"address"}],"name":"setERC20Address","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"niuTokenContract","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newCFO","type":"address"}],"name":"setCFO","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"paused","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"isSiringClockAuction","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"kittyBreeding","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"}],"name":"setKittyCoreAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"getAuction","outputs":[{"name":"seller","type":"address"},{"name":"startingPrice","type":"uint256"},{"name":"endingPrice","type":"uint256"},{"name":"duration","type":"uint256"},{"name":"startedAt","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"pause","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_sireId","type":"uint256"}],"name":"giveBirth","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_tokenId","type":"uint256"}],"name":"cancelAuction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_nftAddress","type":"address"}],"name":"setERC721Address","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_sireId","type":"uint256"}],"name":"breed","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"cooAddress","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"nonFungibleContract","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"kittycore","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"tokenId","type":"uint256"},{"indexed":false,"name":"startingPrice","type":"uint256"},{"indexed":false,"name":"endingPrice","type":"uint256"},{"indexed":false,"name":"duration","type":"uint256"}],"name":"AuctionCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"tokenId","type":"uint256"},{"indexed":false,"name":"totalPrice","type":"uint256"},{"indexed":false,"name":"winner","type":"address"}],"name":"AuctionSuccessful","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"tokenId","type":"uint256"}],"name":"AuctionCancelled","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"newContract","type":"address"}],"name":"ContractUpgrade","type":"event"}]).at("0x2ea07ff7e328378a6d5444691510ba4d7ff2d7f5");

cktoken.setSaleAuctionAddress.sendTransaction("0x53cf83084c3f1b276be3a218f07fc2cb88b0553f", {from:eth.accounts[0], gas:900000});
cktoken.setSiringAuctionAddress.sendTransaction("0x2ea07ff7e328378a6d5444691510ba4d7ff2d7f5", {from:eth.accounts[0], gas:900000});

kittycore.setKittyOwnership.sendTransaction("0xc4daf7c37e7192c22801ca19488abbec4933fcf8", {from:eth.accounts[0], gas:900000});
kittycore.setSaleAuctionAddress.sendTransaction("0x53cf83084c3f1b276be3a218f07fc2cb88b0553f", {from:eth.accounts[0], gas:900000});
kittycore.setBreeding.sendTransaction("0x4fb73dd69db5966e835c325aa2ce496e8eb861ae", {from:eth.accounts[0], gas:900000});
kittycore.setSiringAuctionAddress.sendTransaction("0x2ea07ff7e328378a6d5444691510ba4d7ff2d7f5", {from:eth.accounts[0], gas:900000});

kittyownership.setGeneScienceAddress.sendTransaction("0xd73a02b84fb5a4f03f874575e8c719a62862a3cb", {from:eth.accounts[0], gas:900000});
kittyownership.setKittyCoreAddress.sendTransaction("0x2a5bcfe73a626b41ead4de61501e6aac1d0f589a", {from:eth.accounts[0], gas:900000});
kittyownership.setSaleAuctionAddress.sendTransaction("0x53cf83084c3f1b276be3a218f07fc2cb88b0553f", {from:eth.accounts[0], gas:900000});
kittyownership.setSiringAuctionAddress.sendTransaction("0x2ea07ff7e328378a6d5444691510ba4d7ff2d7f5", {from:eth.accounts[0], gas:900000});
kittyownership.setBreedingAddress.sendTransaction("0x4fb73dd69db5966e835c325aa2ce496e8eb861ae",{from:eth.accounts[0], gas:900000})

kittybreeding.setGeneScienceAddress.sendTransaction("0xd73a02b84fb5a4f03f874575e8c719a62862a3cb", {from:eth.accounts[0], gas:900000});
kittybreeding.setKittyOwnership.sendTransaction("0xc4daf7c37e7192c22801ca19488abbec4933fcf8", {from:eth.accounts[0], gas:900000});
kittybreeding.setSiringAction.sendTransaction("0x2ea07ff7e328378a6d5444691510ba4d7ff2d7f5", {from:eth.accounts[0], gas:900000});

genescience.init_attribute.sendTransaction({from:eth.accounts[0], gas:4700000});
genescience.init_mixrule.sendTransaction({from:eth.accounts[0], gas:4700000});
genescience.init_rate.sendTransaction({from:eth.accounts[0], gas:4700000});
genescience.init_rate_distribution.sendTransaction({from:eth.accounts[0], gas:4700000});

saleclockauction.setERC721Address.sendTransaction("0xc4daf7c37e7192c22801ca19488abbec4933fcf8", {from:eth.accounts[0], gas:900000});
saleclockauction.setERC20Address.sendTransaction("0xdb90f4d1d43128433eba6e74c0a8099830349f82", {from:eth.accounts[0], gas:900000});
saleclockauction.setKittyCoreAddress.sendTransaction("0x2a5bcfe73a626b41ead4de61501e6aac1d0f589a", {from:eth.accounts[0], gas:900000});

siringAuction.setKittyCoreAddress.sendTransaction("0x2a5bcfe73a626b41ead4de61501e6aac1d0f589a",{from:eth.accounts[0], gas:900000});
siringAuction.setERC721Address.sendTransaction("0xc4daf7c37e7192c22801ca19488abbec4933fcf8",{from:eth.accounts[0], gas:900000});
siringAuction.setERC20Address.sendTransaction("0xdb90f4d1d43128433eba6e74c0a8099830349f82",{from:eth.accounts[0], gas:900000});
siringAuction.setKittyBreedingAddress.sendTransaction("0x4fb73dd69db5966e835c325aa2ce496e8eb861ae",{from:eth.accounts[0], gas:900000});

cktoken.transfer.sendTransaction(eth.accounts[1], 1000000, {from:eth.accounts[0], gas:900000});

kittycore.createGen0Kitty.sendTransaction(251, {from:eth.accounts[0], gas:900000});
kittycore.createGen0Kitty.sendTransaction(252, {from:eth.accounts[0], gas:900000});
kittycore.createGen0Kitty.sendTransaction(253, {from:eth.accounts[0], gas:900000});
kittycore.createGen0Kitty.sendTransaction(254, {from:eth.accounts[0], gas:900000});
kittycore.createGen0Kitty.sendTransaction(255, {from:eth.accounts[0], gas:900000});
kittycore.createGen0Kitty.sendTransaction(256, {from:eth.accounts[0], gas:900000});

kittyownership.approveOf(0)
kittyownership.approveOf(1)
kittyownership.approveOf(2)
kittyownership.approveOf(3)
kittyownership.approveOf(4)
kittyownership.approveOf(5)
kittyownership.approveOf(6)

kittycore.createGen0SaleAuction.sendTransaction(0, {from:eth.accounts[0], gas:900000});
saleclockauction.isOnAuction(0)

saleclockauction.bid.sendTransaction(0,2000, {from:eth.accounts[1], gas:900000});
kittyownership._owns(eth.accounts[1],0)

kittyownership.transfer.sendTransaction(eth.accounts[1], 2, {from:eth.accounts[0], gas:900000});

kittyownership.approveToSiringAuction.sendTransaction(1, {from:eth.accounts[0], gas:900000});
kittyownership.approveOf(1)

kittyownership.approveToSiringAuction.sendTransaction(2, {from:eth.accounts[1], gas:900000});
kittyownership.approveOf(2)

kittycore.createSiringAuction.sendTransaction(1,2000,20,99999,{from:eth.accounts[0], gas:900000});
siringAuction.isOnAuction(1)

siringAuction.bid.sendTransaction(1,2, 2000, {from:eth.accounts[1], gas:900000});

siringAuction.breed.sendTransaction(1,{from:eth.accounts[1], gas:900000});

siringAuction.giveBirth.sendTransaction(1,{from:eth.accounts[1], gas:900000});

kittybreeding.breedSelfKitty.sendTransaction(3,4,{from:eth.accounts[0], gas:900000})
kittyBreeding.isPregnant(3)

kittybreeding.giveBirthBySelf.sendTransaction(3,4,{from:eth.accounts[0], gas:900000})
kittyBreeding.isPregnant(3)

**End of test, add by liuhaoyang**

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