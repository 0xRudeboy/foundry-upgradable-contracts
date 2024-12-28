// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BoxV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
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

    function setNumber(uint256 _number) public {
        number = _number;
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 2;
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
