#!/usr/bin/perl

# $Id$

use lib "..";
use Test::More tests => 2;

use SML;

use Log::Log4perl;
Log::Log4perl->init("log.test.conf");

#---------------------------------------------------------------------
# Test Data
#---------------------------------------------------------------------

use SML::TestData;

my $td      = SML::TestData->new;
my $library = $td->get_test_object('SML::Library','library');

#---------------------------------------------------------------------
# Can use module?
#---------------------------------------------------------------------

BEGIN {
  use SML::Exercise;
  use_ok( 'SML::Exercise' );
}

#---------------------------------------------------------------------
# Can instantiate object?
#---------------------------------------------------------------------

my $obj = SML::Exercise->new(id=>'ex1',library=>$library);
isa_ok( $obj, 'SML::Exercise' );

#---------------------------------------------------------------------
# Implements designed public methods?
#---------------------------------------------------------------------

my @public_methods =
  (
   # SML::Exercise public attribute accessors
   # <none>

   # SML::Exercise public methods
   # <none>
  );

# can_ok( $obj, @public_methods );

#---------------------------------------------------------------------
# Returns expected values?
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# Throws expected exceptions?
#---------------------------------------------------------------------

######################################################################
