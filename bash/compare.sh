#!/bin/bash

# Function to extract package names from file
extract_package_names() {
    awk '{print $1}' "$1" | sort | uniq
}

# Function to compare two lists and find missing elements
compare_lists() {
    list1=($(extract_package_names "$1"))
    list2=($(extract_package_names "$2"))

    missing_in_list2=()
    missing_in_list1=()

    # Compare lists
    i=0
    j=0
    while [[ $i -lt ${#list1[@]} && $j -lt ${#list2[@]} ]]; do
        if [[ "${list1[$i]}" < "${list2[$j]}" ]]; then
            missing_in_list2+=("${list1[$i]}")
            ((i++))
        elif [[ "${list1[$i]}" > "${list2[$j]}" ]]; then
            missing_in_list1+=("${list2[$j]}")
            ((j++))
        else
            ((i++))
            ((j++))
        fi
    done

    # Any remaining elements in list1 are missing in list2
    while [[ $i -lt ${#list1[@]} ]]; do
        missing_in_list2+=("${list1[$i]}")
        ((i++))
    done

    # Any remaining elements in list2 are missing in list1
    while [[ $j -lt ${#list2[@]} ]]; do
        missing_in_list1+=("${list2[$j]}")
        ((j++))
    done

    # Output results
    printf "Packages missing in list 2:\n"
    printf "%s\n" "${missing_in_list2[@]}"

    printf "\nPackages missing in list 1:\n"
    printf "%s\n" "${missing_in_list1[@]}"
}

# Check if two file names are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <file1> <file2>"
    exit 1
fi

# Check if files exist
if [ ! -f "$1" ]; then
    echo "File $1 does not exist"
    exit 1
fi

if [ ! -f "$2" ]; then
    echo "File $2 does not exist"
    exit 1
fi

compare_lists "$1" "$2"

