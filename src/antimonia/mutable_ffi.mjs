export function mutableFrom(value) {
  // UUID created to make equaity checks in Gleam fail
  let uuid = Symbol()
  return { value, uuid }
}

export function mutableGet({ value }) {
  return value
}

export function mutableSet(mut, value) {
  mut.value = value
}
