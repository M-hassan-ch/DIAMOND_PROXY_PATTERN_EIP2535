// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { LibFacetA } from  "../libs/LibFacetA.sol";

contract FacetA {
    
    function increaseBalance() public {
        LibFacetA._increaseBalance(msg.sender, 1);
    }

     function getBalance() public view returns (uint256) {
        return LibFacetA._getBalance(msg.sender); 
    }
    
}