# frozen_string_literal: true

require "json"

module Ratalada
  module Contrib
    module Inertia
      # Builds the Inertia page object for a render. Shared data is deep-merged
      # under the page props and errors are merged on top; prop resolution —
      # partial reloads, deferred/optional/merge/once/scroll metadata — is the
      # gem's PropsResolver, evaluating blocks in the request context via the
      # gem's PropEvaluator.
      class Response
        attr_reader(
          :component,
          :props,
          :request,
          :context,
          :version,
          :url,
          :encrypt_history,
          :clear_history,
          :shared,
          :errors,
        )

        def initialize(
          component:,
          props:,
          request:,
          context:,
          version:,
          url: nil,
          encrypt_history: false,
          clear_history: false,
          shared: {},
          errors: nil
        )
          @component = component
          @props = props || {}
          @request = request
          @context = context
          @version = version.to_s
          @url = url || request.fullpath
          @encrypt_history = encrypt_history
          @clear_history = clear_history
          @shared = shared || {}
          @errors = errors
        end

        def to_h
          merged = deep_merge(shared, props)
          if errors
            merged = merged.merge(errors: errors)
          end

          resolved, metadata = ::InertiaRails::PropsResolver.new(
            merged,
            evaluator: ::InertiaRails::PropEvaluator.new(
              context,
              scroll_intent: request.env["HTTP_X_INERTIA_INFINITE_SCROLL_MERGE_INTENT"],
            ),
            visit:     {
              component:   partial_request?,
              only:        header_list("HTTP_X_INERTIA_PARTIAL_DATA"),
              except:      header_list("HTTP_X_INERTIA_PARTIAL_EXCEPT"),
              reset:       header_list("HTTP_X_INERTIA_RESET"),
              except_once: header_list("HTTP_X_INERTIA_EXCEPT_ONCE_PROPS"),
            },
          ).resolve

          page = {
            component: component,
            props:     resolved,
            url:       url,
            version:   version,
          }
          if encrypt_history
            page[:encryptHistory] = true
          end
          if clear_history
            page[:clearHistory] = true
          end
          page.merge!(metadata)
          page
        end

        def to_json(*) = to_h.to_json

        private

          def partial_request?
            request.env["HTTP_X_INERTIA_PARTIAL_COMPONENT"] == component
          end

          def header_list(key)
            request.env[key].to_s.split(",").map(&:strip).reject(&:empty?)
          end

          def deep_merge(a, b)
            a.merge(b) do |_k, av, bv|
              if av.is_a?(Hash) && bv.is_a?(Hash)
                deep_merge(av, bv)
              else
                bv
              end
            end
          end
      end
    end
  end
end
