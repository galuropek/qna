class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    uri = URI.parse(value)
    return true if uri.is_a?(URI::HTTP) && uri.host.present?

    record.errors.add(attribute, message: "is not an URL")
    false
  rescue URI::InvalidURIError
    record.errors.add(attribute, message: "is not an URL")
    false
  end
end
