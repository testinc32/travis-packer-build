module Travis
  module PackerBuild
    class ChefPackerTemplates
      def initialize(cookbook_path, packer_templates_path)
        @cookbook_path = cookbook_path
        @packer_templates_path = packer_templates_path
      end

      def each(&block)
        cookbooks_by_template.each(&block)
      end

      private

      attr_reader :cookbook_path, :packer_templates_path

      def cookbooks_by_template
        @cookbooks_by_template ||= load_cookbooks_by_template
      end

      def load_cookbooks_by_template
        loaded = {}

        Travis::PackerBuild::PackerTemplates.new(
          packer_templates_path
        ).each do |_, t|
          Array(t.parsed['provisioners']).each do |provisioner|
            next unless provisioner['type'] =~ /chef/
            next if Array(provisioner.fetch('run_list', [])).empty?
            loaded[t] = Travis::PackerBuild::ChefDependencyFinder.new(
              provisioner['run_list'], cookbook_path
            ).find
          end
        end

        loaded
      end
    end
  end
end
