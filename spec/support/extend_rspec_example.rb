module RSpec
  module Core
    class Example

      def <<(string)
        metadata[:description] << "\n\n" << string
      end

    end
  end
end
