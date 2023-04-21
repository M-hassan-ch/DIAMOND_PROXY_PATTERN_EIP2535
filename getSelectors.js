const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  
  describe("Lock", function () {
    async function deployA() {
  
      const Lock = await ethers.getContractFactory("FacetA");
      const lock = await Lock.deploy();
      await lock.deployed;
  
      return lock;
    }
  
    async function deployB() {
  
      const Lock = await ethers.getContractFactory("FacetB");
      const lock = await Lock.deploy();
      await lock.deployed;
  
      return lock;
    }
  
    function getSelectors(contract) {
      const signatures = Object.keys(contract.interface.functions)
      
      const selectors = signatures.reduce((acc, val) => {
        acc.push(contract.interface.getSighash(val))
        return acc
      }, [])
      return selectors
    }
  
  
    describe("Deployment", function () {
      it("Should set the right unlockTime", async function () {
        const lock = await loadFixture(deployB);
        console.log(getSelectors(lock));
      });
  
    });
  
    
  });
  