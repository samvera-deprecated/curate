module Curate
  module MigrationServices
    class Logger < ActiveSupport::Logger

      def initialize
        @successes, @failures = 0, 0
        super(Rails.root.join("log/#{Rails.env}-migrator.log"))
      end

      def around(context)
        begin
          start(context)
          yield(self)
          stop(context)
        rescue Exception => e
          error("Unable to finish #{context}. Encountered #{e}")
          raise e
        ensure
          finalize(context)
          exit(-1) if @failures > 0
        end
      end

      def success(pid)
        @successes += 1
        info("PID=#{pid.inspect}\tSuccess")
      end

      def failure(pid)
        @failures += 1
        error("PID=#{pid.inspect}\tFailure\tfailed but no exception was thrown.")
      end

      def exception(pid, exception)
        @failures += 1
        error("PID=#{pid.inspect}\tFailure with Exception\tfailed with the following exception: #{exception}.")
      end
      private
      def start(context)
        info("#{Time.now}\tStart #{context}")
      end
      def stop(context)
        info("#{Time.now}\tFinish #{context}")
      end

      def finalize(context)
        info("\nActivity for #{context}\n\tSuccesses: #{@successes}\n\tFailures: #{@failures}\n")
      end
    end
  end
end
