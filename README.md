# Stresser

A simple Go program to simulate CPU and memory usage for testing purposes.

## Features

- Consume CPU resources by spawning multiple goroutines
- Allocate memory in chunks with configurable size and sleep duration
- Logs detailed information about the resource consumption

## Installation

1. Make sure you have Go installed on your system.
2. Clone this repository:

   ```bash
   git clone https://github.com/enact-it/stresser.git
   ```

3. Navigate to the project directory:

   ```bash
   cd stresser
   ```

## Usage

Run the program with the following command:

```bash
go run main.go [flags]
```

### Flags

- `--cpus`: Number of CPU-consuming goroutines to spawn (default: 1)
- `--mem-total`: Total memory to be consumed (default: "1Mi")
- `--mem-alloc-size`: Amount of memory to be consumed in each step (default: "4Ki")
- `--mem-alloc-sleep`: Duration to sleep between allocations (default: 100ms)

### Example

To simulate consuming 2 CPUs and 1 GiB of memory:

```bash
go run main.go --cpus=2 --mem-total=1Gi
```

## Notes

- The program will run indefinitely until manually terminated.
- Be cautious about running this program on production systems :)

## License

This project is licensed under the [MIT License](LICENSE).
