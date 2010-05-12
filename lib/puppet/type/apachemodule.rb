Puppet::Type.newtype(:apachemodule) do
    @doc = "Manage Apache 2 Modules"

    ensurable

    newparam(:name) do
        desc "The name of the module to be managed."

        isnamevar
    end
end
