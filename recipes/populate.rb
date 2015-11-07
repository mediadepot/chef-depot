
package('libsqlite3-dev')
package('sqlite3')

nas_tvshows 'Populate Sickbeard Shows' do
  gist node[:depot][:gist][:id]
  api_key node[:depot][:gist][:api_key]
end



nas_movies 'Populate Couchpotato Movies' do
  gist node[:depot][:gist][:id]
  api_key node[:depot][:gist][:api_key]
end
