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


    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }
    
    // 1. Stake the tokens  -- Deposit tokens 

    function stakeTokens (uint256 _ammount) public {
        // Transfer the mdai to this contract 
        daiToken.transferFrom(owner, address(this), _ammount);
        //update Staking Balance 
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _ammount;
        // Add users that staked to the array (only ones that havent already staked)
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        hasStaked[msg.sender] = true; 
        isStaking[msg.sender] = true;  
    }

    //2/. Unstake Tokens -- Withdraw Tokens 

    // 3. Issueing Tokens 

    //4. 
    
  
}
