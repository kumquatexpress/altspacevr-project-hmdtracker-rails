class HmdsController < ApplicationController
  def index
    @hmds = Hmd.all.order("announced_at desc, name desc")
    respond_to do |format|
      format.html
      format.json do
        render json: @hmds.to_json(methods: :state)
      end
    end
  end

  def edit
    @hmds = Hmd.all.order("announced_at desc, name desc")
  end

  def update
    @hmd = Hmd.find(params[:id])
    @hmd.state = params[:hmd][:state]
    @hmd.save!

    updated_hmds_with_state = Hmd.all.map do |hmd|
      JSON.parse(hmd.to_json(methods: :state))
    end

    $redis.publish 'change-hmds', updated_hmds_with_state.to_json

    redirect_to hmds_path
  end
end
