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
