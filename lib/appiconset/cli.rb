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

    desc 'square', 'Create icons from a square image'
    method_option :input, desc: 'Input image(1024px x 1024px)', aliases: '-i'
    method_option :output, desc: 'Write output to <dir>', aliases: '-o'
    def square
      generator = Appiconset::Generator.new

      begin
        generator.config(options[:input].to_s, options[:output].to_s)
        generator.square_platforms
      rescue StandardError => e
        warn e.message
        exit(1)
      end
    end

    desc 'tvos', 'Create tvOS icons'
    method_option :input, desc: 'Input image(4640px x 1440px)', aliases: '-i'
    method_option :output, desc: 'Write output to <dir>', aliases: '-o'
    def tvos
      generator = Appiconset::Generator.new

      begin
        generator.config(options[:input].to_s, options[:output].to_s, 4640, 1440)
        generator.tvos_platforms
      rescue StandardError => e
        warn e.message
        exit(1)
      end
    end

    desc 'icons', 'Create Universal icons'
    method_option :input, desc: 'Input any size image', aliases: '-i'
    method_option :output, desc: 'Write output to <dir>', aliases: '-o'
    def icons
      generator = Appiconset::Generator.new

      begin
        generator.config(options[:input].to_s, options[:output].to_s, 0, 0)
        generator.universal_platforms
      rescue StandardError => e
        warn e.message
        exit(1)
      end
    end
  end
end
