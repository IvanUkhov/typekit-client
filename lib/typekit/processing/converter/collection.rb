module Typekit
  module Processing
    module Converter
      class Collection
        def initialize(name)
          @name = name
        end

        def process(response, collection_attributes)
          Typekit::Collection.new(@name, collection_attributes)
        end
      end
    end
  end
end