// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
This is a summary of this contract
This contract is a live price getter of eth so when The funding round goes live it has a requirement of minimum 100$
Thanks for your intrest
*/

//This is the oracle that I use
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


library PriceConverter {
    // this function tells us the price of eth with 18 decimal
    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // This will be the rice of eth in 18 digit so we can use it easily
        return uint256(answer * 10000000000);
    }
    //
    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }
}
