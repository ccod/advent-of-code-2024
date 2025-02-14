package main

import "core:fmt"
import "core:strings"
import "core:strconv"

input: string
rules: map[int][dynamic]int

add_rule :: proc(rule: string) {
    pair := strings.split(rule, "|")
    key, new_value := strconv.atoi(pair[0]), strconv.atoi(pair[1])

    if list, ok := rules[key]; ok {
        append(&list, new_value)
        rules[key] = list
    } else {
        temp := make([dynamic]int)
        append(&temp, new_value)
        rules[key] = temp
    }
}

add_key :: proc(set: ^map[int]struct{}, key: int) {
    set[key] = {}
}

list_pages :: proc(s: string) -> [dynamic]int {
    num_strs := strings.split(s, ",")
    arr := make([dynamic]int)

    for n in num_strs {
        append(&arr, strconv.atoi(n))
    }

    return arr
}

check :: proc(page: int, set: ^map[int]struct{}) -> bool {
    if rule_numbers, ok := rules[page]; ok {
        for num in rule_numbers {
            if num in set {
                return false
            }
        }
    } 

    return true
}

main :: proc() {
    input = #load("input.txt", string)
    lines := strings.split_lines(input)

    count: int
    rules_list := true

    for line in lines {
        switch {
        case line == "":
            rules_list = false
        case rules_list:
            add_rule(line)
        case len(line) > 0 && !rules_list:
            pages := list_pages(line)
            set: map[int]struct{}

            success := true

            for page in pages {
                // check if page has rule list, then run through that list and compare if there is a member among the set
                // if there is, this ordering has failed, so continue, if not, add page to set, and move to next page
                // when pages are exhausted, it means it succeeds, then add middle number to count and move to next list.
                if check(page, &set) {
                    set[page] = {}
                } else {
                    success = false
                    break
                }
            }

            if success {
                count += pages[len(pages)/2]
            }
        }
    }

    fmt.println("count: ", count)
}
