// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
This is a small recap of what this contract do
It has a fund function which funders send money
Withdraw which only owner can use 
Distribute function which sends tokens to contributers and restart funders array and map 
Map which tells you how much someone sent and this map gets restarted once token distibuted
Minimum eth worth 200$ to be sent
1 ETH = 1000 WE Token
**IMPORTANT NOTES** 
When you deploy this contract you must put your Token address which you will distribute
You should send the same token which has the same address which you posted while deploying
You should send the Token you deployed manually
*/

//Basic Imports we need
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./Convert.sol";
import "./WeToken.sol";

//custom error
error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
 

    uint256 private  totalEthReceived;
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public  immutable  i_owner;
    uint256 private  constant MINIMUM_USD = 200 * 10 ** 18;
    IERC20  immutable token;
    //not used again only for knowldge
    uint256 public Minimun_worth_USD = 200;
    address contractAddress = address(this);
 



   
    constructor(address contractoftoken) {
        i_owner = msg.sender;
        token = IERC20(contractoftoken); 
    }
    
    //this function has requre that the msg value when converted through getconv is equal or bigger than 200usd
    //then adds to the mapping and adds the funders array and adds to total eth received
    function fund() public payable {
       (msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more than 200$!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        totalEthReceived = totalEthReceived + msg.value;
    }

    // only owner req
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
    
    //withdraw function has only owner so only owner can withdraw
    function withdraw() public onlyOwner {
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }


    //Distribute function has only owner so owner only can use require eth recived and the reward every funder related to eth sent
    //You should send to the contract enough token to reward funders
    function distributeTokens() public onlyOwner { require(totalEthReceived > 0, "No ETH contributions to distribute tokens for");
        for (uint i = 0; i < funders.length; i++) { address funder = funders[i];
        uint256 contribution = addressToAmountFunded[funder];
        uint256 tokenAmount = calculateTokenAmount(contribution);
        // Transfer "We" tokens to funder 
        require(token.transfer(funder, tokenAmount), "Token transfer failed"); 

        }
        
        //Restarting the map and funders array and total eth sent
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
          address funder = funders[funderIndex];
          addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        totalEthReceived = 0 ;
         }
        
   

    // for every 0.1 eth you will get 100 Token
    function calculateTokenAmount(uint256 ethAmount) private   pure returns (uint256) { 
        //here dividing the eth amount by 15 zero instead of 18 cuz i want 1 eth equal 1000 token
        uint256 tokenAmount = (ethAmount / 1000000000000000) ;
         return tokenAmount; } 

    //Return function which withdraw tokens to contract owner
    function returnoversenttokens (uint256 tokensamount) public onlyOwner{
                require(token.transfer(i_owner, tokensamount), "Token transfer failed"); 
    }

    //When calling doesnt cost fees it tells you how many WE Token does the fund me have
    function seehowmanytokens() public view returns (uint256) {
        return token.balanceOf(contractAddress);
}

   /* This 2 functions redirect poeple who didnt use Fund option and sent eth to this contract through normal transfer so if they
    send less than 200$ their transaction gets reverted and if they did fill the requirement their addres will be added */

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
    /* Explaination to the 2 function
     Ether is sent to contract
         is msg.data empty?
               /   \
              yes  no
              /     \
        receive()?  fallback()
          /   \
        yes   no
       /        \
    receive()  fallback()
    */
}
