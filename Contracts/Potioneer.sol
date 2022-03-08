pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

interface IPotion {
    function mintPotionOfStrength(address potioneerOwner) external;
}

contract Potioneer is ERC721("Potioneer", "PTNR"), ERC1155Holder, Ownable {

    address potionSuppliesContract;
    address potionContract;
    address burnAddress = 0x000000000000000000000000000000000000dEaD;

    uint256 public constant GOLD = 0;
    uint256 public constant OBSIDIAN = 1;
    uint256 public constant FELDSPAR = 2;

    struct PotionSupply {
        uint256 tokenId;
        uint256 amount;
    }

    /*
    Look up the quantity for each amount here.
    For example this returns how much gold potineer 12 has: supplyAmountsForPotioneer[12][0]
    */
    mapping(uint256 => mapping(uint256 => uint256)) private supplyAmountsForPotioneer;

    constructor () public {
        _mint(msg.sender, 1);
        _mint(msg.sender, 2);
        _mint(msg.sender, 3);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC1155Receiver) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function onERC1155Received(address operator, address from, uint256 id, uint256 value, bytes memory data) public override returns (bytes4){
        uint256 potioneerId = bytesToUint(data);
        supplyAmountsForPotioneer[potioneerId][id] += value;
        return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"));
    }

    function setPotionSuppliesContract(address addr) public onlyOwner {
        potionSuppliesContract = addr;
    }

    function setPotionContract(address addr) public onlyOwner {
        potionContract = addr;
    }

    function suppliesBalanceOfPotioneer(uint256 potioneerId, uint256 suppliesId) public view returns (uint256){
        return supplyAmountsForPotioneer[potioneerId][suppliesId];
    }

    function brewPotionOfStrength(uint256 potioneerId) public {
        require(this.ownerOf(potioneerId) == _msgSender(), "You must own this potioneer to brew a potion");

        uint256 goldSupply = supplyAmountsForPotioneer[potioneerId][GOLD];
        uint256 obsidianSupply = supplyAmountsForPotioneer[potioneerId][OBSIDIAN];
        uint256 feldsparSupply = supplyAmountsForPotioneer[potioneerId][FELDSPAR];

        /*
        Checks
        */
        uint256 goldRequired = 10;
        uint256 obsidianRequired = 5;
        uint256 feldsparRequired = 15;
        require(goldSupply >= goldRequired, "You don't have enough gold to brew a potion of strength");
        require(obsidianSupply >= obsidianRequired, "You don't have enough obsidian to brew a potion of strength");
        require(feldsparSupply >= feldsparRequired, "You don't have enough feldspar to brew a potion of strength");

        /*
        Effects
        */
        supplyAmountsForPotioneer[potioneerId][GOLD] -= goldRequired;
        supplyAmountsForPotioneer[potioneerId][OBSIDIAN] -= obsidianRequired;
        supplyAmountsForPotioneer[potioneerId][FELDSPAR] -= feldsparRequired;

        /*
        Interactions
        */

        // Burn ingredients
        IERC1155 potionSupplies = IERC1155(potionSuppliesContract);

        uint256[] memory potionSupplyIds = new uint256[](3);
        potionSupplyIds[0] = GOLD;
        potionSupplyIds[1] = OBSIDIAN;
        potionSupplyIds[2] = FELDSPAR;

        uint256[] memory potionSupplyValues = new uint256[](3);
        potionSupplyValues[0] = goldRequired;
        potionSupplyValues[1] = obsidianRequired;
        potionSupplyValues[2] = feldsparRequired;
        potionSupplies.safeBatchTransferFrom(
            address(this),
            burnAddress,
            potionSupplyIds,
            potionSupplyValues,
            abi.encodePacked(potioneerId)
        );

        // Mint Potion
        IPotion potion = IPotion(potionContract);
        potion.mintPotionOfStrength(_msgSender());

    }


    function bytesToUint(bytes memory data) public returns (uint256) {
        require(data.length == 32, "slicing out of range");
        uint x;
        assembly {
            x := mload(add(data, 0x20))
        }
        return x;
    }

}
