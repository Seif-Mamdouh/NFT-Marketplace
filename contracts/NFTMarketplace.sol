// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarket is ReentrancyGuard {
    \\ //keeping the numbers of IDS and Items Sold, knowing the length of the Array
    using Counters for Counters.Counter; 
    Counters.Counter private _itemsIds; 
    Counters.Counter private _itemsSold; 

    address payable owner; 
    uint256 listingPrice = 0.025 ether;

    \\ //the owner of the contract is the person deploying it
    \\ //which is basically the contract address that we will be deploying it to
     constructor(){
         owner = payable(msg.sender);
     }

     struct MarketItem {
        uint itemId;
        address nftContract;
        uint256 tokenId; 
        address payable seller;
        address payable owner; 
        uint256 price; 
        bool sold;
    }

    \\ // we want to start keeping up with all the items that have been created
    \\ //which will return the MarketItem struct.
    mapping(uint256 => MarketItem) private idToMarketItem;

    \\ //have an event when marketItem has been created
    event MarketItemCreated (
        uint indexed itemId, 
        address indexed nftContract,
        uint265 indexed tokenId,
        address seller, 
        address owner, 
        uint256 price, 
        bool sold
    );

    \\function that returns the listingPrice
    function getLisitngPrice() public view returns (uint256){
        return listingPrice; 
    }

    \\ two functions for intercating with the contract information
    \\ one for creating a market item and outting it for sale
    \\ the second one is creating a market sale for buying and selling an item between parties 
    function createMarketItem(
        \\ contract for the actaul NFT, passing the token ID and price that token is up for sale for.
        address nftContract, 
        uint256 tokenId, 
        uint256 price,  
    ) public payable nonReentrant {
        \\ nonReentrant is basically used to prevent a re-entry attack
        require(price > 0, "Prie must be at least 1 wei"); 
        require(msg.value == listingPrice, "Price must be equal to listing price"); 
        _itemIds.increment();
        uint256 itemId = _itemIds.current();

        idToMarketItem[itemId] = MarketItem (
            itemId, 
            nftContract, 
            tokenId, 
            payable(msg.sender), 
            payable(address(0)), 
            price, 
            false
        );

        \\ we want to transer the ownership to the contract
        \\ takes the ownership of the contract and transfer it to the buyer
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        emit MarketItemCreated(
            itemId, 
            nftContract, 
            tokenId, 
            msg.sender, 
            address(0), 
            price, 
            false
        );
    }

    funtion creatMarkeSale(
        address nftContract, 
        uint256 itemId
    ) public payable nonReentrant {
        \\ listing the price for the toekn ID 
        uint price = idToMarketItem[itemId].price; 
        uint tokenId = idToMarketItem[itemId].tokenId;
        \\ 
        require(msg.value == price, "Please submit the asking price in order to complete the purchase"); 

        idToMarketItem[itemId].seller.transfer(msg.value);
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
        idToMarketItem[itemId].owner = payable(msg.sender);
        idToMarketItem[itemId].sold = true;
        _itemsSold.increment();
        payable(owner).transfer(listingPrice);
    }

    \\ function that return unsold items 
    function fetchMarketItems() public view returns (MarketItem[] memory){
        uint itemCount = _itemIds.current();
        uint unsoldItemCount = _itemIds.current() - itemsSold.current();
        uint currentIndex = 0; 
        \\ to keep up with the local values 
        \\ loopin through an array that has a number of items that have been created
        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint i = 0; i < itemCount; i ){
            if(idToMarketItem[i + 1].owner == address(0)){
                unint currentId = idToMarketItem[i+1].itemId;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;

            }
        }
        return items;
    }

    \\ functions that returns items that I have purchased
    function fetchMyNFTs() public view returns (MarketItem[] memory){
        uint totalItemCount = _itemIds.current();
        uint itemCount = 0; 
        uint currentIndex = 0;

        for (uint i = 0; i<totalItemCount; i++){
            if(idToMarketItem[i + 1].owner == msg.sender){
                itemCount += 1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);
        for (uint i = 0; i < totalItemCount; i++){
            if(idToMarketItem[i + 1].owner == msg.sender){
                uint currentId = idToMarketItem[i+1].itemId;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    \\ A function that returns all the items I have created
    function fetchItemsCreated() public view returns (MarketItem[] memory){
        uint totalItemCount = _itemIds.current();
        uint itemCount = 0;
        uint currentIndex = 0; //
        
        for(uint i = 0; i < totalItemCount; i++){
            if(idToMarketItem[i + 1].seller == msg.sender){
                itemCount += 1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount){
            for (uint i = 0; i < totalItemCount; i++){
                if(idToMarketItem[i + 1].seller == msg.sender){
                    uint currentId = idToMarketItem[i+1].itemId; 
                    MarketItem storage currentItem = idToMarketItem[currentId];
                    item[currentIndex] = currentItem;
                    currentIndex += 1;
                }
            }
            return items;
        }
    } 
}