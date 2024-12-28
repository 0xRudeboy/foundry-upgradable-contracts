// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
// Remember storage is stored in the proxy, not the implementation so contracts that are meant to be used as proxy should not have constructors

// Proxy (borrowing funcs) -> Implementation (if the constructor here were to set a state it would not be stored in the proxy because it runs on deployment)

// So the way it's done should be the following:
// proxy -> deploy implementation -> call some "initializer" function
// Think of the initializer as a constructor for proxies (as we want to store all data over there)

contract BoxV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 internal number;

    /**
     * @notice This is a special case where we can set a constructor that allows us to disable the initializer
     * it is the same as not having a constructor at all but its cleaner and more robust
     */
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        // initializer function typically have a double underscore prefix as seen here
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    /*
    this is where we would usually put auth logic (which we dont need now)

    something like this:

    function _authorizeUpgrade(address newImplementation) internal override {
        require(msg.sender == owner, "Only owner can upgrade");
    }

    if left blank, the proxy will be upgradable by anyone
    */
    function _authorizeUpgrade(address newImplementation) internal override {}
}
