VerticaHistory::Engine.routes.draw do
  get ':class_name/:id' => 'vertica_history#index', as: 'vertica_history_index'
  get ':class_name/:id/history' => 'vertica_history#view_history', as: 'vertica_history_view_history'
  get 'vertica_history_query' => 'vertica_history#make_query', as: 'vertica_history_make_query'
  get 'vertica_history_query/query_results' => 'vertica_history#query_results', as: 'vertica_history_query_results'
end
