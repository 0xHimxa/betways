// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";


/**
 * @title bet app where u try your lock
 * @author Himxa
 * @notice 
 * Contract elements should be laid out in the following order:

Pragma statements

Import statements

Events

Errors

Interfaces

Libraries

Contracts

Inside each contract, library or interface, use the following order:

Type declarations

State variables

Events

Errors

Modifiers

Functions


 */




error FailedTo__BuyTicket_AmountNotEnough(string name );


contract BetApp is VRFConsumerBaseV2Plus{




uint256 private constant TICKET_FEE;
address[] private players;
uint256 private immutable interval;
uint32 private immutable gaslane;
uint32 private immutable callbackgaslim;
uint256  private immutable subscriptionId;



 



constructor(

uint256 _interval,
address vrfcoordinator,
uint256 subId,
uint256 ticketPrice,
uint32 gaslane,
uint32 callbackgaslim




) VRFConsumerBaseV2Plus(vrfcoordinator){

    interval = _interval;
    subscriptionId = subId;
    TICKET_FEE = ticketPrice;
    gaslane = gaslane;
    callbackgaslim = callbackgaslim;

}





function buyTicket() external payable{

if(msg.value < TICKET_FEE){
revert FailedTo__BuyTicket_AmountNotEnough();


players.push(msg.sender);

}



function requestRandomWords()external{





}




}


}