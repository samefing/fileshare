default[:fileshare][:repopath] = 'D:\softwarerepo'
default[:fileshare][:logpath] = 'D:\softwarerepologs'
default[:fileshare][:name] = 'softwarerepo'
default[:fileshare][:hostheader] = 'http/*:80:softwarerepo'
default[:fileshare][:dotnet] = '4.0'

# specify sub-directories to be created
default[:directories] = {
			:add => [
				'chocolatey',
				'isos',
				'files'
			]
	}	