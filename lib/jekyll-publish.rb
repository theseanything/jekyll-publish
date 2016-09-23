require 'aws-sdk'
class Publish < Jekyll::Command
  class << self
    attr_accessor :config
    def get_aws_region()
      if @config['aws_region'].to_s != ''
        region = @config['aws_region']
        Jekyll.logger.info "AWS Region:", region
        return region
      else
        raise "No region defined - use -r AWS_REGION or set \"aws_region: AWS_REGION\" in _config.yml"
      end
    end

    def get_bucket_name()
      if @config['bucket_name'].to_s != ''
        bucket_name = @config['bucket_name']
        Jekyll.logger.info "AWS Bucket Name:", bucket_name
        return bucket_name
      else
        raise "No bucket_name defined - use -b BUCKET_NAME or set \"bucket_name: BUCKET_NAME\" in _config.yml"
      end
    end

    def get_files()
      if @config['include_file_extensions'].to_s != ''
        extensions = "html,css,js,xml,#{@config['include_file_extensions']}"
      else
        extensions = "html,css,js,xml"
      end
      Jekyll.logger.info "File Extensions:", extensions
      file_regex = "./_site/**/*.{#{extensions}}"
      return Dir[file_regex]
    end

    def verify_bucket(region, bucket_name)
      s3 = Aws::S3::Resource.new(region: region)
      bucket = s3.bucket(bucket_name)
      return bucket.exists?
    end

    def create_bucket()
    end

    def upload_to_s3(region, bucket_name, files)
      s3 = Aws::S3::Resource.new(region: region)
      Jekyll.logger.info "Uploading:"
      files.each do |file|
        key = file[2..-1]
        obj = s3.bucket(bucket_name).object(key)
        obj.upload_file(File.absolute_path(file))
        Jekyll.logger.info "", key
      end
      Jekyll.logger.info "Done!"
      Jekyll.logger.info "Published to:", s3.bucket(bucket_name).url
    end

    def init_with_program(prog)
      prog.command(:publish) do |c|
        c.syntax "publish [options]"
        c.description 'Publish Jekyll site to AWS S3.'

        c.option 'aws_region', '-r AWS_REGION', 'Region with the S3 Bucket.'
        c.option 'bucket_name', '-b BUCKET_NAME', 'Name of the S3 Bucket'
        c.option 'include_file_extensions', '-e FILE_EXTENSION', 'Includes files with specified extension'

        c.action do |args, options|
          @config = configuration_from_options options
          region = get_aws_region
          bucket_name = get_bucket_name
          #run the build command. Must get files from the defined destination path - may not always be _site.
          files = get_files
          upload_to_s3 region, bucket_name, files
        end
      end
    end
  end
end
