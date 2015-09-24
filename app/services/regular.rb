class Regular
  def self::is_mobile?(mobile)
    /^1[34578][0-9]{9}$/.match(mobile) != nil
  end

  def self::is_mobile_code?(code)
    /^\d{4}$/.match(code) != nil
  end

  def self::is_email?(email)
    /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/.match(email) != nil
  end
end