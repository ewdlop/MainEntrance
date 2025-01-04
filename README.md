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

### Joke of the day
[~Totally toll cars~Totally towed toll cars]<https://www.youtube.com/watch?v=Hd3fEOtomD8>

![car-towed-after-accident (1)](https://github.com/user-attachments/assets/f67d73cb-7dbf-4fbe-ad28-e3a0ba797d49)

### Repo List
 
```json
[
    {
        "name":  "-",
        "url":  "https://github.com/ewdlop/-"
    },
    {
        "name":  ".Net-Framework-s--Frameworks-Notes",
        "url":  "https://github.com/ewdlop/.Net-Framework-s--Frameworks-Notes"
    },
    {
        "name":  "123",
        "url":  "https://github.com/ewdlop/123"
    },
    {
        "name":  "1900s--2024-PostModertem",
        "url":  "https://github.com/ewdlop/1900s--2024-PostModertem"
    },
    {
        "name":  "2025",
        "url":  "https://github.com/ewdlop/2025"
    },
    {
        "name":  "333",
        "url":  "https://github.com/ewdlop/333"
    },
    {
        "name":  "3DMaze",
        "url":  "https://github.com/ewdlop/3DMaze"
    },
    {
        "name":  "3dTetris",
        "url":  "https://github.com/ewdlop/3dTetris"
    },
    {
        "name":  "4d-like-games",
        "url":  "https://github.com/ewdlop/4d-like-games"
    },
    {
        "name":  "5dChess",
        "url":  "https://github.com/ewdlop/5dChess"
    },
    {
        "name":  "Advance-Javascript-Note",
        "url":  "https://github.com/ewdlop/Advance-Javascript-Note"
    },
    {
        "name":  "A-Genuine-Conundrum",
        "url":  "https://github.com/ewdlop/A-Genuine-Conundrum"
    },
    {
        "name":  "AI-army-navy-and-airforce",
        "url":  "https://github.com/ewdlop/AI-army-navy-and-airforce"
    },
    {
        "name":  "AIFoodReceipe",
        "url":  "https://github.com/ewdlop/AIFoodReceipe"
    },
    {
        "name":  "AIGeneratedMusic",
        "url":  "https://github.com/ewdlop/AIGeneratedMusic"
    },
    {
        "name":  "AIGeneratedPictures",
        "url":  "https://github.com/ewdlop/AIGeneratedPictures"
    },
    {
        "name":  "AimBotsNotes",
        "url":  "https://github.com/ewdlop/AimBotsNotes"
    },
    {
        "name":  "AI-ML-Computational-Physics-Note",
        "url":  "https://github.com/ewdlop/AI-ML-Computational-Physics-Note"
    },
    {
        "name":  "AITerms",
        "url":  "https://github.com/ewdlop/AITerms"
    },
    {
        "name":  "AI-Tools",
        "url":  "https://github.com/ewdlop/AI-Tools"
    },
    {
        "name":  "AllienSurgey",
        "url":  "https://github.com/ewdlop/AllienSurgey"
    },
    {
        "name":  "AmericanHistoryNote",
        "url":  "https://github.com/ewdlop/AmericanHistoryNote"
    },
    {
        "name":  "AndriodNote",
        "url":  "https://github.com/ewdlop/AndriodNote"
    },
    {
        "name":  "Anti-Raymond",
        "url":  "https://github.com/ewdlop/Anti-Raymond"
    },
    {
        "name":  "Any-vs-AnyType",
        "url":  "https://github.com/ewdlop/Any-vs-AnyType"
    },
    {
        "name":  "Apache-Note",
        "url":  "https://github.com/ewdlop/Apache-Note"
    },
    {
        "name":  "AP-Bioloy-12",
        "url":  "https://github.com/ewdlop/AP-Bioloy-12"
    },
    {
        "name":  "API-Note",
        "url":  "https://github.com/ewdlop/API-Note"
    },
    {
        "name":  "ASCIILesson",
        "url":  "https://github.com/ewdlop/ASCIILesson"
    },
    {
        "name":  "A-supermassive-black-hole",
        "url":  "https://github.com/ewdlop/A-supermassive-black-hole"
    },
    {
        "name":  "AutomataTheory",
        "url":  "https://github.com/ewdlop/AutomataTheory"
    },
    {
        "name":  "Avenging-the-World",
        "url":  "https://github.com/ewdlop/Avenging-the-World"
    },
    {
        "name":  "awesome-RTCCT",
        "url":  "https://github.com/ewdlop/awesome-RTCCT"
    },
    {
        "name":  "AWSEatsGoogleCloud",
        "url":  "https://github.com/ewdlop/AWSEatsGoogleCloud"
    },
    {
        "name":  "AzureCosmosDBNoteApp",
        "url":  "https://github.com/ewdlop/AzureCosmosDBNoteApp"
    },
    {
        "name":  "AzureNote.md",
        "url":  "https://github.com/ewdlop/AzureNote.md"
    },
    {
        "name":  "-Backdoor",
        "url":  "https://github.com/ewdlop/-Backdoor"
    },
    {
        "name":  "Backup",
        "url":  "https://github.com/ewdlop/Backup"
    },
    {
        "name":  "BibleKitApp",
        "url":  "https://github.com/ewdlop/BibleKitApp"
    },
    {
        "name":  "Big-O-N-",
        "url":  "https://github.com/ewdlop/Big-O-N-"
    },
    {
        "name":  "BillionDollarIdeas",
        "url":  "https://github.com/ewdlop/BillionDollarIdeas"
    },
    {
        "name":  "BiographyNotes",
        "url":  "https://github.com/ewdlop/BiographyNotes"
    },
    {
        "name":  "BiologicalChemistryNote",
        "url":  "https://github.com/ewdlop/BiologicalChemistryNote"
    },
    {
        "name":  "BiologyNote",
        "url":  "https://github.com/ewdlop/BiologyNote"
    },
    {
        "name":  "Bitmoji",
        "url":  "https://github.com/ewdlop/Bitmoji"
    },
    {
        "name":  "Blackmarket",
        "url":  "https://github.com/ewdlop/Blackmarket"
    },
    {
        "name":  "Black-People-Yellow-man-arent-work-with-White-man",
        "url":  "https://github.com/ewdlop/Black-People-Yellow-man-arent-work-with-White-man"
    },
    {
        "name":  "Blazor-Asp.Net-Notes",
        "url":  "https://github.com/ewdlop/Blazor-Asp.Net-Notes"
    },
    {
        "name":  "BlockChainDevelopmentNote",
        "url":  "https://github.com/ewdlop/BlockChainDevelopmentNote"
    },
    {
        "name":  "Boo-mers",
        "url":  "https://github.com/ewdlop/Boo-mers"
    },
    {
        "name":  "Botany",
        "url":  "https://github.com/ewdlop/Botany"
    },
    {
        "name":  "Bots",
        "url":  "https://github.com/ewdlop/Bots"
    },
    {
        "name":  "Casual-Talk",
        "url":  "https://github.com/ewdlop/Casual-Talk"
    },
    {
        "name":  "ChatGPTKanyeEast",
        "url":  "https://github.com/ewdlop/ChatGPTKanyeEast"
    },
    {
        "name":  "ChatGPTNote",
        "url":  "https://github.com/ewdlop/ChatGPTNote"
    },
    {
        "name":  "CheapBooksNote",
        "url":  "https://github.com/ewdlop/CheapBooksNote"
    },
    {
        "name":  "ChemistryNote",
        "url":  "https://github.com/ewdlop/ChemistryNote"
    },
    {
        "name":  "Chinese-Antique-Store-App",
        "url":  "https://github.com/ewdlop/Chinese-Antique-Store-App"
    },
    {
        "name":  "Chinese-Christmas",
        "url":  "https://github.com/ewdlop/Chinese-Christmas"
    },
    {
        "name":  "ChineseStudyNote",
        "url":  "https://github.com/ewdlop/ChineseStudyNote"
    },
    {
        "name":  "Christianity",
        "url":  "https://github.com/ewdlop/Christianity"
    },
    {
        "name":  "Christmas",
        "url":  "https://github.com/ewdlop/Christmas"
    },
    {
        "name":  "Clinical-s-Psychology-",
        "url":  "https://github.com/ewdlop/Clinical-s-Psychology-"
    },
    {
        "name":  "CNC-Programming-Note",
        "url":  "https://github.com/ewdlop/CNC-Programming-Note"
    },
    {
        "name":  "CognitiveScience",
        "url":  "https://github.com/ewdlop/CognitiveScience"
    },
    {
        "name":  "CognitiveScienceNote",
        "url":  "https://github.com/ewdlop/CognitiveScienceNote"
    },
    {
        "name":  "Communtism",
        "url":  "https://github.com/ewdlop/Communtism"
    },
    {
        "name":  "CompilerNotes",
        "url":  "https://github.com/ewdlop/CompilerNotes"
    },
    {
        "name":  "Computational-Physcis-Notes",
        "url":  "https://github.com/ewdlop/Computational-Physcis-Notes"
    },
    {
        "name":  "ComputerArchitectureNote-",
        "url":  "https://github.com/ewdlop/ComputerArchitectureNote-"
    },
    {
        "name":  "ComputerGraphicNote",
        "url":  "https://github.com/ewdlop/ComputerGraphicNote"
    },
    {
        "name":  "ComputerScienceNote",
        "url":  "https://github.com/ewdlop/ComputerScienceNote"
    },
    {
        "name":  "ComputingNeuralNetworksNote",
        "url":  "https://github.com/ewdlop/ComputingNeuralNetworksNote"
    },
    {
        "name":  "ConsoleGameProject",
        "url":  "https://github.com/ewdlop/ConsoleGameProject"
    },
    {
        "name":  "CosmosDBPartialUpdateTypeConverter",
        "url":  "https://github.com/ewdlop/CosmosDBPartialUpdateTypeConverter"
    },
    {
        "name":  "CrackPot",
        "url":  "https://github.com/ewdlop/CrackPot"
    },
    {
        "name":  "CriminalJustice",
        "url":  "https://github.com/ewdlop/CriminalJustice"
    },
    {
        "name":  "crispy-palm-tree",
        "url":  "https://github.com/ewdlop/crispy-palm-tree"
    },
    {
        "name":  "CSharpAndFSharpNotes",
        "url":  "https://github.com/ewdlop/CSharpAndFSharpNotes"
    },
    {
        "name":  "Cybersecurity-CrimeNote",
        "url":  "https://github.com/ewdlop/Cybersecurity-CrimeNote"
    },
    {
        "name":  "Cyberwarefare",
        "url":  "https://github.com/ewdlop/Cyberwarefare"
    },
    {
        "name":  "Dad-Club",
        "url":  "https://github.com/ewdlop/Dad-Club"
    },
    {
        "name":  "Daolism",
        "url":  "https://github.com/ewdlop/Daolism"
    },
    {
        "name":  "DarkWeb",
        "url":  "https://github.com/ewdlop/DarkWeb"
    },
    {
        "name":  "DarkWebReporting",
        "url":  "https://github.com/ewdlop/DarkWebReporting"
    },
    {
        "name":  "Data-Mining",
        "url":  "https://github.com/ewdlop/Data-Mining"
    },
    {
        "name":  "DataScience.py",
        "url":  "https://github.com/ewdlop/DataScience.py"
    },
    {
        "name":  "DataStructure-Algorithm-Note",
        "url":  "https://github.com/ewdlop/DataStructure-Algorithm-Note"
    },
    {
        "name":  "DataWinFormApp",
        "url":  "https://github.com/ewdlop/DataWinFormApp"
    },
    {
        "name":  "DeathNote",
        "url":  "https://github.com/ewdlop/DeathNote"
    },
    {
        "name":  "DevOps",
        "url":  "https://github.com/ewdlop/DevOps"
    },
    {
        "name":  "Die-JayUPro",
        "url":  "https://github.com/ewdlop/Die-JayUPro"
    },
    {
        "name":  "DigitalCat",
        "url":  "https://github.com/ewdlop/DigitalCat"
    },
    {
        "name":  "Digital-Physics-https-en.wikipedia.org-wiki-Hypercomputation",
        "url":  "https://github.com/ewdlop/Digital-Physics-https-en.wikipedia.org-wiki-Hypercomputation"
    },
    {
        "name":  "DiscordBotNote",
        "url":  "https://github.com/ewdlop/DiscordBotNote"
    },
    {
        "name":  "Distributed-computing-Note",
        "url":  "https://github.com/ewdlop/Distributed-computing-Note"
    },
    {
        "name":  "DLL.md",
        "url":  "https://github.com/ewdlop/DLL.md"
    },
    {
        "name":  "Documentations",
        "url":  "https://github.com/ewdlop/Documentations"
    },
    {
        "name":  "DocumentGenerator",
        "url":  "https://github.com/ewdlop/DocumentGenerator"
    },
    {
        "name":  "DoomsDayNote",
        "url":  "https://github.com/ewdlop/DoomsDayNote"
    },
    {
        "name":  "DotNetAspireAppNote",
        "url":  "https://github.com/ewdlop/DotNetAspireAppNote"
    },
    {
        "name":  "Dream-Note",
        "url":  "https://github.com/ewdlop/Dream-Note"
    },
    {
        "name":  "Driver-Service-registry",
        "url":  "https://github.com/ewdlop/Driver-Service-registry"
    },
    {
        "name":  "Drone",
        "url":  "https://github.com/ewdlop/Drone"
    },
    {
        "name":  "DummyRepo",
        "url":  "https://github.com/ewdlop/DummyRepo"
    },
    {
        "name":  "duning-kunger-and-dont-mind-it-just-go-for-it",
        "url":  "https://github.com/ewdlop/duning-kunger-and-dont-mind-it-just-go-for-it"
    },
    {
        "name":  "EaseOfAccess",
        "url":  "https://github.com/ewdlop/EaseOfAccess"
    },
    {
        "name":  "EatEggs",
        "url":  "https://github.com/ewdlop/EatEggs"
    },
    {
        "name":  "Eclipse",
        "url":  "https://github.com/ewdlop/Eclipse"
    },
    {
        "name":  "EconomicFinanceNote",
        "url":  "https://github.com/ewdlop/EconomicFinanceNote"
    },
    {
        "name":  "EducationSystem",
        "url":  "https://github.com/ewdlop/EducationSystem"
    },
    {
        "name":  "ElectronicsSideProject",
        "url":  "https://github.com/ewdlop/ElectronicsSideProject"
    },
    {
        "name":  "Emerald-Farm",
        "url":  "https://github.com/ewdlop/Emerald-Farm"
    },
    {
        "name":  "Emotional-Program.cs",
        "url":  "https://github.com/ewdlop/Emotional-Program.cs"
    },
    {
        "name":  "EncryptionProgramming",
        "url":  "https://github.com/ewdlop/EncryptionProgramming"
    },
    {
        "name":  "Encryption-ToDos",
        "url":  "https://github.com/ewdlop/Encryption-ToDos"
    },
    {
        "name":  "English-Studying-Notes",
        "url":  "https://github.com/ewdlop/English-Studying-Notes"
    },
    {
        "name":  "E-Note",
        "url":  "https://github.com/ewdlop/E-Note"
    },
    {
        "name":  "ERA-Scalarship",
        "url":  "https://github.com/ewdlop/ERA-Scalarship"
    },
    {
        "name":  "Espa-olNote",
        "url":  "https://github.com/ewdlop/Espa-olNote"
    },
    {
        "name":  "EstacyDrugs",
        "url":  "https://github.com/ewdlop/EstacyDrugs"
    },
    {
        "name":  "ewdlop",
        "url":  "https://github.com/ewdlop/ewdlop"
    },
    {
        "name":  "ewdlopCV",
        "url":  "https://github.com/ewdlop/ewdlopCV"
    },
    {
        "name":  "ewdlopOlderBackup",
        "url":  "https://github.com/ewdlop/ewdlopOlderBackup"
    },
    {
        "name":  "ExperimentalPhysicsNote",
        "url":  "https://github.com/ewdlop/ExperimentalPhysicsNote"
    },
    {
        "name":  "Facepalm",
        "url":  "https://github.com/ewdlop/Facepalm"
    },
    {
        "name":  "FamilyMatters",
        "url":  "https://github.com/ewdlop/FamilyMatters"
    },
    {
        "name":  "fantastic-happiness",
        "url":  "https://github.com/ewdlop/fantastic-happiness"
    },
    {
        "name":  "Flask-web-app",
        "url":  "https://github.com/ewdlop/Flask-web-app"
    },
    {
        "name":  "Formal-Grammar",
        "url":  "https://github.com/ewdlop/Formal-Grammar"
    },
    {
        "name":  "For-the-Community",
        "url":  "https://github.com/ewdlop/For-the-Community"
    },
    {
        "name":  "Functional-Programming-Note",
        "url":  "https://github.com/ewdlop/Functional-Programming-Note"
    },
    {
        "name":  "Funny-Weapon",
        "url":  "https://github.com/ewdlop/Funny-Weapon"
    },
    {
        "name":  "fuzzy-couscous",
        "url":  "https://github.com/ewdlop/fuzzy-couscous"
    },
    {
        "name":  "FuzzyLogicNote",
        "url":  "https://github.com/ewdlop/FuzzyLogicNote"
    },
    {
        "name":  "GameDevResources",
        "url":  "https://github.com/ewdlop/GameDevResources"
    },
    {
        "name":  "GameEnigine",
        "url":  "https://github.com/ewdlop/GameEnigine"
    },
    {
        "name":  "GameForElders",
        "url":  "https://github.com/ewdlop/GameForElders"
    },
    {
        "name":  "Game-Off-2024",
        "url":  "https://github.com/ewdlop/Game-Off-2024"
    },
    {
        "name":  "GamingFriendsApp",
        "url":  "https://github.com/ewdlop/GamingFriendsApp"
    },
    {
        "name":  "General-Relativity-101-Note-",
        "url":  "https://github.com/ewdlop/General-Relativity-101-Note-"
    },
    {
        "name":  "GenZ",
        "url":  "https://github.com/ewdlop/GenZ"
    },
    {
        "name":  "GeographyNote",
        "url":  "https://github.com/ewdlop/GeographyNote"
    },
    {
        "name":  "Gitee",
        "url":  "https://github.com/ewdlop/Gitee"
    },
    {
        "name":  "GitNote",
        "url":  "https://github.com/ewdlop/GitNote"
    },
    {
        "name":  "God",
        "url":  "https://github.com/ewdlop/God"
    },
    {
        "name":  "Godfather-Program",
        "url":  "https://github.com/ewdlop/Godfather-Program"
    },
    {
        "name":  "Graph-Database.md",
        "url":  "https://github.com/ewdlop/Graph-Database.md"
    },
    {
        "name":  "GrasshopperNotes",
        "url":  "https://github.com/ewdlop/GrasshopperNotes"
    },
    {
        "name":  "Green",
        "url":  "https://github.com/ewdlop/Green"
    },
    {
        "name":  "gRPCNotes",
        "url":  "https://github.com/ewdlop/gRPCNotes"
    },
    {
        "name":  "HardwareFabricationNote",
        "url":  "https://github.com/ewdlop/HardwareFabricationNote"
    },
    {
        "name":  "Hardware-Notes",
        "url":  "https://github.com/ewdlop/Hardware-Notes"
    },
    {
        "name":  "Hey-Mr.Bean",
        "url":  "https://github.com/ewdlop/Hey-Mr.Bean"
    },
    {
        "name":  "HistoryProgram",
        "url":  "https://github.com/ewdlop/HistoryProgram"
    },
    {
        "name":  "Holy-Mother-Cow",
        "url":  "https://github.com/ewdlop/Holy-Mother-Cow"
    },
    {
        "name":  "HoneyPots",
        "url":  "https://github.com/ewdlop/HoneyPots"
    },
    {
        "name":  "HouseGame",
        "url":  "https://github.com/ewdlop/HouseGame"
    },
    {
        "name":  "HouseProject",
        "url":  "https://github.com/ewdlop/HouseProject"
    },
    {
        "name":  "HowItShouldHaveEnded",
        "url":  "https://github.com/ewdlop/HowItShouldHaveEnded"
    },
    {
        "name":  "HR-Resources",
        "url":  "https://github.com/ewdlop/HR-Resources"
    },
    {
        "name":  "Htm-Css-Notes",
        "url":  "https://github.com/ewdlop/Htm-Css-Notes"
    },
    {
        "name":  "HungerGame",
        "url":  "https://github.com/ewdlop/HungerGame"
    },
    {
        "name":  "Ideas",
        "url":  "https://github.com/ewdlop/Ideas"
    },
    {
        "name":  "Immunology",
        "url":  "https://github.com/ewdlop/Immunology"
    },
    {
        "name":  "InteriorDesignNote",
        "url":  "https://github.com/ewdlop/InteriorDesignNote"
    },
    {
        "name":  "IPCNote",
        "url":  "https://github.com/ewdlop/IPCNote"
    },
    {
        "name":  "Iron-Man2",
        "url":  "https://github.com/ewdlop/Iron-Man2"
    },
    {
        "name":  "It-is-Casual",
        "url":  "https://github.com/ewdlop/It-is-Casual"
    },
    {
        "name":  "ITNote",
        "url":  "https://github.com/ewdlop/ITNote"
    },
    {
        "name":  "JavascriptNotes",
        "url":  "https://github.com/ewdlop/JavascriptNotes"
    },
    {
        "name":  "JerseyMemes",
        "url":  "https://github.com/ewdlop/JerseyMemes"
    },
    {
        "name":  "JobOpening",
        "url":  "https://github.com/ewdlop/JobOpening"
    },
    {
        "name":  "John.php",
        "url":  "https://github.com/ewdlop/John.php"
    },
    {
        "name":  "JuliaSet",
        "url":  "https://github.com/ewdlop/JuliaSet"
    },
    {
        "name":  "Karen",
        "url":  "https://github.com/ewdlop/Karen"
    },
    {
        "name":  "KEVIN-WTF",
        "url":  "https://github.com/ewdlop/KEVIN-WTF"
    },
    {
        "name":  "Kids",
        "url":  "https://github.com/ewdlop/Kids"
    },
    {
        "name":  "KOL",
        "url":  "https://github.com/ewdlop/KOL"
    },
    {
        "name":  "LangSmithNote",
        "url":  "https://github.com/ewdlop/LangSmithNote"
    },
    {
        "name":  "LaundryMachineApp",
        "url":  "https://github.com/ewdlop/LaundryMachineApp"
    },
    {
        "name":  "Law",
        "url":  "https://github.com/ewdlop/Law"
    },
    {
        "name":  "LearingHtmlWebPage",
        "url":  "https://github.com/ewdlop/LearingHtmlWebPage"
    },
    {
        "name":  "Learnign-WinUI",
        "url":  "https://github.com/ewdlop/Learnign-WinUI"
    },
    {
        "name":  "LearningRust",
        "url":  "https://github.com/ewdlop/LearningRust"
    },
    {
        "name":  "LeetCodeNote",
        "url":  "https://github.com/ewdlop/LeetCodeNote"
    },
    {
        "name":  "Lemonade-stand",
        "url":  "https://github.com/ewdlop/Lemonade-stand"
    },
    {
        "name":  "LetterFromJayToEsmerldaMarte",
        "url":  "https://github.com/ewdlop/LetterFromJayToEsmerldaMarte"
    },
    {
        "name":  "LetterToPeople",
        "url":  "https://github.com/ewdlop/LetterToPeople"
    },
    {
        "name":  "LetterToVinnyAndMarkAndOthers",
        "url":  "https://github.com/ewdlop/LetterToVinnyAndMarkAndOthers"
    },
    {
        "name":  "LibraryNote",
        "url":  "https://github.com/ewdlop/LibraryNote"
    },
    {
        "name":  "License-Templates",
        "url":  "https://github.com/ewdlop/License-Templates"
    },
    {
        "name":  "Linux-WTF",
        "url":  "https://github.com/ewdlop/Linux-WTF"
    },
    {
        "name":  "Living-With-Narcissitc-FamilyMember",
        "url":  "https://github.com/ewdlop/Living-With-Narcissitc-FamilyMember"
    },
    {
        "name":  "LLMNotes",
        "url":  "https://github.com/ewdlop/LLMNotes"
    },
    {
        "name":  "Logic-Note",
        "url":  "https://github.com/ewdlop/Logic-Note"
    },
    {
        "name":  "LongTermCare",
        "url":  "https://github.com/ewdlop/LongTermCare"
    },
    {
        "name":  "LSTM-vs-STLM",
        "url":  "https://github.com/ewdlop/LSTM-vs-STLM"
    },
    {
        "name":  "Ludicrous-Programs",
        "url":  "https://github.com/ewdlop/Ludicrous-Programs"
    },
    {
        "name":  "MachineLearningInUnity",
        "url":  "https://github.com/ewdlop/MachineLearningInUnity"
    },
    {
        "name":  "MainEntrance",
        "url":  "https://github.com/ewdlop/MainEntrance"
    },
    {
        "name":  "MangaTheories",
        "url":  "https://github.com/ewdlop/MangaTheories"
    },
    {
        "name":  "Mathematica-Maple-Matlab-Notes",
        "url":  "https://github.com/ewdlop/Mathematica-Maple-Matlab-Notes"
    },
    {
        "name":  "MathNote",
        "url":  "https://github.com/ewdlop/MathNote"
    },
    {
        "name":  "MechanicCivilEngineerNote",
        "url":  "https://github.com/ewdlop/MechanicCivilEngineerNote"
    },
    {
        "name":  "MedFuse",
        "url":  "https://github.com/ewdlop/MedFuse"
    },
    {
        "name":  "MedicalJurisprudenceNote",
        "url":  "https://github.com/ewdlop/MedicalJurisprudenceNote"
    },
    {
        "name":  "MedicalVirus",
        "url":  "https://github.com/ewdlop/MedicalVirus"
    },
    {
        "name":  "MediFuse",
        "url":  "https://github.com/ewdlop/MediFuse"
    },
    {
        "name":  "Mental-Disorders-Notes",
        "url":  "https://github.com/ewdlop/Mental-Disorders-Notes"
    },
    {
        "name":  "-Metaphysics",
        "url":  "https://github.com/ewdlop/-Metaphysics"
    },
    {
        "name":  "Microservices",
        "url":  "https://github.com/ewdlop/Microservices"
    },
    {
        "name":  "Microsoft-you-suck-ball",
        "url":  "https://github.com/ewdlop/Microsoft-you-suck-ball"
    },
    {
        "name":  "Mindfulness.md",
        "url":  "https://github.com/ewdlop/Mindfulness.md"
    },
    {
        "name":  "Mini-Games",
        "url":  "https://github.com/ewdlop/Mini-Games"
    },
    {
        "name":  "Mistral-Incorporated.-LLC",
        "url":  "https://github.com/ewdlop/Mistral-Incorporated.-LLC"
    },
    {
        "name":  "Mother-Club",
        "url":  "https://github.com/ewdlop/Mother-Club"
    },
    {
        "name":  "MovieSideStories",
        "url":  "https://github.com/ewdlop/MovieSideStories"
    },
    {
        "name":  "Multiplayer-App-Development-Notes",
        "url":  "https://github.com/ewdlop/Multiplayer-App-Development-Notes"
    },
    {
        "name":  "MusicNote",
        "url":  "https://github.com/ewdlop/MusicNote"
    },
    {
        "name":  "Music-Note",
        "url":  "https://github.com/ewdlop/Music-Note"
    },
    {
        "name":  "My-React-JavaScript-Typescript-Notes",
        "url":  "https://github.com/ewdlop/My-React-JavaScript-Typescript-Notes"
    },
    {
        "name":  "MyWill",
        "url":  "https://github.com/ewdlop/MyWill"
    },
    {
        "name":  "NASA-Contacting-Terroist",
        "url":  "https://github.com/ewdlop/NASA-Contacting-Terroist"
    },
    {
        "name":  "NewJerseyNote",
        "url":  "https://github.com/ewdlop/NewJerseyNote"
    },
    {
        "name":  "New-Jersey-Show-God-ExMachnida.",
        "url":  "https://github.com/ewdlop/New-Jersey-Show-God-ExMachnida."
    },
    {
        "name":  "News",
        "url":  "https://github.com/ewdlop/News"
    },
    {
        "name":  "Next-Generation-Captial-Punishment",
        "url":  "https://github.com/ewdlop/Next-Generation-Captial-Punishment"
    },
    {
        "name":  "NikkiPella",
        "url":  "https://github.com/ewdlop/NikkiPella"
    },
    {
        "name":  "NLPNote",
        "url":  "https://github.com/ewdlop/NLPNote"
    },
    {
        "name":  "Nonstandard-analysis",
        "url":  "https://github.com/ewdlop/Nonstandard-analysis"
    },
    {
        "name":  "Notion-Note",
        "url":  "https://github.com/ewdlop/Notion-Note"
    },
    {
        "name":  "Nuclear-Medicine-Note.md",
        "url":  "https://github.com/ewdlop/Nuclear-Medicine-Note.md"
    },
    {
        "name":  "Obsidan-Note.md",
        "url":  "https://github.com/ewdlop/Obsidan-Note.md"
    },
    {
        "name":  "Old-PersonalWebpage",
        "url":  "https://github.com/ewdlop/Old-PersonalWebpage"
    },
    {
        "name":  "OneBook",
        "url":  "https://github.com/ewdlop/OneBook"
    },
    {
        "name":  "OneRepo",
        "url":  "https://github.com/ewdlop/OneRepo"
    },
    {
        "name":  "Onion-Tou",
        "url":  "https://github.com/ewdlop/Onion-Tou"
    },
    {
        "name":  "Online-Policing",
        "url":  "https://github.com/ewdlop/Online-Policing"
    },
    {
        "name":  "OOP-vs-FP-War",
        "url":  "https://github.com/ewdlop/OOP-vs-FP-War"
    },
    {
        "name":  "Paranormal-Notes",
        "url":  "https://github.com/ewdlop/Paranormal-Notes"
    },
    {
        "name":  "PeachAndGoma",
        "url":  "https://github.com/ewdlop/PeachAndGoma"
    },
    {
        "name":  "PersonalMessageIntendedForAFriend",
        "url":  "https://github.com/ewdlop/PersonalMessageIntendedForAFriend"
    },
    {
        "name":  "PhilosphyNote",
        "url":  "https://github.com/ewdlop/PhilosphyNote"
    },
    {
        "name":  "Philsopher-s-42",
        "url":  "https://github.com/ewdlop/Philsopher-s-42"
    },
    {
        "name":  "Physics-Note",
        "url":  "https://github.com/ewdlop/Physics-Note"
    },
    {
        "name":  "Poetry",
        "url":  "https://github.com/ewdlop/Poetry"
    },
    {
        "name":  "PoliticalNote",
        "url":  "https://github.com/ewdlop/PoliticalNote"
    },
    {
        "name":  "potential-fishstick",
        "url":  "https://github.com/ewdlop/potential-fishstick"
    },
    {
        "name":  "Private-Chat-Room",
        "url":  "https://github.com/ewdlop/Private-Chat-Room"
    },
    {
        "name":  "ProabilityAndStatisticsNote",
        "url":  "https://github.com/ewdlop/ProabilityAndStatisticsNote"
    },
    {
        "name":  "Programming-Science",
        "url":  "https://github.com/ewdlop/Programming-Science"
    },
    {
        "name":  "Project-WOKE",
        "url":  "https://github.com/ewdlop/Project-WOKE"
    },
    {
        "name":  "Prolog-notes",
        "url":  "https://github.com/ewdlop/Prolog-notes"
    },
    {
        "name":  "Prologue.md",
        "url":  "https://github.com/ewdlop/Prologue.md"
    },
    {
        "name":  "Promise-is-a-Promise",
        "url":  "https://github.com/ewdlop/Promise-is-a-Promise"
    },
    {
        "name":  "Prompt-Engineering.md",
        "url":  "https://github.com/ewdlop/Prompt-Engineering.md"
    },
    {
        "name":  "Proof-Assistance-Note",
        "url":  "https://github.com/ewdlop/Proof-Assistance-Note"
    },
    {
        "name":  "PsychologyNote",
        "url":  "https://github.com/ewdlop/PsychologyNote"
    },
    {
        "name":  "PuzzleGame",
        "url":  "https://github.com/ewdlop/PuzzleGame"
    },
    {
        "name":  "Qauntum-Physics-Notes",
        "url":  "https://github.com/ewdlop/Qauntum-Physics-Notes"
    },
    {
        "name":  "QFT-101-Note",
        "url":  "https://github.com/ewdlop/QFT-101-Note"
    },
    {
        "name":  "Quote.md",
        "url":  "https://github.com/ewdlop/Quote.md"
    },
    {
        "name":  "RacconCity-PoliceDepartment",
        "url":  "https://github.com/ewdlop/RacconCity-PoliceDepartment"
    },
    {
        "name":  "RandomAPIApp",
        "url":  "https://github.com/ewdlop/RandomAPIApp"
    },
    {
        "name":  "RandomCode.snippets",
        "url":  "https://github.com/ewdlop/RandomCode.snippets"
    },
    {
        "name":  "RapBattle",
        "url":  "https://github.com/ewdlop/RapBattle"
    },
    {
        "name":  "Raymond",
        "url":  "https://github.com/ewdlop/Raymond"
    },
    {
        "name":  "React-Typescript-App",
        "url":  "https://github.com/ewdlop/React-Typescript-App"
    },
    {
        "name":  "React-typescript-notes",
        "url":  "https://github.com/ewdlop/React-typescript-notes"
    },
    {
        "name":  "RecreationalComputerScience",
        "url":  "https://github.com/ewdlop/RecreationalComputerScience"
    },
    {
        "name":  "RecreationalMathematics",
        "url":  "https://github.com/ewdlop/RecreationalMathematics"
    },
    {
        "name":  "RecreationPhysics",
        "url":  "https://github.com/ewdlop/RecreationPhysics"
    },
    {
        "name":  "Restricted-Section",
        "url":  "https://github.com/ewdlop/Restricted-Section"
    },
    {
        "name":  "Riddles",
        "url":  "https://github.com/ewdlop/Riddles"
    },
    {
        "name":  "RIP-DAVID",
        "url":  "https://github.com/ewdlop/RIP-DAVID"
    },
    {
        "name":  "RIP-Earth",
        "url":  "https://github.com/ewdlop/RIP-Earth"
    },
    {
        "name":  "RobotsNote",
        "url":  "https://github.com/ewdlop/RobotsNote"
    },
    {
        "name":  "RogerPenrose",
        "url":  "https://github.com/ewdlop/RogerPenrose"
    },
    {
        "name":  "RSSNote",
        "url":  "https://github.com/ewdlop/RSSNote"
    },
    {
        "name":  "Santa-s-warning",
        "url":  "https://github.com/ewdlop/Santa-s-warning"
    },
    {
        "name":  "Satan-s-warning-",
        "url":  "https://github.com/ewdlop/Satan-s-warning-"
    },
    {
        "name":  "Say-Cheese",
        "url":  "https://github.com/ewdlop/Say-Cheese"
    },
    {
        "name":  "-Scary-Stories",
        "url":  "https://github.com/ewdlop/-Scary-Stories"
    },
    {
        "name":  "ScienceApp",
        "url":  "https://github.com/ewdlop/ScienceApp"
    },
    {
        "name":  "ScienceFictionNote",
        "url":  "https://github.com/ewdlop/ScienceFictionNote"
    },
    {
        "name":  "Scientifc-Horror",
        "url":  "https://github.com/ewdlop/Scientifc-Horror"
    },
    {
        "name":  "Sci-Fi-Science-Note",
        "url":  "https://github.com/ewdlop/Sci-Fi-Science-Note"
    },
    {
        "name":  "Serious-Talk",
        "url":  "https://github.com/ewdlop/Serious-Talk"
    },
    {
        "name":  "ServerlessApp",
        "url":  "https://github.com/ewdlop/ServerlessApp"
    },
    {
        "name":  "ShadersNote",
        "url":  "https://github.com/ewdlop/ShadersNote"
    },
    {
        "name":  "SocialSecurty",
        "url":  "https://github.com/ewdlop/SocialSecurty"
    },
    {
        "name":  "SoftwareEngineer",
        "url":  "https://github.com/ewdlop/SoftwareEngineer"
    },
    {
        "name":  "SolarBall",
        "url":  "https://github.com/ewdlop/SolarBall"
    },
    {
        "name":  "SpaceCatMeme",
        "url":  "https://github.com/ewdlop/SpaceCatMeme"
    },
    {
        "name":  "SpaceProjectXL",
        "url":  "https://github.com/ewdlop/SpaceProjectXL"
    },
    {
        "name":  "spam-repo",
        "url":  "https://github.com/ewdlop/spam-repo"
    },
    {
        "name":  "Spirits",
        "url":  "https://github.com/ewdlop/Spirits"
    },
    {
        "name":  "SQLNotes",
        "url":  "https://github.com/ewdlop/SQLNotes"
    },
    {
        "name":  "SQL-Server-Note.md",
        "url":  "https://github.com/ewdlop/SQL-Server-Note.md"
    },
    {
        "name":  "Story-of-an-Apple",
        "url":  "https://github.com/ewdlop/Story-of-an-Apple"
    },
    {
        "name":  "Strange-things-found-in-the-ocean",
        "url":  "https://github.com/ewdlop/Strange-things-found-in-the-ocean"
    },
    {
        "name":  "studious-parakeet",
        "url":  "https://github.com/ewdlop/studious-parakeet"
    },
    {
        "name":  "Study-Bank.md",
        "url":  "https://github.com/ewdlop/Study-Bank.md"
    },
    {
        "name":  "Sun-Yat-sen",
        "url":  "https://github.com/ewdlop/Sun-Yat-sen"
    },
    {
        "name":  "Supersymmetric-Notes",
        "url":  "https://github.com/ewdlop/Supersymmetric-Notes"
    },
    {
        "name":  "SweeshopBlazor",
        "url":  "https://github.com/ewdlop/SweeshopBlazor"
    },
    {
        "name":  "SweetShopRepo",
        "url":  "https://github.com/ewdlop/SweetShopRepo"
    },
    {
        "name":  "System-Calls-Stuffs-Notes",
        "url":  "https://github.com/ewdlop/System-Calls-Stuffs-Notes"
    },
    {
        "name":  "TableTopSimulation",
        "url":  "https://github.com/ewdlop/TableTopSimulation"
    },
    {
        "name":  "TaiwaneseApps",
        "url":  "https://github.com/ewdlop/TaiwaneseApps"
    },
    {
        "name":  "TaiwanNote",
        "url":  "https://github.com/ewdlop/TaiwanNote"
    },
    {
        "name":  "Tarot-Readings",
        "url":  "https://github.com/ewdlop/Tarot-Readings"
    },
    {
        "name":  "Thanksgiving-Note",
        "url":  "https://github.com/ewdlop/Thanksgiving-Note"
    },
    {
        "name":  "The-Big-Bang",
        "url":  "https://github.com/ewdlop/The-Big-Bang"
    },
    {
        "name":  "Third-World-Country",
        "url":  "https://github.com/ewdlop/Third-World-Country"
    },
    {
        "name":  "ThisisNotMario2",
        "url":  "https://github.com/ewdlop/ThisisNotMario2"
    },
    {
        "name":  "TicTacToe",
        "url":  "https://github.com/ewdlop/TicTacToe"
    },
    {
        "name":  "TrumpOS",
        "url":  "https://github.com/ewdlop/TrumpOS"
    },
    {
        "name":  "Turkey-lingo",
        "url":  "https://github.com/ewdlop/Turkey-lingo"
    },
    {
        "name":  "TurningPoint",
        "url":  "https://github.com/ewdlop/TurningPoint"
    },
    {
        "name":  "Twin-Flame--",
        "url":  "https://github.com/ewdlop/Twin-Flame--"
    },
    {
        "name":  "Typescript-Notes",
        "url":  "https://github.com/ewdlop/Typescript-Notes"
    },
    {
        "name":  "UnitTesting-Note",
        "url":  "https://github.com/ewdlop/UnitTesting-Note"
    },
    {
        "name":  "UnityProjects",
        "url":  "https://github.com/ewdlop/UnityProjects"
    },
    {
        "name":  "UnrealEngine3dProjectNotes",
        "url":  "https://github.com/ewdlop/UnrealEngine3dProjectNotes"
    },
    {
        "name":  "USA-News",
        "url":  "https://github.com/ewdlop/USA-News"
    },
    {
        "name":  "VB-Note",
        "url":  "https://github.com/ewdlop/VB-Note"
    },
    {
        "name":  "Verilog-Notes",
        "url":  "https://github.com/ewdlop/Verilog-Notes"
    },
    {
        "name":  "VeryMiniEngine",
        "url":  "https://github.com/ewdlop/VeryMiniEngine"
    },
    {
        "name":  "Very-Random-Program",
        "url":  "https://github.com/ewdlop/Very-Random-Program"
    },
    {
        "name":  "Virus",
        "url":  "https://github.com/ewdlop/Virus"
    },
    {
        "name":  "WaybackMachine",
        "url":  "https://github.com/ewdlop/WaybackMachine"
    },
    {
        "name":  "WebApplicaitonsNote",
        "url":  "https://github.com/ewdlop/WebApplicaitonsNote"
    },
    {
        "name":  "WebScrappedData",
        "url":  "https://github.com/ewdlop/WebScrappedData"
    },
    {
        "name":  "Who-is-going-to-die-fast-game",
        "url":  "https://github.com/ewdlop/Who-is-going-to-die-fast-game"
    },
    {
        "name":  "Why-I-am-always-so-slow-",
        "url":  "https://github.com/ewdlop/Why-I-am-always-so-slow-"
    },
    {
        "name":  "Why-is-AI-feeling-lacking-foundaiton",
        "url":  "https://github.com/ewdlop/Why-is-AI-feeling-lacking-foundaiton"
    },
    {
        "name":  "WindowsAchivementApp",
        "url":  "https://github.com/ewdlop/WindowsAchivementApp"
    },
    {
        "name":  "WindowsFormsApp",
        "url":  "https://github.com/ewdlop/WindowsFormsApp"
    },
    {
        "name":  "World-War-3",
        "url":  "https://github.com/ewdlop/World-War-3"
    },
    {
        "name":  "WowSideStories",
        "url":  "https://github.com/ewdlop/WowSideStories"
    },
    {
        "name":  "WWE-World-Wrestling-Entertainment-",
        "url":  "https://github.com/ewdlop/WWE-World-Wrestling-Entertainment-"
    },
    {
        "name":  "X-File",
        "url":  "https://github.com/ewdlop/X-File"
    },
    {
        "name":  "XMLNote",
        "url":  "https://github.com/ewdlop/XMLNote"
    },
    {
        "name":  "You-have-less-than-one-month-left",
        "url":  "https://github.com/ewdlop/You-have-less-than-one-month-left"
    },
    {
        "name":  "YoutubeAccountAPI",
        "url":  "https://github.com/ewdlop/YoutubeAccountAPI"
    },
    {
        "name":  "ZeekNote",
        "url":  "https://github.com/ewdlop/ZeekNote"
    }
]
```
