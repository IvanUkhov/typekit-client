module Typekit
  module Converter
    class DateTime
      def initialize(*)
      end

      def process(result, object)
        ::DateTime.parse(object)
      end
    end
  end
end
