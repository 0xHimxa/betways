// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Test} from 'forge-std/Test.sol';

import {DeployBetApp} from 'script/Deploy-Bet.s.sol';
 import {HelperConfig} from 'script/helperConfig.s.sol';
import {BetApp} from 'src/betapp.sol';




contract TestDeployBetApp is Test{

event NewPlayerBuyTicket(address indexed player);



HelperConfig helperConfig;
BetApp betApp;

uint256 constant interval = 30;
uint256 constant ticketPrice = 0.01 ether;
address  player = makeAddr('Player');
uint256 constant newBalance = 100 ether;



function setUp()external{

DeployBetApp deployBetApp = new DeployBetApp();
(helperConfig, betApp) = deployBetApp.run();
vm.deal(player, newBalance);



}


function testInterval() external view{
 assert(betApp.getInterval() == interval); 
}

function testTicketFee() external view{


  assert(betApp.getTicketFee() == ticketPrice); 
}


function testBuyTicketSucceed() external {
vm.prank(player);

betApp.buyTicket{value: ticketPrice}();

}



function testRafileStateInitialize() external view {

    assert(betApp.getBettingState() == BetApp.BettingState.OPEN);
}



function testBuyTicketFaildWithIncrseaseMoneyError() external{

string  memory errname = 'increase money to buy ticket';

vm.expectRevert(abi.encodeWithSelector(BetApp.FailedTo__BuyTicket_AmountNotEnough.selector,errname));
vm.prank(player);

betApp.buyTicket{value: 0.00001 ether}();

}




function testBuyTicketAddUserToStoreArray() external {

vm.prank(player);

betApp.buyTicket{value: ticketPrice}();



assertEq(betApp.getPlayers(0),player);


}








function testBuyTicketEmitEventNewPlayer()external {

vm.expectEmit(true,false , false, false,address(betApp));
// this the emit we expect
emit NewPlayerBuyTicket(player);


vm.prank(player);

betApp.buyTicket{value: ticketPrice}();


}





function testRequestRandomWordsRevetWithNotPickingPlayesYet() external{

vm.prank(player);

betApp.buyTicket{value: ticketPrice}();

vm.expectRevert(BetApp.TimeForPicking_Players_Not_ReachedYet.selector);

betApp.requestRandomWords();


}



// this test will aways fail= will worked wen i setup chailink consumerId


// function testBuyTicketFaildDueToStateChange() external{

// vm.prank(player);

// betApp.buyTicket{value: ticketPrice}();

// vm.warp(block.timestamp + interval + 1);

// // commented requestwords chainlink code to test it


//  betApp.requestRandomWords();


// vm.expectRevert(BetApp.FailedTo__BuyTicket_TryAgain.selector);
// vm.prank(player);

// betApp.buyTicket{value: ticketPrice}();


// }






function testRequestRandomWordRevet() external{


vm.expectRevert(BetApp.FailedTo__BuyTicket_TryAgain.selector);
vm.warp(block.timestamp + interval + 2);
 betApp.requestRandomWords();



}







}