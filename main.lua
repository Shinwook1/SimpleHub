-- [[ Gemini Speed Hub v1.2 - Right Shift Toggle Edition ]]

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- 1. 기존 GUI 제거 (중복 실행 방지)
if CoreGui:FindFirstChild("GeminiSpeedHub") then
    CoreGui:FindFirstChild("GeminiSpeedHub"):Destroy()
end

-- 2. 메인 GUI 생성
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GeminiSpeedHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 3. 메인 프레임 (배경)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Active = true
MainFrame.Draggable = true -- 마우스로 드래그 가능

-- [스타일] 테두리 스트로크 (형광 초록)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- 4. 타이틀
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "GEMINI HUB [R-Shift]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- 5. 스피드 입력창
local SpeedInput = Instance.new("TextBox")
SpeedInput.Parent = MainFrame
SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedInput.Position = UDim2.new(0.1, 0, 0.3, 0)
SpeedInput.Size = UDim2.new(0.8, 0, 0, 30)
SpeedInput.PlaceholderText = "속도 (기본 16)"
SpeedInput.Text = "100" -- 기본 테스트용으로 100 설정
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)

-- 6. 활성화 버튼
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ToggleBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold

-- 7. 핵심 로직: 스피드 변조
local isToggled = false
local player = game.Players.LocalPlayer

ToggleBtn.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    
    if isToggled then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        ToggleBtn.Text = "ON"
        hum.WalkSpeed = tonumber(SpeedInput.Text) or 16
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        ToggleBtn.Text = "OFF"
        hum.WalkSpeed = 16
    end
end)

-- ★★★ 8. 대망의 '오른쪽 쉬프트' 토글 기능 ★★★
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- 다른 채팅창을 치고 있는 중이 아닐 때만 작동
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible -- 보임/안보임 반전
            print("🔓 GUI 가시성 상태 변경됨.")
        end
    end
end)

print("🔓 Gemini R-Shift Toggle Script Loaded!")
