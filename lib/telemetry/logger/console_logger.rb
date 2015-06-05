module Telemetry
  module Logger
    class ConsoleLogger
      include Levels

      attr_reader :name
      attr_reader :device

      attr_reader :level
      attr_reader :level_number

      dependency :clock, Clock::Local

      def self.build(subject)
        name = logger_name(subject)
        device = Defaults.device
        instance = new(name, device)
        instance.level = Defaults.level
        Clock::Local.configure instance
        instance
      end

      def self.logger_name(subject)
        if subject.is_a?(Class) || subject.is_a?(Module)
          name = subject.name
        elsif subject.is_a? String
          name = subject
        else
          name = subject.class.name
        end
        name
      end

      def initialize(name, device)
        @name = name
        @device = device
      end

      def write(message)
        return if Defaults.activation == 'off'
        device.puts message unless excluded?(message)
      end

      def excluded?(message)
        exclude = ENV['LOG_EXCLUDE']

        message =~ /#{exclude}/ if exclude
      end

      def level=(val)
        index = levels.index(val)

        raise "Unknown logger level: #{val}" unless index

        @level_number = index
        @level = val
      end

      module Defaults
        def self.level
          level = ENV['LOG_LEVEL']
          return level.to_sym if level

          :info
        end

        def self.device
          setting = ENV['CONSOLE_DEVICE']
          device = nil
          if setting && !['stderr', 'stdout'].include?(setting)
            raise "The CONSOLE_DEVICE should be either 'stderr' (default) or 'stdout'"
          elsif setting
            device = setting == 'stderr' ? STDERR : STDOUT
          else
            device = STDERR
          end
          device
        end

        def self.activation
          activation = ENV['LOGGER']
          return activation if activation

          'on'
        end
      end
    end
  end
end
