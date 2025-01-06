# frozen_string_literal: true

require 'appiconset'
require 'json'

# Appiconset
module Appiconset
  # Generator
  class Generator
    def initialize; end

    def config(input, output)
      raise 'no input file.' unless File.exist?(input)
      raise 'no output <dir>.' if output == ''

      size = FastImage.size(input)
      raise 'Unsupported file.' if size.nil?

      @width = size[0]
      @height = size[1]

      output += '/' unless output.end_with?('/')

      FileUtils.mkdir_p(output) unless FileTest.exist?(output)

      @input = input
      @output = output
    end

    # 正方形アイコン
    def square_platforms
      return unless @width == 1024 && @height == 1024

      show_info('square')

      json_dir = "#{__dir__}/settings/*.json"

      Dir.glob(json_dir).each do |path|
        json_data = File.open(path) do |f|
          JSON.parse(f.read)
        end

        # プラットフォームごとのディレクトリ
        platform = File.basename(path).gsub('-Contents.json', '')
        output_dir = "#{@output}#{platform}/"

        FileUtils.mkdir_p(output_dir)

        json_data['images'].each do |image|
          size = image['size'].match(/(.*?)x/)[1].to_f
          scale = image['scale'].gsub('x', '').to_i
          # 実際のサイズ
          real_size = size * scale
          name = image['filename']

          image = Magick::ImageList.new(@input)
          new_image = image.resize_to_fit(real_size, real_size)
          new_image.format = 'PNG'
          new_image.write(output_dir + name)
        end

        # Xcode用にファイルをコピーする
        begin
          FileUtils.cp(path, "#{output_dir}/Contents.json") if json_data['info']['author'] == 'xcode'
        rescue StandardError
          # none
        end
      end
    end

    # ユニバーサルアイコン
    def universal_platforms
      show_info('universal')

      platforms = [
        {
          name: 'universal',
          contents: [
            { width: @width, height: @height, scale: 3 },
            { width: @width / 3 * 2, height: @height / 3 * 2, scale: 2 },
            { width: @width / 3, height: @height / 3, scale: 1 }
          ]
        }
      ]

      platforms.each do |platform|
        output_dir = "#{@output}#{platform[:name]}/"
        FileUtils.mkdir_p(output_dir)

        platform[:contents].each do |content|
          width = content[:width].to_f
          height = content[:height].to_f
          scale = content[:scale].to_i

          name = "Icon@#{scale}x.png"

          image = Magick::ImageList.new(@input)
          new_image = image.resize_to_fit(width, height)
          new_image.format = 'PNG'
          new_image.write(output_dir + name)
        end
      end
    end

    # tvOSアイコン
    # Input 4640x1440
    # Output 2400x1440, 3840x1440, 4640x1440
    def tvos_platforms
      return unless @width == 4640 && @height == 1440

      show_info('tvOS')

      platforms = [
        {
          name: 'tv',
          contents: [
            { width: 800, height: 480, scale: 2 },
            { width: 400, height: 240, scale: 1 }
          ]
        },
        {
          name: 'tv-top-shelf',
          contents: [
            { width: 3840, height: 1440, scale: 2 },
            { width: 1920, height: 720, scale: 1 }
          ]
        },
        {
          name: 'tv-top-shelf-wide',
          contents: [
            { width: 4640, height: 1440, scale: 2 },
            { width: 2320, height: 720, scale: 1 }
          ]
        }
      ]

      platforms.each do |platform|
        output_dir = "#{@output}#{platform[:name]}/"
        FileUtils.mkdir_p(output_dir)

        platform[:contents].each do |content|
          width = content[:width].to_f
          height = content[:height].to_f
          scale = content[:scale].to_i

          name = "Icon@#{scale}x.png"

          image = Magick::ImageList.new(@input)
          new_image = image.scale(height / 1440.0)
          new_image = new_image.crop(Magick::CenterGravity, width, height)
          new_image.format = 'PNG'
          new_image.write(output_dir + name)
        end
      end
    end

    def show_info(platform_name)
      puts "Created #{platform_name} icons from #{@width} x #{@height} image."
    end
  end
end
