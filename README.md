# jekyll-publish
The publish plugin for Jekyll to allow easy push of static site files to web hosting services. Currently only AWS S3, but are more comming!

## Publish to S3
The publish command simply pushes all of the HTML, CSS, JS and XML files with the _site folder to a specified S3 bucket. 
The command will "preserve" the folder structure by storing the file with the appropiate object key.
Set up AWS credentials using AWS Cli configure command or having a default profile in the /.aws/credentials file.

## How to use
Within your _config.yml file add:
```yaml
# Publish settings
bucket_name: <your_bucket_name>
aws_region: <aws_region>
```
then you can simply use:
```bash
jekyll publish
```
or you can pass region and bucket name as paramaters:
```bash
jekyll publish -r <region_name> -b <bucket_name>
```
These will take precedence over settings within the _config.yml

Contributions more than welcome!

