# frozen_string_literal: true

require 'appiconset'
require 'json'
require 'rbconfig'

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
      return unless size_match?([1024, 1024])

      json_dir = "#{__dir__}/settings/*.json"

      Dir.glob(json_dir).each do |path|
        json_data = File.open(path) do |f|
          JSON.parse(f.read)
        end

        # プラットフォームごとのディレクトリ
        platform = File.basename(path).gsub('-Contents.json', '')
        output_dir = "#{@output}#{platform}/"
        FileUtils.mkdir_p(output_dir)

        show_info(platform)

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

        if platform == 'icns.iconset' && RbConfig::CONFIG['host_os'].match(/darwin|mac os/)
          # macOSで実行可能
          system("iconutil -c icns --output #{output_dir}/Icon.icns #{output_dir}/")
        elsif platform == 'favicon'
          images = Dir.glob("#{output_dir}*")
          image = Magick::ImageList.new(*images)
          image.format = 'ICO'
          image.write("#{output_dir}favicon.ico")
        end
      end
    end

    def any_platforms
      platforms = [
        {
          name: 'universal',
          size: [0, 0],
          contents: [
            { width: @width, height: @height, name: 'Icon@3x.png' },
            { width: @width / 3 * 2, height: @height / 3 * 2, name: 'Icon@2x.png' },
            { width: @width / 3, height: @height / 3, name: 'Icon@1x.png' }
          ]
        },
        {
          name: 'tv',
          size: [4640, 1440],
          contents: [
            { width: 800, height: 480, name: 'Icon@2x.png' },
            { width: 400, height: 240, name: 'Icon@1x.png' }
          ]
        },
        {
          name: 'tv-top-shelf',
          size: [4640, 1440],
          contents: [
            { width: 3840, height: 1440, name: 'Icon@2x.png' },
            { width: 1920, height: 720, name: 'Icon@1x.png' }
          ]
        },
        {
          name: 'tv-top-shelf-wide',
          size: [4640, 1440],
          contents: [
            { width: 4640, height: 1440, name: 'Icon@2x.png' },
            { width: 2320, height: 720, name: 'Icon@1x.png' }
          ]
        }
      ]

      platforms.each do |platform|
        platform_name = platform[:name]
        next unless size_match?(platform[:size])

        show_info(platform_name)

        output_dir = "#{@output}#{platform_name}/"
        FileUtils.mkdir_p(output_dir)

        platform[:contents].each do |content|
          width = content[:width].to_f
          height = content[:height].to_f
          name = content[:name]

          image = Magick::ImageList.new(@input)
          if platform_name.start_with?('tv')
            image = image.scale(height / 1440.0)
            image = image.crop(Magick::CenterGravity, width, height)
          else
            image = image.resize_to_fit(width, height)
          end
          image.format = 'PNG'
          image.write(output_dir + name)
        end
      end
    end

    private

    # 入力画像のサイズが条件に一致したときtrueを返す
    def size_match?(size)
      size == [0, 0] || (@width == size[0] && @height == size[1])
    end

    def show_info(platform_name)
      puts "Created #{platform_name} icon(s) from #{@width} x #{@height} image."
    end
  end
end
