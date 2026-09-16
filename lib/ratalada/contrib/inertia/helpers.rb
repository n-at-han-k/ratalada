# frozen_string_literal: true

require "json"

require_relative "response"

module Ratalada
  module Contrib
    module Inertia
      module Helpers
        def inertia(component, props: {}, layout: nil)
          if layout.nil?
            layout = current_page_layout
          end

          version = current_inertia_version
          shared = current_inertia_shared

          if !@inertia_encrypt_history_override.nil?
            encrypt = @inertia_encrypt_history_override == true
          else
            encrypt = Ratalada.config.inertia_encrypt_history == true
          end

          clear = @inertia_clear_history == true

          if inertia_request?
            content_type("application/json; charset=utf-8")
            headers("x-inertia" => "true", "vary" => "X-Inertia")
          end

          errors_payload = inertia_errors_payload
          sweep_inertia_session!

          response_obj = Ratalada::Contrib::Inertia::Response.new(
            component:       component,
            props:           props,
            request:         request,
            context:         self,
            version:         version,
            url:             request.fullpath,
            encrypt_history: encrypt,
            clear_history:   clear,
            shared:          shared,
            errors:          errors_payload,
          )
          page_hash = response_obj.to_h
          page_json = page_hash.to_json

          if inertia_request?
            page_json
          else
            @page = page_hash
            @page_json = ::Rack::Utils.escape_html(page_json)
            erb(layout, layout: false)
          end
        end

        def render(*args, **kwargs, &block)
          first = args.first
          if args.length == 1 && first.is_a?(Hash) && first.key?(:inertia)
            inertia(
              first[:inertia],
              props:  first[:props] || {},
              layout: first[:layout],
            )
          elsif kwargs.key?(:inertia) && args.empty?
            inertia(
              kwargs[:inertia],
              props:  kwargs[:props] || {},
              layout: kwargs[:layout],
            )
          elsif first.is_a?(String) &&
              args.length <= 2 &&
              (args.length == 1 || args[1].is_a?(Hash))
            layout = kwargs.delete(:layout)
            props = {}
            if args[1].is_a?(Hash)
              props.merge!(args[1])
            end
            explicit_props = kwargs.delete(:props)
            if explicit_props.is_a?(Hash)
              props.merge!(explicit_props)
            end
            props.merge!(kwargs)
            inertia(first, props: props, layout: layout)
          else
            super(*args, **kwargs, &block)
          end
        end

        def render_modal(background:, background_props:, component:, props:, url:)
          inertia(
            background,
            props: background_props.merge(
              modal: {
                component: component,
                props:     props,
                url:       url,
              },
            ),
          )
        end

        def inertia_request?
          request.env["HTTP_X_INERTIA"] == "true"
        end

        def page_request?
          inertia_request?
        end

        def csrf_token
          request.env["ratalada.inertia.csrf_token"]
        end

        # The prop factories are the gem's (Ratalada::Contrib::Inertia delegates to
        # InertiaRails).
        def always(value = nil, &block) = Ratalada::Contrib::Inertia.always(value, &block)
        def defer(group: "default", &block) = Ratalada::Contrib::Inertia.defer(group: group, &block)
        def optional(&block) = Ratalada::Contrib::Inertia.optional(&block)
        def lazy(&block) = Ratalada::Contrib::Inertia.lazy(&block)
        def merge(value = nil, &block) = Ratalada::Contrib::Inertia.merge(value, &block)
        def deep_merge(&block) = Ratalada::Contrib::Inertia.deep_merge(&block)
        def once(...) = Ratalada::Contrib::Inertia.once(...)
        def cache(...) = Ratalada::Contrib::Inertia.cache(...)
        def scroll(...) = Ratalada::Contrib::Inertia.scroll(...)

        def current_inertia_shared
          blocks = Ratalada.config.inertia_share_blocks || []
          merged = {}
          blocks.each do |b|
            v = instance_exec(&b)
            if v.is_a?(Hash)
              merged = deep_merge_hashes(merged, v)
            end
          end

          merged
        end

        def current_inertia_version
          Ratalada::Contrib::Inertia.current_version
        end

        def inertia_errors(payload = nil)
          if payload.nil?
            (session[:_inertia_errors] || {}).dup
          else
            session[:_inertia_errors] = payload
            payload
          end
        end

        def page_errors(payload = nil)
          inertia_errors(payload)
        end

        def inertia_clear_history!
          @inertia_clear_history = true
        end

        def clear_history!
          inertia_clear_history!
        end

        def inertia_encrypt_history!(flag = true)
          @inertia_encrypt_history_override = flag
        end

        def encrypt_history!(flag = true)
          inertia_encrypt_history!(flag)
        end

        def inertia_errors_payload
          errors = session[:_inertia_errors]
          if errors.nil?
            nil
          else
            if errors.respond_to?(:empty?) && errors.empty?
              nil
            else
              errors
            end
          end
        end

        def sweep_inertia_session!
          if session.respond_to?(:[]=)
            session[:_inertia_errors] = nil
          end
        end

        private

          def current_page_layout
            config = Ratalada.config
            if config.respond_to?(:page_layout)
              config.page_layout
            else
              config.inertia_layout
            end
          end

          def deep_merge_hashes(a, b)
            a.merge(b) do |_k, av, bv|
              (av.is_a?(Hash) && bv.is_a?(Hash)) ? deep_merge_hashes(av, bv) : bv
            end
          end
      end
    end
  end
end
