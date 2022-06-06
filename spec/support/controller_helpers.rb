module ControllerHelpers
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end

  def attach_file_to(source)
    source.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                        filename: 'rails_helper.rb', content_type: 'text/plain')
  end
end
