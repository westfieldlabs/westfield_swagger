WestfieldSwagger::Engine.routes.draw do

  get '/swagger/:service/:version(.:format)', to: "swagger#index",
    version: /\d+/,
    defaults: {format: 'html', version: WestfieldSwagger.api_version}
  get '/swagger/:version(.:format)', to: "swagger#index",
    version: /\d+/,
    defaults: {format: 'html', version: WestfieldSwagger.api_version}

end
