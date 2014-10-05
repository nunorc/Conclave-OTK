use strict;
use warnings;
package Conclave::OTK::Backend::File;
# ABSTRACT: OTK file based backend
use parent qw/Conclave::OTK::Backend/;

use RDF::Trine;
use RDF::Trine::Model;
use RDF::Trine::Parser;
use RDF::Trine::Store::File;
use RDF::Query;
use File::Touch;
use Data::Dumper;

sub new {
  my ($class, $base_uri, %opts) = @_;
  my $self = bless({}, $class);

  my $filename = './model.rdf';
  $filename = $opts{filename} if $opts{filename};

  $self->{base_uri} = $base_uri;
  $self->{filename} = $filename;
  return $self;
}


sub init {
  my ($self, $rdfxml) = @_;

  unless (-e $self->{filename}) {
    touch($self->{filename});
  }
  my $store = RDF::Trine::Store::File->new($self->{filename});
  my $model = RDF::Trine::Model->new($store);

  my $parser = RDF::Trine::Parser->new('rdfxml');
  $parser->parse_into_model($self->{base_uri}, $rdfxml, $model);
}

sub update {
  my ($self, $sparql) = @_;

  my $query = RDF::Query->new($sparql, {update => 1});

  my $store = RDF::Trine::Store::File->new($self->{filename});
  my $model = RDF::Trine::Model->new($store);
  my $iterator = $query->execute($model);

  return $iterator;
}

sub query {
  my ($self, $sparql) = @_;

  my $query = RDF::Query->new($sparql);

  my $store = RDF::Trine::Store::File->new($self->{filename});
  my $model = RDF::Trine::Model->new($store);
  my $iterator = $query->execute($model);

  my @result;
  while (my $triple = $iterator->next) {
    if (scalar(keys %$triple) == 1) {
      foreach (keys %$triple) {
        push @result, $triple->{$_}->[1]; # FIXME
      }
    }
    else {
      # FIXME
      my $str = $triple->as_string;
      if ($str =~ m/{\s*.*?=<(.*?)>,\s*.*?=<(.*?)>,\s*.*?=("|<)(.*?)("|>)/) {
        push @result, [($1,$2,$4)];
      }
    }
  }

  return @result;
}

sub delete {
  my ($self) = @_;

  unlink $self->{filename};
}

1;

