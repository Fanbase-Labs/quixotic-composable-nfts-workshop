import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";


contract Potion is ERC721("Potion", "PTN"), ERC721Enumerable, Ownable {

    address public potioneerContract;

    function setPotioneerContract(address _potioneerContract) external {
        potioneerContract = _potioneerContract;
    }

    function mintPotionOfStrength(address potioneerOwner) external {
        require(potioneerContract == _msgSender(), "Only the Potioneer contract can call this function");
        uint supply = totalSupply();
        _safeMint(potioneerOwner, supply);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
}