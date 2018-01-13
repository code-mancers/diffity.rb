module Diffity
  class RunDetails
    class Jenkins
      def branch
        ENV.fetch('GIT_BRANCH').split('/').last
      end

      def author
        'Jenkins'.freeze
      end
    end

    class Travis
      def branch
        ENV.fetch('TRAVIS_BRANCH')
      end

      def author
        'Travis'.freeze
      end
    end

    class GitRepo
      def branch
        `git rev-parse --abbrev-ref HEAD`.strip
      end

      def author
        `git config user.name`.strip
      end
    end

    class Default
      def branch
        'HEAD'.freeze
      end

      def author
        'None'.freeze
      end
    end

    def details
      if !!ENV['JENKINS_HOME']
        Jenkins.new
      elsif !!ENV['TRAVIS']
        Travis.new
      elsif system('git branch')
        GitRepo.new
      else
        Default.new
      end
    end
  end
end
