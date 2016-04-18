require 'spec_helper'

describe Publish do
  before(:all) do
    @publish = Jekyll::Command::Publish
    options = Hash.new
    conf = @publish.configuration_from_options options
    @publish.instance_variable_set(:@config, conf)
  end

  describe ".get_aws_region" do
    context "\"aws_region\" not set in config" do
      before do
      @publish.config.delete("aws_region")
      end
      it "raises error" do
        expect {@publish.get_aws_region()}.to raise_error(RuntimeError, /No region defined/)
      end
    end

    context "\"aws_region: eu-west-1\" set in config" do
      before do
        @publish.config["aws_region"] = "eu-west-1"
      end
      it "returns \"eu-west-1\"" do
        expect(@publish.get_aws_region()).to eql("eu-west-1")
      end
    end

  end

  describe ".get_bucket_name" do
    context "\"bucket_name\" not set in config" do
      before do
      @publish.config.delete("bucket_name")
      end
      it "raises error" do
        expect {@publish.get_bucket_name()}.to raise_error(RuntimeError, /No bucket_name defined/)
      end
    end

    context "\"bucket_name: bucket_name\" set in config" do
      before do
        @publish.config["bucket_name"] = "bucket_name"
      end
      it "returns \"bucket_name\"" do
        expect(@publish.get_bucket_name()).to eql("bucket_name")
      end
    end
  end

  describe ".get_files" do
    before(:all) do
      Dir.chdir("./spec/fixtures/test-site")
    end
    context "normal _site directory with html, css, js and xml" do
      before do
        @publish.config["include_file_extensions"] = ""
      end
      it "returns array with filenames" do
        expect(@publish.get_files()).to contain_exactly(
        "./_site/about/index.html",
          "./_site/index.html",
          "./_site/jekyll/update/2016/03/29/welcome-to-jekyll.html",
          "./_site/css/main.css",
          "./_site/feed.xml")
      end
    end

    context "normal _site directory with html, css, js, xml and coffeescript" do
      before do
        @publish.config["include_file_extensions"] = "coffee"
      end
      it "returns array with filenames" do
        expect(@publish.get_files()).to contain_exactly(
          "./_site/about/index.html",
          "./_site/index.html",
          "./_site/jekyll/update/2016/03/29/welcome-to-jekyll.html",
          "./_site/css/main.css",
          "./_site/anotherfile.coffee",
          "./_site/feed.xml")
      end
    end

  end

  describe ".upload_to_s3" do
    before do
      Aws.config[:stub_responses] = true
    end
    context "normal html, css, js and xml to s3" do
      it "return" do
        files = ["./_site/about/index.html",
        "./_site/index.html",
        "./_site/jekyll/update/2016/03/29/welcome-to-jekyll.html",
        "./_site/css/main.css",
        "./_site/feed.xml"]
        @publish.upload_to_s3("eu-west-1", "bucket_name", files)
      end
    end
  end
end
