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

// keeping part one around, even if it won't be run again
part_one :: proc() {
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

check_x_directions :: proc(s: string, grid: []string, coord: [2]int, direction: [2]int) -> int {
    //checking bounds by using the top left and bottom right coordinates
    end_coord := coord + (SOUTHEAST * (len(s) - 1))

    if end_coord[0] < 0 ||
        end_coord[1] < 0 ||
        end_coord[0] > len(grid[0]) - 1 ||
        end_coord[1] > len(grid) - 1 {
        return 0
    }

    coord_one: [2]int
    coord_two: [2]int

    by_direction :: proc(start_coord: [2]int, step: int, direction: [2]int) -> [2]int {
        return start_coord + (direction * step)
    }

    switch direction {
    case NORTH:
        for ch, idx in s {
            coord_one = by_direction(coord + {0, 2}, idx, NORTHEAST)
            coord_two = by_direction(coord + {2, 2}, idx, NORTHWEST)

            if rune(grid[coord_one.y][coord_one.x]) != ch ||
               rune(grid[coord_two.y][coord_two.x]) != ch {
                return 0
            }
        }
        return 1
    case SOUTH:
        for ch, idx in s {
            coord_one = by_direction(coord + {0, 0}, idx, SOUTHEAST)
            coord_two = by_direction(coord + {2, 0}, idx, SOUTHWEST)

            if rune(grid[coord_one.y][coord_one.x]) != ch ||
               rune(grid[coord_two.y][coord_two.x]) != ch {
                return 0
            }
        }
        return 1
    case EAST:
        for ch, idx in s {
            coord_one = by_direction(coord + {0, 0}, idx, SOUTHEAST)
            coord_two = by_direction(coord + {0, 2}, idx, NORTHEAST)

            if rune(grid[coord_one.y][coord_one.x]) != ch ||
               rune(grid[coord_two.y][coord_two.x]) != ch {
                return 0
            }
        }
        return 1
    case WEST:
        for ch, idx in s {
            coord_one = by_direction(coord + {2, 0}, idx, SOUTHWEST)
            coord_two = by_direction(coord + {2, 2}, idx, NORTHWEST)

            if rune(grid[coord_one.y][coord_one.x]) != ch ||
               rune(grid[coord_two.y][coord_two.x]) != ch {
                return 0
            }
        }
        return 1
    }

    return 0
}

part_two :: proc() {
    input := #load("input.txt", string)

    lines := strings.split_lines(input)
    if lines[len(lines) - 1] == "" {
        lines = lines[:len(lines) - 1]
    }

    word := "MAS"
    count: int
    coord: [2]int

    for line, line_idx in lines {
        for ch, ch_idx in line {
            coord = {ch_idx, line_idx}

            count += check_x_directions(word, lines, coord, NORTH)
            count += check_x_directions(word, lines, coord, SOUTH)
            count += check_x_directions(word, lines, coord, EAST)
            count += check_x_directions(word, lines, coord, WEST)
        }
    }

    fmt.println("count: ", count)
}

main :: proc() {
    // part_one()
    part_two()
}
