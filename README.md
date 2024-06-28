# System Caretaker

System Caretaker is a PowerShell script designed for system maintenance and optimization tasks.

## Features

- **Flush DNS Cache:** Clears the DNS resolver cache.
- **Clean Temporary Files:** Cleans temporary files from the system.
- **Disable Non-essential Services:** Attempts to disable non-essential services.
- **Close Unnecessary Applications:** Closes unnecessary applications.
- **Automate All Tasks:** Performs all tasks automatically.

## Getting Started

### Requirements

- Windows operating system with PowerShell.

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/jose-litium/system-caretaker.git
   ```

2. **Navigate to the directory:**

   ```bash
   cd system-caretaker
   ```

3. **Ensure script location:**

   Move the `SystemCaretaker.ps1` script to `C:\system-caretaker\`.

### Usage

1. **Run the script:**

   Right-click on `SystemCaretaker.ps1` and select `Run with PowerShell`.

### Detailed Instructions

#### Flush DNS Cache

1. **Open System Caretaker.**
2. **Select** the `Flush DNS Cache` checkbox.
3. **Click** the `Perform` button.
4. **Check** the results in the results box.

#### Clean Temporary Files

1. **Open System Caretaker.**
2. **Select** the `Clean Temporary Files` checkbox.
3. **Click** the `Perform` button.
4. **Check** the results in the results box.

#### Disable Non-essential Services

1. **Open System Caretaker.**
2. **Select** the `Disable Non-essential Services` checkbox.
3. **Click** the `Perform` button.
4. **Check** the results in the results box.

#### Close Unnecessary Applications

1. **Open System Caretaker.**
2. **Select** the `Close Unnecessary Applications` checkbox.
3. **Click** the `Perform` button.
4. **Check** the results in the results box.

#### Automate All Tasks

1. **Open System Caretaker.**
2. **Click** the `Automate All Tasks` button.
3. **Check** the results in the results box.

## Important Notes

- The script attempts to close unnecessary applications and disable non-essential services, but some applications or services might require administrative privileges.
- Temporary files that are currently in use might not be deleted.
- The script generates a `report.txt` file in the same directory, containing the detailed log of all actions performed.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Disclaimer

Use this script at your own risk. The author is not responsible for any damage that may occur due to the use of this script.

## Author

José M. Moreno

## Contributions

Contributions are welcome. Please submit a pull request or open an issue to discuss your changes.
```

This version of the README emphasizes the need to move the script to `C:\system-caretaker\` for proper functionality across different systems. It provides clear instructions for users to follow to ensure the script runs correctly in their environment.
```

#### screenshot

![image](https://github.com/jose-litium/System-Caretaker/assets/172591425/bb4be041-b942-4878-b163-52d330bbd5f5)
