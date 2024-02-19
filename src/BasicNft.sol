// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    // token counter predstavlja tj cuva svaki tokenid koji posedujemo
    uint256 private s_tokenCounter;

    // mapping gde ce maping da uzme tokenId i izbaci token uri
    mapping(uint256 => string) private s_tokenIdToUri;

    constructor() ERC721("Doggie", "DOG") {
        // pocinje od 0 pa cemo stalno da ga update kad god mintujemo nov nft
        s_tokenCounter = 0;
    }

    // kreiramo mint gde ljudi koji mintuju mogu da izaberu koje ce kucence uzmu tako sto ce sami da izaberu token uri
    function mintNft(string memory tokenUri) public {
        // konvertujemo id to uri iz counter jer on cuva sve token id-jeve
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        // koristimo safe mint da mintujemo
        _safeMint(msg.sender, s_tokenCounter);
        // updejtujemo counter
        s_tokenCounter++;
    }

    // kreiramo token uri
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        // vracamo token uri (metadata od tog tokena) od tog tokenId-ja
        return s_tokenIdToUri[tokenId];
    }
}
