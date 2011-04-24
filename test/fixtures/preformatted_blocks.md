I decided to start off this newsletter with one of the most basic but
essential pieces of knowledge you can have about Ruby's object model:
the way it looks up methods.  Let's do a little exploration by working
through a few examples.

Below we have a simple report class who's job is to perform some basic
data manipulations and then produce some text output.

    class Report
      def initialize(ledger)
        @balance          = ledger.inject(0) { |sum, (k,v)| sum + v }
        @credits, @debits = ledger.partition { |k,v| v > 0 }
      end

      attr_reader :credits, :debits, :balance

      def formatted_output
        "Current Balance: #{balance}\n\n" +
        "Credits:\n\n#{formatted_line_items(credits)}\n\n" +
        "Debits:\n\n#{formatted_line_items(debits)}"
      end
      
      def formatted_line_items(items)
        items.map { |k, v| "#{k}: #{'%.2f' % v.abs}" }.join("\n")
      end
    end

The following code demonstrates how we'd make use of this newly created class.

    ledger = [ ["Deposit Check #123", 500.15],
               ["Fancy Shoes",       -200.25],
               ["Fancy Hat",          -54.40],
               ["ATM Deposit",       1200.00],
               ["Kitteh Litteh",       -5.00] ]

    report = Report.new(ledger)
    puts report.formatted_output

And for those who don't want to take the time to copy and paste this
code and run it locally, here's what the output looks like:

    Current Balance: 1440.5

    Credits:

    Deposit Check #123: 500.15
    ATM Deposit: 1200.00

    Debits:

    Fancy Shoes: 200.25
    Fancy Hat: 54.40
    Kitteh Litteh: 5.00
