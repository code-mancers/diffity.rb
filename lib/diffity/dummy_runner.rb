module Diffity
  class DummyRunner
    def self.instance
      @runner ||= DummyRunner.new
    end

    attr_accessor :browser, :device, :os
    attr_accessor :browser_version, :device_name, :os_version

    def start_run
    end

    def wrap_run
    end

    def screenshot(_)
    end
  end
end
