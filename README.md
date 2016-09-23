# jekyll-publish [![Gem Version](https://badge.fury.io/rb/jekyll-publish.svg)](https://badge.fury.io/rb/jekyll-publish)[![Build Status](https://travis-ci.org/theseanything/jekyll-publish.svg?branch=master)](https://travis-ci.org/theseanything/jekyll-publish)
The publish plugin for Jekyll to allow easy push of static site files to web hosting services.
Currently only AWS S3 is supported, but are more coming!

## Publish to S3
The publish command simply pushes all of the HTML, CSS, JS and XML files with the \_site folder to a specified S3 bucket. Fear not, there is the ability to specify other file types to push too.

The command will "preserve" the folder structure by storing the file with the appropriate object key.

Set up AWS credentials using AWS Cli configure command or having a default profile in the /.aws/credentials file.

## How to use
Within your \_config.yml file add:
```yaml
# Publish settings
bucket_name: <your_bucket_name>
aws_region: <aws_region>
include_file_extensions: <comma_seperated_file_extensions> #optional
```
then you can simply use:
```bash
jekyll publish
```
or you can pass region and bucket name as paramaters:
```bash
jekyll publish -r <region_name> -b <bucket_name>
```
You can also specify additional file extensions using:
```bash
jekyll publish -e jpg
jekyll publish -e jpg,png,txt,mov
```
Command line options will take precedence over settings within \_config.yml

## Why does this exist?
There are alternatives such as [s3_website](https://github.com/laurilehmijoki/s3_website), however I wanted an simple command to publish straight from Jekyll and to keep web hosting settings within the site settings.

Contributions more than welcome!

## Why can't I specify AWS Credentials in \_config.yml?
For safety's sake. Prevent AWS credentials floating around and making their way to public repositories.
