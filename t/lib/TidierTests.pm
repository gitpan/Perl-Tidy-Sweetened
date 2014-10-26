package TidierTests;

use Perl::Tidy::Sweetened;
use Test::Most;

sub do_tests {
    my ($fh) = shift;

    my ($message, @test);
    while(my $line = <$fh>){
        if( $line =~ /^={2,} \s* (.*) \s =+ \s* $/x ){
            $message = $1;
        } elsif ( $line =~ /^\s*$/ ){
            test_tidy( \@test, $message );
            undef $message;
            @test = ();
        } elsif ( $line =~ /[|]/ ){
            push @test, $line;
        } else {
            die "Poorly formatted test at:\n$line";
        }
    }
    # Test the last one
    test_tidy( \@test, $message ) if $message;
    done_testing();
}

sub test_tidy {
    my ( $code, $msg ) = @_;
    my ( @raw, @expected );

    for my $line (@$code ){
        my ($raw_line, $expected_line) = split /\s*[|] ?/, $line;
        push @raw,$raw_line unless $raw_line eq "~";
        $expected_line = '' unless defined $expected_line;
        push @expected, $expected_line unless $expected_line eq "~";
    }

    my $raw = join "\n", @raw;
    my $expected = join '', @expected;

    my @tidied;
    Perl::Tidy::Sweetened::perltidy(
        source      => \$raw,
        destination => \@tidied,
        perltidyrc  => undef,
        argv        => '-nsyn -ce -npro -l=60',
    );
    my $tidied = join '', @tidied;
    return eq_or_diff( $tidied, $expected, $msg );
}

1;
