// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import "../src/VRFSignatured.sol";

contract VRFLottery is VRFSignatured {
    constructor(address _vrfSigner) payable VRFSignatured(_vrfSigner) {}

    function claim(uint256 _randomness, bytes memory _signature) public {
        verifyRandomness(_randomness, _signature);
        // sends all balance to the sender
        payable(msg.sender).transfer(address(this).balance);
    }
}

contract VRFSignaturedTest is Test {
    VRFLottery lottery;

    address constant ALICE = 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf;
    address constant BOB = address(0x2000);

    function setUp() public {
        deal(address(this), 1 ether);
        lottery = new VRFLottery{value: 1 ether}(ALICE);
    }

    function testVerifyRandomness() public {
        // signed keccak256(BOB, 1337) by ALICE
        bytes memory signature = hex"dcc3b0537e3a80e9f7fc2343ce8db13bdebabb8472190a7fe2b8978e83f9d5011bdfc1ec502201f0d4c3f9c9f64ead60ca80b4d6f0ea4e477ff858080c0756361c";

        vm.startPrank(BOB);
        lottery.claim(1337, signature);

        assertEq(payable(address(lottery)).balance, 0);
        assertEq(payable(BOB).balance, 1 ether);
        vm.stopPrank();
    }

    function testCannotVerifyRandomnessTwice() public {
        // signed keccak256(BOB, 1337) by ALICE
        bytes memory signature = hex"dcc3b0537e3a80e9f7fc2343ce8db13bdebabb8472190a7fe2b8978e83f9d5011bdfc1ec502201f0d4c3f9c9f64ead60ca80b4d6f0ea4e477ff858080c0756361c";

        vm.startPrank(BOB);
        lottery.claim(1337, signature);
        vm.stopPrank();

        vm.startPrank(BOB);
        vm.expectRevert(abi.encodeWithSignature("DirtySignature()"));
        lottery.claim(1337, signature);
        vm.stopPrank();
    }

    function testCannotVerifyInvalidSIgnature() public {
        bytes memory signature = hex"ABCDb0537e3a80e9f7fc2343ce8db13bdebabb8472190a7fe2b8978e83f9d5011bdfc1ec502201f0d4c3f9c9f64ead60ca80b4d6f0ea4e477ff858080c0756361c";

        vm.startPrank(BOB);
        vm.expectRevert(abi.encodeWithSignature("InvalidSignature()"));
        lottery.claim(1337, signature);
        vm.stopPrank(); 
    }
}
