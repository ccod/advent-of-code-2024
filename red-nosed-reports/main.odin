package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

input := #load("input.txt", string)
example_input := #load("example-input.txt", string)

Direction :: enum {
    Increasing,
    Decreasing
}

LevelDiff :: struct {
    distance: int,
    direction: Direction
}

main :: proc() {
    reports := strings.split(input, "\n")

    safe : int
    levels: [dynamic]int 
    diffs : [dynamic]LevelDiff
    defer delete(diffs)
    defer delete(levels)

    for report in reports[:len(reports) - 1] {
        raw_levels := strings.split(report, " ")

        for l in raw_levels {
            append(&levels, strconv.atoi(l))
        }
        defer clear(&levels)


        has_failed := false

        for to_ignore in 0..<len(levels) {
            defer clear(&diffs) 

            levels_with_ignore := slice.clone_to_dynamic(levels[:])
            defer delete(levels_with_ignore)

            ordered_remove(&levels_with_ignore, to_ignore)

            for l, idx in levels_with_ignore {
                if idx == len(levels_with_ignore) - 1 {
                    continue
                }

                delta := l - levels_with_ignore[idx + 1]
                if delta > 0 {
                    append(&diffs, LevelDiff {abs(delta), .Decreasing})
                } else {
                    append(&diffs, LevelDiff {abs(delta), .Increasing})
                }
            }

            is_safe := true 
            direction := diffs[0].direction

            for d in diffs {
                if !(0 < d.distance && d.distance < 4) {
                    is_safe = false
                    break
                }

                if d.direction != direction {
                    is_safe = false
                    break
                }
                
                direction = d.direction
            }

            if is_safe {
                safe += 1
                break
            }
        }
    }

    fmt.println("safe reports: ", safe)
}
