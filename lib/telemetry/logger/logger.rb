module Telemetry
  module Logger
    extend self

    def build(subject, implementation=nil)
      implementation ||= Defaults.implementation
      logger = implementation.build(subject)
      logger
    end

    def get(subject, implementation=nil)
      logger = Logger.build self
      logger.obsolete "The \"get\" method is obsolete"

      build(subject, implementation=nil)
    end

    def register(subject, implementation=nil)
      logger = Logger.build self
      logger.obsolete "The \"register\" method is obsolete"

      build(subject, implementation=nil)
    end

    def configure(receiver, implementation=nil)
      logger = get(receiver, implementation)
      receiver.logger = logger
      logger
    end

    def self.debug(message)
      write message
    end

    def self.write(message, level=nil, subject=nil, implementation=nil)
      level ||= :debug
      subject ||= '***'

      logger = get subject, implementation

      logger.write_message level, message
    end

    module Defaults
      def self.implementation
        ConsoleLogger
      end
    end
  end
end
