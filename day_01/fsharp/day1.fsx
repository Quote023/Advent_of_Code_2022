let elves =
    System.IO.File.ReadLines("../input.txt")
    |> Seq.fold
        (fun (acc: int list) v ->
            match (v.Trim()) with
            | "" -> 0 :: acc
            | _ when (acc.Length > 1) -> ((int v) + acc.Head) :: acc.Tail
            | _ -> (int v) :: acc)
        []
    |> Seq.toList

printf "1º: %A\n" (elves |> List.max)
printf "2º: %A\n" (elves |> List.sortDescending |> List.take 3 |> List.sum)
