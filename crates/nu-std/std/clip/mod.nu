# Commands for interacting with the system clipboard
#
# > These commands require your terminal to support OSC 52
# > Terminal multiplexers such as screen, tmux, zellij etc may interfere with this command

use std/clip52

# Copy input to system clipboard
@example "Copy a string to the clipboard" {
  "Hello" | clip52 copy
}
@deprecated "Use `clip copy` without `use std/clip`. For OCS 52 copy request use `clip52 copy` using `std/clip52` module"
export def copy [
  --ansi (-a)                 # Copy ansi formatting
]: any -> nothing {
  $in | clip52 copy --ansi=$ansi
}

# Paste contents of system clipboard
@example "Paste a string from the clipboard" {
  clip52 paste
} --result "Hello"
@deprecated "Use `clip paste` without `use std/clip`, for OCS 52 paste request use `clip52 paste` using `std/clip52` module"
export def paste []: [nothing -> string] {
  clip52 paste
}

# Add a prefix to each line of the content to be copied
@example "Format output for Nushell doc" {
  [1 2 3] | prefix '# => '
} --result "# => ╭───┬───╮
# => │ 0 │ 1 │
# => │ 1 │ 2 │
# => │ 2 │ 3 │
# => ╰───┴───╯
# => "
@example "Format output for Nushell doc and copy it" {
  ls | prefix '# => ' | clip52 copy
}
export def "prefix" [prefix: string]: any -> string {
  let input = $in | collect
  match ($input | describe -d | get type) {
    $type if $type in [ table, record, list ] => {
      $input | table -e
    }
    _ => {$input}
  }
  | str replace -r --all '(?m)(.*)' $'($prefix)$1'
}
