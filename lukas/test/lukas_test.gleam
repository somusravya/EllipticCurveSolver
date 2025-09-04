import gleeunit
import gleeunit/should
import lukas

pub fn main() -> Nil {
  gleeunit.main()
}

// Test the mathematical functions
pub fn is_perfect_square_test() {
  // Test perfect squares
  lukas.is_perfect_square(1) |> should.be_true()
  lukas.is_perfect_square(4) |> should.be_true()
  lukas.is_perfect_square(9) |> should.be_true()
  lukas.is_perfect_square(16) |> should.be_true()
  lukas.is_perfect_square(25) |> should.be_true()
  lukas.is_perfect_square(49) |> should.be_true()
  
  // Test non-perfect squares
  lukas.is_perfect_square(2) |> should.be_false()
  lukas.is_perfect_square(3) |> should.be_false()
  lukas.is_perfect_square(5) |> should.be_false()
  lukas.is_perfect_square(10) |> should.be_false()
}

pub fn sum_of_squares_test() {
  // Test sum of squares for known cases
  lukas.sum_of_squares(3, 2) |> should.equal(25)  // 3^2 + 4^2 = 9 + 16 = 25
  lukas.sum_of_squares(1, 3) |> should.equal(14)  // 1^2 + 2^2 + 3^2 = 1 + 4 + 9 = 14
  lukas.sum_of_squares(1, 1) |> should.equal(1)   // 1^2 = 1
  lukas.sum_of_squares(5, 2) |> should.equal(61)  // 5^2 + 6^2 = 25 + 36 = 61
}

pub fn pythagorean_identity_test() {
  // Test the classic Pythagorean identity: 3^2 + 4^2 = 5^2
  let sum = lukas.sum_of_squares(3, 2)
  sum |> should.equal(25)
  lukas.is_perfect_square(sum) |> should.be_true()
}

pub fn lucas_pyramid_test() {
  // Test Lucas' square pyramid: 1^2 + 2^2 + ... + 24^2 = 70^2
  let sum = lukas.sum_of_squares(1, 24)
  sum |> should.equal(4900)  // 70^2 = 4900
  lukas.is_perfect_square(sum) |> should.be_true()
}

pub fn find_solutions_small_range_test() {
  // Test finding solutions in a small range
  let solutions = lukas.find_solutions_in_range(1, 5, 2)
  // Should find solution starting at 3: 3^2 + 4^2 = 25 = 5^2
  solutions |> should.equal([3])
}