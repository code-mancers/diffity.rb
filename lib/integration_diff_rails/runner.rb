module IntegrationDiffRails
  class Runner
    include Capybara::DSL

    DIR = 'tmp/idff_images'

    def self.instance
      @runner ||= Runner.new(IntegrationDiffRails.project_name,
                             IntegrationDiffRails.javascript_driver)
    end

    def initialize(project_name, javascript_driver)
      @project_name = project_name
      @javascript_driver = javascript_driver
      Dir.mkdir(DIR) unless Dir.exist?(DIR)
    end

    # TODO: Improve error handling here for network timeouts
    def start_run
      draft_run
      @upload_image = UploadImageService.pool(size: 10, args: [@run_id])
    rescue StandardError => e
      Rails.logger.fatal e.message
      raise e
    end

    # TODO: Improve error handling here for network timeouts
    def wrap_run
      finalize_run if @run_id
    rescue StandardError => e
      Rails.logger.fatal e.message
      raise e
    end

    def screenshot(identifier)
      screenshot_name = image_file(identifier)
      page.save_screenshot(screenshot_name, full: true)
      @upload_image.async.upload_image_in_thread(identifier, screenshot_name)
    end

    private

    def draft_run
      run_name = @project_name + "-" + Time.current.iso8601

      # will have to make it configurable. ie, read from env.
      # https://github.com/code-mancers/integration-diff-rails/pull/4#discussion-diff-42290464
      branch = `git rev-parse --abbrev-ref HEAD`.strip
      author = `git config user.name`.strip
      project = IntegrationDiffRails.project_name

      response = IntegrationDiffRails.connection.post('/api/v1/runs',
                                                      name: run_name,
                                                      project: project,
                                                      group: branch,
                                                      author: author,
                                                      js_driver: @javascript_driver)

      @run_id = JSON.parse(response.body)['id']
    end

    def finalize_run
      IntegrationDiffRails.connection.put("/api/v1/runs/#{@run_id}/status", status: "finalized")
    end

    def image_file(identifier)
      "#{DIR}/#{identifier}.png"
    end
  end

  def self.connection
    @conn ||= Faraday.new(IntegrationDiffRails.base_uri) do |f|
      f.request :basic_auth, IntegrationDiffRails.api_key, 'X'
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end
  end
end
