#!/bin/bash

rm /tmp/stickycurrentkeys &> /dev/null
echo "PRESS MODS TO INIT" | tee /tmp/stickycurrentkeys

blacklist=${blacklist:=("main")} # keys to ignore
declare -A history
declare -a key_order  # track insertion order


update_keyname() {
    local keyname="$1"
    local value="$2"
    local current="${history[$keyname]:-false,false,false,false,false}"
    local trimmed="${current#*,}"
    history[$keyname]="${trimmed},${value}"

    # track keys and sort alphabetically
    if [[ ! " ${key_order[*]} " =~ " ${keyname} " ]]; then
        key_order+=("$keyname")
        IFS=$'\n' key_order=($(sort <<< "${key_order[*]}")); unset IFS
    fi
}

get_state() {
    local values="$1"
    local last3=$(echo "$values" | cut -d',' -f3-5)
    local last1=$(echo "$values" | cut -d',' -f5)

    if [[ "$last3" == "true,true,false" || "$last3" == "false,true,true" || "$last3" == "true,true,true" ]]; then #hold sends -key at end often
        echo "HOLD"
    elif [[ "$last1" == "true" ]]; then
        echo "LATCH"
    else
        echo "NULL"
    fi
}

format_keyname() {
    local keyname="$1"
    local values="${history[$keyname]:-false,false,false,false,false}"
    local state=$(get_state "$values")
    # local debug="[${values}]"  # debug printing

    case "$state" in
        HOLD)  echo "${keyname^^}" ;; # uppercase
        LATCH) echo "${keyname,,}" ;; # lowercase
        NULL)  printf '%*s' "${#keyname}" | tr ' ' '.' ;; # dots replacement
    esac
}

print_all() {
    local parts=()
    for keyname in "${key_order[@]}"; do
        parts+=("$(format_keyname "$keyname")")
    done
    local output="${parts[*]}"
    echo "$output"
    echo "$output" | tee /tmp/stickycurrentkeys # you could change this to anywhere
}

while IFS= read -r line; do
    symbol="${line:0:1}"
    keyname="${line:1}"

    if [[ " ${blacklist[*]} " =~ " ${keyname} " ]]; then # skip blacklist
        continue
    fi

    if [[ "$symbol" == "+" ]]; then
        value="true"
    else
        value="false"
    fi

    update_keyname "$keyname" "$value"
    print_all
done
