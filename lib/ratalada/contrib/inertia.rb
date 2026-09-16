# frozen_string_literal: true

require "ratalada"

# Prop system only... no rails-coupled stuff.
require "inertia_rails/raw_json"
require "inertia_rails/prop_onceable"
require "inertia_rails/prop_mergeable"
require "inertia_rails/prop_cacheable"
require "inertia_rails/base_prop"
require "inertia_rails/ignore_on_first_load_prop"
require "inertia_rails/always_prop"
require "inertia_rails/lazy_prop"
require "inertia_rails/optional_prop"
require "inertia_rails/cached_prop"
require "inertia_rails/defer_prop"
require "inertia_rails/merge_prop"
require "inertia_rails/once_prop"
require "inertia_rails/scroll_metadata"
require "inertia_rails/scroll_prop"
require "inertia_rails/prop_evaluator"
require "inertia_rails/props_resolver"

require_relative "inertia/errors"
require_relative "inertia/core_ext"
require_relative "inertia/response"
require_relative "inertia/middleware"
require_relative "inertia/csrf_middleware"
require_relative "inertia/helpers"

# LazyProp reports deprecation through code that's tied to rails.
module InertiaRails
  def self.deprecator = Kernel
end

module Ratalada
  module Contrib
    module Inertia
      module_function

      def always(value = nil, &block) = ::InertiaRails::AlwaysProp.new(&block || proc { value })
      def defer(group: "default", &block) = ::InertiaRails::DeferProp.new(group: group, &block)
      def optional(&block) = ::InertiaRails::OptionalProp.new(&block)
      def lazy(value = nil, &block) = ::InertiaRails::LazyProp.new(value, &block)
      def merge(value = nil, &block) = ::InertiaRails::MergeProp.new(&block || proc { value })
      def deep_merge(match_on: nil, &block) = ::InertiaRails::MergeProp.new(deep_merge: true, match_on: match_on, &block)
      def once(...) = ::InertiaRails::OnceProp.new(...)
      def cache(...) = ::InertiaRails::CachedProp.new(...)
      def scroll(metadata = nil, **options, &block) = ::InertiaRails::ScrollProp.new(metadata: metadata, **options, &block)

      # Registers a shared-prop block, run in the request context on every
      # inertia render and deep-merged under the page props.
      def share(&block)
        unless block
          raise ArgumentError, "share requires a block"
        end

        Ratalada.config.inertia_share_blocks = Ratalada.config.inertia_share_blocks + [block]
      end

      def share_props(&block) = share(&block)

      # The asset version sent with every page object. An app-defined
      # page_version setting wins over inertia_version; either may be
      # callable, and whatever comes out is stringified.
      def current_version
        config = Ratalada.config
        if config.respond_to?(:page_version)
          version = config.page_version
        else
          version = config.inertia_version
        end

        version.respond_to?(:call) ? version.call.to_s : version.to_s
      end
    end
  end
end

unless defined?(::Inertia)
  ::Inertia = Ratalada::Contrib::Inertia
end

# Contrib settings, registered on the core config exactly like the core's own.
Ratalada.setting :inertia_version, default: "1"
Ratalada.setting :inertia_layout, default: :layout
Ratalada.setting :inertia_encrypt_history, default: false
Ratalada.setting :inertia_csrf_protection, default: true
Ratalada.setting :inertia_share_blocks, default: []
