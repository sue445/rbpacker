# frozen_string_literal: true

require "rbpacker"

module Rbpacker
  # Command-line interface for rbpacker
  class Cli
    # @param src_file: [String]
    # @param dst_file: [String,nil] non-nil: output to filepath, nil: output to stdout
    # @param minify: [Boolean]
    def perform(src_file:, dst_file:, minify:)
      content = SourceBundler.new.bundle(src_file).result

      content = Minifyrb::Minifier.new(content).minify if minify

      if dst_file
        File.binwrite(dst_file, content)
        warn "#{dst_file} is created"
      else
        $stdout.write(content)
      end
    end
  end
end
