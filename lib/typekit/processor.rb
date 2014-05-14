module Typekit
  class Processor
    def initialize options
      format = options[:format]
      extend Parser.const_get format.to_s.upcase
    rescue NameError
      raise NameError, "The is no parser for the format '#{ format }'."
    end

    def process response
      return parse response.content if response.success?

      begin
        result = parse response.content
      rescue
        result = {}
      end

      if result.include? 'errors'
        raise Error.new code: response.code, message: result['errors']
      else
        raise Error.new code: response.code
      end
    end
  end
end
