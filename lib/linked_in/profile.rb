module LinkedIn
  class Profile < APIResource
    def initialize(connection, data)
      @connection = connection
      @data = data
    end

    def id
      @data['id']
    end

    def first_name
      @data['localizedFirstName']
    end

    def last_name
      @data['localizedLastName']
    end

    def formatted_name
      [first_name, last_name].compact.join(' ')
    end

    def email_address
      response = get("/emailAddress?q=members&projection=(elements*(handle~))")
      response.dig('elements', 0, 'handle~', 'email_address')
    end

    def picture_url
      pictures = @data.dig('profilePicture', 'displayImage~', 'elements')
      return unless pictures
      return if pictures.none?

      picture = pictures.last
      return unless picture
      
      picture.dig('identifiers', 0, 'identifier')
    end
  end
end
