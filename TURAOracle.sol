// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TURAOracle is Ownable {
    mapping(address => AggregatorV3Interface) public priceFeeds;

    event PriceFeedUpdated(address token, address feed);

    function updatePriceFeed(address token, address feed) external onlyOwner {
        priceFeeds[token] = AggregatorV3Interface(feed);
        emit PriceFeedUpdated(token, feed);
    }

    function getLatestPrice(address token) public view returns (int) {
        AggregatorV3Interface priceFeed = priceFeeds[token];
        require(address(priceFeed) != address(0), "Price feed not found");

        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }

}
