class Admin::LocalesController < ApplicationController
  def update
    Current.user.update(locale: params.expect(:locale))
    redirect_back_or_to admin_root_path, status: :see_other
  end
end
