// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script} from 'forge-std/Script.sol';
import {BetApp} from 'src/betapp.sol';

import {VRFCoordinatorV2_5Mock} from '@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol';
contract HelperConfig is Script{

 /** VRF Mock Values */
    uint96 public MOCK_BASE_FEE = 0.015 ether;
    uint96 public MOCK_GAS_PRICE_LINK = 1e9;
 //Link / Eth price
    int256  public MOCK_WEI_PER_UINT_LINK = 4e15;
uint256 private constant SEPOLIA_CHAIN_ID = 11155111;
uint256 private constant LOCAL_HOST_CHAIN_ID = 31337;
NetWorkConfig private  localNetWorkConfig;
mapping(uint256 chainId => NetWorkConfig) private networkConfig;




struct NetWorkConfig{

address vrfCoordinator;
uint256 subId;
uint256 ticketPrice;
uint256 interval;
bytes32 gaslane;
uint32  callbackgaslim;



}



constructor(){
 networkConfig[SEPOLIA_CHAIN_ID] = getSepoliaConfig();

}


function getConfigByChainId(uint256 chainId) internal returns(NetWorkConfig memory){

  if(networkConfig[chainId].vrfCoordinator != address(0)){
    return networkConfig[chainId];
  }

 else if(chainId == LOCAL_HOST_CHAIN_ID){
  return getLocalHostConfig();
 }


}


function getConfig() external returns(NetWorkConfig memory){

  return getConfigByChainId(block.chainid);
}



function getSepoliaConfig() internal pure returns(NetWorkConfig memory){

NetWorkConfig memory sepliaCong = NetWorkConfig({


  vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
         subId: 0,
    ticketPrice: 0.01 ether,// 1e16
        interval: 30, //30 seconds
        gaslane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
callbackgaslim: 50000


});

return sepliaCong;

}



function getLocalHostConfig() internal returns(NetWorkConfig memory){

if(localNetWorkConfig.vrfCoordinator != address(0)) return localNetWorkConfig;


vm.startBroadcast();
VRFCoordinatorV2_5Mock vrfCoordinator = new VRFCoordinatorV2_5Mock(MOCK_BASE_FEE, MOCK_GAS_PRICE_LINK, MOCK_WEI_PER_UINT_LINK);

vm.stopBroadcast();

 localNetWorkConfig = NetWorkConfig({



  vrfCoordinator:address(vrfCoordinator),
         subId: 0,
    ticketPrice: 0.01 ether,// 1e16
        interval: 30, //30 seconds
        gaslane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
callbackgaslim: 50000




});


return localNetWorkConfig;


}





}