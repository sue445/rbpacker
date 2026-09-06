# frozen_string_literal: true

module Rbpacker
  class SourceBundler
    REQUIRE_RELATIVE_PATTERN = /
      (?<separator>\A|[;\n])
      [ \t]*
      require_relative
      [ \t]*
      \(?
      [ \t]*
      (?<quote>["'])
      (?:\\.|(?!\k<quote>).)*
      \k<quote>
      [ \t]*
      \)?
      [ \t]*
      (?=;|\n|\z)
    /x

    # @!method bundle(filepath)
    #   @param file_path [String]

    # @!method result
    #   @return [String]

    def initialize
      loaded_files = Set.new
      collected_sources = []
      depth = 0
      original_require_relative = Kernel.instance_method(:require_relative)
      bundler = self

      define_singleton_method(:bundle) do |filepath|
        filepath += ".rb" unless filepath.end_with?(".rb")
        abs_path = File.expand_path(filepath)

        return true if loaded_files.include?(abs_path)

        loaded_files.add(abs_path)
        code = File.read(abs_path)
        source = strip_require_relative(code)

        if depth == 0
          Kernel.send(:define_method, :require_relative) do |relative_path|
            caller_path = caller_locations(1, 1).first.path
            caller_dir = File.dirname(caller_path)
            target_path = File.expand_path(relative_path, caller_dir)

            bundler.bundle(target_path)
          end
        end

        depth += 1
        begin
          TOPLEVEL_BINDING.eval(code, abs_path)
          collected_sources << source unless source.strip.empty?
        ensure
          depth -= 1

          Kernel.send(:define_method, :require_relative, original_require_relative) if depth == 0
        end

        bundler
      end

      define_singleton_method(:result) do
        collected_sources.join
      end
    end

    private

    def strip_require_relative(code)
      code.gsub(REQUIRE_RELATIVE_PATTERN) do
        Regexp.last_match[:separator] == ";" ? ";" : ""
      end
    end
  end
end
