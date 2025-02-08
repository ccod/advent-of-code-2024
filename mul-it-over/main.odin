package main

import "core:fmt"
import "core:strconv"

Pair :: struct {
    arg1: int,
    arg2: int
}

MulState :: enum {
    Mul,
    Arg1,
    Comma,
    Arg2,
    Close,
}

MulGroup :: struct {
    active: bool,
    start: int
}

is_number :: proc(s: rune) -> bool {
    switch s {
    case '0'..='9':
        return true
    }

    return false
}

mult_and_sum :: proc(pairs: [dynamic]Pair) -> int {
    total: int

    for pair in pairs {
        total += (pair.arg1 * pair.arg2)
    }

    return total
}


main :: proc() {
    input := #load("example-input.txt", string)

    pairs: [dynamic]Pair

    state: MulState
    next: int

    mul_start := MulGroup { false, 0 }
    mul_string := "mul("
    mul_count: int

    arg1_len: int

    arg1: int
    arg2: int

    for ch, idx in input {

        #partial switch state {
        case .Mul:
            if ch == 'm' && !mul_start.active {
                mul_start = { true, idx }
                continue
            }

            if mul_start.active {
                mul_idx := idx - mul_start.start
                if ch == rune(mul_string[mul_idx]) {
                    if mul_idx == 3 {
                        fmt.print(mul_string)
                        mul_count += 1
                        mul_start.active = false
                        state = .Arg1
                        continue
                    }
                } else {
                    // failed, but might be able to start again from here
                    if ch == 'm' {
                        mul_start.start = idx
                        continue
                    } else {
                        mul_start.active = false
                    }
                }
            }

        case .Arg1:
            if is_number(ch) {
                arg1_len += 1
                if arg1_len > 3 {
                    arg1_len = 0
                    state = .Mul
                    continue
                }
            } else if ch == ',' && arg1_len > 0 {
                fmt.print(input[idx - arg1_len:idx], ",")
                arg1 = strconv.atoi(input[idx - arg1_len:idx])
                arg1_len = 0
                state = .Arg2
                continue
            } else {
                arg1_len = 0
                if ch == 'm' {
                    state = .Mul
                    mul_start = { true, idx }
                    continue
                } else {
                    state = .Mul
                    continue
                }
            }
        case .Arg2:
            if is_number(ch) {
                arg1_len += 1
                if arg1_len > 3 {
                    arg1_len = 0
                    state = .Mul
                    continue
                }
            } else if ch == ')' && arg1_len > 0 {
                fmt.println(input[idx - arg1_len:idx], ")")
                arg2 = strconv.atoi(input[idx - arg1_len:idx])
                arg1_len = 0
                append(&pairs, Pair { arg1, arg2 })
                state = .Mul
                continue
            } else {
                arg1_len = 0
                if ch == 'm' {
                    state = .Mul
                    mul_start = { true, idx }
                    continue
                } else {
                    state = .Mul
                    continue
                }
            }
        }
    }

    fmt.println(mult_and_sum(pairs))
}
