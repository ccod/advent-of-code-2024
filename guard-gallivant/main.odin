package main

import "core:fmt"
import "core:strings"

Direction :: enum {
    North,
    South,
    East,
    West
}

Guard :: struct {
    position: [2]int,
    facing: Direction
}

NORTH :: [2]int { 0, -1 }
SOUTH :: [2]int { 0,  1 }
EAST  :: [2]int { 1,  0 }
WEST  :: [2]int {-1,  0 }

input: string
guard: Guard
grid := make([dynamic][dynamic]u8)

forward :: proc(direction: Direction) -> [2]int {
    switch direction {
    case .North:
        return NORTH
    case .South:
        return SOUTH
    case .East:
        return EAST
    case .West:
        return WEST
    }

    panic("forward function failed to account for new direction")
}

turn :: proc(direction: Direction) -> Direction {
    switch direction {
    case .North:
        return .East
    case .East:
        return .South
    case .South:
        return .West
    case .West:
        return .North
    }

    panic("turn function failed to accounnt for new direction")
}

out_of_bounds :: proc(position: [2]int) -> bool {
    if position.x > len(grid[0]) -1 || position.y > len(grid) - 1 ||
       position.x < 0 || position.y < 0 {
        return true
    }
    return false
}


make_grid :: proc(data: []u8) {
    x: int
    y: int

    // adding initial column containers
    for b in data {
        done := false

        switch rune(b) {
        case '\n':
            done = true
        case:
            column_at_x := make([dynamic]u8)
            append(&grid, column_at_x)
        }

        if done {
            break
        }
    }

    for b in data {
        switch rune(b) {
        case '.', '#':
            append(&grid[x], b)
        case '^':
            guard = Guard {{x, y}, .North}
            append(&grid[x], b)
        case '\n':
            x = 0
            y += 1
            continue
        }
        x += 1
    }
}

print_grid :: proc() {
    y: int
    x: int

    done := false

    for y < len(grid) {
        switch {
        case x >= len(grid[0]):
            x = 0
            y += 1
            fmt.println()
        case:
            fmt.printf("%v ", rune(grid[x][y]))
            x += 1
        }
    }
    fmt.println()
}

main :: proc() {
    input := #load("input.txt")
    make_grid(input)

    for {
        next_position := guard.position + forward(guard.facing) 

        if out_of_bounds(next_position) {
            grid[guard.position.x][guard.position.y] = u8('X')
            break 
        }

        if '#' == rune(grid[next_position.x][next_position.y]) {
            guard.facing = turn(guard.facing)

            next_position = guard.position + forward(guard.facing)
            if out_of_bounds(next_position) {
                grid[guard.position.x][guard.position.y] = u8('X')
                break
            }
        }
        
        grid[guard.position.x][guard.position.y] = u8('X')
        guard.position = next_position
    }

    count: int
    for column in grid {
        for value in column {
            if 'X' == rune(value) {
                count += 1
            }
        }
    }

    print_grid()
    fmt.println("count: ", count)
}
