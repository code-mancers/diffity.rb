module Diffity
  module Dsl
    def self.diffity
      @diffity ||=
        begin
          klass =
            if Diffity.enable_service
              Diffity::Runner
            else
              Diffity::DummyRunner
            end

          Diffity.logger.info "Using runner #{klass}"
          klass.instance
        end
    end

    def diffity
      Diffity::Dsl.diffity
    end
  end
end
