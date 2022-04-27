// SPDX-License-Identifier: WTFPL 
// author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
//    _     __       _____  _   _  ___       _           _    _          
//  /'_`\ /' _`\    (_   _)( ) ( )(  _`\    (_ )        ( )_ ( )_        
// ( (_) )| ( ) |     | |  | |_| || (_) )    | |    _   | ,_)| ,_)   _   
//  > _ <'| | | |     | |  |  _  ||  _ <'    | |  /'_`\ | |  | |   /'_`\ 
// ( (_) )| (_) |     | |  | | | || (_) )    | | ( (_) )| |_ | |_ ( (_) )
// `\___/'`\___/'     (_)  (_) (_)(____/'   (___)`\___/'`\__)`\__)`\___/'

//            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//                    Version 2, December 2004
 
// Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

// Everyone is permitted to copy and distribute verbatim or modified
// copies of this license document, and changing it is allowed as long
// as the name is changed.
 
//            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

//  0. You just DO WHAT THE FUCK YOU WANT TO.

pragma solidity 0.8.13;


import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract the80THBLotto {
    using SafeERC20 for ERC20;

    address public immutable THB;
    uint public constant price = 80 * baht;
    uint private constant platformFee = 15 * baht;

    uint private prizeFees = 1;
    uint private tax = 1;

    uint constant baht = 1 ether;
    address public immutable theOracle;

    uint currentRound = 0;
    mapping (uint => mapping(address => mapping(uint => uint))) userLotto;
    mapping(uint => mapping(uint => uint)) prize;
    mapping(uint => mapping(uint => uint)) prizeL3;
    mapping(uint => mapping(uint => uint)) prizeF3;
    mapping(uint => mapping(uint => uint)) prizeL2;


    uint nextDeadline ;

    constructor(address _THB) {
        THB = _THB;
        theOracle = msg.sender;
    }

    function buyLotto(uint number, uint amount) public{
        require(number < 1000000, "1-999999 only");
        require(number > 0 , "1-999999 only"); // too lazy to check for 0
        require(block.timestamp < nextDeadline, "round ended");
        ERC20(THB).safeTransferFrom(msg.sender,address(this), amount * (price + platformFee));
        userLotto[currentRound][msg.sender][number] += amount;
    }

    function startRound(uint _deadline) public{
        require(msg.sender == theOracle);
        currentRound += 1;
        nextDeadline = _deadline;
    }

    function endRound(uint _first, uint[] memory _p2,uint[] memory _p3,uint[] memory _p4,uint[] memory _p5, uint[] memory _l3,uint[]memory  _f3,uint[] memory _l2) public{
        require(msg.sender == theOracle);
        prize[currentRound][_first] += 6_000_000;
        prize[currentRound][_first +1] += 100_000 ;
        prize[currentRound][_first - 1] += 100_000 ;


        for (uint i=0;i<_p2.length;i++){
            prize[currentRound][_p2[i]] += 200_000;
        }

        for (uint i=0;i<_p3.length;i++){
            prize[currentRound][_p3[i]] += 80_000;
        }

        for (uint i=0;i<_p4.length;i++){
            prize[currentRound][_p4[i]] += 40_000;
        }

        for (uint i=0;i<_p5.length;i++){
            prize[currentRound][_p5[i]] += 20_000;
        }

        for (uint i=0;i<_l3.length;i++){
            prizeL3[currentRound][_l3[i]] += 4_000;
        }

        for (uint i=0;i<_f3.length;i++){
            prizeF3[currentRound][_f3[i]] += 4_000;
        }

        for (uint i=0;i<_l2.length;i++){
            prizeL2[currentRound][_l2[i]] += 2_000;
        }
        
    }

    function claim(uint round, uint number) public{
        uint ticket = userLotto[round][msg.sender][number];
        require(ticket > 0);
        require(currentRound > round);
        userLotto[round][msg.sender][number] = 0;

        uint payout = 0;
        payout += prize[round][number];
        payout += prizeF3[round][number/1000];
        payout += prizeL3[round][number%1000];
        payout += prizeL2[round][number%100];

        payout = payout * ticket * 10 **18;

        ERC20(THB).transfer(theOracle, payout *prizeFees /10_000);
        ERC20(THB).transfer(0x6647a7858a0B3846AbD5511e7b797Fc0a0c63a4b, payout *tax /10_000);
        ERC20(THB).transfer(msg.sender, payout *(10_000 - tax- prizeFees) /10_000);

    }


}
