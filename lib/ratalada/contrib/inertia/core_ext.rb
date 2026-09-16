# frozen_string_literal: true

# The gem's PropsResolver is plain Ruby except for three ActiveSupport core
# extensions it calls on every resolve. We don't load ActiveSupport, so here
# they are, AS-compatible.
class Object
  def try(method_name, ...) = respond_to?(method_name) ? public_send(method_name, ...) : nil

  def blank? = respond_to?(:empty?) ? !!empty? : !self

  def present? = !blank?
end
