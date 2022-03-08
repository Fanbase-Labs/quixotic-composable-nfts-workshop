const { expect } = require('chai')
const { ethers, waffle } = require('hardhat')

describe('Potion Supplies', function () {
    it('Can be transferred to a potioneer', async () => {

        const GOLD = 0
        const OBSIDIAN = 1
        const FELDSPAR = 2
        const [potionsSupplySigner, potioneerSigner, potionSigner, playerSigner] = await ethers.getSigners()

        const PotionSuppliesContract = await ethers.getContractFactory('PotionSupplies')
        const potionSuppliesContract = await PotionSuppliesContract.connect(potionsSupplySigner).deploy()

        const PotioneerContract = await ethers.getContractFactory('Potioneer')
        const potioneerContract = await PotioneerContract.connect(potioneerSigner).deploy()

        const PotionContract = await ethers.getContractFactory('Potion')
        const potionContract = await PotionContract.connect(potionSigner).deploy()

        // Configure contracts correctly
        await potioneerContract.setPotionSuppliesContract(potionSuppliesContract.address)
        await potioneerContract.setPotionContract(potionContract.address)
        await potionContract.setPotioneerContract(potioneerContract.address)

        await expect(
            potioneerContract.connect(potioneerSigner).brewPotionOfStrength(1)
        ).to.be.revertedWith('You don\'t have enough gold to brew a potion of strength')

        console.log('<=== Inventory of Potioneer ===>')
        console.log('GOLD:    ', await potioneerContract.suppliesBalanceOfPotioneer(1, GOLD))
        console.log('OBSIDIAN:', await potioneerContract.suppliesBalanceOfPotioneer(1, OBSIDIAN))
        console.log('FELDSPAR:', await potioneerContract.suppliesBalanceOfPotioneer(1, FELDSPAR))
        console.log('<=== Inventory of Player (EOA) ===>')
        console.log('Potions of Strength: ', await potionContract.balanceOf(playerSigner.address))
        console.log("...")

        console.log('* Transfer Potioneer to Player *')
        await potioneerContract.connect(
            potioneerSigner
        )["safeTransferFrom(address,address,uint256)"](potioneerSigner.address, playerSigner.address, 1)

        console.log('* Transfer to Potioneer * ')
        const potioneerIdBytes32 = await ethers.utils.zeroPad('0x0001', 32)
        await potionSuppliesContract.connect(
            potionsSupplySigner
        ).safeTransferFrom(
            potionsSupplySigner.address, potioneerContract.address, GOLD, 100, potioneerIdBytes32
        )

        await potionSuppliesContract.connect(
            potionsSupplySigner
        ).safeTransferFrom(
            potionsSupplySigner.address, potioneerContract.address, OBSIDIAN, 100, potioneerIdBytes32
        )

        await potionSuppliesContract.connect(
            potionsSupplySigner
        ).safeTransferFrom(
            potionsSupplySigner.address, potioneerContract.address, FELDSPAR, 100, potioneerIdBytes32
        )

        console.log('<=== Inventory of Potioneer ===>')
        console.log('GOLD:    ', await potioneerContract.suppliesBalanceOfPotioneer(1, GOLD))
        console.log('OBSIDIAN:', await potioneerContract.suppliesBalanceOfPotioneer(1, OBSIDIAN))
        console.log('FELDSPAR:', await potioneerContract.suppliesBalanceOfPotioneer(1, FELDSPAR))
        console.log('<=== Inventory of Player (EOA) ===>')
        console.log('Potions of Strength: ', await potionContract.balanceOf(playerSigner.address))
        console.log("...")

        console.log('* Brew Potion * ')
        await potioneerContract.connect(playerSigner).brewPotionOfStrength(1)

        console.log('<=== Inventory of Potioneer ===>')
        console.log('GOLD:    ', await potioneerContract.suppliesBalanceOfPotioneer(1, GOLD))
        console.log('OBSIDIAN:', await potioneerContract.suppliesBalanceOfPotioneer(1, OBSIDIAN))
        console.log('FELDSPAR:', await potioneerContract.suppliesBalanceOfPotioneer(1, FELDSPAR))

        console.log('<=== Inventory of Player (EOA) ===>')
        console.log('Potions of Strength: ', await potionContract.balanceOf(playerSigner.address))

    })

})