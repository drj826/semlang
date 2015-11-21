#!/usr/bin/perl

# $Id: Element.pm 255 2015-04-01 16:07:27Z drj826@gmail.com $

package SML::Element;

use Moose;

use version; our $VERSION = qv('2.0.0');

extends 'SML::Block';

use namespace::autoclean;

use Log::Log4perl qw(:easy);
with 'MooseX::Log::Log4perl';
my $logger = Log::Log4perl::get_logger('sml.Element');

######################################################################
######################################################################
##
## Public Attributes
##
######################################################################
######################################################################

has '+name' =>
  (
   required => 1,
  );

######################################################################

has value =>
  (
   is        => 'ro',
   isa       => 'Str',
   reader    => 'get_value',
   writer    => 'set_value',
   predicate => 'has_value',
  );

# This is the value of the element.  The value may contain SML markup.

######################################################################
######################################################################
##
## Public Methods
##
######################################################################
######################################################################

sub validate_element_allowed {

  my $self = shift;

  my $library  = $self->get_library;
  my $ontology = $library->get_ontology;
  my $name     = $self->get_name;
  my $division = $self->get_containing_division;
  my $valid    = 1;

  return 0 if not defined $division;

  my $divname      = $division->get_name;
  my $value        = $self->get_value;
  my $object_type  = $self->_type_of($value);

  if
    (
     $ontology->get_rule_for($divname,$name,$object_type)
     or
     $ontology->get_rule_for($divname,$name,'STRING')
    )
      {
	# valid
      }

  elsif
    (
     $ontology->get_rule_for('UNIVERSAL',$name,$object_type)
     or
     $ontology->get_rule_for('UNIVERSAL',$name,'STRING')
    )
      {
	# valid
      }

  elsif ( $name eq 'id' and $divname eq $object_type )
      {
	# valid
      }

  else
    {
      my $location = $self->get_location;
      $logger->warn("ELEMENT NOT ALLOWED \'$divname\' \'$name\' \'$object_type\' at $location");
      $valid = 0;
    }

  return $valid;
}

######################################################################

sub validate_outcome_semantics {

  my $self = shift;

  my $valid   = 1;
  my $library = $self->get_library;
  my $syntax  = $library->get_syntax;
  my $util    = $library->get_util;
  my $text    = $self->get_content;

  $text =~ s/[\r\n]*$//;                # chomp;

  if ( $text =~ /$syntax->{outcome_element}/xms )
    {
      my $date        = $2;
      my $entity_id   = $3;
      my $status      = $4;
      my $description = $5;

      # date valid?
      if ( not $date =~ /$syntax->{valid_date}/xms )
	{
	  my $location = $self->get_location;
	  $logger->error("INVALID OUTCOME DATE at $location: \'$date\'");
	  $valid = 0;
	}

      # item under test valid?
      if ( not $library->has_division($entity_id) )
	{
	  my $location = $self->get_location;
	  $logger->error("INVALID OUTCOME ITEM at $location: \'$entity_id\'");
	  $valid = 0;
	}

      # status valid?
      if ( not $status =~ /$syntax->{valid_status}/xms )
	{
	  my $location = $self->get_location;
	  $logger->error("INVALID OUTCOME STATUS at $location: must be green, yellow, red, or grey");
	  $valid = 0;
	}

      # description valid?
      if ( not $description =~ /$syntax->{valid_description}/xms )
	{
	  my $location = $self->get_location;
	  $logger->error("INVALID OUTCOME DESCRIPTION at $location: description not provided");
	  $valid = 0;
	}

      return $valid;
    }

  else
    {
      my $location = $self->get_location;
      $logger->error("This should never happen (at $location)");
      $valid = 0;
    }

  return $valid;
}

######################################################################

# sub validate_footnote_syntax {

#   my $self = shift;

#   my $valid   = 1;
#   my $library = $self->get_library;
#   my $syntax  = $library->get_syntax;
#   my $text    = $self->get_content;

#   if ( not $text =~ /$syntax->{footnote_element}/xms )
#     {
#       my $location = $self->get_location;
#       $logger->warn("INVALID FOOTNOTE SYNTAX: at $location");
#       $self->set_valid(0);
#       $valid = 0;
#     }

#   return $valid;
# }

######################################################################

# override 'validate_syntax' => sub {

#   my $self = shift;

#   my $name  = $self->get_name;
#   my $valid = super();

#   if ( $name eq 'footnote' )
#     {
#       if ( not $self->validate_footnote_syntax )
# 	{
# 	  $valid = 0;
# 	}
#     }

#   return $valid;
# };

######################################################################

# override 'validate_semantics' => sub {

#   # Validate there is an ontology rule for this element. In other
#   # words, validate the ontology allows this element.

#   my $self = shift;

#   my $valid = super();
#   my $name  = $self->get_name;

#   if ( not $self->validate_element_allowed )
#     {
#       $valid = 0;
#     }

#   if ( $name eq 'outcome' )
#     {
#       if ( not $self->validate_outcome_semantics )
# 	{
# 	  $valid = 0;
# 	}
#     }

#   return $valid;
# };

######################################################################
######################################################################
##
## Private Methods
##
######################################################################
######################################################################

sub _build_value {

  # Strip the element name off the beginning of the element content.
  # Strip any comment text off the end of the element content.

  my $self = shift;

  my $library = $self->get_library;
  my $syntax  = $library->get_syntax;
  my $text    = $self->get_content || q{};

  $text =~ s/[\r\n]*$//;                # chomp;

  if ( $text =~ /$syntax->{'element'}/xms )
    {
      my $util = $library->get_util;

      if ( $1 eq 'date' and $3 =~ /^\$Date:\s*(.*)\s*\$$/ )
	{
	  return $1;
	}

      elsif ( $1 eq 'revision' and $3 =~ /^\$Revision:\s*(.*)\s*\$$/ )
	{
	  return $1;
	}

      else
	{
	  return $util->trim_whitespace($3);
	}
    }

  elsif ( $text =~ /$syntax->{'start_section'}/xms )
    {
      my $util = $library->get_util;

      return $util->trim_whitespace($4);
    }

  else
    {
      my $name = $self->get_name;
      $logger->error("This should never happen $name $self (\'$text\')");
      return q{};
    }
}

######################################################################

sub _type_of {

  # Return the TYPE of the element value (object name, STRING, or
  # BOOLEAN)

  my $self  = shift;
  my $value = shift;

  my $library = $self->get_library;
  my $util    = $library->get_util;
  my $name    = q{};

  if ( $library->has_division_id($value) )
    {
      my $object = $library->get_division($value);
      return $object->get_name;
    }

  elsif ( $value eq '0' or $value eq '1' )
    {
      return 'BOOLEAN';
    }

  else
    {
      return 'STRING';
    }
}

######################################################################

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=head1 NAME

C<SML::Element> - a block containing a name/value pair expressing a
piece of structured information (descriptive markup) or instructing
the publishing application to take some action (procedural markup).

=head1 VERSION

2.0.0

=head1 SYNOPSIS

  extends SML::Block

  my $element = SML::Element->new
                  (
                    name    => $name,
                    library => $library,
                  );

  my $string  = $element->get_value;
  my $boolean = $element->validate_element_allowed;
  my $boolean = $element->validate_outcome_semantics;
  my $boolean = $element->validate_footnote_syntax;

=head1 DESCRIPTION

An element is a block containing a name/value pair expressing a piece
of structured information (descriptive markup) or instructing the
publishing application to take some action (procedural markup).
Elements are usually defined within DATA SEGMENT divisions but there
are several 'universal' elements that may be used in NARRATIVE
SEGMENTS as well.

=head1 METHODS

=head2 get_value

=head2 validate_element_allowed

=head2 validate_outcome_semantics

=head2 validate_footnote_syntax

=head1 AUTHOR

Don Johnson (drj826@acm.org)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012,2013 Don Johnson (drj826@acm.org)

Distributed under the terms of the Gnu General Public License (version
2, 1991)

This software is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
License for more details.

MODIFICATIONS AND ENHANCEMENTS TO THIS SOFTWARE OR WORKS DERIVED FROM
THIS SOFTWARE MUST BE MADE FREELY AVAILABLE UNDER THESE SAME TERMS.

=cut
