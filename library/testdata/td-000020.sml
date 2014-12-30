######################################################################

title:: Section Structure With Regions

id:: td-000020

version:: 2.0

revision:: 4444

date:: 2012-09-11

status:: yellow

define:: version2

######################################################################

This SML [g:sml:document] contains a section structure with regions. This opening paragraph is not in a section. I like to insert a line of 70 '#' signs before each section heading to make the manuscript easier to browse.

The Chicago Manual of Style has a lot of good things to say about how to put together a book. [cite:cms15]

SML is a [ac:sml:TLA] that stands for Structured Manuscript Language.

glossary:: document {sml} = (SML) A written work about a topic. SML document types are: book, report, and article. An SML document is composed of a document preamble followed by a document narrative

acronym:: TLA {sml} = Three Letter Acronym

######################################################################

* Introduction

id:: introduction

type:: chapter

This section is a chapter.[f:introduction:1] This is some introductory text. It really doesn't say anything interesting so let's just move along.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# footnotes

footnote::1: This is a footnote.

######################################################################

* System Model

id:: system-model

type:: chapter

This section is another chapter. This section will be a little more complicated because it has sub-sections.

######################################################################

** Problems

id:: problems

This section enumerates the problems (i.e. requirements) in the system model.

>>>problem

title:: Problem One

id:: problem-1

type:: technical

description:: This is a description of my problem. This purpose of this problem is to serve as a test for applications designed to process SML problem regions.

This paragraph begins the narrative portion of problem-1. The region narratives cannot contain sections but may contain environments such as tables and figures.

index:: narrative!region

Just for kicks, here is a baretable inside this problem region.

:: division

:: type

---

: table

: environment

---

: exercise

: region

---

<<<problem

######################################################################

** Solutions

id:: solutions

This section enumerates the solutions in the system model. Here is a table that defines the types of solutions:

---table

title:: Solutions Types

id:: tab-solution-types

:: Type

:: Description

---

: Architecture

: an architectural view of the system at a point in time

---

: Design

: a model of the system at a point in time

---

: Configuration Item

: description of implemented hardware, software, or documentation

---table

######################################################################

** Tests

id:: tests

This section enumerates the tests in the system model.

###comment

This is a comment division.  Everything between the begin and end tags
is ignored by the parser.  Well, not exactly ignored, but the content
of this comment won't appear in rendered documents.

###comment

???version1

This text will only be used if 'version1' has been defined.

???version1

######################################################################
# Sources

---source

source:: book

title:: The Chicago Manual of Style

label:: cms15

editor:: William S. Strong

editor:: Bryan A. Garner

edition:: 15th Edition

publisher:: The University of Chicago Press

year:: 2003

address:: Chicago 60637

note:: [url:http://www.chicagomanualofstyle.org]

---source

######################################################################
# Local Emacs Variables

# Local Variables:
# mode: outline
# mode: fill
# coding: us-ascii
# fill-column: 70
# End:

######################################################################
