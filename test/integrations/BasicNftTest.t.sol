// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "lib/forge-std/src/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract BasicNftTest is Test {
    // prvo kreiramo setup i ubacujemo deployer i basic nft contracte

    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    // prvo proveravamo dal je ime tacno napisano
    function testNameIsCorrect() public view {
        // nemozemo direktno da poredimo stringove ne preko assert obican nego treba da abi.enkodiramo i hashujemo pa uporedjujemo njihove hasove
        // koristeci keccak256
        string memory expectedName = "Doggie";
        string memory actualName = basicNft.name();

        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    // test da vidimo moze li da mintuje i da ima balans
    function testCanMintAndHaveABalance() public {
        // kreiramo usera fejk adresu i prenkujemo
        vm.prank(USER);
        // stvaramo string odnosno dodajemo adresu tog nftja sto ocemo da mintujemo i preko basicnft ga mintujemo
        // i PUG zauzima polozaj 0 u token URI
        basicNft.mintNft(PUG);

        // proveravamo dal je vrednost usera kad izmintuje jednak s 1 tj da je izmintovao 1 nft
        assert(basicNft.balanceOf(USER) == 1);
        // proveravamo dal je adresa tj string tog nftja na polozaju 0 jednaka sa adresom nftja u nasem contractu (PUG)
        assert(
            keccak256(abi.encodePacked(PUG)) ==
                keccak256(abi.encodePacked(basicNft.tokenURI(0)))
        );
    }
}

// when it is using deployer.run() it is integration test so we put it in integrations
