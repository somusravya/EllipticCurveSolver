import argv
import gleam/io
import gleam/int
import gleam/float
import gleam/list
import gleam/otp/actor
import gleam/erlang/process

// Message types for our actor system
pub type WorkerMessage {
  ComputeRange(start: Int, end: Int, k: Int, boss: process.Subject(BossMessage))
  Shutdown
}

pub type BossMessage {
  Result(solutions: List(Int))
  WorkerDone
}

pub type BossState {
  BossState(
    expected_workers: Int,
    completed_workers: Int,
    all_solutions: List(Int)
  )
}

// Check if a number is a perfect square
fn is_perfect_square(n: Int) -> Bool {
  case float.square_root(int.to_float(n)) {
    Ok(sqrt_n) -> {
      let int_sqrt = float.round(sqrt_n)
      int_sqrt * int_sqrt == n
    }
    Error(_) -> False
  }
}

// Calculate sum of squares from start to start+k-1
fn sum_of_squares(start: Int, k: Int) -> Int {
  list.range(start, start + k - 1)
  |> list.map(fn(x) { x * x })
  |> list.fold(0, int.add)
}

// Find all solutions in a range for sequences of length k
fn find_solutions_in_range(start_range: Int, end_range: Int, k: Int) -> List(Int) {
  list.range(start_range, end_range)
  |> list.filter(fn(start) {
    let sum = sum_of_squares(start, k)
    is_perfect_square(sum)
  })
}

// Worker actor implementation
fn worker_message_handler(state: Nil, message: WorkerMessage) -> actor.Next(Nil, WorkerMessage) {
  case message {
    ComputeRange(start, end, k, boss) -> {
      let solutions = find_solutions_in_range(start, end, k)
      process.send(boss, Result(solutions))
      process.send(boss, WorkerDone)
      actor.continue(state)
    }
    Shutdown -> actor.stop()
  }
}

// Boss actor implementation
fn boss_message_handler(state: BossState, message: BossMessage) -> actor.Next(BossState, BossMessage) {
  case message {
    Result(solutions) -> {
      let new_solutions = list.append(state.all_solutions, solutions)
      actor.continue(BossState(..state, all_solutions: new_solutions))
    }
    WorkerDone -> {
      let new_completed = state.completed_workers + 1
      case new_completed >= state.expected_workers {
        True -> {
          // All workers done, print results and stop
          state.all_solutions
          |> list.sort(int.compare)
          |> list.each(fn(solution) { io.println(int.to_string(solution)) })
          
          actor.stop()
        }
        False -> {
          actor.continue(BossState(..state, completed_workers: new_completed))
        }
      }
    }
  }
}

// Create workers and distribute work
fn distribute_work(n: Int, k: Int, work_unit_size: Int) -> Result(Nil, String) {
  let num_workers = case n / work_unit_size {
    0 -> 1
    x -> x + case n % work_unit_size {
      0 -> 0
      _ -> 1
    }
  }
  
  // Start boss actor
  let boss_initial_state = BossState(
    expected_workers: num_workers,
    completed_workers: 0,
    all_solutions: []
  )
  
  let assert Ok(boss_actor) = 
    actor.new(boss_initial_state)
    |> actor.on_message(boss_message_handler)
    |> actor.start()
  
  // Start worker actors and assign work
  list.range(0, num_workers - 1)
  |> list.each(fn(worker_id) {
    let start_range = worker_id * work_unit_size + 1
    let end_range = case worker_id == num_workers - 1 {
      True -> n  // Last worker gets remaining range
      False -> start_range + work_unit_size - 1
    }
    
    let assert Ok(worker_actor) = 
      actor.new(Nil)
      |> actor.on_message(worker_message_handler)
      |> actor.start()
    
    process.send(worker_actor.data, ComputeRange(start_range, end_range, k, boss_actor.data))
  })
  
  // Wait for boss to complete by sleeping
  process.sleep(5000)  // 5 second timeout for now
  Ok(Nil)
}

pub fn main() -> Nil {
  case argv.load().arguments {
    [n_str, k_str] -> {
      case int.parse(n_str), int.parse(k_str) {
        Ok(n), Ok(k) -> {
          // Use work unit size of 1000 for good balance
          let work_unit_size = 1000
          
          case distribute_work(n, k, work_unit_size) {
            Ok(_) -> Nil
            Error(msg) -> {
              io.println_error("Error: " <> msg)
            }
          }
        }
        _, _ -> {
          io.println_error("Error: Both arguments must be valid integers")
          io.println_error("Usage: lukas <N> <k>")
        }
      }
    }
    _ -> {
      io.println_error("Usage: lukas <N> <k>")
      io.println_error("Find k consecutive numbers starting at 1 or higher, up to N,")
      io.println_error("such that the sum of squares is itself a perfect square.")
    }
  }
}