const { assert } = require("chai");

const DaiToken = artifacts.require("DaiToken");
const DappToken = artifacts.require("DappToken");
const TokenFarm = artifacts.require("TokenFarm");

require("chai")
    .use(require("chai-as-promised"))
    .should();
// Helper Function
function tokens(n) {
    return web3.utils.toWei(n, "ether");
}

contract("TokenFarm", ([owner, investor]) => {
    let daiToken, dappToken, tokenFarm;

    before(async() => {
        // Loading the Contracts
        daiToken = await DaiToken.new();
        dappToken = await DappToken.new();
        tokenFarm = await TokenFarm.new(dappToken.address, daiToken.address);
        // Transfer the all the Dapp Tokens to the Farms
        await dappToken.transfer(tokenFarm.address, tokens("1000000"));
        //Make Tokens go to investor
        await daiToken.transfer(investor, tokens("100"), { from: owner });
    });

    describe("Mock DAI deployment", async() => {
        it("has a name", async() => {
            const name = await daiToken.name();
            assert.equal(name, "Mock DAI Token");
        });
    });

    describe("Dapp Token deployment", async() => {
        it("has a name", async() => {
            const name = await dappToken.name();
            assert.equal(name, "DApp Token");
        });
    });

    describe("Token Farm deployment", async() => {
        it("has a name", async() => {
            const name = await tokenFarm.name();
            assert.equal(name, "Dapp Token Farm");
        });
    });

    it("contract has gotten the Tokens", async() => {
        let balance = await dappToken.balanceOf(tokenFarm.address);
        assert.equal(balance.toString(), tokens("1000000"));
    });

    describe("Farming Tokens", async() => {
        it("rewards investors for Staking mockDai Tokens", async() => {
            let results;
            // Check the investor balance for staking
            results = await daiToken.balanceOf(investor);
            assert.equal(
                results.toString(),
                tokens("100"),
                "Investor correct balance before staking"
            );
            // Stake MockDai tokens
            await daiToken.approve(tokenFarm.address, tokens("100"));
            await tokenFarm.stakeTokens(tokens("100"), { from: investor });

            // Check the investor balance after staking
            results = await tokenFarm.stakingBalance(investor);
            assert.equal(
                results.toString(),
                tokens("100"),
                "investor staking balance correct after staking"
            );

            results = await tokenFarm.isStaking(investor);
            assert.equal(
                results.toString(),
                "true",
                "investor staking status correct after staking"
            );

            results = await tokenFarm.stakingBalance(investor);
            assert.equal(
                results.toString(),
                tokens("100"),
                "investor staking balance is correct after staking"
            );
        });
    });
});