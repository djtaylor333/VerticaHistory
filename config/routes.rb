VerticaHistory::Engine.routes.draw do
  get 'vertica_history/:class_name/:id' => 'vertica_history#index', as: 'vertica_history_index'
  get 'vertica_history/:class_name/:id/history' => 'vertica_history#view_history', as: 'vertica_history_view_history'
end
