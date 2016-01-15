type Counter = Cntr Int
type Action = Increment
            | Decrement


calc action (Cntr n) =
  case action of
    Increment -> Cntr (n + 1)
    Decrement -> Cntr (n - 1)


calc Increment (Cntr 41)
calc Decrement (Cntr 1)