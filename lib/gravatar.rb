require 'digest/md5'

class Gravatar
  def self.gravatar_url(for_user, with_options = {})
    email = self.email_for_gravatar(for_user.email)
    hash = Digest::MD5.hexdigest(email)
    params = with_options.slice(:rating, :size, :default).map do |k,v|
      v = CGI::escape(v) if k == :default
      "#{k.to_s.first}=#{v}"
    end.join("&")
    params = "?#{params}" unless params.blank?
    "http://www.gravatar.com/avatar/#{hash}#{params}"
  end

  def self.email_for_gravatar(email)
    (email || "").to_s.downcase.strip
  end
end
