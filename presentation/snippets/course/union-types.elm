type Action = Increment
            | Decrement


calc action m =
  case action of
    Increment -> m + 1
    Decrement -> m - 1


calc Increment 41
calc Decrement 1