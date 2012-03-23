# Add hook methods to user, which will be called after user created, such as add_sensor, join_group, etc.
# Supposed to be included by ApplicationController

module UserHook
  
  def add_user_hook(key, method, value)
    session[:hook_keys] ||= {}
    session[:hook_keys][key] = {:value => value, :method => method}
  end
  
  def call_user_hook(user)
    hash = session[:hook_keys] || {}
    hash.each do |k, v|
      if v[:value].present?
        user.send(v[:method], v[:value])
        hash.delete(k)
      end
    end    
  end
  
end