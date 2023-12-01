local thread = require("thread")
local event = require("event")
local shell = require("shell")
local tty = require("tty")
local text = require("text")
local sh = require("sh")

local command = ...
thread.create(function()
  shell.execute(command)
end):detach()