module ElectricSheep
  module Metadata
    class Shell < Base
      include Queue
      include Metered

      def initialize(options={})
        super
        reset!
      end
      
      def validate(config)
        each_item do |command|
          unless command.validate(config)
            errors.add("Invalid command #{command.id}", command.errors)
          end
        end
        reset!
        super
      end

    end
  end
end
