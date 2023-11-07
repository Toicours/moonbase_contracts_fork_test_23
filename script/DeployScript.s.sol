// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

import {UniswapV2Factory} from "../src/exchange/UniswapV2Factory.sol";
import {UniswapV2Router} from "../src/exchange/UniswapV2Router.sol";
import {CheeseToken} from "../src/farm/CheeseToken.sol";
import {MoonChef} from "../src/farm/MoonChef.sol";

contract DeployScript is Script {
    uint256 public constant INITIAL_SUPPLY = 100_000 ether; // 100k tokens with 18 decimal places
    uint256 public DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    address public s_deployerKey;
    address public weth;

    function run() external {
        // Log the current chain ID
        console.log("Current chain ID:", block.chainid);
        HelperConfig helperConfig = new HelperConfig();
        (weth, s_deployerKey) = helperConfig.activeNetworkConfig();
        vm.startBroadcast(s_deployerKey);
        // Deploy Factory contract with deployerKey as feeToSetter
        UniswapV2Factory uniswapV2Factory = new UniswapV2Factory(s_deployerKey);
        UniswapV2Router uniswapV2Router = new UniswapV2Router(
            address(uniswapV2Factory),
            weth
        );
        CheeseToken cheeseToken = new CheeseToken();
        MoonChef moonChef = new MoonChef(
            cheeseToken,
            s_deployerKey,
            s_deployerKey,
            115000000000000000000
        );
        vm.stopBroadcast();
    }
}
