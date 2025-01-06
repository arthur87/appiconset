# frozen_string_literal: true

require 'appiconset'
require 'thor'

module Appiconset
  # entry point
  class CLI < Thor
    class << self
      def exit_on_failure?
        true
      end
    end

    desc 'version', 'Show Version'
    def version
      puts(Appiconset::VERSION)
    end

    desc 'g', 'Create icons from any size image'
    method_option :input, desc: 'Input image', aliases: '-i'
    method_option :output, desc: 'Write output to <dir>', aliases: '-o'
    def generator
      generator = Appiconset::Generator.new

      begin
        generator.config(options[:input].to_s, options[:output].to_s)
        generator.square_platforms
        generator.tvos_platforms
        generator.universal_platforms
        generator.icns_platforms
      rescue StandardError => e
        warn e.message
        exit(1)
      end
    end
  end
end
