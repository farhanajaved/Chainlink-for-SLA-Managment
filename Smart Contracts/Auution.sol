pragma solidity ^0.4.23;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract ReverseAuction is Ownable {
    event BidPlaced(address bidder, uint amount);

    mapping (address => uint) bids;

    uint8 private totalBids = 0;

    address lowestBid;

    address winningBid;

    uint endTime;

    modifier auctionOpen() {
        require(isRunning(), "The auction has ended.");
        _;
    }

    constructor(uint _endTime) public {
        endTime = _endTime;
    }

    function getLowestBid() public view returns (uint) {
        return bids[lowestBid];
    }

    function getTotalBids() public view returns (uint8) {
        return totalBids;
    }

    function setWinningBid(address _bidder) public onlyOwner {
        winningBid = _bidder;
    }

    function getWinningBid() public view returns (address) {
        return winningBid;
    }

    function getBidAmount(address _address) public view returns (uint) {
        return bids[_address];
    }

    function bid(address _bidder, uint _amount) public payable auctionOpen onlyOwner {
        require(_amount > 0);

        bids[_bidder] = _amount;
        totalBids = totalBids + 1;

        if (bids[lowestBid] == 0 || _amount < bids[lowestBid]) {
            lowestBid = _bidder;
        }

        emit BidPlaced(_bidder, _amount);
    }

    function isRunning() public view returns (bool) {
        if (endTime <= block.timestamp) {
            return false;
        }

        return true;
    }
}
