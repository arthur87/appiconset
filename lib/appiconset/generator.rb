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

      size = FastImage.size(input)
      raise 'unsupported size.' if size[0].to_i != 1024 || size[1].to_i != 1024

      output += '/' unless output.end_with?('/')

      FileUtils.mkdir_p(output) unless FileTest.exist?(output)

      @input = input
      @output = output
    end

    # 正方形アイコン
    def square_platforms
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

          image_write(real_size, output_dir + name)
        end

        # Xcode用にファイルをコピーする
        begin
          FileUtils.cp(path, "#{output_dir}/Contents.json") if json_data['info']['author'] == 'xcode'
        rescue StandardError
          # none
        end
      end
    end

    private

    def image_write(size, path)
      image = Magick::ImageList.new(@input)
      new_image = image.resize_to_fit(size, size)
      new_image.format = 'PNG'
      new_image.write(path)
    end
  end
end
