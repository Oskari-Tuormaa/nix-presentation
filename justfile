_present +FLAGS:
    presenterm nix.md -xX {{FLAGS}}

_present-win +FLAGS:
    kitty -d {{justfile_directory()}} sh -c "just _present {{FLAGS}}"

present: (_present "-P")
listen: (_present "-l")

present-win: (_present-win "-P")
listen-win: (_present-win "-l")

both-win:
    just listen-win &
    just present-win

export: (_present "-e")

clean:
    -rm *.pdf
