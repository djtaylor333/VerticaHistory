VerticaHistory::Engine.routes.draw do
  get 'vertica_history_query' => 'vertica_history#make_query'
  post 'vertica_history_query/query_results' => 'vertica_history#query_results'
  get ':class_name/:id' => 'vertica_history#index'
  get ':class_name/:id/history' => 'vertica_history#view_history', as: 'vertica_history_view_history'
end
