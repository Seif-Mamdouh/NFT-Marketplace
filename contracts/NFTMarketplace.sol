// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMarket is ReenttrancyGuard {
    using Counters for Counters.Counter; 
    Counters.Counter private _itemsIds; 
    Counters.Counter private _itermsSold;

    address payable owner;
    unit256 listingPrice = 0.025 ether;

    constructor(){
        owner = payable(msg.sender);
    }

    struct MarketItem {
        uint itemId;
        address nftContract;
        unit256 tokenId; 
        address payable seller;
        address payable owner; 
        uint256 price; 
        bool sold;
    }

    event MarketItemCreated (
        uint265 indexed tokenId,
        address seller, 
        address owner, 
        unint256 price, 
        bool sold
    );

    constructor() ERC721{"Metaverse Tokens", "METT") {
        owner = payable(msg.sender);
    }

    /* Update the listing price of the contract */
    function updateListingPrice(uint _listingPrice) public payable {
        require(owner == msg.sender, "Only marketplace ownd )
    }
}