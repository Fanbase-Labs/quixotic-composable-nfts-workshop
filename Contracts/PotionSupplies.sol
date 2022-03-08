pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PotionSupplies is ERC1155, Ownable {
    uint256 public constant GOLD = 0;
    uint256 public constant OBSIDIAN = 1;
    uint256 public constant FELDSPAR = 2;

    constructor () public ERC1155("https://game.example/api/item/{id}.json") {
        _mint(msg.sender, GOLD, 2000, "");
        _mint(msg.sender, OBSIDIAN, 800, "");
        _mint(msg.sender, FELDSPAR, 4000, "");
    }

    function name() public returns (string memory) {
        return "PotionSupplies";
    }

    function symbol() public returns (string memory) {
        return "POTION";
    }
}
