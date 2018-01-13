require 'time'
require 'json'
require 'diffity/run_details'
require 'diffity/uploader'
require 'diffity/utils'

module Diffity
  class Runner
    include Capybara::DSL

    def self.instance
      @runner ||= Runner.new(Diffity.project_name,
                             Diffity.javascript_driver)
    end

    attr_accessor :browser, :device, :os
    attr_accessor :browser_version, :device_name, :os_version

    def initialize(project_name, javascript_driver)
      @project_name = project_name
      @javascript_driver = javascript_driver

      dir = Diffity::Utils.images_dir
      Dir.mkdir('tmp') unless Dir.exist?('tmp')
      Dir.mkdir(dir) unless Dir.exist?(dir)

      self.browser = 'firefox'
      self.device = 'desktop'
      self.os = 'linux'
    end

    # TODO: Improve error handling here for network timeouts
    def start_run
      draft_run
      @uploader = Diffity::Uploader.build(@run_id)
    rescue StandardError => e
      Diffity.logger.fatal e.message
      raise e
    end

    # TODO: Improve error handling here for network timeouts
    def wrap_run
      @uploader.wrapup

      complete_run if @run_id
    rescue StandardError => e
      Diffity.logger.fatal e.message
      raise e
    end

    def screenshot(identifier)
      raise 'no browser information provided' if browser.nil?
      raise 'no device information provided' if device.nil?
      raise 'no os information provided' if os.nil?

      screenshot_name = Diffity::Utils.image_file(identifier)
      page.save_screenshot(screenshot_name, full: true)
      @uploader.enqueue(identifier, browser, device, os, browser_version,
                        device_name, os_version)
    end

    private

    def draft_run
      run_name = @project_name + "-" + Time.now.iso8601

      details = Diffity::RunDetails.new.details
      branch = details.branch
      author = details.author
      project = @project_name

      response = connection.post('/api/v1/runs',
                                 name: run_name, project: project, group: branch,
                                 author: author, js_driver: @javascript_driver)

      @run_id = JSON.parse(response.body)["id"]
    end

    def complete_run
      connection.put("/api/v1/runs/#{@run_id}/status", status: "completed")
    end

    def connection
      @connection ||= Diffity::Utils.connection
    end
  end
end
