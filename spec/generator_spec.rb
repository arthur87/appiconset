# frozen_string_literal: true

require 'appiconset/generator'
require 'fileutils'
require 'fastimage'
require 'rmagick'

RSpec.describe Appiconset::Generator do # rubocop:disable Metrics/BlockLength
  let(:output_dir) { "#{__dir__}/output/" }
  let(:input_1024_image) { "#{__dir__}/input/1024.png" }
  let(:input_tvos_image) { "#{__dir__}/input/tvos.jpg" }

  it 'square_platforms' do
    generator = Appiconset::Generator.new
    generator.config(input_1024_image, output_dir)
    generator.square_platforms

    assert_size('mac-xcode9.1/Icon-16@1x.png', [16, 16])
    assert_size('mac-xcode9.1/Icon-16@2x.png', [32, 32])
    assert_size('mac-xcode9.1/Icon-32@1x.png', [32, 32])
    assert_size('mac-xcode9.1/Icon-32@2x.png', [64, 64])
    assert_size('mac-xcode9.1/Icon-128@1x.png', [128, 128])
    assert_size('mac-xcode9.1/Icon-128@2x.png', [256, 256])
    assert_size('mac-xcode9.1/Icon-256@1x.png', [256, 256])
    assert_size('mac-xcode9.1/Icon-256@2x.png', [512, 512])
    assert_size('mac-xcode9.1/Icon-512@1x.png', [512, 512])
    assert_size('mac-xcode9.1/Icon-512@2x.png', [1024, 1024])
  end

  it 'any_platforms' do
    generator = Appiconset::Generator.new
    generator.config(input_1024_image, output_dir)
    generator.any_platforms

    assert_size('universal/Icon@1x.png', [1024 / 3, 1024 / 3])
    assert_size('universal/Icon@2x.png', [1024 / 3 * 2, 1024 / 3 * 2])
    assert_size('universal/Icon@3x.png', [1024, 1024])

    assert_size('icns.iconset/icon_16x16.png', [16, 16])
    assert_size('icns.iconset/icon_16x16@2x.png', [32, 32])
    assert_size('icns.iconset/icon_32x32.png', [32, 32])
    assert_size('icns.iconset/icon_32x32@2x.png', [64, 64])
    assert_size('icns.iconset/icon_64x64.png', [64, 64])
    assert_size('icns.iconset/icon_64x64@2x.png', [128, 128])
    assert_size('icns.iconset/icon_128x128.png', [128, 128])
    assert_size('icns.iconset/icon_128x128@2x.png', [256, 256])
    assert_size('icns.iconset/icon_256x256.png', [256, 256])
    assert_size('icns.iconset/icon_256x256@2x.png', [512, 512])
    assert_size('icns.iconset/icon_512x512.png', [512, 512])
    assert_size('icns.iconset/icon_512x512@2x.png', [1024, 1024])

    expect(File.exist?("#{output_dir}Icon.icns")).to be true if RbConfig::CONFIG['host_os'].match(/darwin|mac os/)
  end

  it 'tvos_platforms' do
    generator = Appiconset::Generator.new
    generator.config(input_tvos_image, output_dir)
    generator.any_platforms

    assert_size('tv/Icon@1x.png', [400, 240])
    assert_size('tv/Icon@2x.png', [800, 480])

    assert_size('tv-top-shelf/Icon@1x.png', [1920, 720])
    assert_size('tv-top-shelf/Icon@2x.png', [3840, 1440])

    assert_size('tv-top-shelf-wide/Icon@1x.png', [2320, 720])
    assert_size('tv-top-shelf-wide/Icon@2x.png', [4640, 1440])
  end

  private

  def assert_size(path, size)
    expect(FastImage.size("#{output_dir}#{path}")).to eq size
  end
end
