module CatTree
  class Logger
    class << self
      attr_writer :logger

      def warn(message)
        return unless @logger
        @logger.warn message
      end
    end
  end
end
