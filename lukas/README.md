# Lukas — Parallel Perfect Square Finder (Merged README)

A Gleam application that uses the BEAM VM’s actor model (boss–worker pattern) to find starting points **s** such that
`s² + (s+1)² + … + (s+k−1)²` is a perfect square. Designed for efficient multi‑core execution.  

---

## Overview

- **Language/Runtime:** Gleam → Erlang bytecode on the **BEAM** (Erlang/OTP), using OTP actors for concurrency and fault tolerance.  
- **Architecture:** **Boss** actor coordinates multiple **Worker** actors to process disjoint ranges in parallel and collect results.  
- **Problem:** For inputs **N** and **k**, search `s ∈ [1..N]` where the sum of **k** consecutive squares starting at `s` is a perfect square.  
- **Output:** Print all valid `s` values; optionally write performance metrics to a file.

---

## Problem & Examples

- **Goal:** Find all `s` where `s² + (s+1)² + … + (s+k−1)²` is a perfect square.  
- **Examples:**  
  - `3² + 4² = 25 = 5²`  
  - `1² + 2² + … + 24² = 70²` (Lucas’ square pyramid)

---

## Features

- Parallel search via OTP **actors** (lightweight BEAM processes)
- Boss–worker scheduling with even range partitioning
- Configurable **work unit size** and worker count
- Clear CLI with **verbose** steps for small N and concise output for large N
- Optional **metrics file** (name: `metrics_N{N}_k{k}.txt`) capturing timing and throughput

---

## Requirements

- **Erlang/OTP:** 27.0+  
- **Gleam:** latest stable recommended  
- **Dependencies:**  
  - `gleam_stdlib` – core library  
  - `gleam_otp` – OTP actors  
  - `gleam_erlang` – Erlang interop  
  - `argv` – CLI argument parsing  
  - `simplifile` – file I/O for metrics (if metrics enabled)  

Dev: `gleeunit` for tests.

---

## Installation

### Local (Linux/macOS/WSL)

1) Install Gleam (or use your package manager):  
```bash
# Example manual install (Linux):
curl -sSL https://github.com/gleam-lang/gleam/releases/latest/download/gleam-x86_64-unknown-linux-musl.tar.gz | tar -xz
sudo mv gleam /usr/local/bin/
```

2) Build:  
```bash
cd lukas
gleam build
```

### Replit
Gleam is typically preinstalled; open the project and run the commands below.

---

## Usage

Run with **N** and **k**:
```bash
gleam run -- <N> <k>
```

**Examples**
```bash
# Small demo (prints detailed steps for N ≤ 100)
gleam run -- 25 2

# Find s for k = 24 within 1..40
gleam run -- 40 24

# Stress test
gleam run -- 1000000 4
```

---

## Architecture (Actor Model)

```
┌─────────────┐
│ Boss Actor  │ ← Coordinates workers, collects results
└─────────────┘
       │
   ┌───┴──┬──────┬──────┬──────┐
   │      │      │      │      │
┌──▼──┐ ┌─▼──┐ ┌─▼──┐ ┌─▼──┐ ┌─▼──┐
│Work1│ │Work2│ │Work3│ │Work4│ │...│
└─────┘ └────┘ └────┘ └────┘ └────┘
```

**Message types (abridged):**
```gleam
pub type WorkerMessage {
  ComputeRange(start: Int, end: Int, k: Int, boss: Subject(BossMessage))
  Shutdown
}

pub type BossMessage {
  Result(solutions: List(Int))
  WorkerDone
}
```

---

## Algorithm & Logic

- For each `s` from `1..N`, compute `sum = s² + (s+1)² + … + (s+k−1)²` and test if `sum` is a perfect square.  
- Optimizations: (1) efficient perfect‑square check via `sqrt` + integer check, (2) actor‑based range partitioning, (3) direct summation or formula‑based equivalents.

**Example (N=25, k=2):**  
`s=3: 3² + 4² = 9 + 16 = 25 = 5² ✓`  
`s=20: 20² + 21² = 400 + 441 = 841 = 29² ✓`

---

## Parallelism & Work Distribution

- **Workers:** computed from `N` and `work_unit_size` (last worker takes the remainder).  
- **Work unit size:** configurable. Many runs use **1000** as a balanced default; an adaptive heuristic like `{≤1000→10, ≤10000→200, >10000→1000}` also works well.  
- **Sequential vs parallel:** tiny inputs may run sequentially for clarity; larger inputs run in parallel for speed.

---

## Performance & Benchmarks

- Example benchmark (`gleam run 1000000 4`) observed on a sample machine:  
  - Real: ~6.316s, User: ~0.699s, Sys: ~0.531s → CPU/Real ≈ **1.23**  
- Metrics categories you may track:
  - **Real time** (wall‑clock), **CPU time**, **throughput**, **#actors** (1 boss + N workers).  
- A simple model for **CPU/Real** is `workers × efficiency (≈0.85)`; values > 1.0 indicate meaningful parallelism.  
- For large N, the app prints a concise summary; for small N it can print step‑by‑step calculations.

---

## Output & Metrics File

When enabled, a metrics report is written after completion:

- **Name:** `metrics_N{N}_k{k}.txt` (e.g., `metrics_N25_k2.txt`, `metrics_N2000_k3.txt`)  
- **Contents (example):** problem configuration, actor/worker counts, timings, throughput, and discovered solutions.  
- **Location:** project root (Replit: project root; Local: executable directory).

---

## Project Structure

```
lukas/
├── src/                # Main implementation
├── test/               # Test suite
├── gleam.toml          # Project configuration
├── manifest.toml       # Dependency lock file
└── README.md
```

---

## Development

- Run tests: `gleam test`  
- Build (prod): `gleam build --target erlang`  
- Performance tuning: adjust `work_unit_size` (and optionally chunking heuristic) to match your hardware.

---

## Notes

- The design leverages BEAM’s preemptive schedulers and “let‑it‑crash” philosophy via supervisors for resilience.  
- Scales to large **N** with many workers; memory use and actor overhead remain modest on typical machines.

