# Overview

This is a Gleam-based computational project that solves the mathematical problem of finding consecutive square sequences that sum to perfect squares. The application uses the BEAM virtual machine's actor model to distribute computational work across multiple processes, making it suitable for multi-core execution. The project implements a boss-worker pattern where a supervisor actor coordinates multiple worker actors to solve mathematical computations in parallel.

# User Preferences

Preferred communication style: Simple, everyday language.

# System Architecture

## Core Language and Runtime
- **Language**: Gleam - a functional language that compiles to Erlang bytecode
- **Runtime**: BEAM virtual machine (Erlang/OTP) - provides fault-tolerant, concurrent execution
- **Concurrency Model**: Actor model using Gleam's OTP actors for parallel processing

## Application Structure
- **Main Module**: Entry point that accepts command line arguments (N and k values)
- **Boss Actor**: Coordinates work distribution and collects results from workers
- **Worker Actors**: Process mathematical computations for assigned ranges
- **Work Unit Strategy**: Configurable chunk sizes for optimal performance distribution

## Mathematical Processing
- **Problem Domain**: Finding sequences of k consecutive integers starting from 1 to N where the sum of their squares equals a perfect square
- **Algorithm**: Brute force search with parallel processing across multiple actors
- **Output Format**: Starting numbers of valid sequences, printed line by line

## Performance Optimization
- **Parallel Processing**: Multiple worker actors process different ranges simultaneously
- **Work Distribution**: Boss actor assigns work units to available workers
- **Scalability**: Designed to utilize multi-core machines effectively through BEAM's lightweight process model

## Command Line Interface
- **Input**: Two integers (N and k) via command line arguments
- **Output**: List of starting numbers for valid consecutive square sequences
- **Example Usage**: `lukas 1000000 4` to find sequences of 4 consecutive numbers up to 1,000,000

# External Dependencies

## Gleam Ecosystem
- **gleam_stdlib**: Core standard library providing basic data structures and utilities
- **gleam_otp**: OTP (Open Telecom Platform) bindings for actor system implementation
- **gleam_erlang**: Erlang interop and process management utilities
- **argv**: Cross-platform command line argument parsing library

## Development Tools
- **gleeunit**: Testing framework for unit tests and test runners
- **Hex Package Manager**: Dependency management and package distribution

## Runtime Environment
- **Erlang/OTP 27.0+**: Required runtime environment for BEAM virtual machine
- **BEAM VM**: Provides the actor model, fault tolerance, and concurrent execution capabilities