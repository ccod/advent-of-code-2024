package main

import "core:fmt"
import "core:strings"
import "core:unicode/utf8"

// should be x, y
NORTH :: [2]int { 0, -1}
SOUTH :: [2]int { 0,  1}
EAST  :: [2]int { 1,  0}
WEST  :: [2]int {-1,  0}

NORTHEAST :: [2]int { 1, -1}
SOUTHEAST :: [2]int { 1,  1}
NORTHWEST :: [2]int {-1, -1}
SOUTHWEST :: [2]int {-1,  1}

check_direction :: proc(s: string, lines: []string, coord: [2]int, direction: [2]int) -> int {
    alt_coord := coord + (direction * len(s))
    end_coord := coord + (direction * (len(s) - 1))

    if end_coord[0] < 0 ||
        end_coord[1] < 0 ||
        end_coord[0] > len(lines[0]) - 1 ||
        end_coord[1] > len(lines) - 1 {
        return 0
    }

    current_coord := coord

    for ch in s {
        rr, size := utf8.decode_rune_in_string(lines[current_coord[1]][current_coord[0]:])
        if size > 1 {
            panic("I am not prepared to handle funky symbols")
        }

        if rr != ch {
            return 0 
        }

        current_coord += direction
    }

    success_coord := coord

    for ch in s {
        replace_at(ch, success_coord)
        success_coord += direction
    }

    return 1
}

alternate := make([dynamic][dynamic]u8)

replace_at :: proc(ch: rune, coord: [2]int) {
    alternate[coord.y][coord.x] = u8(ch)
}

main :: proc() {
    input := #load("input.txt", string)

    lines := strings.split_lines(input)
    if lines[len(lines) - 1] == "" {
        lines = lines[:len(lines) - 1]
    }

    // making a similar image to example to help find bug
    for line in lines {
        alt_line := make([dynamic]u8, len(line))
        for _, idx in alt_line {
            alt_line[idx] = u8('.')
        }
        append(&alternate, alt_line)
    }

    word := "XMAS"
    count: int
    coord: [2]int

    for line, line_idx in lines {
        for ch, ch_idx in line {
            coord = {ch_idx, line_idx}

            count += check_direction(word, lines, coord, NORTH)
            count += check_direction(word, lines, coord, SOUTH)
            count += check_direction(word, lines, coord, EAST)
            count += check_direction(word, lines, coord, WEST)

            count += check_direction(word, lines, coord, NORTHEAST)
            count += check_direction(word, lines, coord, SOUTHEAST)
            count += check_direction(word, lines, coord, NORTHWEST)
            count += check_direction(word, lines, coord, SOUTHWEST)
        }
    }

    for a in alternate {
        builder := strings.builder_make()
        strings.write_bytes(&builder, a[:])
        fmt.println(strings.to_string(builder))
    }

    fmt.println("count", count)
}
