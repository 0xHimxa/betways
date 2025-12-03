// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";

import {DeployBetApp} from "script/Deploy-Bet.s.sol";
import {HelperConfig} from "script/helperConfig.s.sol";
import {BetApp} from "src/betapp.sol";

import {
    VRFCoordinatorV2_5Mock
} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/vrf/interfaces/VRFCoordinatorV2Interface.sol"; 
// Adjust the path above based on your actual dependencies and folder structure.

 import {CreateSubscritions,Consumer,Addconsumer} from 'script/vrf-sub.s.sol';


contract TestCreateSub is Test{
    CreateSubscritions create;
HelperConfig helperConfig;
BetApp betApp;
function setUp() external{

DeployBetApp deployBetApp = new DeployBetApp();


(helperConfig,betApp) = deployBetApp.run();
create = new CreateSubscritions();

}



function testCreateSubscriptionSuccess() external{

//vm.expectCall = we use it to confirm a fuction call what we expect like below

vm.expectCall(helperConfig.getConfig().vrfCoordinator, abi.encodeWithSelector( VRFCoordinatorV2Interface.createSubscription.selector));


(uint256 subid,address vrfCordinator) = create.CreateSubscrition(helperConfig.getConfig().vrfCoordinator);


assert(vrfCordinator == helperConfig.getConfig().vrfCoordinator);








}







}