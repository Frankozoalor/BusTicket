// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract TicketBooking {
    using EnumerableSet for EnumerableSet.UintSet;
    EnumerableSet.UintSet private seats;

    uint256 public MAX_TICKET = 4;
    uint256 public MAX_NUMBER_OF_SEATS = 20;

    error SeatNotAvailableError();
    error seatLengthZero();

    mapping(uint256 seatNumber => bool avaliable) public seatAvaliable;
    mapping(address user => uint256[] seatNumbers) public userSeat;

    constructor(uint256[] memory totalSeats) {
        for (uint256 i = 0; i < totalSeats.length; i++) {
            seats.add(totalSeats[i]);
            seatAvaliable[totalSeats[i]] = true;
        }
    }

    function bookSeats(uint256[] memory seatNumbers) public {
        require(
            seatNumbers.length > 0 && seatNumbers.length <= MAX_TICKET,
            "book atleast one seat"
        );

        for (uint256 i = 0; i < seatNumbers.length; i++) {
            if (!isSeatAvaliable(seatNumbers[i]))
                revert SeatNotAvailableError();
            uint256 seatLength = seats.length();
            if (seatLength < MAX_NUMBER_OF_SEATS) {
                userSeat[msg.sender].push(seatNumbers[i]);
                seatAvaliable[seatNumbers[i]] = false;
                seats.remove(seatNumbers[i]);
            } else {
                break;
            }
        }
    }

    function isSeatAvaliable(uint256 seatNumber) public returns (bool) {
        return seats.contains(seatNumber);
    }

    //To get available seats
    function showAvailableSeats() public returns (uint256[] memory) {
        uint256 seatLength = seats.length();
        uint256[] memory avaliableSeats = new uint256[](seatLength);
        if (seatLength == 0) revert seatLengthZero();
        for (uint256 i = 0; i < seatLength; i++) {
            avaliableSeats[i] = seats.at(i);
        }
        return avaliableSeats;
    }

    //To check availability of a seat
    function checkAvailability(uint256 seatNumber) public returns (bool) {
        return seatAvaliable[seatNumber];
    }

    //To check tickets booked by the user
    function myTickets() public returns (uint256[] memory) {
        return userSeat[msg.sender];
    }
}
