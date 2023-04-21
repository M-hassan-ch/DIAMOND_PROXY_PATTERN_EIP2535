// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { LibFacetB } from  "../libs/LibFacetB.sol";
import { LibFacetA } from  "../libs/LibFacetA.sol";

contract FacetB{
    
    function setMessage() public {
        require(LibFacetA._getBalance(msg.sender) > 0, "FacetB: insufficient balance");
        LibFacetB._setMessage("balance > 0");
    }

    function getMessage() public view returns (string memory) {
        return LibFacetB._getMessage(); 
    }
    
}