use lib 't/lib';
use TidierTests;
TidierTests::do_tests(\*DATA);

__DATA__

=== Github issue #1  =====
use strict;            |
use warnings;            |
            |
use Method::Signatures::Simple;            |
use Moose::Role;            |
use MooseX::App::Role;            |
            |
use LWP::UserAgent;            |
use File::Spec::Functions;            |
use File::ShareDir qw(:ALL);            |
use Template;            |
use Data::Dumper;            |
            |
use Net::OAuth::LP::Client;            |
            |
has lpc => (            |
    is      => 'ro',            |
    isa     => 'Net::OAuth::LP::Client',            |
    lazy    => 1,            |
    default => method {            |
        Net::OAuth::LP::Client->new();            |
    },            |
    handles => {lpc_search => 'search',},            |
);            |
            |
method build_report($report_file, $vars) {            |
    my $report_path = catfile($self->tpl_path, $report_file);            |
      my $report_out_path = catfile('/tmp', $self->lp_login . "-report.txt");            |
      my $tt = Template->new(            |
        {   INCLUDE_PATH => $self->tpl_path,            |
            ABSOLUTE     => 1            |
        }            |
      ) || die "$Template::ERROR\n";            |
      $tt->process(catfile($report_path), $vars, $report_out_path)            |
      || die $tt->error(),            |
    "\n";            |
      return $report_out_path;            |
  }            |
            |
  1;            |
