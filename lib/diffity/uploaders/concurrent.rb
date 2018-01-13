require 'diffity/utils'

module Diffity
  module Uploaders
    class Concurrent
      MAX_NO_OF_THREADS = 20

      def initialize(run_id)
        @run_id = run_id
        @pool = ::Concurrent::FixedThreadPool.new(MAX_NO_OF_THREADS)
        @screenshots_taken = 0
      end

      def enqueue(identifier, browser, device, os, browser_version,
                  device_name, os_version)
        @screenshots_taken += 1

        @pool.post do
          Diffity::Utils
            .upload_image(@run_id, identifier, browser, device, os,
                          browser_version, device_name, os_version)
        end
      end

      def wrapup
        retries = 180           # 30 mins

        # if all screenshots are not uploaded, wait.
        until @screenshots_taken == @pool.completed_task_count
          retries -= 1
          break if retries.zero?

          sleep 10
        end

        @pool.shutdown
        @pool.wait_for_termination
      end
    end
  end
end
