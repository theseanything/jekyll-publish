require 'aws-sdk'
class Publish < Jekyll::Command
  class << self

    def set_aws_region(options)
      if options['region'].to_s != ''
        return options['region']
      elsif Jekyll.configuration({})['aws_region'].to_s != ''
        return Jekyll.configuration({})['aws_region']
      else
        raise "No region defined - use -r AWS_REGION or set aws_region: AWS_REGION in _config.yml"
      end
    end

    def set_bucket_name(options)
      if options['bucket_name'].to_s != ''
        bucket_name = options['bucket_name']
      elsif Jekyll.configuration({})['bucket_name'].to_s != ''
        bucket_name = Jekyll.configuration({})['bucket_name']
      else
        raise "No bucket_name defined - use -b BUCKET_NAME or set bucket_name: BUCKET_NAME in _config.yml"
      end
    end

    def upload_to_s3(region, bucket_name)
      Dir.chdir("./_site")
      s3 = Aws::S3::Resource.new(region: region)
      Dir['./**/*.{html,css,js,xml}'].each do |file|
        key = file[2..-1]
        puts "Uploading -> #{key}"
        obj = s3.bucket(bucket_name).object(key)
        obj.upload_file(File.absolute_path(file))
      end
    end

    def init_with_program(prog)
      prog.command(:publish) do |c|
        c.syntax "publish [options]"
        c.description 'Publish Jekyll site to AWS S3.'

        c.option 'region', '-r AWS_REGION', 'Region with the S3 Bucket.'
        c.option 'bucket_name', '-b BUCKET_NAME', 'Region with the S3 Bucket.'

        c.action do |args, options|
          region = set_aws_region options
          bucket_name = set_bucket_name options
          puts "AWS Region: #{region}"
          puts "AWS Bucket Name: #{bucket_name}"
          upload_to_s3 region, bucket_name
          puts "Done!"
        end
      end
    end
  end
end