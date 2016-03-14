Rails.application.routes.draw do

  mount VerticaHistory::Engine => "/vertica_history"
end
