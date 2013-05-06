use 5.010;

sub foo : Attrib(bla) {    # Comment
    say "hi";
}

sub foo : Attrib(bla) { # Comment that is really too long to go on this one line
    say "hi";
}

sub morning {           # __FUNC 0
    say "hi";
}

sub morning returns(Bool) {
    say "hi";
  }
