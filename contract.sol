/* This contract is a test to fetch int from json using a rinkeby testnet chainlink oracle 
 */
 
pragma solidity ^0.6.0;

import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.6/ChainlinkClient.sol";

contract UniquenessDaoScore is ChainlinkClient {
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    uint256 public userScore;

    constructor() public {
    	setPublicChainlinkToken();
    	oracle = 0xf71775b3640D7034466e0321E35c5CFB78fd212F; // oracle address
    	jobId = "7599d3c8f31e4ce78ad2b790cbcfc673"; //job id
    	fee = 0.05 * 10 ** 18; // 0.1 LINK
    }   
    
    /**
     * Make initial request
     */
    function requestScore() public {
    	Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfillEthereumPrice.selector);
        req.add("get", "https://bafybeidryhlob4s2w4zgjfrzdfwcfjbwnfqlargirgm3oornyi7n6skvd4.ipfs.dweb.link/test.json");
        req.add("path", "address");
    	sendChainlinkRequestTo(oracle, req, fee);
    }
    
    /**
     * Callback function
     */
    function fulfillEthereumPrice(bytes32 _requestId, uint256 _score) public recordChainlinkFulfillment(_requestId) {
    	userScore = _score;
    }
}