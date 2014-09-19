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
          error("Unable to finish #{context}. Encountered #{e}\n#{e.backtrace}")
          raise e
        ensure
          finalize(context)
          exit(-1) if @failures > 0
        end
      end

      def success(pid, model_name)
        @successes += 1
        info("#{preamble(pid, model_name)}\tSuccess")
      end

      def failure(pid, model_name)
        @failures += 1
        error("#{preamble(pid, model_name)}\tFailure\tfailed but no exception was thrown.")
      end

      def exception(pid, model_name, exception)
        @failures += 1
        error("#{preamble(pid, model_name)}\tFailure with Exception\tfailed with the following exception: #{exception}.\n#{exception.backtrace.inspect}")
      end
      private
      def preamble(pid, model_name)
        "PID=#{pid.inspect}\tMODEL=#{model_name}"
      end
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
