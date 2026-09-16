require "vite_ruby"

module Ratalada
  module Contrib
    module Vite
      module TagHelpers
        def vite_client_tag
          src = vite_manifest.vite_client_src

          if src
            %(<script type="module" src="#{src}"></script)
          end
        end

        def vite_react_refresh_tag = vite_manifest.react_refresh_preamble

        def vite_asset_path(name, **options) = vite_manifest.path_for(name, **options)

        def vite_javascript_tag(*names, type: "module", crossorigin: "anonymous", **options)
          entries = vite_manifest.resolve_entries(*names, **options)

          scripts = entries.fetch(:scripts).map do |src|
            %(<script type="#{type}" crossorigin="#{crossorigin}" src="#{src}"></script>)
          end
          preloads = entries.fetch(:imports).map do |href|
            %(<link rel="modulepreload" as="script" crossorigin="#{crossorigin}" href="#{href}">)
          end
          styles = entries.fetch(:stylesheets).map { |href| %(<link rel="stylesheet" href="#{href}">) }

          (scripts + preloads + styles).join("\n")
        end

        def vite_styleshee_tag(*name, **options)
          name
            .map { |name| vite_asset_path(name, type: :stylesheet, **options) }
            .map { |href| %(<link rel="stylesheet" href="#{href}">) }
            .join("\n")
        end

        private

          def vite_manifest
            ViteRuby.instance.manifest
          end
      end
    end
  end
end
