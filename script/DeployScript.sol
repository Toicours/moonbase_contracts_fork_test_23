// SPDX-License-Identifier: MIT

pragma solidity >=0.8.;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {UniswapV2Factory} from "../src/exchange/UniswapV2Factory.sol";
import {UniswapV2Pair} from "../src/exchange/UniswapV2Pair.sol";

contract DeployScript is Script {
    uint256 public constant INITIAL_SUPPLY = 100_000 ether; // 100k tokens with 18 decimal places
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    address public deployerKey;

    function run() external {
        if (block.chainid == 31337) {
            deployerKey = vm.envAddress(
                "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
            );
        } else {
            deployerKey = vm.envAddress("DEPLOYER_ADDRESS");
        }

        vm.startBroadcast(deployerKey);
        // Deploy Factory contract with deployerKey as feeToSetter
        // UniswapV2Factory uniswapV2Factory = new UniswapV2Factory(deployerKey);
    }
}
