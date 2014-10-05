#!perl -T

use Test::More tests => 11;
use Test::File;

use Conclave::OTK;
use File::Temp qw/tempfile tempdir/;

my $rdfxml = do { local $/; <main::DATA> };
my $base_uri = 'http://local/example';
my (undef, $filename) = tempfile('onto_test_XXXXXXXX', TMPDIR=>1, SUFFIX=>'.rdf', OPEN=>0, );

my $onto = Conclave::OTK->new($base_uri, 
               backend => 'File',
               filename => $filename
             );
$onto->init($rdfxml);

my @classes = sort $onto->get_classes;
is( scalar(@classes), 0, 'start with no classes' );

# add classes
$onto->add_class('Person','<http://www.w3.org/2002/07/owl#Thing>');

# add classes with parents
$onto->add_class('Female', 'Person');
$onto->add_class('Male', 'Person');

@classes = sort $onto->get_classes;
is_deeply( [@classes], ["$base_uri#Female","$base_uri#Male","$base_uri#Person"], 'classes' );

my @subs = sort $onto->get_subclasses('Person');
is_deeply( [@subs], ["$base_uri#Female","$base_uri#Male"], 'sub-classes' );

$onto->add_instance('Ann', 'Female');
$onto->add_instance('Peter', 'Male');

my @females = $onto->get_instances('Female');
is_deeply( [@females], ["$base_uri#Ann"], 'instances' );
my @males = $onto->get_instances('Male');
is_deeply( [@males], ["$base_uri#Peter"], 'instances' );

$onto->add_obj_prop('Ann', 'hasParent', 'Peter');

my @props = $onto->get_obj_props('Ann');
is_deeply( [@props], [["$base_uri#Ann","$base_uri#hasParent","$base_uri#Peter"]], 'object proprieties' );
my @props = $onto->get_obj_props('Peter');
is_deeply( [@props], [["$base_uri#Ann","$base_uri#hasParent","$base_uri#Peter"]], 'object proprieties' );

$onto->add_data_prop('Ann', 'hasAge', '4', 'int');
$onto->add_data_prop('Peter', 'hasAge', '28', 'int');

@props = $onto->get_data_props('Ann');
is_deeply( [@props], [["$base_uri#Ann","$base_uri#hasAge","4"]], 'data proprieties' );

@props = $onto->get_data_props('Peter');
is_deeply( [@props], [["$base_uri#Peter","$base_uri#hasAge","28"]], 'data proprieties' );

my $expect = { 'http://www.w3.org/2002/07/owl#Thing' => { "$base_uri#Person" => { "$base_uri#Female" => undef, "$base_uri#Male" => undef } } };
my $tree = $onto->get_class_tree;
is_deeply( $tree, $expect, 'class tree' );

$onto->delete;
file_not_exists_ok($filename);

__DATA__
<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE rdf:RDF [
    <!ENTITY owl "http://www.w3.org/2002/07/owl#" >
    <!ENTITY xsd "http://www.w3.org/2001/XMLSchema#" >
    <!ENTITY example "http://local/example" >
    <!ENTITY rdfs "http://www.w3.org/2000/01/rdf-schema#" >
    <!ENTITY rdf "http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
]>

<rdf:RDF xmlns="http://local/example"
     xml:base="http://local/example"
     xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
     xmlns:empty="[% base_uri %]"
     xmlns:owl="http://www.w3.org/2002/07/owl#"
     xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
     xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <owl:Ontology rdf:about="http://local/example"/>
</rdf:RDF>
