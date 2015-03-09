Inferno
===========
An experimental transformative selector-based templating system for
Elixir.

Goals
===========
- Provide a means for writing templates in a functional style.
- Seperation of presentation/logic 
- Provide cache mechanisms to re-output content that has already been created.
- compiled
- Easy to use.
- Well documented.
- Well Tested.

Preamble
==========

Actions
=======


Libraries that may be useful 
============================

Structure
=========

urlreader
filereader
reader - get the document from a file or a url

tokenizer - tokenize a html document 
parser

Tree - A structure for the parse tree. Zipper tree? Longer term the parser
       should generate this directly but in the short term a converstion 
       nethod will suffice.

Selector - CSS syntax based selectors acting on the tree

Transforms - macros and functions to apply the transforms to the tree


# Mockup
========
