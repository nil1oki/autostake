#!/bin/bash
GREEN_COLOR='\033[0;32m'
RED_COLOR='\033[0;31m'
WITHOU_COLOR='\033[0m'
DELEGATOR_ADDRESS='deweb18t66ve30sdl7szas5kq5j2ms0ugkrasx0cwaf9'
VALIDATOR_ADDRESS='dewebvaloper18t66ve30sdl7szas5kq5j2ms0ugkrasxualqtx'
DELAY=86400 #in secs - how often restart the script 
ACC_NAME=Niloki #example: = ACC_NAME=wallet_qwwq_54
NODE="tcp://localhost:14657" #change it only if you use another rpc port of your node
CHAIN_NAME=deweb-testnet-sirius

for (( ;; )); do
        echo -e "Get reward from Delegation"
        echo -e "${PWD}\ny\n" | dewebd tx distribution withdraw-rewards ${VALIDATOR_ADDRESS} --chain-id ${CHAIN_NAME} --from ${ACC_NAME} --gas=auto --fees=2000udws --commission --node ${NODE} --yes

        for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOUT_COLOR} sec\r" $timer
                sleep 1
        done
 
        BAL=$(dewebd q bank balances ${DELEGATOR_ADDRESS} --node ${NODE} -o json | jq -r '.balances | .[].amount')
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} utollo\n"

        echo -e "Claim rewards\n"
        echo -e "${PWD}\n${PWD}\n" | dewebd tx distribution withdraw-all-rewards --from ${ACC_NAME} --chain-id ${CHAIN_NAME} --gas=auto --fees=1000udws --node ${NODE} --yes
        for (( timer=30; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done
        BAL=$(dewebd q bank balances ${DELEGATOR_ADDRESS} --node ${NODE} -o json | jq -r '.balances | .[].amount');
        BAL=$(($BAL-1000000))
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} utollo\n"
        echo -e "Stake ALL\n"
        if (( BAL > 1000000 )); then
        echo -e "${PWD}\n${PWD}\n" | dewebd tx staking delegate ${VALIDATOR_ADDRESS} ${BAL}udws --from ${ACC_NAME} --gas=auto --fees=1000udws --node ${NODE} --chain-id ${CHAIN_NAME}  --yes
        else
        echo -e "BALANCE: ${GREEN_COLOR}${BAL}${WITHOU_COLOR} utollo BAL < 10000000 ((((\n"
        fi
        for (( timer=${DELAY}; timer>0; timer-- ))
        do
                printf "* sleep for ${RED_COLOR}%02d${WITHOU_COLOR} sec\r" $timer
                sleep 1
        done       

done
