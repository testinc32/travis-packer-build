require 'yaml'
require 'erb'

module Travis
  module PackerBuild
    class YamlLoader
      def self.load(filename)
        load_string(File.read(filename))
      end

      def self.load_string(string)
        YAML.load(ERB.new(string).result)
      end
    end
  end
end
