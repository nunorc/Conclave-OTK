use strict;
use warnings;
package Conclave::OTK::Backend;
# ABSTRACT: base class for OTK backends

sub new {
  my ($class, $base_uri) = @_;
  my $self = bless({}, $class);

  $self->{base_uri} = $base_uri;
  return $self;
}

1;

__END__

=encoding UTF-8

=head1 SYNOPSIS

    package Conclave::OTK::Backend::MyBackend;
    use parent qw/Conclave::OTK::Backend/;

=head1 DESCRIPTION

This should be the base class for all OTK backends. The main functions
a plugin needs to overwrite are:

=over

=item C<new>

TODO

=item C<init>

TODO

=item C<update>

TODO

=item C<query>

TODO

=item C<delete>

TODO

=back

=head1 EXAMPLES

For examples view the C<Conclave::OTK::Backend::*> included in this
distribution.

