# antimonia

antimonia — antipatterns & escape hatches for programming Gleam, wrong :)

please please do not use this library if you can i just made it bc i thought it was silly

[![Package Version](https://img.shields.io/hexpm/v/antimonia)](https://hex.pm/packages/antimonia)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/antimonia/)

```sh
gleam add antimonia@1
```

```gleam
import antimonia/ctrl
import antimonia/mutable
import gleam/int
import gleam/io

pub fn main() -> Nil {
  let #(counter, set_counter) = mutable.tuple_from(0)
  {
    use <- ctrl.repeat(5)
    io.println("counter is at " <> int.to_string(counter()))
    set_counter(counter() + 1)
  }
}
```

Further documentation can be found at <https://hexdocs.pm/antimonia>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
