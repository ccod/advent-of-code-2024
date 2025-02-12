package main

import "core:fmt"
import "core:strconv"
import "core:unicode/utf8"


Pair :: struct {
    arg1: int,
    arg2: int
}

mult_and_sum :: proc(pairs: [dynamic]Pair) -> int {
    total: int

    for pair in pairs {
        total += (pair.arg1 * pair.arg2)
    }

    return total
}

get_arg :: proc(s: string, idx: int, sep: rune) -> (num: int, total_size: int, ok: bool) {
    current := idx
    count: int
 
    for current < len(s) && count < 4 {
        rr, size := utf8.decode_rune_in_string(s[current:])
        switch rr {
        case '0'..='9':
            count += 1
            current += 1
            total_size += size
            continue
        case sep:
            total_size += size
            return strconv.atoi(s[idx:current]), total_size, true
        }
        return 0, 0, false
    }
    return 0, 0, false
}

main :: proc() {
    input := #load("input.txt", string)
    idx: int

    pairs: [dynamic]Pair

    activate_keyword := "do()"
    deactivate_keyword := "don't()"
    mul_keyword := "mul("

    active := true


    for idx < len(input) {
        rr, size := utf8.decode_rune_in_string(input[idx:])

        switch {
        case rr == 'd':
            act_idx := idx + len(activate_keyword)
            dea_idx := idx + len(deactivate_keyword)

            switch {
            case act_idx < len(input) && input[idx:act_idx] == activate_keyword:
                active = true
                idx += len(activate_keyword)
                continue
            case dea_idx < len(input) && input[idx:dea_idx] == deactivate_keyword:
                active = false
                idx += len(deactivate_keyword)
                continue
            }

        case active && rr == 'm':
            mul_idx := idx + len(mul_keyword)

            if mul_idx < len(input) && input[idx:mul_idx] == mul_keyword {
                arg1, arg1_size, ok := get_arg(input, mul_idx, ','); if ok {
                    arg2, arg2_size, ok2 := get_arg(input, mul_idx + arg1_size, ')'); if ok {
                        idx = mul_idx + arg1_size + arg2_size
                        append(&pairs, Pair {arg1, arg2})
                        continue
                    }
                }
            }
        }

        idx += size
    }

    
    total := mult_and_sum(pairs)
    fmt.println("total is: ", total)
}
