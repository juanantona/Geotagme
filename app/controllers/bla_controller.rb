class BlaController < ActionController::Base

  def ble
    @things = ["cosa 1", "cosa 2", "cosa 3"]
    render "ble"
  end

  def bli
    sleep 3
    render :json => { moreThings: ["cosa 4", "cosa 5"] }
  end

end
