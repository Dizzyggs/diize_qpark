fx_version 'bodacious'

game 'gta5'

author 'Diize'

dependencies {
  "zf_dialog"
}

client_script {
  'client.lua',
  'config.lua'

}

server_script {
  '@mysql-async/lib/MySQL.lua',
     'config.lua',
     'server.lua'
 }
