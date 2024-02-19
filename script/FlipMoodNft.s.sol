// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "lib/forge-std/src/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

contract FlipMoodNft is Script {
    MoodNft moodNft;

    function run() external returns (MoodNft) {
        // one way is to hardcode sad and happy svg like in our tests but I will use another way here
        // we will read it directly from svg files
        string memory sadSvg = vm.readFile("./img/sad.svg");
        string memory happySvg = vm.readFile("./img/happy.svg");

        // kreiramo nov deploy s moodNft koji sadrzi hardcodovane podatke od happy and sad svg
        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
            svgToImageURI(sadSvg),
            svgToImageURI(happySvg)
        );
        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        // u sustini dajemo mu onaj kod od slike iz img folder
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
    function flipMood(uint256 tokenId) public {
        moodNft.flipMood(tokenId);
    }
}