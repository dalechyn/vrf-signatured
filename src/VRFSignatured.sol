// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

abstract contract VRFSignatured {
  address public immutable vrfSigner;
  mapping (bytes => bool) public dirty;

  error DirtySignature();
  error InvalidSignature();

  constructor(address _vrfSigner) {
    vrfSigner = _vrfSigner;
  }

  function verifyRandomness(
    uint256 _randomness,
    bytes memory _signature
  ) internal {
    if (dirty[_signature]) {
      revert DirtySignature();
    }
    dirty[_signature] = true;
    bytes32 message = keccak256(abi.encodePacked(msg.sender, _randomness));
    if (ECDSA.recover(ECDSA.toEthSignedMessageHash(message), _signature) != vrfSigner) revert InvalidSignature();
  }
}
