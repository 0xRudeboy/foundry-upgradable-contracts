// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console2} from "forge-std/Test.sol";
import {DeployBox} from "script/DeployBox.s.sol";
import {UpgradeBox} from "script/UpgradeBox.s.sol";
import {BoxV1} from "src/BoxV1.sol";
import {BoxV2} from "src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER = makeAddr("owner");

    address public proxy;
    BoxV2 public boxV2;

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();

        proxy = deployer.run(); // right now points to boxV1 as the implementation
    }

    function test_ProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7);
    }

    function test_Upgrades() public {
        BoxV2 box2 = new BoxV2();

        upgrader.upgradeBox(address(proxy), address(box2));

        uint256 expectedValue = 2;

        assertEq(BoxV2(proxy).version(), expectedValue);

        BoxV2(proxy).setNumber(7);

        assertEq(BoxV2(proxy).getNumber(), 7);

        console2.log("Proxy:", proxy);
    }
}
