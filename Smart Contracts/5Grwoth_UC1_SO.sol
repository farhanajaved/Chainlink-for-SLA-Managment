// SPDX-License-Identifier: MIT
// block-farms.io
// Discord=https://discord.gg/PgxRVrDUm7

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract getMultiDataTypeTemplate is ChainlinkClient {
  using Chainlink for Chainlink.Request;

  bytes public data;
  string public convertedBytes;
  uint256 public amount;

  bytes32 private externalJobId;
  uint256 private oraclePayment;

  constructor(
  ) {
    setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
    setChainlinkOracle(0xedaa6962Cf1368a92e244DdC11aaC49c0A0acC37);
    externalJobId = "293676225a0e49ec9828b2cb593dcf39";
    oraclePayment = (0.0 * LINK_DIVISIBILITY); // n * 10**18
  }
//0x5473dcE6a20Ad9076270f620A79969fb75e7e9FD


//   function requestBytesAndAmount(
//   )
//     public
//   {
//     Chainlink.Request memory req = buildChainlinkRequest(externalJobId, address(this), this.fulfillBytes.selector);
//     req.add("get","https://raw.githubusercontent.com/Block-Farms/Chainlink-Public-Jobs/master/example-json/x1%20uint256%2Bx1%20bytes-example.json");
//     // req.add("get", "https://raw.githubusercontent.com/Block-Farms/Chainlink-Public-Jobs/master/example-json/x1%20uint256%2Bx1%20bytes-example.json");
//     req.add("path1", "data,linkusd");
//     req.add("path2", "data,bytes");
//     req.addInt("times", 100);
//     sendOperatorRequest(req, oraclePayment);
//   }

bytes public Url;

function setIPFS(string memory _hash) public {
     bytes memory baseUrl = "https://gateway.pinata.cloud/ipfs/"; //Qmd6L9rCMmLN1GUnBTwud6ymCW5uYeEoLfTQvAQNiC1ypD
     Url = string.concat(baseUrl, bytes(_hash));
}

function getIPFSHash() public view returns(string memory){
    return string(Url);
}

function requestBytesAndAmount()public{
    Chainlink.Request memory req = buildChainlinkRequest(externalJobId,address(this), this.fulfillBytes.selector);
    req.add("get","https://raw.githubusercontent.com/farhanajaved/Chainlink-for-SLA-Managment/main/Datalogs/metrices/UC1_SO.json");
    req.add("path1", "remoteLinkId");
    req.add("path2", "bytes");
    req.addInt("times", 100);
    sendOperatorRequest(req, oraclePayment);
}

  event RequestFulfilled(bytes32 indexed requestId,bytes indexed data,uint256 amount);

  function fulfillBytes(bytes32 requestId, bytes memory bytesData, uint256 _amount)
    public
    recordChainlinkFulfillment(requestId)
  {
    emit RequestFulfilled(requestId, bytesData, _amount);
    data = bytesData;
    convertedBytes = string(data);
    amount = _amount;
  }

}
