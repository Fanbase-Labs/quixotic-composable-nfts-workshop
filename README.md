# The Potioneers (Composable NFTs)

## How it works
In this game, you have 3 items + players who are normal wallets ([EOAs](https://ethereum.stackexchange.com/questions/5828/what-is-an-eoa-account)])
- **Potioneers** (ERC721) - Avatar characters. They alone can brew potions. They can also own supplies.
  If a potioneer is transferred or sold by a player, it's potion supplies go with it.
- **Potion Supplies** (ERC1155) - Supplies used to brew potions
- **Potions** (ERC721) - Potions that can have special affects on potioneers. 
- **Players** (EOAs) - A player can own any of the above, but a player cannot brew a potion. The player must transfer 
potion supplies to a potioneer and have the potioneer brew the potion.
  
## Running this example
To run this example first install all the dependencies

```shell
yarn install
```

Then run the tests which do the following:
- Deploy the contracts. 
- Transfer Potioneer #1 to the player 
- Transfer some potion supplies to Potioneer #1
- Brew a potion of strength which is owned by the player

```shell
yarn test
```

All relevant code can be found in the following directories:

[Contracts/Potion.sol](./Contracts/Potion.sol)

[Contracts/Potioneer.sol](./Contracts/Potioneer.sol)

[Contracts/PotionSupplies.sol](./Contracts/PotionSupplies.sol)

[test/potion.js](./test/potions.js)