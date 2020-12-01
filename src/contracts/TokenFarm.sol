pragma solidity >=0.4.21 <0.6.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    address public owner;
    DappToken public dappToken;
    DaiToken public daiToken;

 
address[] public stakers; 
mapping(address => uint ) public stakingBalance;
mapping (address=> bool) public hasStaked; 
mapping (address=> bool) public isStaking; 


    constructor (DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }
    
    // 1. Stake the tokens  -- Deposit tokens 

    function stakeTokens (uint256 _ammount) public {
        // Make sure the staking amount is more than 0
        require(_ammount > 0, 'ammount being staked needs to be larger than 0'); // require is a method that allows the function to only work if the conditions are met
        
        // Transfer the mdai to this contract 
        daiToken.transferFrom(owner, address(this), _ammount);
        //update Staking Balance 
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _ammount;
        // Add users that staked to the array (only ones that havent already staked)
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // updates the status of the staking 
        hasStaked[msg.sender] = true; 
        isStaking[msg.sender] = true;  
    }

    //2. Unstake Tokens -- Withdraw Tokens 

    function unStakeTokens() public {
        uint balance = stakingBalance[msg.sender];
        require(balance > 0, 'ammount being staked needs to be larger than 0'); // require is a method that allows the function to only work if the conditions are met
        daiToken.transfer(msg.sender, balance);
        //reset the balance staked 
        stakingBalance[msg.sender] = 0;
        isStaking[msg.sender] = false; 


    }

    // 3. Issueing Tokens 
    function issueToken() public { // we want to loop through the array of people who have staked and reward them 
        require(msg.sender == owner, 'Must be contract owner for this method');
        
        for (uint i = 0; i < stakers.length; i++) {
            address stakerAddress = stakers[i];
            uint balance = stakingBalance[stakerAddress];
           
            if( balance > 0) {
            dappToken.transfer(stakerAddress, balance); // staker gets 1 : 1 Dapp tokens from which they deposited mockDai for 
            }
        }
    }
    //4. 
    
  
}
