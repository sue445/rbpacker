# frozen_string_literal: true

RSpec.describe Rbpacker::Cli do
  let(:cli) { Rbpacker::Cli.new }

  describe "#perform" do
    subject do
      cli.perform(
        src_file: src_file,
        dst_file: dst_file
      )
    end

    let(:src_file) { fixtures_dir.join("test1.rb").to_s }

    let(:expected) do
      <<~RUBY
        class A
        end
        class B
        end
      RUBY
    end

    context "when dst_file is not nil" do
      include_context "uses temp dir"

      let(:dst_file) { File.join(temp_dir, "output.rb") }

      it "dst_file is created" do
        subject

        expect(File.exist?(dst_file)).to eq true
        expect(File.read(dst_file)).to eq expected
      end
    end

    context "when dst_file is nil" do
      let(:dst_file) { nil }

      it { expect { subject }.to output(expected).to_stdout }
    end
  end
end
