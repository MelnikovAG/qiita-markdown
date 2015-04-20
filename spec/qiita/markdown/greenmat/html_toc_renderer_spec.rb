require "active_support/core_ext/string/strip"

describe Qiita::Markdown::Greenmat::HTMLToCRenderer do
  let(:renderer) { described_class.new }
  let(:greenmat) { ::Greenmat::Markdown.new(renderer) }
  subject(:rendered_html) { greenmat.render(markdown) }

  context "with duplicated heading names" do
    let(:markdown) do
      <<-EOS.strip_heredoc
        # a
        ## a
        ### a
        ### a
      EOS
    end

    it "renders ToC anchors with unique ids" do
      should eq <<-EOS.strip_heredoc
        <ul>
        <li>
        <a href="#a">a</a>
        <ul>
        <li>
        <a href="#a-1">a</a>
        <ul>
        <li>
        <a href="#a-2">a</a>
        </li>
        <li>
        <a href="#a-3">a</a>
        </li>
        </ul>
        </li>
        </ul>
        </li>
        </ul>
      EOS
    end
  end

  context "with a document starting with level 2 heading" do
    let(:markdown) do
      <<-EOS.strip_heredoc
        ## a
        ### a
        ## a
      EOS
    end

    it "offsets the heading levels" do
      should eq <<-EOS.strip_heredoc
        <ul>
        <li>
        <a href="#a">a</a>
        <ul>
        <li>
        <a href="#a-1">a</a>
        </li>
        </ul>
        </li>
        <li>
        <a href="#a-2">a</a>
        </li>
        </ul>
      EOS
    end
  end

  context "with a document starting with level 2 heading but includes level 1 heading at the end" do
    let(:markdown) do
      <<-EOS.strip_heredoc
        ## a
        ### a
        # a
      EOS
    end

    it "does not generate invalid list structure" do
      should eq <<-EOS.strip_heredoc
        <ul>
        <li>
        <a href="#a">a</a>
        <ul>
        <li>
        <a href="#a-1">a</a>
        </li>
        </ul>
        </li>
        <li>
        <a href="#a-2">a</a>
        </li>
        </ul>
      EOS
    end
  end
end