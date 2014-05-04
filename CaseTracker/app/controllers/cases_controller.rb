class CasesController < ApplicationController
  def index
    @cases = Case.filtered_cases(filters_from_params)

    respond_to do |format|
      format.json { render json: @cases.map {|c| c.to_json_body}, status: :ok }
      format.html { render 'errors/404', status: :not_found }
      format.any { head :not_found }
    end
  end

  private

  def filters_from_params
    {
        since: datetime_since,
        status: params[:status],
        source: params[:source],
        near: coordinates_near
    }
  end

  def coordinates_near
    coordinates = params[:near] ? params[:near].split(',') : []
    latitude = coordinates[0].to_f
    longitude = coordinates.length > 1 ? coordinates[1].to_f : nil

    {latitude: latitude, longitude: longitude}
  end

  def datetime_since
    params[:since] ? Time.at(params[:since].to_i).to_datetime : nil
  end
end
