When we know something is ugly or "evil", we're quick to replace it with what we
know to be a better solution.  But if we don't know *why* the solution is
better, it makes it hard for us to investigate those things that look reasonable
on the surface, yet have weaknesses just beneath the skin.

I'll run through a quick example of what I mean, and then, it'll be your turn to
run with it and report back here.  While I don't use this approach all the time,
I find it's a neat tool to have handy when you're trying to push your
understanding of your code just a little bit farther.

## Continuations are Evil?

It's pretty common knowledge that continuations in Ruby are evil.  But let's
pretend we didn't know that.  We might end up catching ourselves writing code
like this:

    table.each do |row|
      call_cc do |next_row|
        row.each do |field|
          if field.valid?
            do_something_with(field)
          else
            STDERR.puts "skipping a bad row"
            next_row[]
          end 
        end
      end
    end

The continuation approach actually doesn't look so bad.  All we're doing is
iterating over a two-dimensional structure and skipping ahead to the next row if
there is a problem with any of the fields. But having to pass along the
next_row callback seems a bit heavy handed, and also makes one wonder
what sort of magic it might be concealing.  Preserving the same basic flow, we
could be using catch / throw instead, lowering the conceptual
baggage:

    table.each do |row|
      catch(:next_row) do
        row.each do |field|
          if field.valid?
            do_something_with(field)
          else
            STDERR.puts "skipping a bad row"
            throw :next_row
          end 
        end
      end
    end

So, now, we have something that looks more-or-less like a transactional block,
which gets aborted when you throw :next_row.  Not too bad, but if
you're like me, you probably get annoyed about having your eyes bounce up and
down while you trace the flow, in both of these examples.  We can fix that, of
course:

    def process(row)
      row.each do |field|
        if field.valid?
          do_something_with(field)
        else
          STDERR.puts "skipping a bad row"
          return
        end
      end
    end
    
    table.each { |row| process(row) }

Now this is more like it!  This code is probably the same as what a beginner
might write, but it's also the clearest out of what we've seen here.  But
without it as a point of reference, neither the catch / throw or callcc
solutions would look terrible.

Through this quick little set of examples, I found a good reason *not* to use
continuations for this particular use case.  Arriving back at a simple solution
by starting with a "clever" one and reducing it down to the fundamentals was a
refreshing experience for me.

## Your Homework

Now it's your turn.  I'm encouraging you to ignore "Best Practices" and the
common idioms that we often accept as gospel.  

Pick one technique that's typically considered a no-no and do the best you can
to use it in a somewhat reasonable way.  You don't want to waste your time with
something that not even the most muddy-eyed coder would touch with a ten-foot
pole, as you won't learn much that way.  Instead, work with something that looks
fine or even clever at a first glance. 

Then, try to fix up what you built by using more idiomatic, simpler code.  Your
goal is to create something that still looks good, but isn't as much as a
liability (conceptually) as what you started with.  If you fail to do so, the
worst thing that could happen is that you may have come across a new idiom worth
sharing with others.  But more likely, with a little effort you'll have no
trouble uncovering the wisdom behind whatever idiom you were putting to the
test.

What's the difference?  Now, something that used to be a somewhat arbitrary rule
to you is now common sense.  As contexts shift, you may need to conduct new
experiments, but repeat this exercise often enough and you'll start to see a
powerful intuition develop that allows you to internalize your design decisions
rather than running through a punch list of patterns.  And at least for me, I
find that experience a lot more fun.  I hope you will, too.

If you try out this exercise, please share what you've done, either via a link
to your own blog, or a gist  I'm interested in how many bad ideas we can 
rack up here.
