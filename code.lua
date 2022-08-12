-- services
local http = game:GetService("HttpService")
-- packages
local tpscript = loadstring(http:GetAsync("https://raw.githubusercontent.com/headsmasher8557/tpscript/main/init.lua"))()

-- put neat variables for conditions here

local hidden = false;
local messages = 0;
local deleted = 0;
local limit = 40;

-- ok code starts here
local screen = Instance.new("Part", script)
local weld = Instance.new("Weld", owner.Character.Head)
local gui = Instance.new("SurfaceGui", screen)
local box = Instance.new("TextBox", gui)
local event = Instance.new("RemoteEvent", owner)

screen.CFrame = owner.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,-3)
screen.Size = Vector3.new(10,5,0.05)
screen.CanCollide = false
screen.Massless = true

weld.Part1 = screen
weld.Part0 = owner.Character.Head
weld.C1 = CFrame.new(0,0,3)

gui.Face = "Back"

box.Size = UDim2.new(1,0,1,0)
box.TextSize = 24
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.ZIndex = 2


local consoleScreen = Instance.new("Part", script)
local weld2 = Instance.new("Weld", owner.Character.Head)
local outputgui = Instance.new("SurfaceGui", consoleScreen)
local event2 = Instance.new("RemoteEvent", owner)
local frame = Instance.new("ScrollingFrame", outputgui)
local options = Instance.new("UIListLayout", frame)
event2.Name = "event2"

consoleScreen.Name = "outputConsole"
consoleScreen.Size = Vector3.new(5,5,0.05)
consoleScreen.CanCollide = false
consoleScreen.Massless = true

outputgui.Face = "Back"

weld2.Part1 = consoleScreen
weld2.Part0 = owner.Character.Head
weld2.C1 = CFrame.new(-4.5,0,5) * CFrame.Angles(math.rad(0),math.rad(45),math.rad(0))

frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundColor3 = Color3.fromRGB(69,69,69)

local function print(msg)
	local txt = Instance.new("TextBox", frame)
	messages += 1
	if messages > limit then
		limit += 1;
		frame.TextBox:Destroy()
	end
	txt.Size = UDim2.new(1,0,0,30)
	txt.TextColor3 = Color3.fromRGB(0, 225, 7)
	txt.BorderSizePixel = 0
	txt.BackgroundColor3 = Color3.fromRGB(69,69,69)
	txt.TextSize = 20
	txt.TextXAlignment = Enum.TextXAlignment.Left
	txt.Text = tostring(messages) .. " - " .. msg
end

print("Welcome to JdXom's Console!")

local screengui = Instance.new("ScreenGui", owner.PlayerGui)
local clientbox = Instance.new("TextBox", screengui)
local codetorun;
clientbox.Name = "ClientBox"
clientbox.Size = UDim2.new(0.2,0,0.15,0)
clientbox.Position = UDim2.new(0.80,0,0.85,0)
clientbox.MultiLine = true
clientbox.ClearTextOnFocus = false
clientbox.Text = ""

event.OnServerEvent:Connect(function(player, text)
	box.Text = text
	codetorun = text
end)

event2.OnServerEvent:Connect(function(player, d)
	print(d)
end)


owner.Chatted:Connect(function(msg)
	local args = string.split(msg,"/")
	if args[1] == "-exec" then
		if args[2] == 'lua' then
			local code = loadstring(codetorun)
			local fenv = {}
			fenv['print'] = print
			setfenv(code, fenv)
			code()
		elseif args[2] == 'tps' then
			tpscript.loadstring(codetorun, true)
		end
	end
end)

local logs = game:GetService("LogService")



NLS([[

local box = owner.PlayerGui.ScreenGui.ClientBox
local event = owner.RemoteEvent

box:GetPropertyChangedSignal("Text"):Connect(function()
	event:FireServer(box.Text)
end)

local event2 = owner.event2
local outputgui = owner.PlayerGui.SB_OutputGUI.Main.Output.Entries
outputgui.DescendantAdded:Connect(function(descendant)
	local x;
end)

]], owner.PlayerGui)

