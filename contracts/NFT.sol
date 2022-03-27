// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

contract NFT is ERC721URIStorage {
    using Counter for Counter.Counter; 
    Counters.Counter private _tokenIds;
    address contractAddress;
    Counters.Counter private _itemsSold;

    constructor(address marketplaceAddress) ERC721("Metaverse Tokens", "METT"){
        contactAddress = marketplaceAddress
    }

    function createToken(string memory tokenURI) public returns (unit){
        _tokenIds.increment(); 
        uint256 newItemId = _tokenIds.current(); 

        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        setApprovalForAll(contactAddress, true);
        return newItemId;
    }
}

