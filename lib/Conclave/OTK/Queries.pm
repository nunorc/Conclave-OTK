use strict;
use warnings;
package Conclave::OTK::Queries;
# ABSTRACT: query provider for OTK

use Template;
use Conclave::OTK::Queries::OWL;

sub new {
  my ($class, $format) = @_;
  my $self = bless({}, $class);

  my $provider = "Conclave::OTK::Queries::$format";

  my $template_config = {
      INCLUDE_PATH => [ 'templates' ],
    };
  my $template = Template->new({
      LOAD_TEMPLATES => [ $provider->new($template_config) ],
    });

  $self->{format} = $format;
  $self->{template} = $template;

  return $self;
}

sub process {
  my ($self, $template_name, $vars) = @_;

  my $sparql;
  $self->{template}->process($template_name, $vars, \$sparql);

  return $sparql
}

1;

__END__

=encoding UTF-8

=head1 SYNOPSIS

  TODO

=head1 DESCRIPTION

  TODO

