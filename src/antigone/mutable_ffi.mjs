export function mutableFrom(value) {
  return { value }
}

export function mutableGet({ value }) {
  return value
}

export function mutableSet(mut, value) {
  mut.value = value
}
