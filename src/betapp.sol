// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {
    VRFV2PlusClient
} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
import {
    VRFConsumerBaseV2Plus
} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

contract BetApp is VRFConsumerBaseV2Plus {
    error FailedTo__BuyTicket_AmountNotEnough(string name);

    error FailedTo__BuyTicket_TryAgain();
    error TimeForPicking_Players_Not_ReachedYet();
    error Betting_Need_To_Close_First( );
    error FailedTo__SendMoney_To_Winner();

    event NewPlayerBuyTicket(address indexed player);
event LuckyWinnerSelected(address indexed winner);
    enum BettingState {
        OPEN,
        CLOSED
    }

    uint32 private constant MINWORDS = 1;
    uint256 private immutable TICKET_FEE;

    address[] s_players;
    uint256 private immutable interval;
    bytes32 private immutable gaslane;
    uint32 private immutable callbackgaslim;
    uint256 private immutable subscriptionId;
    uint256 private  lastTimeStamp;
    address private luckyWinner;

    BettingState private s_bettingState = BettingState.OPEN;

    constructor(
        uint256 _interval,
        address vrfcoordinator,
        uint256 subId,
        uint256 ticketPrice,
        bytes32 _gaslane,
        uint32 _callbackgaslim
    ) VRFConsumerBaseV2Plus(vrfcoordinator) {
        interval = _interval;
        subscriptionId = subId;
        TICKET_FEE = ticketPrice;
        gaslane = _gaslane;
        callbackgaslim = _callbackgaslim;
        lastTimeStamp = block.timestamp;
    }

    function buyTicket() external payable {
        if (s_bettingState == BettingState.CLOSED)
            revert FailedTo__BuyTicket_TryAgain();

        if (msg.value < TICKET_FEE) {
            revert FailedTo__BuyTicket_AmountNotEnough(
                "increase money to buy ticket"
            );
        } else {
            s_players.push(msg.sender);
            emit NewPlayerBuyTicket(msg.sender);
        }
    }

    function requestRandomWords() external {
        if ((block.timestamp - lastTimeStamp) < interval)
            revert TimeForPicking_Players_Not_ReachedYet();

        bool performaction = s_players.length > 0 &&
            address(this).balance > 0 &&
            s_bettingState == BettingState.OPEN;

        if (!performaction) revert FailedTo__BuyTicket_TryAgain();

        s_bettingState = BettingState.CLOSED;

        uint256 s_requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: gaslane,
                subId: subscriptionId,
                requestConfirmations: 3,
                callbackGasLimit: callbackgaslim,
                numWords: MINWORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
    }

    function fulfillRandomWords(
         uint256 requestId,
        uint256[] calldata randomWords
    ) internal override {

if(s_bettingState != BettingState.CLOSED)revert Betting_Need_To_Close_First(); 

uint256 pickWinnerIndex = randomWords[0] % s_players.length;
address pickedWinner = s_players[pickWinnerIndex];
    luckyWinner = pickedWinner;
    emit LuckyWinnerSelected(pickedWinner);


 (bool sucess,) = payable(pickedWinner).call{value: address(this).balance}(''); 


 if(!sucess) revert FailedTo__SendMoney_To_Winner();


        lastTimeStamp = block.timestamp;
        s_bettingState = BettingState.OPEN;
        s_players = new address[](0);



    }

    function getPlayers(uint256 index) external view returns (address) {
        return s_players[index];
    }

    function getInterval() external view returns (uint256) {
        return interval;
    }

    function getTicketFee() external view returns (uint256) {
        return TICKET_FEE;
    }

    function getBettingState() external view returns (BettingState) {
        return s_bettingState;
    }
}
