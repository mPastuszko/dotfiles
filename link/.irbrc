require 'rubygems'
require 'ap'

# load and start wirble
begin
  require 'wirble'
  Wirble.init
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load Wirble: #{err}"
end

IRB::Irb.class_eval do
  def output_value
    ap @context.last_value
  end
end
