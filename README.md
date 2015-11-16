# NAME

Conclave::OTK - Conclave Ontology Toolkit

# VERSION

version 0.01

# SYNOPSIS

    use Conclave::OTK;

    my $onto = Conclave::OTK->new($base_uri);

    $onto->add_class($class_name);
    $onto->add_obj_prop($class1, $relation, $class2);
    $onto->add_data_prop($class, $relation, $value, $type);
      # default type is string

# DESCRIPTION

OTK implements a set of operations to handle ontologies. Its' main goal
is to provide an ORM-style API, but for RDF documents, to implement
ontology oriented applications.

This module is under developement, and things still change often.

# METHODS

## new

## init

## delete

## add\_class

## get\_classes

## get\_subclasses

## get\_all\_subclasses

## get\_instance\_classes

## add\_instance

## get\_instances

## add\_obj\_prop

## get\_obj\_props

## get\_obj\_props\_for

## get\_ranges

## get\_data\_props

## add\_data\_prop

## full\_uri

## get\_class\_tree

## draw\_graph

# AUTHOR

Nuno Carvalho <smash@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014-2015 by Nuno Carvalho <smash@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
