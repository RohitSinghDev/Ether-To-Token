// SPDX-License-Identifier: MIT

// 0xf8e81D47203A594245E36C48e151709F0C19fBe8

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";


contract EtherToTokenSwap {

    event TokensTransferred(address indexed recipient, uint amount);
    event sendMessage(string message);

    constructor() payable{

    }
    


    function swapEtherToToken(address token, uint minAmount) public payable returns (uint) {
        require(msg.value > 0, "Must send Ether to swap");
        ERC20 erc20 = ERC20(token);
        uint256 tokenAmount = (msg.value / getRate()); // Calculate token amount based on current rate
        // require(erc20.balanceOf(address(this)) >= tokenAmount, "Insufficient token balance in contract");
        

        // if the contract doesnt have suffcient amount of token balance, before transfering to the requesting person, it requests the erc20 
        //contract to gain suffcient funds and user is shown "low on funds for few minutes"
        if(erc20.balanceOf(address(this)) < tokenAmount){
            emit sendMessage("currently low on tokens, try again after sometime");
            
            uint temp = 1 ether;
            temp+= msg.value;
            payable(msg.sender).transfer(msg.value);
            (bool success2, ) = address(erc20).call{value: temp}(abi.encodeWithSignature("issueTokens()"));
            require(success2, "Call to receive tokens");
            
            return 0;

        }
        
        
        require(tokenAmount >= minAmount, "Token amount too low");

        bool success = erc20.transfer(msg.sender, tokenAmount);
        require(success, "Token transfer failed");
        emit TokensTransferred(msg.sender, tokenAmount);
        return tokenAmount;
    }

    function getRate() public pure returns (uint) {
        // Replace this with actual rate calculation function
        // price of 1 token = 1000 wei
        return 1000;
    }

    receive() external payable {
        // Do something with the received Ether
    }

    fallback() external payable {

       

    }
}
