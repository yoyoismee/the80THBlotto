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


contract BTHB is ERC20("beter thai bath", "BTHB"){
    using SafeERC20 for ERC20;
    uint exchangeRate = 33; 
    address public USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    uint USDdecimal = 6; 

    function getBTHB(uint amount) public {
        ERC20(USDT).safeTransferFrom(msg.sender,address(this), amount);
        uint toMint = amount * exchangeRate * 10**18 / 10**USDdecimal;
        _mint(msg.sender, toMint);
    }

    function sellBTHB(uint amount) public {
        _burn(msg.sender, amount);
        uint toRefund = amount * 10**USDdecimal / exchangeRate / 10**18;
        ERC20(USDT).safeTransfer(msg.sender, toRefund);
    }
}
