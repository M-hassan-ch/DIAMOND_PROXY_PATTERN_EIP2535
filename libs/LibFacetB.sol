// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


library LibFacetB {
    bytes32 constant LibFacetB_STORAGE_POSITION = keccak256("LibFacetB.facetB.diamond.storage");

    struct Storage {
        string message;
    }

    function _setMessage(string memory val) internal{
        Storage storage ds = getStorage();
        ds.message = val;
    }

    function _getMessage() internal view returns (string memory){
        Storage storage ds = getStorage();
        return ds.message;
    }

    function getStorage() internal pure returns (Storage storage ds) {
        bytes32 position = LibFacetB_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }
}