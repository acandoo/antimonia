//// The `mutable` module allows you to use mutable values of any type within your code.

// note to self: implement Mutable in erlang through process housing value and message passing

/// The `Mutable` generic type houses a reference to the value of the specified type stored elsewhere in memory.
/// 
/// Implementation note: On JavaScript, `Mutable(a)` values correspond to an object of type `{ value: a }`.
/// This may be subject to change, so if you (for some reason) are writing bindings in JavaScript that
/// requires the Mutable type, please don't use this.
pub type Mutable(a)

/// Creates a `#(getter, setter)` tuple from a value.
/// 
/// ## Example
/// 
/// ```gleam
/// let #(counter, set_counter) = tuple_from(3)
/// 
/// counter()
/// // -> 3
/// set_counter(counter() + 2)
/// // -> Nil
/// counter()
/// // -> 5
/// 
/// ```
/// 
pub fn tuple_from(value: a) -> #(fn() -> a, fn(a) -> Nil) {
  from(value)
  |> to_tuple
}

/// Converts a [`Mutable`](#Mutable) to a `#(getter, setter)` tuple.
/// 
/// ## Example
/// 
/// ```gleam
/// fn update_mutable_handler(mut: Mutable(Int)) -> Nil {
///   let #(val, set_val) = to_tuple(mut)
///   case val() {
///     0 -> set_val(2)
///     _ -> set_val(0)
///   }
/// }
/// ```
/// 
pub fn to_tuple(mut: Mutable(a)) -> #(fn() -> a, fn(a) -> Nil) {
  let get = fn() { get(mut) }
  let set = fn(new_value) { set(mut, new_value) }
  #(get, set)
}

/// Creates a [`Mutable`](#Mutable) from a value.
@external(javascript, "./mutable_ffi.mjs", "mutableFrom")
pub fn from(value: a) -> Mutable(a)

/// Gets the value of a [`Mutable`](#Mutable).
@external(javascript, "./mutable_ffi.mjs", "mutableGet")
pub fn get(mut: Mutable(a)) -> a

/// Updates the value of a [`Mutable`](#Mutable).
@external(javascript, "./mutable_ffi.mjs", "mutableSet")
pub fn set(mut: Mutable(a), value: a) -> Nil
