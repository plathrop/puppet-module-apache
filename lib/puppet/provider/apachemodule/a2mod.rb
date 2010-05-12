Puppet::Type.type(:apachemodule).provide(:a2mod) do
    desc "Manage Apache 2 modules on Debian/Ubuntu using a2{en,dis}mod."

    commands :enable_cmd => "a2enmod"
    commands :disable_cmd => "a2dismod"

    defaultfor :operatingsystem => [:debian, :ubuntu]

    def create
        enable_cmd resource[:name]
    end

    def destroy
        disable_cmd resource[:name]
    end

    def exists?
        module_file = "/etc/apache2/mods-enabled/" + resource[:name] + ".load"
        File.exists?(module_file)
    end
end
