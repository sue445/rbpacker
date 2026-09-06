# frozen_string_literal: true

RSpec.describe Rbpacker::SourceBundler do
  let(:source_bundler) { Rbpacker::SourceBundler.new }

  describe "#bundle" do
    subject { source_bundler.bundle(file) }

    let(:file) { fixtures_dir.join("test.rb") }

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
