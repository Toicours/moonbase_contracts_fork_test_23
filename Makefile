-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil

# Default network is anvil, but you can override it with `make deploy NETWORK=sepolia or mainnet`
NETWORK ?= anvil

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network mainnet\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make fund ARGS=\"--network mainnet\""

all: clean update build

# Clean the repo
clean:
	forge clean

# Update Dependencies
update:
	forge update

build:
	forge build

test:
	forge test

snapshot:
	forge snapshot

format:
	forge fmt

anvil:
	anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1


NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

# Set up network arguments based on the selected network
ifeq ($(NETWORK),base)
	NETWORK_ARGS := --rpc-url $(BASE_RPC_URL) --account deployerKey --sender 0x83C73e1aCa5D406862e0D37Ff87A1175AFCefa5e --broadcast --verify --optimizer-runs 200  --etherscan-api-key $(BASESCAN_API_KEY) -vvvv
else ifeq ($(NETWORK),base_goerli)
	NETWORK_ARGS := --rpc-url $(BASE_GOERLI_RPC_URL) --account deployerKey --sender 0x83C73e1aCa5D406862e0D37Ff87A1175AFCefa5e --broadcast --verify --optimizer-runs 200 --etherscan-api-key $(BASESCAN_API_KEY) -vvvv
else ifeq ($(NETWORK),scroll)
	NETWORK_ARGS := --rpc-url $(SCROLL_RPC_URL) --account deployerKey --sender 0x83C73e1aCa5D406862e0D37Ff87A1175AFCefa5e --broadcast --verify --verifier blockscout --verifier-url https://blockscout.scroll.io/api\? --optimizer-runs 200 -vvvv
else ifeq ($(NETWORK),scroll_sepolia)
	NETWORK_ARGS := --rpc-url $(SCROLL_RPC_URL) --account deployerKey --sender 0x83C73e1aCa5D406862e0D37Ff87A1175AFCefa5e --broadcast --verify --verifier blockscout --verifier-url https://sepolia-blockscout.scroll.io/api\? --optimizer-runs 200 -vvvv
else
# If not mainnet, use default values or other network configurations
	NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast
endif

# Deploy the contract using the network arguments
deploy:
	@echo "Using network arguments: $(NETWORK_ARGS)"
	forge script script/DeployScript.s.sol:DeployScript $(NETWORK_ARGS)
