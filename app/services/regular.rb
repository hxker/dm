class Regular
  def self::is_mobile?(mobile)
    /^1[3458][0-9]{9}$/.match(mobile) != nil
  end

  def self::is_mobile_code?(code)
    /^\d{4}$/.match(code) != nil
  end
end