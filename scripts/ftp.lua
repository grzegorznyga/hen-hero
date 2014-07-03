-- 
-- Abstract: Simplifies the use of FTP functions with Lua.
-- 
-- Author: Graham Ranson - http://www.grahamranson.co.uk
--
-- Version: 1.0
-- 
-- FTP Helper is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
 
--module(..., package.seeall) 
 
local ftp = require("socket.ftp")
local ltn12 = require("ltn12")

local M = {}

local putFile = function(params, command)                        
        success, error = ftp.put{
                host = M.host, 
                user = M.user,
                password = M.password,
                port = M.port,
                type = "i",
                step = ltn12.all,
                command = command,
                argument = params.remoteFile,
                source = ltn12.source.file( io.open( params.localFile, "rb" ) )  
        }
        
        if success then
                if params.onSuccess then
                        params.onSuccess( { path = M.host .. params.remoteFile } )
                end
        else
                if params.onError then
                        params.onError( { error = error } ) 
                end
        end
                        
        return success, error
        
end
        
local getFile = function(params)
        local success, error = ftp.get{
                host = M.host, 
                user = M.user,
                password = M.password,
                port = M.port,
                type = "i",
                step = ltn12.all,
                command = command,
                argument = params.remoteFile,
                sink = ltn12.sink.file(params.localFile)
        }
        
        if success then
                if params.onSuccess then
                        params.onSuccess( { path = params.localPath } )
                end
        else
                if params.onError then
                        params.onError( { error = error } ) 
                end
        end
                
        return success, error
end
 
function M:newConnection(params)
        
        
        self.host = params.host or "anonymous.org"
        self.user = params.user or "anonymous"
        self.password = params.password or ""
        self.port = params.port or 21
end

---
function M:upload(params)
                return putFile(params, "stor")
        end

---        
function M:download(params)        
        params.localPath = system.pathForFile( params.localFile, system.DocumentsDirectory )
        params.localFile = io.open( params.localPath, "w+b" ) 

        return getFile(params)
end
 
---        
function M:append(params)
        return putFile(params, "appe")
end

return M