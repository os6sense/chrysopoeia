Chrysopoeia
===========
A experimental parallel template rendering engine for Elixir.

Goals
===========
- Significantly increase rendering speed of HTML templates.
- Provide a means for writing templates in a functional style.
- Seperate the presentation/logic concerns
- Provide cache mechanisms to re-output content that has already been created.
- compiled
- Easy to use.
- Well documented.
- Well Tested.

Preamble
==========
A long time ago I had the good fortune to work with my first functional
language, XSLT. I loved it, but apart from a few snippets here and there all I
really remember about it was my main takeaway - that when working with XML it
made hard things easier and easy things harder.  Oh and one other thing - that
the promise, in being a functional language without side effects, that the
individual transformations were (in theory) parralizable.

Sadly life being life, I've had little opportunity to program over the last few
years - I've dabbled, had one of two serious side projects, but for the most
part my work has leaned more to the sys admin side of things.

But I recently decided to learn Elixir and saw some real promise in the
language but was somewhat agahst by the PHP style ".ex" templates I was seeing,
and my mind turned back to XSLT.  Of course, XSL never really gained the
traction that (I think) it deserved because it was so damn complicatied but it
was good to see that some of the basic ideas are alive and well in projects
such as Enlive, Tritium, Moulder et al.

Hence Chrysopoeia is a transformative selector-based templating system 

Selector Syntax:

I was VERY tempted to use an XPATH syntax and may well add one as an alternative
at a later date but for now the syntax is based on CSS 3.0.

Actions
=======
# Action 0 - TESTS. No feature shall be added without an accompaning test. 
             

# Action 0 - Benchmark. At this point can compare to eex but also
#            compare to erlang ones at a later date.

Libraries that may be useful 
============================
okeuday/trie

floki - sort of does what I want but dependent on mochiweb for tokenization,
parsing and generating the parse tree.

Structure
=========

urlreader
filereader
reader - get the document from a file or a url


tokenizer - tokenize a html document 
parser

Tree - A structure for the parse tree.
I had a look at the structure returned by 






# Mockup
========
# Note it should be possible to require the defhtmls from another file.



