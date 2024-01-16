// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "../src/TicketBooking.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract BusTicket is Test {
    TicketBooking public ticketBooking;

    address alice = address(0x1);

    function setUp() public {
        uint256[] memory totalSeats = new uint256[](12);
        totalSeats[0] = 1;
        totalSeats[1] = 2;
        totalSeats[2] = 3;
        totalSeats[3] = 4;
        totalSeats[4] = 5;
        totalSeats[5] = 6;
        totalSeats[6] = 7;
        totalSeats[7] = 8;
        totalSeats[8] = 9;
        totalSeats[9] = 10;
        ticketBooking = new TicketBooking(totalSeats);
    }

    function testMaxNumber() public {
        assertEq(ticketBooking.MAX_TICKET(), 4);
    }

    function testBookseats() public {
        vm.startPrank(alice);
        uint256[] memory bookseats = new uint256[](4);
        bookseats[0] = 5;
        bookseats[1] = 2;
        bookseats[2] = 3;
        ticketBooking.bookSeats(bookseats);
        uint256[] memory mytickets = ticketBooking.myTickets();
        console.log(mytickets[0]);
        console.log(mytickets[1]);
        console.log(mytickets[2]);
        vm.stopPrank();

        assertEq(ticketBooking.checkAvailability(5), false);
        assertEq(ticketBooking.checkAvailability(2), false);
        assertEq(ticketBooking.checkAvailability(3), false);
    }

    function testshowAvailableSeats() public {
        uint256[] memory avaliableSeats = ticketBooking.showAvailableSeats();
        console.log(avaliableSeats[0]);
        console.log(avaliableSeats[1]);
        console.log(avaliableSeats[2]);
        console.log(avaliableSeats[3]);
    }

    function testisSeatAvaliable() public {
        assertEq(ticketBooking.isSeatAvaliable(5), true);
    }

    function testcheckAvailability() public {
        assertEq(ticketBooking.checkAvailability(11), false);
    }

    function testCheckAvailabilityRevert() public {
        assertEq(ticketBooking.checkAvailability(2), true);
    }
}
