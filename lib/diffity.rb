require 'faraday'
require 'diffity/dummy_runner'
require 'diffity/runner'
require 'diffity/dsl'
require 'logger'

module Diffity
  # configure domain to which all images have to be uploaded.
  @@base_uri = "http://diffity.com"
  def self.base_uri=(uri)
    @@base_uri = uri
  end
  def self.base_uri
    @@base_uri
  end

  # configure project name to which images belong to.
  @@project_name = "idf"
  def self.project_name=(name)
    @@project_name = name
  end
  def self.project_name
    @@project_name
  end

  # configure api_key required to authorize api access
  @@api_key = ''
  def self.api_key=(key)
    @@api_key = key
  end
  def self.api_key
    @@api_key
  end

  # configure js driver which is used for taking screenshots.
  @@javascript_driver = "poltergeist"
  def self.javascript_driver=(driver)
    @@javascript_driver = driver
  end
  def self.javascript_driver
    @@javascript_driver
  end

  # configure service to be mocked so that no screenshots are
  # taken, and uploaded to service.
  @@enable_service = false
  def self.enable_service=(enable)
    @@enable_service = enable
  end
  def self.enable_service
    @@enable_service
  end

  # configure logger, which will be used to log issues if any
  @@logger = Logger.new(STDOUT)
  def self.logger=(new_logger)
    @@logger = new_logger
  end
  def self.logger
    @@logger
  end

  # helper to configure above variables.
  def self.configure
    yield(self)
  end

  # helps in setting up the run
  def self.start_run
    Diffity::Dsl.diffity.start_run
  end

  # helps in wrapping up run by uploading images
  def self.wrap_run
    Diffity::Dsl.diffity.wrap_run
  end
end
