#!/usr/bin/perl

package SML::Error;

use Moose;

use version; our $VERSION = qv('2.0.0');

use namespace::autoclean;

use Log::Log4perl qw(:easy);
with 'MooseX::Log::Log4perl';
my $logger = Log::Log4perl::get_logger('sml.Error');

######################################################################
######################################################################
##
## Public Attributes
##
######################################################################
######################################################################

has level =>
  (
   is       => 'ro',
   isa      => 'Str',
   reader   => 'get_level',
   required => 1,
  );

# One of: WARN, ERROR, FATAL

######################################################################

has location =>
  (
   is       => 'ro',
   isa      => 'Str',
   reader   => 'get_location',
   default  => q{},
  );

# Manuscript location of the error (if applicable)

######################################################################

has message =>
  (
   is       => 'ro',
   isa      => 'Str',
   reader   => 'get_message',
   required => 1,
  );

# This is the error message itself.

######################################################################
######################################################################
##
## Public Methods
##
######################################################################
######################################################################

# NONE

######################################################################
######################################################################
##
## Private Attributes
##
######################################################################
######################################################################

# NONE

######################################################################
######################################################################
##
## Private Methods
##
######################################################################
######################################################################

# NONE

######################################################################

no Moose;
__PACKAGE__->meta->make_immutable;
1;
