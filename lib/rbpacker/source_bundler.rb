# frozen_string_literal: true

module Rbpacker
  # Bundles Ruby source files into a single script by resolving `require_relative`.
  #
  # @note Bundling evaluates the input files to capture nested `require_relative` calls,
  #       so running this on untrusted sources can execute arbitrary code.
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

    def initialize
      @loaded_files = Set.new
      @collected_sources = [] #: Array[String]
      @depth = 0
      @original_require_relative = Kernel.instance_method(:require_relative)
    end

    # @param filepath [String]
    #
    # @return [SourceBundler]
    def bundle(filepath)
      filepath += ".rb" unless filepath.end_with?(".rb")
      abs_path = File.expand_path(filepath)

      return self if @loaded_files.include?(abs_path)

      @loaded_files.add(abs_path)
      code = File.read(abs_path)

      with_require_relative_hook do
        eval_and_collect_source(code, abs_path)
      end

      self
    end

    # @return [String]
    def result
      @collected_sources.join
    end

    private

    # @yield
    def with_require_relative_hook
      define_require_relative_hook if @depth.zero?

      @depth += 1
      yield
    ensure
      @depth -= 1

      restore_require_relative if @depth.zero?
    end

    def define_require_relative_hook
      bundler = self

      Kernel.send(:define_method, :require_relative) do |relative_path|
        caller_location = caller_locations(1, 1)&.first
        raise Error, "caller location is not found" unless caller_location

        caller_path = caller_location.path
        raise Error, "caller path is not found" unless caller_path

        caller_dir = File.dirname(caller_path)
        target_path = File.expand_path(relative_path, caller_dir)

        bundler.bundle(target_path)
      end
    end

    def restore_require_relative
      Kernel.send(:define_method, :require_relative, @original_require_relative)
    end

    def eval_and_collect_source(code, abs_path)
      source = strip_require_relative(code)

      TOPLEVEL_BINDING.eval(code, abs_path)
      @collected_sources << source unless source.strip.empty?
    end

    # @param code [String]
    def strip_require_relative(code)
      code.gsub(REQUIRE_RELATIVE_PATTERN) do
        match = Regexp.last_match
        raise Error, "regexp match is not found" unless match

        match[:separator] == ";" ? ";" : ""
      end
    end
  end
end
