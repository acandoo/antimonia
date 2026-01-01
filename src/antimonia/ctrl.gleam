//// The `ctrl` module provides functions for iterative control flow in Gleam.

/// Repeat a function a certain number of times.
/// If 0 or a negative value is passed, `Nil` is returned and nothing is executed.
/// 
/// ## Examples
/// 
/// Usage with `use`:
/// 
/// ```gleam
/// import gleam/io
/// 
/// {
///   use <- repeat(5)
///   io.println("are we there yet?")
/// }
/// // are we there yet?
/// // are we there yet?
/// // are we there yet?
/// // are we there yet?
/// // are we there yet?
/// // -> Nil
/// ```
/// 
/// Negative number handling:
/// 
/// ```gleam
/// {
///   use <- repeat(-1)
///   io.println("are we there yet?")
/// }
/// // -> Nil
/// ```
/// 
pub fn repeat(number: Int, exec: fn() -> Nil) -> Nil {
  case number {
    a if a <= 0 -> Nil
    _ -> {
      exec()
      repeat(number - 1, exec)
    }
  }
}

/// Loop interrupt types. They are usually used by wrapping them in an `Error`, such as
/// `Error(Break)`.
/// 
/// Note that a `Continue` constructor isn't provided as Gleam's implicit return makes
/// such a construct equivalent to returning `Nil`.
pub type LoopInterrupt {
  /// Breaks from the loop early.
  Break
}

/// Creates a `for` loop, with the callback returning the value.
/// Note that the value passed into the function is immutable.
/// If you want to change the value within the loop, you can pass in a
/// [`Mutable`](./mutable.html#Mutable).
/// 
/// If you're using this, what are you doing? Please don't use this. Please!
/// 
/// ## Examples
/// 
/// Print through the values of i:
/// 
/// ```gleam
/// {
///   use i <- for(i: 0, cond: fn(i) { i < 5 }, change: fn(i) { i + 1 })
///   io.println("i is " <> int.to_string(i))
///   Ok(Nil)
/// }
/// // i is 0
/// // i is 1
/// // i is 2
/// // i is 3
/// // i is 4
/// // -> Nil
/// ```
/// 
/// Interrupt early:
/// 
/// ```gleam
/// {
///   use i <- for(i: 0, cond: fn(i) { i < 5 }, change: fn(i) { i + 1 })
///   case i == 3 {
///     True -> {
///       io.println("i is 3!! i can't count that high...")
///       Error(ctrl.Break)
///     }
///     False -> {
///       io.println("i is " <> int.to_string(i))
///       Ok(Nil)
///     }
///   }
/// }
/// // i is 0
/// // i is 1
/// // i is 2
/// // i is 3!! i can't count that high...
/// // -> Nil
/// ```
/// 
/// Mutate `i`:
/// 
/// ```gleam
/// import antimonia/mutable
/// 
/// {
///   use i <- for(
///     i: mutable.from(0),
///     cond: fn(i) { mutable.get(i) < 5 },
///     change: fn(i) {
///       mutable.set(i, mutable.get(i) + 1)
///       i
///     },
///   )
///   let #(i, set_i) = mutable.to_tuple(i)
///   case i() == 2 {
///     True -> {
///       io.println("i is 2! i'll skip over 3...")
///       set_i(3)
///       Ok(Nil)
///     }
///     False -> {
///       io.println("i is " <> int.to_string(i()))
///       Ok(Nil)
///     }
///   }
/// }
/// // i is 0
/// // i is 1
/// // i is 2! i'll skip over 3...
/// // i is 4
/// // -> Nil
/// ```
/// 
pub fn for(
  i value: value,
  cond condition: fn(value) -> Bool,
  change change: fn(value) -> value,
  then exec: fn(value) -> Result(Nil, LoopInterrupt),
) -> Nil {
  let cond_check = condition(value)
  case cond_check {
    True -> {
      case exec(value) {
        Ok(_) -> for(change(value), condition, change, exec)
        Error(Break) -> Nil
      }
    }
    False -> Nil
  }
}

/// Evaluates the condition and executes the exec function until the condition is false.
pub fn while(condition: fn() -> Bool, exec: fn() -> Result(Nil, LoopInterrupt)) {
  case condition() {
    True -> {
      case exec() {
        Ok(_) -> while(condition, exec)
        Error(Break) -> Nil
      }
    }
    False -> Nil
  }
}

/// Similar to the [`while`](#while) loop, but it will always execute at least once regardless of the condition.
pub fn do_while(
  condition: fn() -> Bool,
  exec: fn() -> Result(Nil, LoopInterrupt),
) {
  case exec() {
    Ok(_) -> while(condition, exec)
    Error(Break) -> Nil
  }
}

/// Executes a function and returns the same function, given the function does not return with an error
/// with type [`LoopInterrupt`](#LoopInterrupt). This is useful when piping to while.
/// 
/// ## Example
/// 
/// ```gleam
/// import antimonia/mutable
/// 
/// let #(password_attempt, set_password_attempt) = mutable.tuple_from("")
/// do(fn() {
///   set_password_attempt(request_password())
/// })
/// |> while(fn() { password_attempt() != "password123" }, _)
/// ```
/// 
pub fn do(
  exec: fn() -> Result(Nil, LoopInterrupt),
) -> fn() -> Result(Nil, LoopInterrupt) {
  case exec() {
    Ok(_) -> exec
    Error(Break) -> fn() { Ok(Nil) }
  }
}
