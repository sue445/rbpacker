# frozen_string_literal: true

RSpec.describe Rbpacker::SourceBundler do
  let(:source_bundler) { Rbpacker::SourceBundler.new }

  describe "#bundle" do
    subject { source_bundler.bundle(path.to_s).result }

    context "when file contains require_relative" do
      let(:path) { fixtures_dir.join("test1.rb") }

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

    context "when there is other code on the same line as `require_relative`" do
      let(:path) { fixtures_dir.join("test2.rb") }

      let(:expected) do
        <<~RUBY
          class A
          end
          "a";; "b"
        RUBY
      end

      it { should eq expected }
    end

    context "when multiple `require_relative` calls are on the same line" do
      let(:path) { fixtures_dir.join("test3.rb") }

      let(:expected) do
        <<~RUBY
          class A
          end
          class B
          end
          ;
        RUBY
      end

      it { should eq expected }
    end

    context "when file contains magic comment" do
      let(:path) { fixtures_dir.join("test_magic_comment.rb") }

      let(:expected) do
        <<~RUBY
          # frozen_string_literal: true

          class C
          end
        RUBY
      end

      it { should eq expected }
    end
  end
end
