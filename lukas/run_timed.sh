#!/bin/bash
# Run with timing and calculate real CPU/REAL ratio
echo "Starting timed execution..."
(time gleam run -- "$@") 2> time.txt
echo "Calculating actual CPU/REAL ratio from timing data..."
# Parse the timing format: real0m12.284s user0m0.408s sys0m0.765s
awk '
/^real/ { 
    gsub(/real/, "", $1);
    gsub(/s$/, "", $1);  # Remove trailing "s"
    split($1, parts, "m");  # Split by "m" to get minutes and seconds
    real = parts[1] * 60 + parts[2]  # Convert to total seconds
}
/^user/ { 
    gsub(/user/, "", $1);
    gsub(/s$/, "", $1);
    split($1, parts, "m");
    user = parts[1] * 60 + parts[2]
}
/^sys/ { 
    gsub(/sys/, "", $1);
    gsub(/s$/, "", $1);
    split($1, parts, "m");
    sys = parts[1] * 60 + parts[2]
}
END {
    cpu = user + sys; 
    if (real > 0) {
        printf "ACTUAL TIMING: CPU=%.3fs  REAL=%.3fs  CPU/REAL_RATIO=%.2f\n", cpu, real, cpu/real
    } else {
        printf "ACTUAL TIMING: CPU=%.3fs  REAL=%.3fs  CPU/REAL_RATIO=N/A (too fast to measure)\n", cpu, real
    }
}' time.txt

