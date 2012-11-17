class User < ActiveRecord::Base
  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil # or consider a custom null object
  end

  def likes
    facebook { |fb| fb.get_connections("me", "likes") }
  end

  def friends_count
    facebook { |fb| fb.get_connection("me", "friends").size }
  end

  def friends
    @friends ||= facebook { |fb| fb.get_connections("me", "friends", "fields"=>"name,birthday") }
  end

  def friend_likes(uid)
    facebook { |fb| fb.get_connections(uid, "likes") }
  end

  def friends_birthday
    birthdays = Array.new(13) # [0] is not used
    friends.each do |friend|
      if friend["birthday"].present?
        birthday = friend["birthday"].split('/')
        month_i = birthday[0].to_i # [1]=Jan,[2]=Feb,...,[12]=Dec
        birthdays[month_i] ||= Array.new(32) # [0] is not used
        day_i = birthday[1].to_i # [1]=1,[2]=2,...,[31]=31
        birthdays[month_i][day_i] ||= Array.new
        birthdays[month_i][day_i] << friend
      end
    end
    birthdays
  end

  private

  def parse_birthday(birthday_str)
    if birthday_str.present?
      birthday_str = birthday_str.split('/')
      birthday = Date.strptime("#{birthday_str[0]}/#{birthday_str[1]}/#{Date.current.year}", '%m/%d/%Y') if birthday_str[0].present? && birthday_str[1].present?
    end
    birthday || nil
  end
end
