// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library LibFacetA {
    bytes32 constant LibFacetA_STORAGE_POSITION = keccak256("LibFacetA.facetA.diamond.storage");

    struct Storage {
        mapping(address => uint) balance;
    }

    function getStorage() internal pure returns (Storage storage ds) {
        bytes32 position = LibFacetA_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    function _increaseBalance(address account, uint256 amount) internal {
        Storage storage ds = getStorage();
        ds.balance[account] += amount;
    }

    function _getBalance(address account) internal view returns (uint256) {
        Storage storage ds = getStorage();
        return ds.balance[account];   
    }
}