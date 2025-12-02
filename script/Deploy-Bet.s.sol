// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from 'forge-std/Script.sol';
import {BetApp} from 'src/betapp.sol';

import {HelperConfig} from './helperConfig.s.sol';
 import {CreateSubscritions,Consumer,Addconsumer} from './vrf-sub.s.sol';
contract DeployBetApp is Script{

HelperConfig helperconfig = new HelperConfig();

function run() external returns(HelperConfig, BetApp){

HelperConfig.NetWorkConfig memory config = helperconfig.getConfig();


if(config.subId == 0){

CreateSubscritions createSubscritions = new CreateSubscritions();
(config.subId, config.vrfCoordinator) = createSubscritions.CreateSubscrition(config.vrfCoordinator);

Consumer consumer = new Consumer();
consumer.fundSubscription(config.vrfCoordinator, config.subId, config.link);    




}


 
 vm.startBroadcast();

 BetApp  betApp = new BetApp(config.interval, config.vrfCoordinator, config.subId, config.ticketPrice, config.gaslane, config.callbackgaslim);

vm.stopBroadcast();


Addconsumer addconsumer = new Addconsumer();
addconsumer.addConsumer(config.vrfCoordinator,config.subId,address(betApp));




return(helperconfig, betApp);


}








}