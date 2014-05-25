module Typekit
  module Routing
    class Proxy
      def initialize(map, **options)
        @map = map
        @options = options
      end

      def resources(name, **options, &block)
        @map.define_collection(name, **@options, **options, &block)
      end

      def scope(path, &block)
        @map.define_scope(path, **@options, &block)
      end

      Config.actions.each do |action|
        define_method action do |name, **options|
          @map.define_singleton(action, name, **@options, **options)
        end
      end
    end
  end
end