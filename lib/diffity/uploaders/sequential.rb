require 'diffity/utils'

module Diffity
  module Uploaders
    class Sequential
      def initialize(run_id)
        @run_id = run_id
        @identifiers_with_env = []
      end

      def enqueue(identifier, browser, device, os, browser_version,
                  device_name, os_version)
        @identifiers_with_env << [identifier, browser, device, os,
                                  browser_version, device_name,
                                  os_version]
      end

      def wrapup
        @identifiers_with_env
          .each do |identifier, browser, device, os, browser_version, device_name, os_version|
          Diffity::Utils
            .upload_image(@run_id, identifier, browser, device, os,
                          browser_version, device_name, os_version)
        end
      end
    end
  end
end
