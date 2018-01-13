module Diffity
  module Utils
    # http connection that will be used for uploading images
    def self.connection
      base_uri = Diffity.base_uri
      Faraday.new(base_uri, request: { timeout: 120, open_timeout: 120 }) do |f|
        f.request :basic_auth, Diffity.api_key, 'X'
        f.request :multipart
        f.request :url_encoded
        f.adapter :net_http
      end
    end

    def self.images_dir
      'tmp/diffity'.freeze
    end

    def self.upload_image(run_id, identifier, browser, device, os, browser_version,
                          device_name, os_version)
      Diffity.logger.fatal "uploading #{identifier}"
      image_io = Faraday::UploadIO.new(image_file(identifier), 'image/png')
      connection.post("/api/v1/runs/#{run_id}/run_images",
                      identifier: identifier, image: image_io, browser: browser,
                      device: device, os: os, browser_version: browser_version,
                      device_name: device_name, os_version: os_version)
    end

    def self.image_file(identifier)
      "#{Dir.pwd}/#{images_dir}/#{identifier}.png"
    end
  end
end
