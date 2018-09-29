module Concerns
  module ApiSettings
    extend ActiveSupport::Concern
    require 'securerandom'
    protected
    def send_to_bucket(upload_item)
      puts "uploading..."
      path = ENV.fetch("BUCKET_TRANSFER_API")
      bucket = ENV.fetch("BUCKET_NAME")
      puts "path: #{path}"
      puts "bucket: #{bucket}"
      puts "#{upload_item.class}"

      post_params = {"oss"=> {
        "bucket"     => bucket,
        "user_id"    => "TEST",
        "attachment" => upload_item,
        "encrypted_name" => SecureRandom.hex
      }}
      response = RestClient.post(path, post_params)
      JSON.parse(response.body)["url"]
    end

    def slack_it(url, content)
      # url must be a SLACK webhook
      message =
        {
          "attachments": [
            {
              "fallback": "",
              "color": "#36a64f",
              "pretext": "#{content[:pretext] || '---'}",
              "author_name": "#{content[:author] || '-no_author_provided-'}",
              "title": "#{content[:title] || '-no_title_provided-'}",
              "text": "#{content[:text] || '-no_text_provided-'}"
            }
          ]
        }.to_json

      RestClient.post(url, message)
    end
  end
end
