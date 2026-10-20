
```lua
local TweenService = game:GetService("TweenService")
local TextService  = game:GetService("TextService")

local S
do
    local cam = workspace.CurrentCamera
    S = math.clamp((cam and cam.ViewportSize.Y or 1000) / 1000 * 0.9, 0.7, 1.4)
end
local function px(n) return math.floor(n * S + 0.5) end
local function even(n) return n % 2 == 1 and n + 1 or n end

local T = {
    bg        = Color3.fromRGB(0, 0, 0),
    border    = Color3.fromRGB(38, 38, 42),
    divider   = Color3.fromRGB(26, 26, 29),
    text      = Color3.fromRGB(245, 245, 247),
    subtext   = Color3.fromRGB(140, 140, 146),
    muted     = Color3.fromRGB(96, 96, 102),
    field     = Color3.fromRGB(14, 14, 16),
    fieldLine = Color3.fromRGB(30, 30, 34),
    rowHover  = Color3.fromRGB(14, 14, 16),
    rowActive = Color3.fromRGB(24, 24, 27),
    card      = Color3.fromRGB(10, 10, 12),
    cardLine  = Color3.fromRGB(28, 28, 31),
    rowLine   = Color3.fromRGB(22, 22, 25),
    font      = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Medium),
    fontBold  = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold),
    mono      = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Medium),
    size      = Vector2.new(px(760), px(470)),
    radius    = px(8),
    toggleKey = Enum.KeyCode.Z,
}

local ICON = {
    ["axe"]="rbxassetid://132405197863294", ["bed"]="rbxassetid://97726529032925", ["bell"]="rbxassetid://97392696311902",
    ["book-open"]="rbxassetid://129845326810392", ["bot"]="rbxassetid://80451686744860", ["briefcase"]="rbxassetid://96754188164225",
    ["check"]="rbxassetid://93898873302694", ["check-check"]="rbxassetid://95183312173858", ["circle"]="rbxassetid://130359823580534",
    ["coffee"]="rbxassetid://106864403231093", ["cog"]="rbxassetid://116544501716299", ["crosshair"]="rbxassetid://134242818164054",
    ["dollar-sign"]="rbxassetid://127320961224019", ["droplets"]="rbxassetid://140111846025180", ["eye"]="rbxassetid://100033680381365",
    ["flask-conical"]="rbxassetid://128406680901165", ["flask-round"]="rbxassetid://127508287324940", ["gamepad-2"]="rbxassetid://92483947987410",
    ["gauge"]="rbxassetid://110273524101447", ["gem"]="rbxassetid://112904952151156", ["glass-water"]="rbxassetid://115526102400988",
    ["hand"]="rbxassetid://130703864968637", ["hand-coins"]="rbxassetid://126990543175462", ["magnet"]="rbxassetid://135162361226972",
    ["map"]="rbxassetid://95107167260947", ["map-pin"]="rbxassetid://84279202219901", ["mouse-pointer-click"]="rbxassetid://107150227368485",
    ["move-vertical"]="rbxassetid://86234730730899", ["package"]="rbxassetid://97261141732706", ["package-check"]="rbxassetid://102374216055130",
    ["package-plus"]="rbxassetid://129261988138366", ["power"]="rbxassetid://96479131758775", ["refresh-cw"]="rbxassetid://138133190015277",
    ["repeat"]="rbxassetid://121886242955173", ["scan"]="rbxassetid://123104789658180", ["scan-eye"]="rbxassetid://99244790601968",
    ["settings"]="rbxassetid://80758916183665", ["shield"]="rbxassetid://110987169760162", ["shield-check"]="rbxassetid://87354736164608",
    ["siren"]="rbxassetid://134210267818039", ["sparkles"]="rbxassetid://138635884129147", ["sprout"]="rbxassetid://100091687832508",
    ["target"]="rbxassetid://87563802520297", ["trees"]="rbxassetid://121203841375919", ["triangle-alert"]="rbxassetid://125920361880643",
    ["user"]="rbxassetid://81589895647169", ["user-search"]="rbxassetid://101335649828115", ["users"]="rbxassetid://115398113982385",
    ["wind"]="rbxassetid://114551690399915", ["x"]="rbxassetid://110786993356448", ["zap"]="rbxassetid://130551565616516",
    ["info"]="rbxassetid://124560466474914", ["search"]="rbxassetid://121018724060431", ["chevron-left"]="rbxassetid://73780377692148",
    ["chevron-right"]="rbxassetid://92473583511724", ["chevron-down"]="rbxassetid://134243273101015", ["trash-2"]="rbxassetid://109843431391323",
    ["save"]="rbxassetid://126116963775616", ["play"]="rbxassetid://135609604299893", ["star"]="rbxassetid://136141469398409",
    ["sword"]="rbxassetid://124448418211665", ["footprints"]="rbxassetid://139192589041315", ["monitor"]="rbxassetid://72664649203050",
    ["palette"]="rbxassetid://86350350950064", ["keyboard"]="rbxassetid://121474456068237", ["bookmark"]="rbxassetid://121093149326239",
    ["layers"]="rbxassetid://81973586053257", ["hammer"]="rbxassetid://83545120140895", ["swords"]="rbxassetid://81872698913435",
}
ICON["knife"] = ICON["sword"]
ICON["alert-triangle"] = ICON["triangle-alert"]
local function icon(name) return ICON[name or ""] or ICON.circle end

local C = {
    blue   = Color3.fromRGB(96, 180, 255),
    purple = Color3.fromRGB(176, 124, 255),
    red    = Color3.fromRGB(255, 107, 107),
    amber  = Color3.fromRGB(251, 191, 36),
    green  = Color3.fromRGB(74, 222, 128),
    pink   = Color3.fromRGB(244, 114, 182),
    teal   = Color3.fromRGB(45, 212, 191),
}
local SECTION_COLORS = { C.blue, C.green, C.amber, C.pink, C.purple, C.teal, C.red }
local GLOW_IMAGE = "rbxassetid://8992230677"

local function tween(inst, time, goal, style)
    local tw = TweenService:Create(inst, TweenInfo.new(time, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), goal)
    tw:Play()
    return tw
end
local function new(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end
local function corner(p, r) new("UICorner", { CornerRadius = UDim.new(0, r) }, p) end
local function textW(text, size, face)
    local w = #text * size * 0.55
    pcall(function()
        local params = Instance.new("GetTextBoundsParams")
        params.Text, params.Font, params.Size, params.Width = text, face or T.font, size, 10000
        w = TextService:GetTextBoundsAsync(params).X
    end)
    return math.ceil(w) + 1
end

local function kp(t, v) return NumberSequenceKeypoint.new(t, v) end
local function glass(el, o)
    o = o or {}
    el.BackgroundColor3 = o.tint or Color3.new(1, 1, 1)
    el.BackgroundTransparency = o.fill or 0.9
    new("UIGradient", { Name = "GlassBody", Rotation = 90, Transparency = NumberSequence.new({ kp(0, 0), kp(1, 0.5) }) }, el)
    local rim = new("UIStroke", {
        Name = "GlassRim", Color = o.rimColor or Color3.new(1, 1, 1), Thickness = 1,
        Transparency = o.rim or 0.7, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, el)
    new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ kp(0, 0), kp(0.45, 0.7), kp(1, 0.35) }) }, rim)
    local r = o.radius or 0
    local shine = new("Frame", {
        Name = "GlassShine", Position = UDim2.fromOffset(r, 1), Size = UDim2.new(1, -r * 2, 0, 1),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = o.shine or 0.5, BorderSizePixel = 0,
    }, el)
    new("UIGradient", { Transparency = NumberSequence.new({ kp(0, 1), kp(0.5, 0), kp(1, 1) }) }, shine)
    return { rim = rim, shine = shine }
end

local TAGS = { Risky = C.red, Beta = C.amber, New = C.blue, Safe = C.green, ["On start"] = C.amber }
local function tag(parent, text, color, order)
    color = color or TAGS[text] or T.subtext
    local label = text:upper()
    local h = px(16)
    local pill = new("Frame", {
        Name = "Tag", LayoutOrder = order or 1,
        Size = UDim2.fromOffset(textW(label, px(9), T.fontBold) + px(12), h),
    }, parent)
    corner(pill, math.floor(h / 2))
    glass(pill, { tint = color, fill = 0.84, rim = 0.5, rimColor = color, shine = 0.75, radius = px(5) })
    new("TextLabel", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, FontFace = T.fontBold, TextSize = px(9),
        TextColor3 = color:Lerp(Color3.new(1, 1, 1), 0.2), Text = label,
    }, pill)
    return pill
end

local function parseTitle(title)
    title = tostring(title or "")
    local tags = {}
    local plain = title:gsub("<[^>]+>", "")
    if plain:find("RISKY", 1, true) then
        table.insert(tags, "Risky")
        plain = plain:gsub("%s*RISKY%s*", " ")
    end
    plain = plain:gsub("^%s+", ""):gsub("%s+$", "")
    if plain:sub(1, 1) == "=" then plain = "What RISKY means" end
    return plain, tags
end

local host = (gethui and gethui()) or game:GetService("CoreGui")
for _, old in ipairs(host:GetChildren()) do
    if old.Name == "MonoUI" then old:Destroy() end
end
local gui = new("ScreenGui", {
    Name = "MonoUI", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100000,
}, host)

local window = new("Frame", {
    Name = "Window", Size = UDim2.fromOffset(T.size.X, T.size.Y),
    BackgroundColor3 = T.bg, BorderSizePixel = 0,
}, gui)
do
    local vp = workspace.CurrentCamera.ViewportSize
    window.Position = UDim2.fromOffset(math.floor((vp.X - T.size.X) / 2), math.floor((vp.Y - T.size.Y) / 2))
end
corner(window, T.radius)
new("UIStroke", { Color = T.border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, window)
local pop = new("UIScale", {}, window)
local userScale = 1

local function inWindow(el)
    local s = pop.Scale
    local p = (el.AbsolutePosition - window.AbsolutePosition) / s
    return Vector2.new(math.floor(p.X + 0.5), math.floor(p.Y + 0.5)), el.AbsoluteSize / s
end

do
    local dragging, startMouse, startPos
    window.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, startMouse, startPos = true, input.Position, window.Position
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = input.Position - startMouse
        window.Position = UDim2.fromOffset(math.floor(startPos.X.Offset + d.X + 0.5), math.floor(startPos.Y.Offset + d.Y + 0.5))
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local shown = true
local closePopup
local function setShown(on)
    if on == shown then return end
    shown = on
    if closePopup then closePopup() end
    if on then
        window.Visible = true
        pop.Scale = userScale * 0.94
        tween(pop, 0.22, { Scale = userScale }, Enum.EasingStyle.Back)
    else
        local tw = tween(pop, 0.14, { Scale = userScale * 0.94 })
        tw.Completed:Once(function() if not shown then window.Visible = false end end)
    end
end

local capture = { active = false }
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed or capture.active then return end
    if input.KeyCode == T.toggleKey then setShown(not shown) end
end)

local TAB = {
    top = px(10), height = px(26), icon = px(15), gap = px(6), spacing = px(16),
    textSize = px(13), openTime = 0.22, glowSize = px(15) * 2, glowRest = 0.86, glowLit = 0.72,
}
if (TAB.height - TAB.icon) % 2 == 1 then TAB.height += 1 end

local tabBar = new("Frame", {
    Name = "TabBar", Position = UDim2.fromOffset(0, TAB.top), Size = UDim2.fromOffset(0, TAB.height),
    AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1,
}, window)
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, TAB.spacing),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, tabBar)
local function centreTabBar()
    local w = tabBar.AbsoluteSize.X / pop.Scale
    tabBar.Position = UDim2.fromOffset(math.floor((T.size.X - w) / 2 + 0.5), TAB.top)
end
tabBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(centreTabBar)
task.defer(centreTabBar)

local tabs, tabOrder, selectedTab = {}, {}, nil
local tabChanged = new("BindableEvent")

local function setOpen(tab, open)
    tween(tab.clip, TAB.openTime, { Size = UDim2.fromOffset(open and tab.labelW or 0, TAB.height) })
    tween(tab.spacer, TAB.openTime, { Size = UDim2.fromOffset(open and TAB.gap or 0, TAB.height) })
    tween(tab.label, TAB.openTime, { TextTransparency = open and 0 or 1 })
end
local function setGlow(tab, lit)
    lit = lit or tab.hover or selectedTab == tab
    tween(tab.glow, 0.2, { ImageTransparency = lit and TAB.glowLit or TAB.glowRest })
end
local function setLined(tab, on)
    tween(tab.line, 0.18, { Size = on and UDim2.new(1, 0, 0, 1) or UDim2.new(0, 0, 0, 1), BackgroundTransparency = on and 0 or 1 })
end
local function selectTab(name)
    local tab = tabs[name]
    if not tab or selectedTab == tab then return end
    local prev = selectedTab
    selectedTab = tab
    if prev then setLined(prev, false) setGlow(prev, false) end
    setLined(tab, true)
    setGlow(tab, true)
    tabChanged:Fire(name, prev and prev.name)
end

local function addTab(name, iconId, color)
    local btn = new("TextButton", {
        Name = name, LayoutOrder = #tabOrder + 1, Size = UDim2.fromOffset(0, TAB.height),
        AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, AutoButtonColor = false, Text = "",
    }, tabBar)
    local row = new("Frame", { Name = "Row", Size = UDim2.fromOffset(0, TAB.height), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1 }, btn)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder }, row)
    local holder = new("Frame", { Name = "Icon", LayoutOrder = 1, Size = UDim2.fromOffset(TAB.icon, TAB.icon), BackgroundTransparency = 1 }, row)
    local glow = new("ImageLabel", {
        Name = "Glow", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(TAB.glowSize, TAB.glowSize), BackgroundTransparency = 1,
        Image = GLOW_IMAGE, ImageColor3 = color, ImageTransparency = 1, ZIndex = 1,
    }, holder)
    new("ImageLabel", { Name = "Image", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = iconId, ImageColor3 = color, ZIndex = 2 }, holder)
    local spacer = new("Frame", { Name = "Gap", LayoutOrder = 2, Size = UDim2.fromOffset(0, TAB.height), BackgroundTransparency = 1 }, row)
    local clip = new("Frame", { Name = "LabelClip", LayoutOrder = 3, Size = UDim2.fromOffset(0, TAB.height), BackgroundTransparency = 1, ClipsDescendants = true }, row)
    local label = new("TextLabel", {
        Name = "Label", Size = UDim2.fromScale(0, 1), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1,
        FontFace = T.font, TextSize = TAB.textSize, TextColor3 = T.text, TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left, Text = name,
    }, clip)
    local line = new("Frame", {
        Name = "Underline", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.fromScale(0.5, 1),
        Size = UDim2.new(0, 0, 0, 1), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
    }, btn)
    local tab = { name = name, glow = glow, clip = clip, spacer = spacer, label = label, line = line,
        labelW = textW(name, TAB.textSize) }
    tabs[name] = tab
    table.insert(tabOrder, tab)
    setGlow(tab, false)
    btn.MouseEnter:Connect(function() tab.hover = true setOpen(tab, true) setGlow(tab, true) end)
    btn.MouseLeave:Connect(function() tab.hover = false setOpen(tab, false) setGlow(tab, false) end)
    btn.MouseButton1Click:Connect(function() selectTab(name) end)
    return tab
end

local SB = {
    header = px(44), width = px(200), pad = px(12), titleSize = px(21), titleH = px(28),
    searchY = px(46), searchH = px(30), listY = px(88), rowH = px(32), rowGap = px(3),
    icon = px(15), iconX = px(10), labelX = px(35), textSize = px(14), radius = px(6), time = 0.25,
}
SB.narrow = SB.pad * 2 + SB.iconX * 2 + SB.icon

local sidebar = new("Frame", {
    Name = "Sidebar", Position = UDim2.fromOffset(0, SB.header), Size = UDim2.new(0, SB.width, 1, -SB.header),
    BackgroundTransparency = 1, ClipsDescendants = true,
}, window)
local sideLine = new("Frame", {
    Name = "Divider", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(0, SB.width, 0, SB.header),
    Size = UDim2.new(0, 1, 1, -SB.header - T.radius), BackgroundColor3 = T.divider, BorderSizePixel = 0,
}, window)
local content = new("Frame", {
    Name = "Content", Position = UDim2.fromOffset(SB.width, SB.header), Size = UDim2.new(1, -SB.width, 1, -SB.header),
    BackgroundTransparency = 1, ClipsDescendants = true,
}, window)
local contentTitle = new("TextLabel", {
    Name = "Title", Position = UDim2.fromOffset(px(28), px(8)), Size = UDim2.new(1, -px(56), 0, SB.titleH),
    BackgroundTransparency = 1, FontFace = T.fontBold, TextSize = px(19), TextColor3 = T.text,
    TextXAlignment = Enum.TextXAlignment.Left, Text = "",
}, content)

local sideTitle = new("TextLabel", {
    Name = "Title", Position = UDim2.fromOffset(SB.pad + px(4), px(8)), Size = UDim2.new(1, -(SB.pad * 2 + px(32)), 0, SB.titleH),
    BackgroundTransparency = 1, FontFace = T.fontBold, TextSize = SB.titleSize, TextColor3 = T.text,
    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
}, sidebar)
local collapseBtn = new("ImageButton", {
    Name = "Collapse", Size = UDim2.fromOffset(px(24), px(24)), Position = UDim2.fromOffset(SB.width - SB.pad - px(24), px(10)),
    BackgroundTransparency = 1, Image = "", AutoButtonColor = false,
}, sidebar)
local collapseIcon = new("ImageLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(px(14), px(14)),
    BackgroundTransparency = 1, Image = ICON["chevron-left"], ImageColor3 = T.subtext,
}, collapseBtn)
collapseBtn.MouseEnter:Connect(function() tween(collapseIcon, 0.15, { ImageColor3 = T.text }) end)
collapseBtn.MouseLeave:Connect(function() tween(collapseIcon, 0.15, { ImageColor3 = T.subtext }) end)

local search = new("Frame", {
    Name = "Search", Position = UDim2.fromOffset(SB.pad, SB.searchY), Size = UDim2.fromOffset(SB.width - SB.pad * 2, SB.searchH),
    BackgroundColor3 = T.field, ClipsDescendants = true,
}, sidebar)
corner(search, SB.radius)
new("UIStroke", { Color = T.fieldLine, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, search)
new("ImageLabel", {
    Position = UDim2.fromOffset(math.floor((SB.narrow - SB.pad * 2 - px(13)) / 2), math.floor((SB.searchH - px(13)) / 2)),
    Size = UDim2.fromOffset(px(13), px(13)), BackgroundTransparency = 1, Image = ICON.search, ImageColor3 = T.subtext,
}, search)
local searchBox = new("TextBox", {
    Name = "Query", Position = UDim2.fromOffset(SB.labelX - px(6), 0), Size = UDim2.new(1, -(SB.labelX - px(6)) - px(8), 1, 0),
    BackgroundTransparency = 1, ClearTextOnFocus = false, FontFace = T.font, TextSize = px(13), TextColor3 = T.text,
    PlaceholderText = "Search...", PlaceholderColor3 = T.muted, Text = "", TextXAlignment = Enum.TextXAlignment.Left,
}, search)

local panels, currentPanel, collapsed = {}, nil, false
local sectionChanged = new("BindableEvent")

local function paintRow(sec)
    local active = sec.panel.selected == sec
    tween(sec.row, 0.15, { BackgroundColor3 = active and T.rowActive or T.rowHover, BackgroundTransparency = (active or sec.hover) and 0 or 1 })
    tween(sec.label, 0.15, { TextColor3 = active and T.text or T.subtext })
end
local function selectSection(tabName, name)
    local panel = panels[tabName]
    local sec = panel and panel.sections[name]
    if not sec then return end
    local prev = panel.selected
    panel.selected = sec
    if prev then paintRow(prev) end
    paintRow(sec)
    if currentPanel == panel then contentTitle.Text = name end
    sectionChanged:Fire(tabName, name)
end
local function getPanel(tabName)
    if panels[tabName] then return panels[tabName] end
    local frame = new("ScrollingFrame", {
        Name = tabName, Position = UDim2.fromOffset(SB.pad, SB.listY), Size = UDim2.new(1, -SB.pad * 2, 1, -SB.listY - SB.pad),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false,
    }, sidebar)
    new("UIListLayout", { Padding = UDim.new(0, SB.rowGap), SortOrder = Enum.SortOrder.LayoutOrder }, frame)
    panels[tabName] = { name = tabName, frame = frame, sections = {}, order = {} }
    return panels[tabName]
end
local function addSection(tabName, name, iconId, color)
    local panel = getPanel(tabName)
    local row = new("TextButton", {
        Name = name, LayoutOrder = #panel.order + 1, Size = UDim2.new(1, 0, 0, SB.rowH),
        BackgroundColor3 = T.rowHover, BackgroundTransparency = 1, AutoButtonColor = false, Text = "",
    }, panel.frame)
    corner(row, SB.radius)
    local img = new("ImageLabel", {
        Position = UDim2.fromOffset(SB.iconX, math.floor((SB.rowH - SB.icon) / 2)), Size = UDim2.fromOffset(SB.icon, SB.icon),
        BackgroundTransparency = 1, Image = iconId, ImageColor3 = color,
    }, row)
    local label = new("TextLabel", {
        Position = UDim2.fromOffset(SB.labelX, 0), Size = UDim2.new(1, -SB.labelX, 1, 0), BackgroundTransparency = 1,
        FontFace = T.font, TextSize = SB.textSize, TextColor3 = T.subtext, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, TextTransparency = collapsed and 1 or 0, Text = name,
    }, row)
    local sec = { name = name, panel = panel, row = row, icon = img, label = label }
    panel.sections[name] = sec
    table.insert(panel.order, sec)
    row.MouseEnter:Connect(function() sec.hover = true paintRow(sec) end)
    row.MouseLeave:Connect(function() sec.hover = false paintRow(sec) end)
    row.MouseButton1Click:Connect(function() selectSection(tabName, name) end)
    if not panel.selected then selectSection(tabName, name) end
    return sec
end
local function applySearch()
    if not currentPanel then return end
    local q = searchBox.Text:lower()
    for _, sec in ipairs(currentPanel.order) do
        sec.row.Visible = q == "" or sec.name:lower():find(q, 1, true) ~= nil
    end
end
searchBox:GetPropertyChangedSignal("Text"):Connect(applySearch)
tabChanged.Event:Connect(function(name)
    local panel = getPanel(name)
    if currentPanel then currentPanel.frame.Visible = false end
    currentPanel = panel
    panel.frame.Visible = true
    sideTitle.Text = name
    contentTitle.Text = panel.selected and panel.selected.name or ""
    applySearch()
end)

local function setCollapsed(on)
    collapsed = on
    local w = on and SB.narrow or SB.width
    tween(sidebar, SB.time, { Size = UDim2.new(0, w, 1, -SB.header) })
    tween(sideLine, SB.time, { Position = UDim2.new(0, w, 0, SB.header) })
    tween(content, SB.time, { Position = UDim2.fromOffset(w, SB.header), Size = UDim2.new(1, -w, 1, -SB.header) })
    tween(search, SB.time, { Size = UDim2.fromOffset(w - SB.pad * 2, SB.searchH) })
    tween(sideTitle, SB.time * 0.6, { TextTransparency = on and 1 or 0 })
    tween(searchBox, SB.time * 0.6, { TextTransparency = on and 1 or 0 })
    searchBox.PlaceholderText = on and "" or "Search..."
    tween(collapseBtn, SB.time, { Position = UDim2.fromOffset(on and math.floor((SB.narrow - px(24)) / 2) or SB.width - SB.pad - px(24), px(10)) })
    collapseIcon.Image = on and ICON["chevron-right"] or ICON["chevron-left"]
    for _, panel in pairs(panels) do
        for _, sec in ipairs(panel.order) do tween(sec.label, SB.time * 0.6, { TextTransparency = on and 1 or 0 }) end
    end
end
collapseBtn.MouseButton1Click:Connect(function() setCollapsed(not collapsed) end)
searchBox.Focused:Connect(function() if collapsed then setCollapsed(false) end end)

do
    local av = px(26)
    local profile = new("Frame", {
        Name = "Profile", Position = UDim2.fromOffset(SB.pad + px(4), TAB.top + math.floor((TAB.height - av) / 2)),
        Size = UDim2.fromOffset(px(220), av), BackgroundTransparency = 1,
    }, window)
    local pfp = new("ImageLabel", { Name = "Avatar", Size = UDim2.fromOffset(av, av), BackgroundColor3 = T.field, Image = "" }, profile)
    new("UICorner", { CornerRadius = UDim.new(1, 0) }, pfp)
    new("UIStroke", { Color = T.fieldLine, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, pfp)
    task.spawn(function()
        local ok, img = pcall(game:GetService("Players").GetUserThumbnailAsync, game:GetService("Players"), game:GetService("Players").LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        if ok and pfp.Parent then pfp.Image = img end
    end)
    local nx, half = av + px(8), math.floor(av / 2)
    new("TextLabel", {
        Position = UDim2.fromOffset(nx, 0), Size = UDim2.new(1, -nx, 0, half + px(1)), BackgroundTransparency = 1,
        FontFace = T.fontBold, TextSize = px(13), TextColor3 = T.text, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom, TextTruncate = Enum.TextTruncate.AtEnd, Text = game:GetService("Players").LocalPlayer.DisplayName,
    }, profile)
    new("TextLabel", {
        Position = UDim2.fromOffset(nx, half + px(1)), Size = UDim2.new(1, -nx, 0, av - half - px(1)), BackgroundTransparency = 1,
        FontFace = T.font, TextSize = px(11), TextColor3 = T.muted, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, TextTruncate = Enum.TextTruncate.AtEnd, Text = "@" .. game:GetService("Players").LocalPlayer.Name,
    }, profile)

    local h, xs, r = px(22), px(22), px(6)
    local fill, fillHot = Color3.fromRGB(26, 26, 29), Color3.fromRGB(38, 38, 42)
    local w = xs + px(9) * 2 + textW("Close", px(11))
    local bar = new("TextButton", {
        Name = "Close", Size = UDim2.fromOffset(w, h),
        Position = UDim2.fromOffset(T.size.X - SB.pad - px(4) - w, TAB.top + math.floor((TAB.height - h) / 2)),
        BackgroundTransparency = 1, AutoButtonColor = false, Text = "",
    }, window)
    corner(bar, r)
    new("UIStroke", { Color = Color3.fromRGB(40, 40, 44), Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, bar)
    new("ImageLabel", {
        Size = UDim2.fromOffset(px(10), px(10)), Position = UDim2.fromOffset(math.floor((xs - px(10)) / 2), math.floor((h - px(10)) / 2)),
        BackgroundTransparency = 1, Image = ICON.x, ImageColor3 = T.text,
    }, bar)
    local half2 = new("Frame", { Position = UDim2.fromOffset(xs, 0), Size = UDim2.new(1, -xs, 1, 0), BackgroundColor3 = fill, BorderSizePixel = 0 }, bar)
    corner(half2, r)
    local sq = new("Frame", { Size = UDim2.new(0, r, 1, 0), BackgroundColor3 = fill, BorderSizePixel = 0 }, half2)
    new("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, FontFace = T.font, TextSize = px(11), TextColor3 = T.text, Text = "Close", ZIndex = 2 }, half2)
    bar.MouseEnter:Connect(function() tween(half2, 0.15, { BackgroundColor3 = fillHot }) tween(sq, 0.15, { BackgroundColor3 = fillHot }) end)
    bar.MouseLeave:Connect(function() tween(half2, 0.15, { BackgroundColor3 = fill }) tween(sq, 0.15, { BackgroundColor3 = fill }) end)
    bar.MouseButton1Click:Connect(function() setShown(false) end)
end

local K = {
    pagePad = px(28), pageTop = px(8) + SB.titleH + px(10), groupGap = px(18),
    caption = px(11), captionH = px(22), rowMin = even(px(46)), rowPad = px(14), vPad = px(11),
    title = px(13), desc = px(11), radius = px(8), ctrlH = even(px(28)),
}
local overlay = new("Frame", { Name = "Overlay", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 20 }, window)

local pages, currentPage = {}, nil
local function showPage(tabName, section)
    local page = tabName and section and pages[tabName .. "/" .. section]
    if currentPage and currentPage ~= page then currentPage.scroll.Visible = false end
    currentPage = page
    if page then page.scroll.Visible = true end
    if closePopup then closePopup() end
end
sectionChanged.Event:Connect(function(tabName, name)
    if panels[tabName] == currentPanel then showPage(tabName, name) end
end)
tabChanged.Event:Connect(function(name)
    local p = panels[name]
    showPage(name, p and p.selected and p.selected.name)
end)

local function makePage(tabName, section)
    local key = tabName .. "/" .. section
    if pages[key] then return pages[key] end
    local scroll = new("ScrollingFrame", {
        Name = key, Position = UDim2.fromOffset(0, K.pageTop), Size = UDim2.new(1, 0, 1, -K.pageTop),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = px(3),
        ScrollBarImageColor3 = Color3.fromRGB(60, 60, 66), CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false,
    }, content)
    local body = new("Frame", {
        Name = "Body", Position = UDim2.fromOffset(K.pagePad, 0), Size = UDim2.new(1, -K.pagePad * 2, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
    }, scroll)
    new("UIListLayout", { Padding = UDim.new(0, K.groupGap), SortOrder = Enum.SortOrder.LayoutOrder }, body)
    new("UIPadding", { PaddingBottom = UDim.new(0, px(24)) }, body)
    local page = { key = key, scroll = scroll, body = body, groups = 0 }
    pages[key] = page
    if currentPanel and currentPanel.name == tabName and currentPanel.selected and currentPanel.selected.name == section then
        showPage(tabName, section)
    end
    return page
end

local function group(page, caption)
    page.groups += 1
    local holder = new("Frame", {
        Name = caption or "Group", LayoutOrder = page.groups, Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
    }, page.body)
    new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, holder)
    if caption then
        new("TextLabel", {
            Name = "Caption", LayoutOrder = 0, Size = UDim2.new(1, 0, 0, K.captionH), BackgroundTransparency = 1,
            FontFace = T.fontBold, TextSize = K.caption, TextColor3 = T.muted, TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top, Text = caption:upper(),
        }, holder)
    end
    local card = new("Frame", {
        Name = "Card", LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = T.card,
    }, holder)
    corner(card, K.radius)
    new("UIStroke", { Color = T.cardLine, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, card)
    new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, card)
    return { page = page, card = card, holder = holder, rows = 0 }
end

local function row(g, title, desc, tags)
    g.rows += 1
    if g.rows > 1 then
        local line = new("Frame", { Name = "Line", LayoutOrder = g.rows * 2 - 1, Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = 1 }, g.card)
        new("Frame", { Position = UDim2.fromOffset(K.rowPad, 0), Size = UDim2.new(1, -K.rowPad * 2, 1, 0), BackgroundColor3 = T.rowLine, BorderSizePixel = 0 }, line)
    end
    local r = new("Frame", {
        Name = title, LayoutOrder = g.rows * 2, Size = UDim2.new(1, 0, 0, K.rowMin),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
    }, g.card)
    local slot = new("Frame", {
        Name = "Control", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -K.rowPad, 0, 0),
        Size = UDim2.fromOffset(0, K.ctrlH), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1,
    }, r)
    local col = new("Frame", {
        Name = "Text", Position = UDim2.fromOffset(K.rowPad, 0), Size = UDim2.new(1, -K.rowPad * 2, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
    }, r)
    new("UIPadding", { PaddingTop = UDim.new(0, K.vPad), PaddingBottom = UDim.new(0, K.vPad) }, col)
    new("UIListLayout", { Padding = UDim.new(0, px(3)), SortOrder = Enum.SortOrder.LayoutOrder }, col)
    local line1 = new("Frame", { Name = "TitleLine", LayoutOrder = 1, Size = UDim2.new(1, 0, 0, K.title + px(2)), BackgroundTransparency = 1 }, col)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, px(6)), SortOrder = Enum.SortOrder.LayoutOrder }, line1)
    local titleLabel = new("TextLabel", {
        Name = "Title", LayoutOrder = 0, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1, FontFace = T.font, TextSize = K.title, TextColor3 = T.text,
        TextXAlignment = Enum.TextXAlignment.Left, Text = title,
    }, line1)
    for i, t in ipairs(tags or {}) do tag(line1, t, nil, i) end
    local descLabel
    if desc and desc ~= "" then
        descLabel = new("TextLabel", {
            Name = "Desc", LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, FontFace = T.font, TextSize = K.desc, TextColor3 = T.muted,
            TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Text = desc,
        }, col)
    end
    local function fit()
        local s = pop.Scale
        local cw = math.floor(slot.AbsoluteSize.X / s + 0.5)
        col.Size = UDim2.new(1, -(K.rowPad * 2 + (cw > 0 and cw + px(16) or 0)), 0, 0)
        local rh = math.floor(r.AbsoluteSize.Y / s + 0.5)
        slot.Position = UDim2.new(1, -K.rowPad, 0, math.floor((math.max(rh, K.rowMin) - K.ctrlH) / 2))
    end
    slot:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
    r:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
    task.defer(fit)
    return r, slot, titleLabel, descLabel
end

local function toggle(g, o)
    local title, tags = parseTitle(o.Title)
    local _, slot = row(g, title, o.Desc, tags)
    local size = px(18)
    local box = new("TextButton", {
        Name = "Check", Size = UDim2.fromOffset(size, size), Position = UDim2.fromOffset(0, math.floor((K.ctrlH - size) / 2)),
        AutoButtonColor = false, Text = "",
    }, slot)
    corner(box, px(5))
    local rim = glass(box, { fill = 0.9, rim = 0.7, radius = px(4) }).rim
    local mark = new("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(px(12), px(12)),
        BackgroundTransparency = 1, Image = ICON.check, ImageColor3 = T.bg, ImageTransparency = 1,
    }, box)
    local obj = { Value = o.Value == true }
    local function paint(t)
        tween(box, t, { BackgroundTransparency = obj.Value and 0.08 or 0.9 })
        tween(rim, t, { Transparency = obj.Value and 0.3 or 0.7 })
        tween(mark, t, { ImageTransparency = obj.Value and 0 or 1 })
    end
    function obj:Set(v)
        obj.Value = v == true
        paint(0.15)
        if o.Callback then task.spawn(o.Callback, obj.Value) end
    end
    paint(0)
    box.MouseButton1Click:Connect(function() obj:Set(not obj.Value) end)
    box.MouseEnter:Connect(function() if not obj.Value then tween(rim, 0.12, { Transparency = 0.45 }) end end)
    box.MouseLeave:Connect(function() if not obj.Value then tween(rim, 0.12, { Transparency = 0.7 }) end end)
    return obj
end

local function decimals(step)
    local s = tostring(step)
    local d = s:match("%.(%d+)$")
    return d and #d or 0
end
local function slider(g, o)
    local title, tags = parseTitle(o.Title)
    local _, slot = row(g, title, o.Desc, tags)
    local v = type(o.Value) == "table" and o.Value or {}
    local min, max = tonumber(v.Min) or 0, tonumber(v.Max) or 100
    local step = tonumber(o.Step) or 1
    local dec = decimals(step)
    local suffix = o.Suffix or ""
    local obj = { Value = math.clamp(tonumber(v.Default) or min, min, max) }
    local trackW, valueW = px(150), px(50)
    local holder = new("Frame", { Size = UDim2.fromOffset(trackW + px(10) + valueW, K.ctrlH), BackgroundTransparency = 1 }, slot)
    local hit = new("TextButton", { Name = "Track", Size = UDim2.fromOffset(trackW, K.ctrlH), BackgroundTransparency = 1, AutoButtonColor = false, Text = "" }, holder)
    local trackH = px(6)
    if (K.ctrlH - trackH) % 2 == 1 then trackH += 1 end
    local track = new("Frame", { Position = UDim2.fromOffset(0, math.floor((K.ctrlH - trackH) / 2)), Size = UDim2.fromOffset(trackW, trackH), BorderSizePixel = 0 }, hit)
    corner(track, trackH)
    glass(track, { fill = 0.93, rim = 0.78, shine = 0.8, radius = trackH })
    local fill = new("Frame", { Name = "Fill", Size = UDim2.fromScale(0, 1), BorderSizePixel = 0 }, track)
    corner(fill, trackH)
    glass(fill, { fill = 0.18, rim = 0.45, shine = 0.3, radius = math.floor(trackH / 2) })
    local knobS = even(px(14))
    local knob = new("Frame", {
        Name = "Knob", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(knobS, knobS), BorderSizePixel = 0, ZIndex = 2,
    }, track)
    corner(knob, knobS)
    local bead = glass(knob, { fill = 0.04, rim = 0.25, shine = 0.1, radius = math.floor(knobS / 3) })
    local ring = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, px(6), 1, px(6)),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.9, BorderSizePixel = 0,
    }, knob)
    corner(ring, knobS)
    local pillH = even(px(20))
    local pill = new("Frame", {
        Position = UDim2.fromOffset(trackW + px(10), math.floor((K.ctrlH - pillH) / 2)), Size = UDim2.fromOffset(valueW, pillH),
    }, holder)
    corner(pill, math.floor(pillH / 2))
    glass(pill, { fill = 0.92, rim = 0.7, shine = 0.6, radius = px(6) })
    local valueLabel = new("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, FontFace = T.mono, TextSize = px(11), TextColor3 = T.text }, pill)

    local function paint(t)
        local a = max > min and (obj.Value - min) / (max - min) or 0
        tween(fill, t, { Size = UDim2.fromScale(a, 1) })
        tween(knob, t, { Position = UDim2.new(a, 0, 0.5, 0) })
        valueLabel.Text = string.format("%." .. dec .. "f", obj.Value) .. suffix
    end
    local function snap(x)
        x = math.clamp(tonumber(x) or min, min, max)
        x = min + math.floor((x - min) / step + 0.5) * step
        return math.clamp(tonumber(string.format("%." .. dec .. "f", x)), min, max)
    end
    function obj:Set(x)
        x = snap(x)
        local changed = x ~= obj.Value
        obj.Value = x
        paint(0.08)
        if changed and o.Callback then task.spawn(o.Callback, x) end
    end
    paint(0)
    local dragging = false
    local function fromMouse(x)
        obj:Set(min + math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1) * (max - min))
    end
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            tween(knob, 0.1, { Size = UDim2.fromOffset(knobS + px(2), knobS + px(2)) })
            tween(ring, 0.1, { BackgroundTransparency = 0.8 })
            tween(bead.rim, 0.1, { Transparency = 0.05 })
            fromMouse(input.Position.X)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            fromMouse(input.Position.X)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            tween(knob, 0.1, { Size = UDim2.fromOffset(knobS, knobS) })
            tween(ring, 0.1, { BackgroundTransparency = 0.9 })
            tween(bead.rim, 0.1, { Transparency = 0.25 })
        end
    end)
    return obj
end

local openPopup
closePopup = function()
    if openPopup then
        local p = openPopup
        openPopup = nil
        p.close()
    end
end
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if not openPopup then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local m = game:GetService("UserInputService"):GetMouseLocation()
    local function inside(el)
        local a, s = el.AbsolutePosition, el.AbsoluteSize
        return m.X >= a.X and m.X <= a.X + s.X and m.Y >= a.Y and m.Y <= a.Y + s.Y
    end
    if not (inside(openPopup.list) or inside(openPopup.field)) then closePopup() end
end)

local function dropdown(g, o)
    local title, tags = parseTitle(o.Title)
    local _, slot = row(g, title, o.Desc, tags)
    local obj = { Values = o.Values or {} }
    local multi = o.Multi == true
    local chosen
    local function setChosen(v)
        if multi then
            chosen = {}
            if type(v) == "table" then
                for k, x in pairs(v) do
                    local label = (type(k) == "string" and x == true) and k or x
                    if label ~= nil then chosen[label] = true end
                end
            elseif v ~= nil then
                chosen[v] = true
            end
        else
            chosen = v
        end
    end
    setChosen(o.Value)
    if not multi and chosen == nil and not o.AllowNone then chosen = obj.Values[1] end

    local width = px(170)
    local field = new("TextButton", { Name = "Dropdown", Size = UDim2.fromOffset(width, K.ctrlH), AutoButtonColor = false, Text = "" }, slot)
    corner(field, px(6))
    local fieldRim = glass(field, { fill = 0.93, rim = 0.75, radius = px(6) }).rim
    local text = new("TextLabel", {
        Position = UDim2.fromOffset(px(10), 0), Size = UDim2.new(1, -px(34), 1, 0), BackgroundTransparency = 1,
        FontFace = T.font, TextSize = px(12), TextColor3 = T.text, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, field)
    local chev = new("ImageLabel", {
        Size = UDim2.fromOffset(px(12), px(12)), Position = UDim2.new(1, -px(22), 0, math.floor((K.ctrlH - px(12)) / 2)),
        BackgroundTransparency = 1, Image = ICON["chevron-down"], ImageColor3 = T.subtext,
    }, field)

    local function list()
        local out = {}
        for _, v in ipairs(obj.Values) do if chosen[v] then table.insert(out, v) end end
        return out
    end
    local function refresh()
        if not multi then text.Text = chosen ~= nil and tostring(chosen) or "None" return end
        local l = list()
        text.Text = #l == 0 and "None" or (#l == 1 and tostring(l[1]) or ("%s +%d"):format(tostring(l[1]), #l - 1))
    end
    refresh()
    obj.Value = multi and list() or chosen
    local function fire()
        obj.Value = multi and list() or chosen
        if o.Callback then task.spawn(o.Callback, obj.Value) end
    end

    local itemH = px(28)
    local function open()
        closePopup()
        local pos, size = inWindow(field)
        local searchable = #obj.Values > 8
        local searchH = searchable and (px(28) + px(4)) or 0
        local visible = math.min(#obj.Values, 7)
        local fullH = visible * itemH + px(8) + searchH
        local up = pos.Y + size.Y + px(4) + fullH > T.size.Y - px(8)
        local listFrame = new("Frame", {
            Name = "DropdownList", AnchorPoint = Vector2.new(0, up and 1 or 0),
            Position = UDim2.fromOffset(pos.X, up and (pos.Y - px(4)) or (pos.Y + size.Y + px(4))),
            Size = UDim2.fromOffset(size.X, 0), BackgroundColor3 = Color3.fromRGB(12, 12, 14), ClipsDescendants = true,
        }, overlay)
        corner(listFrame, px(6))
        new("UIStroke", { Color = T.fieldLine, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, listFrame)
        local query
        if searchable then
            local sb = new("Frame", {
                Position = UDim2.fromOffset(px(4), px(4)), Size = UDim2.new(1, -px(8), 0, px(28)), BackgroundColor3 = T.field,
            }, listFrame)
            corner(sb, px(5))
            query = new("TextBox", {
                Position = UDim2.fromOffset(px(8), 0), Size = UDim2.new(1, -px(16), 1, 0), BackgroundTransparency = 1,
                ClearTextOnFocus = false, FontFace = T.font, TextSize = px(12), TextColor3 = T.text,
                PlaceholderText = "Search...", PlaceholderColor3 = T.muted, Text = "", TextXAlignment = Enum.TextXAlignment.Left,
            }, sb)
        end
        local scroller = new("ScrollingFrame", {
            Position = UDim2.fromOffset(0, searchH), Size = UDim2.new(1, 0, 1, -searchH), BackgroundTransparency = 1,
            BorderSizePixel = 0, ScrollBarThickness = px(2), ScrollBarImageColor3 = Color3.fromRGB(60, 60, 66),
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        }, listFrame)
        new("UIPadding", { PaddingTop = UDim.new(0, px(4)), PaddingBottom = UDim.new(0, px(4)), PaddingLeft = UDim.new(0, px(4)), PaddingRight = UDim.new(0, px(4)) }, scroller)
        new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, scroller)
        local items = {}
        for i, v in ipairs(obj.Values) do
            local item = new("TextButton", {
                Name = tostring(v), LayoutOrder = i, Size = UDim2.new(1, 0, 0, itemH), BackgroundColor3 = T.rowActive,
                BackgroundTransparency = 1, AutoButtonColor = false, Text = "",
            }, scroller)
            corner(item, px(5))
            new("TextLabel", {
                Position = UDim2.fromOffset(px(8), 0), Size = UDim2.new(1, -px(30), 1, 0), BackgroundTransparency = 1,
                FontFace = T.font, TextSize = px(12), TextColor3 = T.text, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, Text = tostring(v),
            }, item)
            local on = multi and chosen[v] or (not multi and chosen == v)
            local mark = new("ImageLabel", {
                Size = UDim2.fromOffset(px(12), px(12)), Position = UDim2.new(1, -px(20), 0, math.floor((itemH - px(12)) / 2)),
                BackgroundTransparency = 1, Image = ICON.check, ImageColor3 = T.text, ImageTransparency = on and 0 or 1,
            }, item)
            items[i] = { item = item, v = v }
            item.MouseEnter:Connect(function() tween(item, 0.1, { BackgroundTransparency = 0 }) end)
            item.MouseLeave:Connect(function() tween(item, 0.1, { BackgroundTransparency = 1 }) end)
            item.MouseButton1Click:Connect(function()
                if multi then
                    chosen[v] = not chosen[v] or nil
                    tween(mark, 0.12, { ImageTransparency = chosen[v] and 0 or 1 })
                    refresh()
                    fire()
                else
                    chosen = v
                    refresh()
                    fire()
                    closePopup()
                end
            end)
        end
        if query then
            query:GetPropertyChangedSignal("Text"):Connect(function()
                local q = query.Text:lower()
                for _, it in ipairs(items) do it.item.Visible = q == "" or tostring(it.v):lower():find(q, 1, true) ~= nil end
            end)
        end
        tween(listFrame, 0.18, { Size = UDim2.fromOffset(size.X, fullH) })
        tween(chev, 0.18, { Rotation = 180 })
        tween(fieldRim, 0.15, { Transparency = 0.4 })
        openPopup = {
            list = listFrame, field = field,
            close = function()
                tween(chev, 0.15, { Rotation = 0 })
                tween(fieldRim, 0.15, { Transparency = 0.75 })
                local tw = tween(listFrame, 0.12, { Size = UDim2.fromOffset(size.X, 0) })
                tw.Completed:Once(function() listFrame:Destroy() end)
            end,
        }
    end
    field.MouseButton1Click:Connect(function()
        if openPopup and openPopup.field == field then closePopup() else open() end
    end)

    function obj:Select(v)
        setChosen(v)
        refresh()
        fire()
    end
    function obj:Refresh(values)
        obj.Values = values or {}
        if multi then
            local keep = {}
            for _, x in ipairs(obj.Values) do if chosen[x] then keep[x] = true end end
            chosen = keep
        elseif not table.find(obj.Values, chosen) then
            chosen = obj.Values[1]
        end
        refresh()
    end
    return obj
end

local KEYNAMES = { LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl",
    LeftAlt = "LAlt", RightAlt = "RAlt", MouseButton2 = "RMB", MouseButton3 = "MMB" }
local function keybind(g, o)
    local title, tags = parseTitle(o.Title)
    local _, slot = row(g, title, o.Desc, tags)
    local obj = { Value = typeof(o.Value) == "EnumItem" and o.Value.Name or o.Value, Picking = false }
    local btn = new("TextButton", { Name = "Keybind", Size = UDim2.fromOffset(px(84), K.ctrlH), AutoButtonColor = false, Text = "" }, slot)
    corner(btn, px(6))
    local rim = glass(btn, { fill = 0.93, rim = 0.75, radius = px(6) }).rim
    local label = new("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, FontFace = T.mono, TextSize = px(11), TextColor3 = T.text }, btn)
    local function paint()
        if obj.Picking then
            label.Text, label.TextColor3 = "...", T.subtext
        else
            label.Text = obj.Value and (KEYNAMES[obj.Value] or obj.Value) or "None"
            label.TextColor3 = obj.Value and T.text or T.muted
        end
        tween(rim, 0.15, { Transparency = obj.Picking and 0.2 or 0.75 })
    end
    function obj:Set(k)
        obj.Value = typeof(k) == "EnumItem" and k.Name or ((type(k) == "string" and k ~= "") and k or nil)
        paint()
        if o.Callback then task.spawn(o.Callback, obj.Value) end
    end
    paint()
    btn.MouseButton1Click:Connect(function()
        if obj.Picking then return end
        obj.Picking = true
        capture.active = true
        paint()
    end)
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if not obj.Picking then return end
        local kc = input.KeyCode
        local mb = input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3
        if kc == Enum.KeyCode.Unknown and not mb then return end
        task.defer(function() obj.Picking = false capture.active = false paint() end)
        if kc == Enum.KeyCode.Escape then return end
        if kc == Enum.KeyCode.Backspace then obj:Set(nil) return end
        obj.Value = mb and input.UserInputType.Name or kc.Name
        if o.Callback then task.spawn(o.Callback, obj.Value) end
    end)
    return obj
end

local function paragraph(g, o)
    local title, tags = parseTitle(o.Title)
    local _, _, titleLabel, descLabel = row(g, title, (o.Desc and o.Desc ~= "") and o.Desc or " ", tags)
    local obj = {}
    function obj:SetDesc(t) if descLabel then descLabel.Text = tostring(t or "") end end
    function obj:SetTitle(t) titleLabel.Text = (parseTitle(t)) end
    return obj
end

local function button(g, o)
    local title, tags = parseTitle(o.Title)
    local _, slot = row(g, title, o.Desc, tags)
    local s = K.ctrlH
    local b = new("TextButton", { Name = "Run", Size = UDim2.fromOffset(s, s), AutoButtonColor = false, Text = "" }, slot)
    corner(b, px(7))
    glass(b, { fill = 0.88, rim = 0.6, radius = px(7) })
    new("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(px(13), px(13)),
        BackgroundTransparency = 1, Image = icon(o.Icon or "play"), ImageColor3 = T.text,
    }, b)
    b.MouseEnter:Connect(function() tween(b, 0.12, { BackgroundTransparency = 0.78 }) end)
    b.MouseLeave:Connect(function() tween(b, 0.12, { BackgroundTransparency = 0.88 }) end)
    b.MouseButton1Click:Connect(function() if o.Callback then task.spawn(o.Callback) end end)
    return {}
end

local toastHolder = new("Frame", {
    Name = "Toasts", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -px(18), 1, -px(18)),
    Size = UDim2.fromOffset(px(290), 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
}, gui)
new("UIListLayout", { Padding = UDim.new(0, px(8)), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom }, toastHolder)
local toastN = 0
local function toastColor(name)
    if name == "check" or name == "package-check" then return C.green end
    if name == "triangle-alert" or name == "alert-triangle" then return C.amber end
    return C.blue
end
local function notify(o)
    toastN += 1
    local wrap = new("Frame", { LayoutOrder = toastN, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 }, toastHolder)
    local card = new("Frame", {
        Position = UDim2.fromOffset(px(310), 0), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(10, 10, 12),
    }, wrap)
    corner(card, px(10))
    new("UIStroke", { Color = T.cardLine, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, card)
    local col = toastColor(o.Icon)
    local inner = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 }, card)
    new("UIPadding", { PaddingTop = UDim.new(0, px(11)), PaddingBottom = UDim.new(0, px(11)), PaddingLeft = UDim.new(0, px(44)), PaddingRight = UDim.new(0, px(12)) }, inner)
    new("UIListLayout", { Padding = UDim.new(0, px(2)), SortOrder = Enum.SortOrder.LayoutOrder }, inner)
    local badge = new("Frame", { Position = UDim2.fromOffset(px(12), px(11)), Size = UDim2.fromOffset(px(22), px(22)) }, card)
    corner(badge, px(7))
    glass(badge, { tint = col, fill = 0.8, rim = 0.45, rimColor = col, shine = 0.7, radius = px(4) })
    new("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(px(12), px(12)),
        BackgroundTransparency = 1, Image = icon(o.Icon), ImageColor3 = col:Lerp(Color3.new(1, 1, 1), 0.3),
    }, badge)
    new("TextLabel", {
        LayoutOrder = 1, Size = UDim2.new(1, 0, 0, px(15)), BackgroundTransparency = 1, FontFace = T.fontBold, TextSize = px(13),
        TextColor3 = T.text, TextXAlignment = Enum.TextXAlignment.Left, Text = tostring(o.Title or "Mono"),
    }, inner)
    if o.Content and o.Content ~= "" then
        new("TextLabel", {
            LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
            FontFace = T.font, TextSize = px(12), TextColor3 = T.subtext, TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true, Text = tostring(o.Content),
        }, inner)
    end
    tween(card, 0.35, { Position = UDim2.fromOffset(0, 0) })
    task.delay(tonumber(o.Duration) or 4, function()
        if not wrap.Parent then return end
        local tw = tween(card, 0.3, { Position = UDim2.fromOffset(px(310), 0) })
        tw.Completed:Once(function() wrap:Destroy() end)
    end)
end

local function popup(o)
    local shade = new("TextButton", {
        Name = "Popup", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1, AutoButtonColor = false, Text = "", ZIndex = 30,
    }, window)
    corner(shade, T.radius)
    tween(shade, 0.2, { BackgroundTransparency = 0.35 })
    local card = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(px(340), 0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Color3.fromRGB(12, 12, 14),
    }, shade)
    corner(card, px(12))
    new("UIStroke", { Color = T.cardLine, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, card)
    new("UIPadding", { PaddingTop = UDim.new(0, px(18)), PaddingBottom = UDim.new(0, px(16)), PaddingLeft = UDim.new(0, px(18)), PaddingRight = UDim.new(0, px(18)) }, card)
    new("UIListLayout", { Padding = UDim.new(0, px(8)), SortOrder = Enum.SortOrder.LayoutOrder }, card)
    new("TextLabel", {
        LayoutOrder = 1, Size = UDim2.new(1, 0, 0, px(20)), BackgroundTransparency = 1, FontFace = T.fontBold, TextSize = px(16),
        TextColor3 = T.text, TextXAlignment = Enum.TextXAlignment.Left, Text = tostring(o.Title or ""),
    }, card)
    new("TextLabel", {
        LayoutOrder = 2, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        FontFace = T.font, TextSize = px(12), TextColor3 = T.subtext, TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true, Text = tostring(o.Content or ""),
    }, card)
    local rowF = new("Frame", { LayoutOrder = 3, Size = UDim2.new(1, 0, 0, px(34)), BackgroundTransparency = 1 }, card)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, px(8)), SortOrder = Enum.SortOrder.LayoutOrder }, rowF)
    local function close()
        local tw = tween(shade, 0.15, { BackgroundTransparency = 1 })
        card.Visible = false
        tw.Completed:Once(function() shade:Destroy() end)
    end
    for i, b in ipairs(o.Buttons or {}) do
        local primary = b.Variant == "Primary"
        local label = tostring(b.Title or "OK")
        local btn = new("TextButton", {
            LayoutOrder = i, Size = UDim2.fromOffset(textW(label, px(12), T.fontBold) + px(28), px(28)), AutoButtonColor = false, Text = "",
        }, rowF)
        corner(btn, px(7))
        glass(btn, { fill = primary and 0.1 or 0.9, rim = primary and 0.3 or 0.7, shine = primary and 0.2 or 0.5, radius = px(7) })
        new("TextLabel", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, FontFace = T.fontBold, TextSize = px(12),
            TextColor3 = primary and T.bg or T.text, Text = label,
        }, btn)
        btn.MouseButton1Click:Connect(function()
            close()
            if b.Callback then task.spawn(b.Callback) end
        end)
    end
    shade.MouseButton1Click:Connect(function() end)
end

local Lib = {}
local tabColors = { Player = C.blue, Settings = C.purple }
local gameColors = { C.amber, C.green, C.pink, C.teal }
local gameN = 0
local SECTION_ICONS = {
    Overview = "info", Interface = "monitor", Appearance = "palette", Presets = "bookmark", General = "settings",
    Script = "power", Hotkey = "keyboard", Movement = "wind",
    Seeds = "refresh-cw", Trees = "trees", Carving = "hand", Selling = "store",
    Delivery = "package", ["GIGA Planter"] = "zap", Events = "cloud-lightning",
}

local function makeTab(o)
    local name = tostring(o.Title or "Tab")
    local color = tabColors[name]
    if not color then
        gameN += 1
        color = gameColors[(gameN - 1) % #gameColors + 1]
    end
    addTab(name, icon(o.Icon), color)
    local tabObj = { name = name, sections = 0 }

    function tabObj:Section(so)
        local title = tostring(so.Title or "Section")
        self.sections += 1
        local col = SECTION_COLORS[(self.sections - 1) % #SECTION_COLORS + 1]
        local named = SECTION_ICONS[title]
        self.sec = addSection(name, title, icon(named or "circle"), col)
        self.secIconSet = named ~= nil
        self.page = makePage(name, title)
        self.group = group(self.page, nil)
        return self
    end
    local function g(self, iconName)
        if not self.group then self:Section({ Title = "Overview" }) end
        if iconName and not self.secIconSet and ICON[iconName] then
            self.sec.icon.Image = ICON[iconName]
            self.secIconSet = true
        end
        return self.group
    end
    function tabObj:Toggle(e)    return toggle(g(self, e.Icon), e) end
    function tabObj:Slider(e)    return slider(g(self, e.Icon), e) end
    function tabObj:Dropdown(e)  return dropdown(g(self, e.Icon), e) end
    function tabObj:Keybind(e)   return keybind(g(self, e.Icon), e) end
    function tabObj:Paragraph(e) return paragraph(g(self, e.Icon), e) end
    function tabObj:Button(e)    return button(g(self, e.Icon), e) end
    function tabObj:Current() return g(self) end
    function tabObj:Divider() return {} end
    function tabObj:Space() return {} end
    function tabObj:Group(caption)
        g(self)
        if self.group.rows == 0 then
            self.group.holder:Destroy()
            self.page.groups -= 1
        end
        self.group = group(self.page, caption)
        return self.group
    end
    return tabObj
end

local Window = {}
function Window:Tab(o) return makeTab(o) end
function Window:Section() return { Tab = function(_, o) return makeTab(o) end } end
function Window:SelectTab(i)
    local t = tabOrder[tonumber(i) or 1]
    if t then selectTab(t.name) end
end
function Window:SetToggleKey(code) if typeof(code) == "EnumItem" then T.toggleKey = code end end
function Window:SetUIScale(v)
    userScale = math.clamp(tonumber(v) or 1, 0.5, 2)
    pop.Scale = userScale
end
function Window:SetTheme() end
function Window:Destroy() pcall(function() gui:Destroy() end) end
function Window:Toggle() setShown(not shown) end

function Lib:CreateWindow(o)
    if o and typeof(o.ToggleKey) == "EnumItem" then T.toggleKey = o.ToggleKey end
    return Window
end
function Lib:Notify(o) pcall(notify, o or {}) end
function Lib:Popup(o) pcall(popup, o or {}) end

Lib.ScreenGui = gui
Lib.window = window
Lib.select = selectTab
Lib.selectSection = selectSection
Lib.collapse = setCollapsed
Lib.show = function() setShown(true) end
Lib.hide = function() setShown(false) end

getgenv().WindUI = Lib
