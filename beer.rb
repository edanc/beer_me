class Beer
  def initialize(beer)
    @beer = beer
  end

  def beers_json
    {
      "response_type": "in_channel",
      "text": "Here is your beer!",
      "attachments": [
        "title": beer["name_display"],
        "image_url": beer["labels"]["large"],
        "fields": [
          {
            "title": "Description",
            "value": beer["description"],
            "short": false
          },
          {
            "title": "Abv",
            "value": "#{beer["abv"]}%",
            "short": true
          }
        ],
      ]
    }
  end
  private
  attr_reader :beer
end
