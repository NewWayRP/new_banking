resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

description 'The New Way of Banking'

version '1.0.0'

client_scripts {
  '@es_extended/locale.lua',
  'locales/en.lua',  
  'locales/fr.lua',
  'config.lua',
  'client/main.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',	
	'config.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

-- Uncomment the desired version 
ui_page('client/html/UI-fr.html') -- French UI
--ui_page('client/html/UI-en.html') -- English UI
--ui_page('client/html/UI-de.html') -- German UI

files {
	'client/html/UI-fr.html', -- French UI
	--'client/html/UI-en.html', -- English UI
	--'client/html/UI-de.html', -- German UI
    'client/html/style.css',
    'client/html/media/font/Bariol_Regular.otf',
    'client/html/media/font/Vision-Black.otf',
    'client/html/media/font/Vision-Bold.otf',
    'client/html/media/font/Vision-Heavy.otf',
    'client/html/media/img/bg.png',
    'client/html/media/img/circle.png',
    'client/html/media/img/curve.png',
    'client/html/media/img/fingerprint.png',
    'client/html/media/img/fingerprint.jpg',
    'client/html/media/img/graph.png',
    'client/html/media/img/logo-big.png',
    'client/html/media/img/logo-top.png'
}
