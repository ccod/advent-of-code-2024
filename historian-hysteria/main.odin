package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:sort"

input := #load("input.txt", string)

main :: proc() {
    lines, err := strings.split(input, "\n")
    if err != nil {
        fmt.panicf("failed to split lines: %v", err)
    }

    col_a:= make([dynamic]int, 0, len(lines))
    col_b:= make([dynamic]int, 0, len(lines))

    for l, idx in lines {
        if pair := strings.split(l, "   "); len(pair) >= 2 {
            append(&col_a, strconv.atoi(pair[0]))
            append(&col_b, strconv.atoi(pair[1]))
        }
    }

    sort.merge_sort(col_a[:])
    sort.merge_sort(col_b[:])

    appearance_counter: map[int]int
    similarity_score := 0

    for val in col_b {
        appearance_counter[val] += 1
    }

    for val in col_a {
        similarity_score += val * appearance_counter[val]
    }

    sum_delta := 0

    for idx in 0..<len(col_a) {
        sum_delta += abs(col_a[idx] - col_b[idx])
    }

    fmt.println("sum_delta: ", sum_delta)
    fmt.println("similarity_score: ", similarity_score)
}
