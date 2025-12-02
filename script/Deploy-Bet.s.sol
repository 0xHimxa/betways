// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script} from 'forge-std/Script.sol';
import {BetApp} from 'src/betapp.sol';

import {HelperConfig} from './helperConfig.s.sol';

contract DeployBetApp is Script{

HelperConfig helperconfig = new HelperConfig();

function run() external returns(HelperConfig, BetApp){

HelperConfig.NetWorkConfig memory config = helperconfig.getConfig();
 
 vm.startBroadcast();

 BetApp  betApp = new BetApp(config.interval, config.vrfCoordinator, config.subId, config.ticketPrice, config.gaslane, config.callbackgaslim);

vm.stopBroadcast();


return(helperconfig, betApp);


}








}