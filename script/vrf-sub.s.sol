// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Script, console} from "forge-std/Script.sol";
import {BetApp} from "src/betapp.sol";
import {DevOpsTools} from 'lib/foundry-devops/src/DevOpsTools.sol';

import {HelperConfig, ConstantCode} from "./helperConfig.s.sol";
import {
    VRFCoordinatorV2_5Mock
} from "@chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_5Mock.sol";
import {LinkToken} from "test/mocks/linkToken.sol";

contract CreateSubscritions is Script {
    function CreateSubscrition(
        address vrfCordinator
    ) external returns (uint256, address) {
        vm.startBroadcast();
        uint256 subId = VRFCoordinatorV2_5Mock(vrfCordinator)
            .createSubscription();
        vm.stopBroadcast();
        console.log("created subscription with id", subId);
        console.log("suing this vrf coordinator", vrfCordinator);

        return (subId, vrfCordinator);
    }
}

contract Consumer is Script, ConstantCode {
    uint256 private constant FUND_AMOUNT = 100 ether;

    function fundSubscription(
        address vrfCoordinator,
        uint256 subId,
        address link
    ) external {
        if (block.chainid == LOCAL_HOST_CHAIN_ID) {
            vm.startBroadcast();
            VRFCoordinatorV2_5Mock(vrfCoordinator).fundSubscription(
                subId,
                FUND_AMOUNT
            );
            vm.stopBroadcast();
        } else {
            vm.startBroadcast();
            LinkToken(link).transferAndCall(
                vrfCoordinator,
                FUND_AMOUNT,
                abi.encode(subId)
            );
            vm.stopBroadcast();
        }
    }
}


contract Addconsumer is Script{



function addonsumerConfi(address recentDeployedcontract) internal {
    
    HelperConfig helperConfig = new HelperConfig();
    address vrfCoordinator = helperConfig.getConfig().vrfCoordinator;
    uint256 subId = helperConfig.getConfig().subId;


addConsumer(vrfCoordinator, subId, recentDeployedcontract);


}


function addConsumer( address vrfCoordinator, uint256 subId, address contratAdd)public{


vm.startBroadcast();
VRFCoordinatorV2_5Mock(vrfCoordinator).addConsumer(subId,contratAdd);
vm.stopBroadcast();



}

function run() external{
address recentlyDeployed = DevOpsTools.get_most_recent_deployment('BetApp',block.chainid);
addonsumerConfi(recentlyDeployed);

}



}
