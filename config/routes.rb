Kablam::Engine.routes.draw do
  post   '/message'   => 'kablam#message',   as: 'message'
  get    '/:name/form' => 'kablam#form',     as: 'form'
  post   '/:name'      => 'kablam#create',   as: 'create'
  patch  '/:name/:id'  => 'kablam#update',   as: 'update'
  delete '/:name/:id'  => 'kablam#destroy',  as: 'destroy'
  put    '/:name/:id'  => 'kablam#undo',     as: 'undo'
end
