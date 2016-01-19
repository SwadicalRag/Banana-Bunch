local Loader = banana.Define("Loader")

function Loader:__ctor()
    self.Logger = banana.New("Logger")
    self.Logger:SetTag("Loader")

    self.Loaded = {}
end

function Loader:SetTag(...)
    self.Logger:SetTag(...)
end

function Loader:SetLoaded(path,status)
    self.Loaded[path] = status
end

function Loader:IsLoaded(path)
    return self.Loaded[path] or false
end

function Loader:LoadFile(path,csl_override)
    if self:IsLoaded(path) then return end
    self.Logger:LogDebug("Loading "..path.."...")
    self:SetLoaded(path,true)
    if bFS then
        bFS:RunFile(path)
    else
        include(path:sub(2,-1))
        if not csl_override then
            AddCSLuaFile(path:sub(2,-1))
        end
    end
end

function Loader:LoadFolder(path,csl_override) -- path ends with /
    local files,folders = file.Find(path:sub(2,-1).."*","LUA")

    for _,fileName in ipairs(files) do
        self:LoadFile(path..fileName,csl_override)
    end
end

function Loader:LoadFolderRecursive(path,csl_override) -- path ends with /
    local files,folders = file.Find(path:sub(2,-1).."*","LUA")

    for _,fileName in ipairs(files) do
        self:LoadFile(path..fileName,csl_override)
    end

    for _,folderName in ipairs(folders) do
        self:LoadFolderRecursive(path..folderName.."/")
    end
end
