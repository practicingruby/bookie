## 0.0.1 (2011.04.23)

Add some barely functional Parser and Document object stubs, initial gem release
to claim the namespace.

## 0.0.2 (2011.04.23)

Create some stubs for Paragraph and ContentTree objects, enough for us to start
thinking about what the emitter API might look like. But not really enough to do
anything else.

## 0.0.3 (2011.04.23)

Added some basic emitters for PDF and HTML paragraphs. Note these are proofs of
concept ONLY, not meant for practical use. See examples/simple_emitters.rb to
see how they're used.

## 0.0.4 (2011.04.24)

Removed HTML emitter for now. Expanded parser and PDF emitter to support
preformatted text. See examples/preformatted.rb for to see how it works.

## 0.0.5 (2011.04.24)

Reinstated a skeletal HTML emitter because it's needed for EPub and Mobi. Added
pretty terrible Mobi support, will not really be useful until we flesh out
manifests and table of content generation, but looks okay on my Kindle!

## 0.0.6 (2011.04.26)

Added a minimal ePUB generator that seems to work at least for Adobe Digital
Editions and EPubReader. Still have not tested where it matters, the
iPad+iBooks.

## 0.0.7 (2011.04.27)

Hack in section headings, right now using the ## syntax from markdown.
Copy-paste lots of stuff from github.com/madriska/jambalaya, including the
DejaVu font sets. Make PDF output look pretty, but the source code look ugly.

## 0.0.8 (2011.04.28)

Basic support for unordered lists. The ePUB output has not been tested yet,
because most desktop based ePUB readers suck and I don't have an iPad. Will ask
friends to test soon.

## 0.0.9 (2011.04.28)

Add barely useful command line app

## 0.0.10 (2011.04.28)

Fix some PDF bugs and make a little draw() helper for emitter.

## 0.0.11 (2011.04.30)

Remove Document class for now. Remove bookie executable for now. Remove all old
examples from <= 0.0.10. Move towards a book manifest type API. Much work needs
 to be done to make this actually usable.

## 0.0.12 (2011.05.12)

Added rudimentary chapter support for EPUB, MOBI, and PDF. Render once per
emitter rather than once per chapter per emitter (bugfix).

## 0.0.13 (2011.05.23)

Basic inline code formatting. Horrible parser needs to go away...

## 0.0.14 (2011.10.7)

Improved parser (using RedCarpet 2) thanks to Gregory Parkhurst
