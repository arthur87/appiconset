# frozen_string_literal: true

require 'appiconset/generator'
require 'fileutils'
require 'fastimage'
require 'rmagick'

RSpec.describe Appiconset::Generator do
  let(:output_dir) { "#{__dir__}/output/" }
  let(:input_1024_image) { "#{__dir__}/input/1024.png" }
  let(:input_tvos_image) { "#{__dir__}/input/tvos.jpg" }

  it 'square' do
    generator = Appiconset::Generator.new
    generator.config(input_1024_image, output_dir, 1024, 1024)
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

  it 'universal' do
    generator = Appiconset::Generator.new
    generator.config(input_1024_image, output_dir, 0, 0)
    generator.universal_platforms

    assert_size('universal/Icon@1x.png', [1024 / 3, 1024 / 3])
    assert_size('universal/Icon@2x.png', [1024 / 3 * 2, 1024 / 3 * 2])
    assert_size('universal/Icon@3x.png', [1024, 1024])
  end

  it 'tvos' do
    generator = Appiconset::Generator.new
    generator.config(input_tvos_image, output_dir, 4640, 1440)
    generator.tvos_platforms

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
