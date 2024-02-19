// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    //error
    error MoodNft__CantFlipMoodIfNotOwner();


    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    // stavljamo koje ce sve moodove da ima
    enum Mood {
        HAPPY,
        SAD
    }

    // mapiramo te moodove u token id to mood
    mapping(uint256 => Mood) private s_tokenIdToMood;

    // u constructor definisemo slike
    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    // function for minting
    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        // stavljamo da je default happy mood
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    // ovaj baseURI nam vraca data:image/svg+xml;base64, i to kombinujemo s enkodirannu metadatu
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    // funkcija gde cemo da menjamo mood nftja
    function flipMood(uint256 tokenId) public {
        // first we make sure only owner can change mood (mora da bude approved i da je owner)
        if(getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender){
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }

    }

    // function for returning metadata
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        // prvo pravimo string image uri da bi mogli da joj dodelimo happy or sad uri
        string memory imageURI;

        // kreiramo if gde ce moci da bira izmedju sad ili happy image uri
        // uporedjujemo dal je token id jednak happy moody ili ne
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        // kreiramo metadatu
        /* prvo smo kreirali string s informacije ime opis i to,  zatim smo je sve povezali u encodepacked pa smo to pretvorili u bytes
        zatim smo uz pomoc BASE64 encodirali taj bytes objekat i povezali ga s baseURI koji nam daje data i ostalo zatim smo sve to 
        povezali tj enkodirali i vratili kao string*/
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                name(),
                                '", "description": "An NFT that reflects the owners mood.", "attributes": [{"trait_type": "moodiness", "value": 100}], "image": "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
