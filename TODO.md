# Things to do and/or think about
  
* Emitter experiment is useful for getting some ideas about how all this will
  hang together, but is as of right now untested and hard codes several
  assumptions that should probably be configurable.

* QUESTION: To what extent should the parser mess with whitespace characters?
  Currently aggressively mangling whitespace as needed.

* Look into generating ePub from scratch. eeepub is straightforward but we could
  better.

* Make it possible for unordered list items to include newlines without
  breaking listing. Multi-line statements are still possible in output, but
  input file must be soft wrapped in list items to have proper output.

* Refactoring is definitely going to need to happen soon. The whole project is
  currently a mess.

* Need to be able to pull snippets in from other files for pre-formatted text
  sections.  Something like:  [pre path/to/file]

* Find out why MOBI format is placing us at the last chapter by default rather
  than the first

* Need Table of Contents

* Need page numbers for PDF at least.

* Need a parser that doesn't suck
