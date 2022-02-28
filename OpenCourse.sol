// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BscNFT.sol";

contract Market {
    address private BFTaddress; // BscNFT address

/// platform 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

/// creater 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

/// student 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db

// newOwner 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB

    mapping(uint256 => uint256) public subscriptionPrice; // tokenId => subscription price

    //To be revised later
    mapping(string => uint256) private distributionRatio; // distribution ratio;  

    mapping(address => mapping(uint256 => uint256)) subscriptionHistory; // address => tokenId => date of purchase

    constructor(address _BFTaddress) {
        BFTaddress = _BFTaddress; // BscNFT address
        setApproveAddress(address(this)); // set the Market address to approve
        //distributionRatio initialization
        distributionRatio["creater"] = 10;
        distributionRatio["owner"] = 80;
        distributionRatio["seller"] = 90;
        distributionRatio["broker"] = 10;
    }

    // set the Market address to approve
    function setApproveAddress(address _Marketaddress) private {
        BscNFT _BFT = BscNFT(BFTaddress);
        _BFT.setApproveAddress(_Marketaddress);
    }

    // Mint NFT  --clear
    function MintCourse(string memory _tokenURI, uint256 _price) public {
        BscNFT _BFT = BscNFT(BFTaddress);
        uint256 newTokenId = _BFT.createToken(_tokenURI,msg.sender);
        subscriptionPrice[newTokenId] = _price * 10 ** 18;
    }

    // Subscript Course --clear
    function subscriptCourse(uint256 _tokenId) public payable{
        BscNFT _BFT = BscNFT(BFTaddress);
        address owner = _BFT.ownerOf(_tokenId);
        address creater  =_BFT.getOwnerHistory(_tokenId)[0];
        uint256 price = subscriptionPrice[_tokenId];

        require(_tokenId > 0 && _tokenId <= _BFT.getCount(), "Does not exists the tokenId");
        require(msg.sender != owner, "You are Seller, Seller cannot puchase");
        require(price > 0, "Does not sales the token");
        require(msg.value == price, "Incorrected amount");
        
        payable(owner).transfer((msg.value * distributionRatio["owner"])/100);
        payable(creater).transfer((msg.value * distributionRatio["creater"])/100);
        subscriptionHistory[msg.sender][_tokenId] = block.timestamp;
    }

    //  Sell NFT --clear
        function sellCourse(uint256 _tokenId, uint256 _price) public{
            BscNFT _BFT = BscNFT(BFTaddress);
            _BFT.salesToken(_tokenId,_price, msg.sender);
        }

    //  buy NFT --clear
        function buyCourse(uint256 _tokenId) public payable {
        BscNFT _BFT = BscNFT(BFTaddress);
        address seller = _BFT.ownerOf(_tokenId);
        uint256 price = _BFT.getTokenPrice(_tokenId);
        require(_tokenId > 0 && _tokenId <= _BFT.getCount(), "Does not exists the tokenId");
        require(msg.sender != seller, "You are Seller, Seller cannot puchase");
        require(price > 0, "Does not sales the token");
        require(msg.value == price, "Incorrected amount");
        
        // edit myTokenList and ownerhistory
        _BFT.editList(_tokenId, msg.sender);

        // payment od price
        // payable(seller).call{value: msg.value}(""); // return type is bool

        payable(seller).transfer((msg.value * distributionRatio["seller"])/100);
        // transfer the token from seller to buyer
        _BFT.sendToken(_tokenId, msg.sender);
    }

    function getSubscriptionPrice(uint256 tokenId) public view returns (uint256){
        return subscriptionPrice[tokenId];
    }

    function getSubscriptionHistory(uint256 tokenId) public view returns (uint256){
        return subscriptionHistory[msg.sender][tokenId];
    }


    // reset subscription price
    function setSubscriptionPrice(uint256 tokenId,uint256 price) public{
        BscNFT _BFT = BscNFT(BFTaddress);
        address owner = _BFT.ownerOf(tokenId);
        require(tokenId > 0 && tokenId <= _BFT.getCount(), "Does not exists the tokenId");
        require(price > 0, "Price must be greater than zero.");
        require(msg.sender == owner, "You are Owner");
        subscriptionPrice[tokenId] = price * 10 ** 18;
    }

    // withdrawal

    // get market balance 
    function getMarketBalance() public view returns(uint256) {
        return address(this).balance;
    }


    // fee controller





    // get contract balance



}