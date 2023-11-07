// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import {Script} from "forge-std/Script.sol";
import {Test, console} from "forge-std/Test.sol";
import {WETH} from "@solmate/src/tokens/WETH.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address weth;
        address deployerKey;
    }

    constructor() {
        if (
            block.chainid == 8453 ||
            block.chainid == 84531 ||
            block.chainid == 84532
        ) {
            activeNetworkConfig = getBaseConfig();
        } else if (block.chainid == 31337) {
            activeNetworkConfig = getAnvilConfig();
        } else {
            revert("Unsupported network");
        }
    }

    function getBaseConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory baseConfig = NetworkConfig({
            weth: address(0x4200000000000000000000000000000000000006),
            deployerKey: vm.envAddress("DEPLOYER_ADDRESS")
        });
        return baseConfig;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        vm.startBroadcast();
        WETH weth = new WETH();
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            weth: address(weth),
            deployerKey: vm.envAddress("ANVIL_ADDRESS")
        });
        return anvilConfig;
    }
}
