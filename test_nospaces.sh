#!/bin/bash

# Test script for nospaces.sh
# This script creates test files with various challenging filenames,
# runs nospaces.sh on them, and verifies the results

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Create a temporary test directory
TEST_DIR="./nospaces_test_dir"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || { echo "Failed to create/enter test directory"; exit 1; }

echo -e "${YELLOW}Starting nospaces.sh tests...${NC}"
echo "Test directory: $TEST_DIR"
echo

# Function to create a test file
create_test_file() {
    local filename="$1"
    echo "Test content" > "$filename"
    echo -e "Created test file: '${filename}'"
}

# Function to run a test
run_test() {
    local test_name="$1"
    local filename="$2"
    local expected_result="$3"

    echo -e "\n${YELLOW}Test: $test_name${NC}"
    echo "Original filename: '$filename'"
    echo "Expected result: '$expected_result'"

    # Create the test file
    create_test_file "$filename"

    # Run nospaces.sh with automatic yes response
    echo "y" | ../nospaces.sh "$filename" > /dev/null 2>&1

    # Check if the expected file exists
    if [ -f "$expected_result" ]; then
        echo -e "${GREEN}PASS: File was renamed correctly to '$expected_result'${NC}"
        # Check permissions
        permissions=$(stat -c "%a" "$expected_result")
        if [ "$permissions" = "777" ]; then
            echo -e "${GREEN}PASS: Permissions set correctly to 777${NC}"
        else
            echo -e "${RED}FAIL: Permissions not set to 777, actual: $permissions${NC}"
        fi
    else
        echo -e "${RED}FAIL: File was not renamed to '$expected_result'${NC}"
        # Try to find what it was renamed to, if anything
        possible_file=$(find . -type f -name "*" | grep -v "$filename" | head -1)
        if [ -n "$possible_file" ]; then
            echo -e "${RED}File may have been renamed to: ${possible_file#./}${NC}"
        fi
    fi
}

# Test cases
echo -e "${YELLOW}Running test cases...${NC}"

# Test 1: Simple spaces
run_test "Simple spaces" "file with spaces.txt" "file_with_spaces.txt"

# Test 2: Single quotes
run_test "Single quotes" "file's with quotes.txt" "files_with_quotes.txt"

# Test 3: Double quotes
run_test "Double quotes" "file \"quoted\" name.txt" "file_quoted_name.txt"

# Test 4: Mixed quotes
run_test "Mixed quotes" "file's \"mixed\" quotes.txt" "files_mixed_quotes.txt"

# Test 5: Leading/trailing spaces
echo -e "\n${YELLOW}Detailed test for leading/trailing spaces${NC}"
filename=" space at ends .txt"
expected_result="space_at_ends_.txt"

echo "Creating test file: '$filename'"
create_test_file "$filename"

echo "Running nospaces.sh with debug output:"
echo "y" | ../nospaces.sh "$filename"

echo "Checking for expected result: '$expected_result'"
if [ -f "$expected_result" ]; then
    echo -e "${GREEN}PASS: File was renamed correctly to '$expected_result'${NC}"
else
    echo -e "${RED}FAIL: File was not renamed to '$expected_result'${NC}"
    echo "Listing all files in directory:"
    ls -la
fi

# Test 6: Multiple consecutive spaces
run_test "Multiple spaces" "multiple   spaces.txt" "multiple___spaces.txt"

# Test 7: Special characters
run_test "Special characters" "special!@#$%^&*()_+.txt" "special!@#$%^&*()_+.txt"

# Test 8: File with spaces and extension with spaces
run_test "Extension with spaces" "file name.text file" "file_name.text_file"

# Test 9: Unicode characters
run_test "Unicode characters" "üñíçødé file.txt" "üñíçødé_file.txt"

# Test 10: File with only quotes
run_test "Only quotes" "''\"\"'.txt" ".txt"

# Clean up
echo -e "\n${YELLOW}Cleaning up test directory...${NC}"
cd ..
rm -rf "$TEST_DIR"

echo -e "\n${GREEN}All tests completed!${NC}"
