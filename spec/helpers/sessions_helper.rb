module SessionsHelper
  def sign_in(user)
    post new_user_session_path, params: { email: user.email, password: user.password }
  end
end
