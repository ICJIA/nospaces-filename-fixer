# NoSpaces File Utility

A bash utility script for cleaning up filenames by replacing spaces with underscores, removing quotes, and setting appropriate file permissions.

## Technical Requirements
- **Operating System**: Linux-based systems
- **Permissions**: Requires sudo access for global installation
- **Dependencies**: No external dependencies beyond core utilities

**Important**: This utility has been extensively tested in Ubuntu 22.04 running in Windows WSL2 environment and is confirmed to work reliably in this configuration.

## Features

- Replaces spaces with underscores in filenames
- Removes single and double quotes from filenames
- Sets file permissions to 777 (rwxrwxrwx)
- Includes safety checks to prevent overwriting existing files
- Requires user confirmation before renaming

## Installation

### System-wide Installation (requires sudo)

Make the script available to all users on the system:

```bash
chmod +x nospaces.sh
sudo cp nospaces.sh /usr/local/bin/nospaces
```

Verify installation:
```bash
which nospaces
```

### User-specific Installation (no sudo required)

To make the script executable from anywhere in your home directory without sudo privileges:

1. Create a bin directory in your home if it doesn't exist:

```bash
mkdir -p ~/bin
```

2. Copy the script to your bin directory and make it executable:

```bash
cp nospaces.sh ~/bin/nospaces
chmod +x ~/bin/nospaces
```

3. Add your bin directory to your PATH if it's not already there. Add this to your `~/.bashrc` or `~/.bash_profile`:

```bash
export PATH="$HOME/bin:$PATH"
```

4. Apply the changes:

```bash
source ~/.bashrc  # or source ~/.bash_profile
```

5. Verify installation:

```bash
which nospaces
```

Now you can run `nospaces` from anywhere in your home directory.

## Usage

```bash
nospaces <filename>
```

### Examples

```bash
nospaces "my file.txt"        # -> my_file.txt
nospaces "user's file.txt"    # -> users_file.txt
nospaces "my \"quoted\" file" # -> my_quoted_file
```

## Exit Codes

- 0: Success (file renamed or no action needed)
- 1: Error (missing argument, file not found, target exists)

## Testing

The utility comes with a comprehensive test script (`test_nospaces.sh`) that verifies its functionality across various scenarios:

### Test Cases

1. **Simple spaces**: Tests basic space replacement (`file with spaces.txt` → `file_with_spaces.txt`)
2. **Single quotes**: Tests removal of apostrophes (`file's with quotes.txt` → `files_with_quotes.txt`)
3. **Double quotes**: Tests removal of double quotes (`file "quoted" name.txt` → `file_quoted_name.txt`)
4. **Mixed quotes**: Tests handling of both quote types (`file's "mixed" quotes.txt` → `files_mixed_quotes.txt`)
5. **Leading/trailing spaces**: Tests trimming of leading spaces and handling of trailing spaces (` space at ends .txt` → `space_at_ends_.txt`)
6. **Multiple consecutive spaces**: Tests handling of multiple spaces (`multiple   spaces.txt` → `multiple___spaces.txt`)
7. **Special characters**: Tests preservation of special characters (`special!@#$%^&*()_+.txt` → `special!@#$%^&*()_+.txt`)
8. **Extension with spaces**: Tests handling spaces in file extensions (`file name.text file` → `file_name.text_file`)
9. **Unicode characters**: Tests handling of non-ASCII characters (`üñíçødé file.txt` → `üñíçødé_file.txt`)
10. **Only quotes**: Tests handling files with only quotes (`''""'.txt` → `.txt`)

### Running Tests

```bash
chmod +x test_nospaces.sh
./test_nospaces.sh
```

The test script creates a temporary directory with test files, runs the utility on each file, and verifies both the renaming and permission setting functionality.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.