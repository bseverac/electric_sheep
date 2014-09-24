require 'shellwords'
require 'fileutils'

module ElectricSheep
  module Helpers
    class Directories

      def initialize(host, project, interactor)
        @host=host
        @project=project
        @interactor=interactor
      end

      def working_directory
        @host.working_directory || '$HOME/.electric_sheep'
      end

      def project_directory
        unless @project_directory
          File.join(
            working_directory,
            Shellwords.escape(@project.id.downcase)
          ).tap do |directory|
            @interactor.exec("echo \"#{directory}\"")[:out]
          end
        end
      end

      def mk_project_directory!
        @interactor.exec(
          "mkdir -p #{project_directory} ; chmod 0700 #{project_directory}"
        )[:out]
      end

      def expand_path(path)
        return path if Pathname.new(path).absolute?
        File.join(project_directory, resource.path)
      end

    end
  end
end
