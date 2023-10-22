# update local dependencies to the latest version [skip if already the latest]
cargo install --locked --git https://github.com/MystenLabs/sui.git --branch devnet sui

export ACCOUNT=0x4c213ea8e5093f567cb71f7594b95033c2ee671bc36b04c89486b5451fb6f8aa

# switch to ACCOUNT
sui client switch --address $ACCOUNT

# set GAS
sui client gas $ACCOUNT
export GAS=0x3affb8e056c95bb2d281491d7ce64f8eefa34f4970716f268da187bfca303273

# publish package
sui client publish ./ --gas $GAS --gas-budget 300000000

export PACKAGE=0xc17d3bb4d2852dab63bffda68ec9e27116e544e0790874a3725fc63ad6c12ed3
export GAS_BUDGET=10000000

export CERTIFIED_ISSUER_CAP=0x8fe30c4ed8f711046b8dc4dfd6f6690bdc0221b4e2b446b4c98c33175c3f814c
export UPGRAD_CAP=0x542347a990b8ecbc26b61ad90c460d8ae36e70da1ab1a3ba5a13f1958afeebe3

sui client call --function mint_wall --module wall --package $PACKAGE --args $CERTIFIED_ISSUER_CAP $ACCOUNT --gas-budget $GAS_BUDGET
sui client call --function mint_badge --module badge --package $PACKAGE --args $CERTIFIED_ISSUER_CAP 0x6 $ACCOUNT 120000 100 50 --gas-budget $GAS_BUDGET

export WALL=0x479f12c2285862508ad7f5158be4837649d05ed1a90f76f982f46c65df0713f0
export BADGE=0x5d97a230f0436ea7d621c0aad7a0f6bdc5063491ba6c0447fec90311dee1b644

sui client call --function equip_badge --module badge --package $PACKAGE --args $WALL $BADGE --gas-budget $GAS_BUDGET
