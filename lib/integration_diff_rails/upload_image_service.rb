require 'celluloid/current'

module IntegrationDiffRails
  class UploadImageService
    include Celluloid

    def initialize(run_id)
      @run_id = run_id
    end

    def upload_image_in_thread(identifier, image_file)
      return if identifier.blank?
      image_io = Faraday::UploadIO.new(image_file, 'image/png')
      IntegrationDiffRails.connection.post("/api/v1/runs/#{@run_id}/run_images",
                                           identifier: identifier,
                                           image: image_io)
    end
  end
end
