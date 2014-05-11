class ApplicationController < ActionController::Base
	include ActionView::Helpers::UrlHelper
  	# Prevent CSRF attacks by raising an exception.
  	# For APIs, you may want to use :null_session instead.
  	protect_from_forgery with: :exception
  	before_filter :configure_permitted_parameters, if: :devise_controller?

	protected

  	def configure_permitted_parameters
  		devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:firstname, :lastname, :email, :password, :password_confirmation, :current_password) }

  		devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname, :email, :password, :password_confirmation, :current_password) }
	end

	helper_method :fetch_categories_moods
	helper_method :fetch_supporters

	def fetch_categories_moods(data, data_type, item, category_mood, show)
		if category_mood == "category" && data_type == "trigger" && Category.where(:id => item.to_i).exists?
			if !Category.where(:id => item.to_i).first.description.blank?
				link_name = Category.where(:id => item.to_i).first.name
				link_url = '/categories/' + item.to_s
				if show
					link_url += '?trigger=' + data.id.to_s
				end 
				return_this = link_to link_name, link_url
			else 
				return_this = Category.where(:id => item.to_i).first.name
			end
			if item != data.category.last
				return_this += ', '
			end
		elsif category_mood == "mood" && data_type == "trigger" && Mood.where(:id => item.to_i).exists?
			if !Mood.where(:id => item.to_i).first.description.blank?
				link_name = Mood.where(:id => item.to_i).first.name
				link_url = '/moods/' + item.to_s 
				if show
					link_url += '?trigger=' + data.id.to_s
				end 
				return_this = link_to link_name, link_url
			else 
				return_this = Mood.where(:id => item.to_i).first.name
			end
			if item != data.mood.last
				return_this += ', '
			end
		end

		return return_this
	end

	def fetch_supporters(support, type)
		supporters = false
		first_element = 0
		return_this = ''
		support.each do |s|
			if s.support_ids.include?(type.id)
				supporters = true
				first_element = first_element + 1
				link_url = '/profile?userid=' + s.userid.to_s
				if first_element == 1
         			return_this = link_to User.where(:id => s.userid).first.firstname + " " + User.where(:id => s.userid).first.lastname, link_url
         		else
         			return_this += ", "
         			return_this += link_to User.where(:id => s.userid).first.firstname + " " + User.where(:id => s.userid).first.lastname, link_url
         		end
      		end
      	end

      	if supporters
      		return_this = "Supporters: " + return_this 
      	else
      		return_this = ""
      	end

      	return return_this.html_safe
	end

end