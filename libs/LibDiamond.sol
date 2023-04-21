// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

library LibDiamond {
    struct DiamondStorage {
        mapping(bytes4 => FacetAddressAndPosition) selectorToFacetAndPosition;
        mapping(address => FacetFunctionSelectors) facetFunctionSelectors;
        address[] facetAddresses;
        address contractOwner;
    }

    bytes32 constant DIAMOND_STORAGE_POSITION = keccak256("diamond.standard.diamond.storage");

    struct FacetCut {
        address facetAddress;
        bytes4[] functionSelectors;
    }

    struct FacetAddressAndPosition {
        address facetAddress;
        uint96 functionSelectorPosition; 
    }

    struct FacetFunctionSelectors {
        bytes4[] functionSelectors;
        uint256 facetAddressPosition;
    }

    function diamondCut(FacetCut calldata _diamondCut)
    internal
    {
        address facetAddress = _diamondCut.facetAddress;
        bytes4[] memory functionSelectors = _diamondCut.functionSelectors;

        require(functionSelectors.length > 0, "LibDiamondCut: No selectors in facet to cut");
        require(facetAddress != address(0), "LibDiamondCut: Add facet can't be address(0)");

        DiamondStorage storage ds = diamondStorage(); 

        uint96 selectorPosition = uint96(ds.facetFunctionSelectors[facetAddress].functionSelectors.length);

        if (selectorPosition == 0) { 
            _isValidContract(facetAddress, "LibDiamondCut: New facet has no code");
            
            ds.facetFunctionSelectors[facetAddress].facetAddressPosition = ds.facetAddresses.length;
            ds.facetAddresses.push(facetAddress);
        }

        for (uint256 selectorIndex; selectorIndex < functionSelectors.length; selectorIndex++) {
            bytes4 selector = functionSelectors[selectorIndex];
            
            address currentFacetAddressIfAny = ds.selectorToFacetAndPosition[selector].facetAddress;
            require(currentFacetAddressIfAny == address(0), "LibDiamondCut: Can't add function that already exists");

            ds.selectorToFacetAndPosition[selector].functionSelectorPosition = selectorPosition;
            ds.selectorToFacetAndPosition[selector].facetAddress = facetAddress;
            ds.facetFunctionSelectors[facetAddress].functionSelectors.push(selector);

            selectorPosition++;
        }
    }
    
    function setContractOwner(address _newOwner) internal {
        DiamondStorage storage ds = diamondStorage();
        ds.contractOwner = _newOwner;
    }

    function contractOwner() internal view returns (address) {
        return diamondStorage().contractOwner;
    }

    function enforceIsContractOwner() internal view {
        require(msg.sender == contractOwner(), "LibDiamond: Must be contract owner");
    }


    function _isValidContract(address _contract, string memory _errorMessage) private view {
        require(_contract.code.length > 0, _errorMessage);
    }

     function diamondStorage() internal pure returns (DiamondStorage storage ds) {
        bytes32 position = DIAMOND_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }
}