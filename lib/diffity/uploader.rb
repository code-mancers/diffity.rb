module Diffity
  class Uploader
    def self.build(run_id)
      if defined?(::Concurrent)
        require 'diffity/uploaders/concurrent'
        Diffity::Uploaders::Concurrent.new(run_id)
      else
        require 'diffity/uploaders/sequential'
        Diffity::Uploaders::Sequential.new(run_id)
      end
    end
  end
end
