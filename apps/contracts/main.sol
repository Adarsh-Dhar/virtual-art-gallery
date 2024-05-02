// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//INTERNAL IMPORT FOR NFTOPENZEPPELINE 
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage {

    uint256 private _tokenIds;
    uint256 private _itemsSold;
    uint256 listPrice = 0.000000000000000001 ether;


address payable owner ;

    constructor() ERC721("NFTMarketPlace" , "NFTM"){

        
        owner = payable(msg.sender);
    }

    struct ListedToken {
        uint256 tokenId;
        address payable owner;
        address payable seller;
        uint256 price;
        bool currentlyListed;
    }
    mapping(uint256 => ListedToken) private idToListedToken;

    

    function updateListPrice(uint256 _listPrice) public payable {
        require (owner == msg.sender, "List price update can be only done by owner of NFT") ;
        listPrice = _listPrice;
    }

    function getListPrice() public view returns (uint256) {
        return listPrice ;
    }

    function getCurrentToken() public view returns (uint256) {
        return _tokenIds;
    }

    function getLatestIdToListedToken() public view returns (ListedToken memory){
        return idToListedToken[_tokenIds];
    }

    function getListedForTokenId(uint256 tokenId) public view returns (ListedToken memory){
        return idToListedToken[tokenId];
    }

    function createToken (string memory tokenURI, uint256 price) public payable returns (uint) {
        require(msg.value == listPrice , "send enough eth to buy this nft");

        _tokenIds++;

        uint256 currentTokenId = _tokenIds ;
        _safeMint(msg.sender, currentTokenId);
        _setTokenURI(currentTokenId, tokenURI);

        createListedToken(currentTokenId , price);
        return currentTokenId ;
    } 

    function createListedToken(uint256 tokenId , uint256 price) private {
        idToListedToken[tokenId] = ListedToken(
            tokenId,
            payable(address(this)),
            payable(msg.sender),
            price,
            true
        ) ;

        _transfer(msg.sender, address(this), tokenId);
    }

    function getAllNFTs() public view returns (ListedToken[] memory){
       uint nftcount = _tokenIds ;
       ListedToken[] memory tokens = new ListedToken[] (nftcount) ;
       uint currentIndex = 0;

       for(uint i = 0; i < nftcount; i++) {
        uint currentId = i+1;
        ListedToken storage currentItem = idToListedToken[currentId];
        tokens[currentIndex] = currentItem ;
        currentIndex ++;
       }
       return tokens ;
    }

    function getMyNFTs() public view returns (ListedToken[] memory){
       
       uint totalItemCount = _tokenIds ;
       uint itemCount = 0;
       uint currentIndex = 0;


       for(uint i =0 ; i< totalItemCount ; i++){
        if(idToListedToken[i+1].owner == msg.sender || idToListedToken[i+1].seller == msg.sender ){
            itemCount ++;
        }
       }

       ListedToken[] memory items = new ListedToken[] (itemCount) ;

       for(uint i = 0; i < totalItemCount; i++) {
        if(idToListedToken[i+1].owner == msg.sender || idToListedToken[i+1].seller == msg.sender){
                    uint currentId = i+1;
                    ListedToken storage currentItem = idToListedToken[currentId];
                    items[currentIndex] = currentItem ;
                    currentIndex ++;
        }
        
       }

       return items ;
    }


    function executeSale(uint256 tokenId) public payable {
       uint price = idToListedToken[tokenId].price ;

       require(msg.value == price , "please provide correct amount to make the sale") ;

       address seller = idToListedToken[tokenId].seller;
       idToListedToken[tokenId].currentlyListed = true;
       idToListedToken[tokenId].seller = payable(msg.sender) ;
       _itemsSold ++ ;

       _transfer(address(this), msg.sender, tokenId);

       approve(address(this), tokenId);

       payable(owner).transfer(listPrice);
       payable(seller).transfer(msg.value);
    }


    
}

