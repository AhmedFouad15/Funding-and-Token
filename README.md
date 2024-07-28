Funding and Token Distribution
Welcome to the Funding and Token Distribution project!

Overview
This project consists of a smart contract system for funding and token distribution. Users can send Ethereum (ETH) to a funding contract and, based on their contributions, receive WE Tokens when the contract owner performs a token distribution.

The system tracks each contributor's ETH contributions and allows the contract owner to withdraw any remaining unused WE Tokens from the contract.

Key Features
Funding: Send ETH to the contract and be eligible for token rewards.
Token Distribution: The owner can distribute WE Tokens to funders based on their contributions.
Tracking: Monitor contributions through a mapping system.
Withdrawal: The owner can reclaim unused WE Tokens from the contract.
Conversion Rate: 1 ETH = 1000 WE Tokens
Minimum Contribution: $200 worth of ETH

Getting Started
Deployment Steps
Deploy the WE Token Contract:

First, deploy the WeToken.sol contract. This contract represents the WE Tokens that will be distributed to funders.
Deploy the Funding Contract:

Next, deploy the Fund.sol contract. During deployment, provide the address of the WeToken contract. This allows the Funding contract to interact with the WE Token.
Contract Files
IERC20.sol:

Interface for ERC20 tokens. Defines the standard functions required for ERC20 compliance.
WeToken.sol:

Implementation of the WE Token. This contract is used to mint and manage WE Tokens.
Convert.sol:

Contains logic to fetch the latest ETH-to-USD conversion rate using Chainlink's Aggregator.
Fund.sol:

Main funding contract where users can send ETH. The contract tracks contributions, distributes WE Tokens, and allows the owner to withdraw any leftover tokens.
Additional Information
Ensure that the WE Token contract address is correctly provided when deploying the Funding contract.
Use test networks to verify the functionality of the contracts before deploying to the mainnet.
Feel free to reach out if you have any questions or need further assistance!

