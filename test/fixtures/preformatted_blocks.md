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

Amazing, right? (Yadda... yadda.. yadda)
