
#!/usr/bin/perl

# $Id: template.t 15151 2013-07-08 21:01:16Z don.johnson $

use lib "..";
use Test::More;
use Test::Perl::Critic;

use SML;

use Log::Log4perl;
Log::Log4perl->init("log.test.conf");

#---------------------------------------------------------------------
# Test Data
#---------------------------------------------------------------------

my $testdata =
  {
  };

#---------------------------------------------------------------------
# Can use module?
#---------------------------------------------------------------------

BEGIN {
  use SML::Template;
  use_ok( 'SML::Template' );
}

#---------------------------------------------------------------------
# Follows coding standards?
#---------------------------------------------------------------------

critic_ok('../SML/Template.pm');

#---------------------------------------------------------------------
# Can instantiate object?
#---------------------------------------------------------------------

my $obj = SML::Template->new;
isa_ok( $obj, 'SML::Template' );

#---------------------------------------------------------------------
# Implements designed public methods?
#---------------------------------------------------------------------

my @public_methods =
  (
  );

# can_ok( $obj, @public_methods );

#---------------------------------------------------------------------
# Implements designed attributes?
#---------------------------------------------------------------------

my @attributes =
  (
  );

# can_ok( $obj, @attributes );

#---------------------------------------------------------------------
# Implements designed private methods?
#---------------------------------------------------------------------

my @private_methods =
  (
  );

# can_ok( $obj, @private_methods );

#---------------------------------------------------------------------
# Returns expected values?
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# Throws expected exceptions?
#---------------------------------------------------------------------

######################################################################

done_testing()
