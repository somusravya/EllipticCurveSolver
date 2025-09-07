# Overview

This is a Gleam-based computational project that solves the mathematical problem of finding consecutive square sequences that sum to perfect squares. The application uses the BEAM virtual machine's actor model to distribute work across multiple cores, finding sequences of k consecutive integers (starting from 1 to N) where the sum of their squares equals a perfect square. Examples include the Pythagorean identity (3² + 4² = 5²) and Lucas' Square Pyramid (1² + 2² + ... + 24² = 70²).

The project has been successfully set up in the Replit environment with all dependencies installed and tests passing.

# Recent Changes

- **September 07, 2025**: Project imported from GitHub and set up in Replit environment
  - Installed Gleam programming language and Erlang/OTP runtime 
  - Built project and installed all dependencies successfully
  - All unit tests pass (5 tests covering mathematical functions)
  - Configured workflow to demonstrate application with example parameters (N=20, k=2)
  - Application successfully finds perfect square solutions (e.g., 3² + 4² = 25 = 5²)

# User Preferences

Preferred communication style: Simple, everyday language.

# System Architecture

## Core Language and Runtime
- **Language**: Gleam - a functional language that compiles to Erlang bytecode for type safety and concurrency
- **Runtime**: BEAM virtual machine (Erlang/OTP 27.0+) - provides fault-tolerant, concurrent execution with lightweight processes
- **Concurrency Model**: Actor model using Gleam's OTP actors for parallel mathematical processing

## Application Architecture
- **Main Module**: Entry point that parses command line arguments (N and k values) and coordinates the computation
- **Boss Actor**: Central coordinator that distributes work ranges to worker actors and collects results
- **Worker Actors**: Independent computational units that process assigned ranges of starting numbers
- **Work Distribution Strategy**: Configurable chunk sizes to optimize performance across available CPU cores

## Mathematical Processing
- **Problem Domain**: Brute force search for consecutive integer sequences where sum of squares equals a perfect square
- **Algorithm**: Parallel range-based computation with mathematical validation of square sums
- **Performance Optimization**: Multi-core utilization through BEAM's lightweight process model
- **Output Format**: Sequential printing of valid sequence starting numbers

## Command Line Interface
- **Input Validation**: Accepts two integer parameters via command line (N for upper bound, k for sequence length)
- **Error Handling**: Built-in argument parsing and validation through argv library
- **Usage Pattern**: `gleam run <N> <k>` where N is the search limit and k is the consecutive sequence length

# External Dependencies

## Gleam Core Libraries
- **gleam_stdlib**: Standard library providing core data structures, mathematical functions, and I/O operations
- **gleam_otp**: OTP (Open Telecom Platform) bindings for actor system implementation and process management
- **gleam_erlang**: Erlang interoperability layer for process spawning and BEAM VM integration
- **argv**: Cross-platform command line argument parsing library for input handling

## Development and Testing
- **gleeunit**: Testing framework for unit tests and automated test execution
- **Hex Package Manager**: Dependency management and package distribution system

## Runtime Requirements
- **Erlang/OTP 27.0+**: Required runtime environment providing the BEAM virtual machine
- **Multi-core Hardware**: Optimized for parallel execution across multiple CPU cores