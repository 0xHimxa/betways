// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";







error FailedTo__BuyTicket_AmountNotEnough(string name );


contract BetApp is VRFConsumerBaseV2Plus{




uint256 private constant MINWORDS = 1;
uint256 private immutable TICKET_FEE;

address[] private players;
uint256 private immutable interval;
uint32 private immutable gaslane;
uint32 private immutable callbackgaslim;
uint256  private immutable subscriptionId;
uint256 private immutable lastTimeStamp;





 



constructor(

uint256 _interval,
address vrfcoordinator,
uint256 subId,
uint256 ticketPrice,
uint32 _gaslane,
uint32 _callbackgaslim




) VRFConsumerBaseV2Plus(vrfcoordinator){

    interval = _interval;
    subscriptionId = subId;
    TICKET_FEE = ticketPrice;
    gaslane = _gaslane;
    callbackgaslim = _callbackgaslim;
    lastTimeStamp = block.timestamp;


}





function buyTicket() external payable{

if(msg.value < TICKET_FEE){
revert FailedTo__BuyTicket_AmountNotEnough('increase money to buy ticket');


players.push(msg.sender);

}

}


function requestRandomWords() external{


bool performaction= players.length > 0 && address(this).balance > 0 && (block.timestamp - lastTimeStamp) > interval;

// if(performaction){




// }
}


function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override{}



}