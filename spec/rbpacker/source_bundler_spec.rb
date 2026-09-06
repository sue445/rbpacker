# frozen_string_literal: true

RSpec.describe Rbpacker::SourceBundler do
  let(:source_bundler) { Rbpacker::SourceBundler.new }

  describe "#bundle" do
    subject { source_bundler.bundle(path.to_s).result }

    context "when file contains require_relative" do
      let(:path) { fixtures_dir.join("test1.rb").to_s }

      let(:expected) do
        <<~RUBY
          class A
          end
          class B
          end
        RUBY
      end

      it { should eq expected }
    end
  end
end
