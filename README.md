# MainEntrance

# Main Function Implementation Guide Across Programming Languages

This comprehensive guide demonstrates how program entry points (main functions) are implemented across different programming languages, including various styles, patterns, and best practices.

## Table of Contents
- [Compiled Languages](#compiled-languages)
- [Interpreted Languages](#interpreted-languages)
- [JVM Languages](#jvm-languages)
- [Modern Languages](#modern-languages)
- [Systems Programming](#systems-programming)
- [Scripting Languages](#scripting-languages)
- [Functional Languages](#functional-languages)
- [Historical Languages](#historical-languages)

## Compiled Languages

### C
```c
#include <stdio.h>

/* Traditional style */
int main(void) {
    printf("Hello, World!\n");
    return 0;
}

/* With command line arguments */
int main(int argc, char *argv[]) {
    for (int i = 0; i < argc; i++) {
        printf("Argument %d: %s\n", i, argv[i]);
    }
    return 0;
}
```

### C++
```cpp
#include <iostream>
#include <vector>
#include <string>

// Modern C++ style
int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}

// With command line arguments and exceptions
int main(int argc, char* argv[]) try {
    std::vector<std::string> args(argv, argv + argc);
    for (const auto& arg : args) {
        std::cout << arg << '\n';
    }
    return 0;
} catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << std::endl;
    return 1;
}

// With exit codes
namespace {
    constexpr int SUCCESS = 0;
    constexpr int ERROR_INVALID_ARGS = 1;
    constexpr int ERROR_FILE_NOT_FOUND = 2;
}

int main() {
    // ... error handling with specific codes
    return SUCCESS;
}
```

### Go
```go
package main

import (
    "flag"
    "fmt"
    "os"
)

// Simple version
func main() {
    fmt.Println("Hello, World!")
}

// With command line flags and error handling
func main() {
    // Define flags
    verbose := flag.Bool("verbose", false, "Enable verbose output")
    name := flag.String("name", "", "Your name")
    flag.Parse()

    // Setup error handling
    if err := run(*verbose, *name); err != nil {
        fmt.Fprintf(os.Stderr, "error: %v\n", err)
        os.Exit(1)
    }
}

func run(verbose bool, name string) error {
    if verbose {
        fmt.Printf("Running in verbose mode\n")
    }
    if name == "" {
        return fmt.Errorf("name is required")
    }
    fmt.Printf("Hello, %s!\n", name)
    return nil
}
```

### Rust
```rust
use std::env;
use std::process;

// Simple version
fn main() {
    println!("Hello, World!");
}

// With error handling
fn main() {
    if let Err(e) = run() {
        eprintln!("Error: {}", e);
        process::exit(1);
    }
}

// With command line arguments and custom error type
#[derive(Debug)]
enum AppError {
    InvalidArgument(String),
    IoError(std::io::Error),
}

fn run() -> Result<(), AppError> {
    let args: Vec<String> = env::args().collect();
    
    match args.get(1) {
        Some(name) => println!("Hello, {}!", name),
        None => return Err(AppError::InvalidArgument(
            "Name argument required".to_string()
        )),
    }
    Ok(())
}
```

## Interpreted Languages

### Python
```python
import sys
import argparse
from typing import List, Optional

# Simple version
def main() -> None:
    print("Hello, World!")

# With type hints and argument parsing
def main(argv: Optional[List[str]] = None) -> int:
    parser = argparse.ArgumentParser(description="Sample program")
    parser.add_argument("--name", required=True, help="Your name")
    parser.add_argument("--verbose", action="store_true", help="Increase output verbosity")
    
    args = parser.parse_args(argv)
    
    try:
        if args.verbose:
            print(f"Running with arguments: {args}")
        print(f"Hello, {args.name}!")
        return 0
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1

# Module guard pattern
if __name__ == "__main__":
    sys.exit(main())

# Async version
import asyncio

async def async_main() -> None:
    print("Starting async operation...")
    await asyncio.sleep(1)
    print("Completed!")

if __name__ == "__main__":
    asyncio.run(async_main())
```

### Ruby
```ruby
# Simple version
def main
  puts "Hello, World!"
end

# With argument parsing and error handling
require 'optparse'

def main
  options = parse_options
  
  begin
    run(options)
  rescue StandardError => e
    warn "Error: #{e.message}"
    exit 1
  end
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options]"
    
    opts.on("-n", "--name NAME", "Your name") do |name|
      options[:name] = name
    end
    
    opts.on("-v", "--verbose", "Run verbosely") do
      options[:verbose] = true
    end
  end.parse!
  
  options
end

def run(options)
  puts "Running verbosely" if options[:verbose]
  puts "Hello, #{options[:name] || 'World'}!"
end

if __FILE__ == $0
  main
end
```

## JVM Languages

### Java
```java
import java.util.Arrays;
import java.util.Optional;
import java.util.logging.Logger;

// Simple version
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}

// Modern Java with logging and error handling
public class Application {
    private static final Logger LOGGER = Logger.getLogger(Application.class.getName());

    public static void main(String[] args) {
        try {
            int exitCode = new Application().run(args);
            System.exit(exitCode);
        } catch (Exception e) {
            LOGGER.severe("Application failed: " + e.getMessage());
            System.exit(1);
        }
    }

    private int run(String[] args) {
        Optional<String> name = Arrays.stream(args)
            .findFirst();

        name.ifPresentOrElse(
            n -> LOGGER.info("Hello, " + n + "!"),
            () -> LOGGER.warning("No name provided")
        );

        return 0;
    }
}
```

### Kotlin
```kotlin
import kotlinx.cli.*

// Simple version
fun main() {
    println("Hello, World!")
}

// With argument parsing and coroutines
import kotlinx.coroutines.*

suspend fun main(args: Array<String>) = coroutineScope {
    val parser = ArgParser("example")
    val name by parser.option(
        ArgType.String,
        shortName = "n",
        description = "Your name"
    )
    val verbose by parser.option(
        ArgType.Boolean,
        shortName = "v",
        description = "Enable verbose mode"
    )
    
    parser.parse(args)
    
    launch {
        if (verbose == true) {
            println("Running in verbose mode")
        }
        println("Hello, ${name ?: "World"}!")
    }
}
```

### Scala
```scala
// Simple version
object Main extends App {
  println("Hello, World!")
}

// With argument parsing and error handling
import scala.util.{Try, Success, Failure}

object Application extends App {
  case class Config(name: String = "", verbose: Boolean = false)
  
  def parseArgs(args: Array[String]): Try[Config] = Try {
    val parser = new scopt.OptionParser[Config]("app") {
      opt[String]('n', "name")
        .action((x, c) => c.copy(name = x))
        .text("Your name")
      
      opt[Unit]('v', "verbose")
        .action((_, c) => c.copy(verbose = true))
        .text("Enable verbose mode")
    }
    
    parser.parse(args, Config()) match {
      case Some(config) => config
      case None => throw new IllegalArgumentException("Failed to parse arguments")
    }
  }
  
  parseArgs(args) match {
    case Success(config) =>
      if (config.verbose) println("Running in verbose mode")
      println(s"Hello, ${if (config.name.isEmpty) "World" else config.name}!")
    case Failure(e) =>
      System.err.println(s"Error: ${e.getMessage}")
      System.exit(1)
  }
}
```

## Modern Languages

### TypeScript (Node.js)
```typescript
#!/usr/bin/env node

// Simple version
function main(): void {
    console.log("Hello, World!");
}

// With argument parsing and async/await
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

interface Arguments {
    name: string;
    verbose: boolean;
}

async function main(): Promise<number> {
    try {
        const argv = await yargs(hideBin(process.argv))
            .option('name', {
                alias: 'n',
                type: 'string',
                description: 'Your name',
                demandOption: true
            })
            .option('verbose', {
                alias: 'v',
                type: 'boolean',
                description: 'Run verbosely'
            })
            .strict()
            .parse() as Arguments;

        if (argv.verbose) {
            console.log('Running in verbose mode');
        }

        console.log(`Hello, ${argv.name}!`);
        return 0;
    } catch (error) {
        console.error('Error:', error.message);
        return 1;
    }
}

if (require.main === module) {
    main()
        .then(code => process.exit(code))
        .catch(error => {
            console.error('Fatal error:', error);
            process.exit(1);
        });
}
```

### Swift
```swift
// Simple version
func main() {
    print("Hello, World!")
}

// With argument parsing and error handling
import Foundation
import ArgumentParser

struct Application: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "app",
        abstract: "A sample application"
    )
    
    @Option(name: .shortAndLong, help: "Your name")
    var name: String
    
    @Flag(name: .shortAndLong, help: "Run verbosely")
    var verbose = false
    
    func run() throws {
        if verbose {
            print("Running in verbose mode")
        }
        print("Hello, \(name)!")
    }
}

// Entry point
Application.main()
```

## Systems Programming

### Assembly (x86_64)
```nasm
; Linux x86_64 Assembly
section .data
    msg db "Hello, World!", 0xa
    len equ $ - msg

section .text
    global _start

_start:
    ; Write the message
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg        ; message
    mov rdx, len        ; length
    syscall

    ; Exit
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; status: 0
    syscall
```

## Scripting Languages

### Perl
```perl
#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;

# Simple version
sub main {
    print "Hello, World!\n";
}

# With argument parsing and error handling
sub main {
    my %opts;
    GetOptions(
        \%opts,
        'name=s',
        'verbose',
        'help|h',
    ) or pod2usage(2);
    
    pod2usage(1) if $opts{help};
    
    eval {
        run(\%opts);
    };
    if ($@) {
        die "Error: $@\n";
    }
}

sub run {
    my ($opts) = @_;
    print "Running verbosely\n" if $opts->{verbose};
    printf "Hello, %s!\n", $opts->{name} || 'World';
}

main() unless caller();

__END__

=head1 NAME

script.pl - Sample application

=head1 SYNOPSIS

script.pl [options]

 Options:
   --name      Your name
   --verbose   Run verbosely
   --help      Show this message
```

### Bash
```bash
#!/usr/bin/env bash

# Exit on error, undefined vars, and pipe failures
set -euo pipefail

# Simple version
main() {
    echo "Hello, World!"
}

# With argument parsing and error handling
usage() {
    cat <<EOF
Usage: ${0##*/} [OPTIONS]

Options:
    -n, --name NAME    Your name
    -v, --verbose      Enable verbose output
    -h, --help         Show this help message
EOF
}

main() {
    local name=""
    local verbose=0

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--name)
                name="$2"
                shift 2
                ;;
            -v|--verbose)
                verbose=1
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                usage >&2
                exit 1
                ;;
        esac
    done

    # Main logic
    [[ $verbose -eq 1 ]] && echo "Running in verbose mode"
    echo "Hello, ${name:-World}!"
}

# Only run if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
```

## Functional Languages

### Haskell
```haskell
module Main where

import System.Environment
import System.Exit
import System.IO
import Control.Monad

-- Simple version
main :: IO ()
main = putStrLn "Hello, World!"

-- With argument parsing and error handling
data Options = Options
    { optName :: String
    , optVerbose :: Bool
    }

defaultOptions :: Options
defaultOptions = Options
    { optName = "World"
    , optVerbose = False
    }

main :: IO ()
main = do
    args <- getArgs
    case parseArgs args defaultOptions of
        Left err -> do
            hPutStrLn stderr $ "Error: " ++ err
            exitFailure
        Right opts -> run opts

parseArgs :: [String] -> Options -> Either String Options


parseArgs [] opts = Right opts

```
## Repo Index

[~Totally toll cars~Totally towed toll cars]<https://www.youtube.com/watch?v=Hd3fEOtomD8>

![car-towed-after-accident (1)](https://github.com/user-attachments/assets/f67d73cb-7dbf-4fbe-ad28-e3a0ba797d49)
