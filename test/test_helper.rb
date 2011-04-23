require "minitest/autorun"

# adopted from: https://gist.github.com/839034
def context(*args, &block)
  return super unless (name = args.first) && block

  context_class = Class.new(MiniTest::Unit::TestCase) do
    class << self
      def test(name, &block)
        test_method_name = "test_#{name.gsub(/\W/,'_')}"
        block ||= lambda { skip(name) }

        define_method(test_method_name, &block)
      end

      def setup(&block)
        define_method(:setup, &block)
      end

      def teardown(&block)
        define_method(:teardown, &block)
      end
    end
  end

   context_class.singleton_class.instance_eval do
     define_method(:name) { name }
   end

  context_class.class_eval(&block)
end
