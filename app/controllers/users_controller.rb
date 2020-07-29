class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  	@articles = current_user.articles
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
	  	if @user.update(user_params)
	  		flash[:success] = 'ユーザー情報を編集しました。'
	  		redirect_to user_path
	  	else
	  		flash.now[:danger] = 'ユーザー情報の編集に失敗しました。'
	  		render :edit
	  	end
  end

  # def destroy
  # end

  private
    def user_params
  	 params.require(:user).permit(:name, :introduction, :profile_image, :goal)
    end

    def check_current_user?
      user = User.find_by(id: params[:id])
      if user != current_user
        redirect_to user_path(current_user)
      end
    end
end
