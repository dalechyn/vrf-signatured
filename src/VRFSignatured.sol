// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

abstract contract VRFSignatured {
  address public immutable vrfSigner;
  constructor(address _vrfSigner) {
    vrfSigner = _vrfSigner;
  }

  function verifyRandomness(
    uint256 _randomness,
    bytes memory _signature
  ) public view returns (bool) {
    bytes32 message = keccak256(abi.encodePacked(msg.sender, _randomness));
    return ECDSA.recover(ECDSA.toEthSignedMessageHash(message), _signature) == vrfSigner;
  }
}
