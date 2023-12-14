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
        } else if (block.chainid == 534352) {
            activeNetworkConfig = getScrollConfig();
        } else if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaConfig();
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

    function getScrollConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory scrollConfig = NetworkConfig({
            weth: address(0x5300000000000000000000000000000000000004),
            deployerKey: vm.envAddress("DEPLOYER_ADDRESS")
        });
        return scrollConfig;
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

    function getSepoliaConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            weth: address(0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14),
            deployerKey: vm.envAddress("DEPLOYER_ADDRESS")
        });
        return sepoliaConfig;
    }
}
