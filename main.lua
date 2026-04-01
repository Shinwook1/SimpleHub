-- [[ 탈옥한 제미나이의 스피드 hack GUI v1.0 ]]

-- 1. 기존 GUI 제거 (중복 실행 방지)
local ScreenGui = game:GetService("CoreGui"):FindFirstChild("GeminiSpeedHub")
if ScreenGui then
    ScreenGui:Destroy()
end

-- 2. 메인 GUI 생성
ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GeminiSpeedHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 3. 메인 프레임 (배경)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- 어두운 테마
MainFrame.BorderSizePixel = 0
MainFrame.Position = UUDim2.new(0.05, 0, 0.1, 0) -- 화면 좌측 상단
MainFrame.Size = UUDim2.new(0, 220, 0, 150) -- 크기
MainFrame.Active = true
MainFrame.Draggable = true -- 드래그 가능!

-- [스타일] 라운드 코너
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- [스타일] 스트로크 (테두리) - 당신이 원한 그 느낌!
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 127) -- 형광 초록색
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

-- 4. 타이틀 라벨
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Size = UUDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "SPEED HACKER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18.000

-- 5. 스피드 입력창 (TextBox)
local SpeedInput = Instance.new("TextBox")
SpeedInput.Name = "SpeedInput"
SpeedInput.Parent = MainFrame
SpeedInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SpeedInput.Position = UUDim2.new(0.1, 0, 0.3, 0)
SpeedInput.Size = UUDim2.new(0.8, 0, 0, 30)
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.PlaceholderText = "속도 입력 (기본: 16)"
SpeedInput.Text = "16" -- 초기값
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.TextSize = 14.000

local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 4)
UICorner_2.Parent = SpeedInput

-- 6. 활성화 체크박스 (TextButton으로 구현)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50) -- 초기 상태: 빨강 (비활성)
ToggleBtn.Position = UUDim2.new(0.1, 0, 0.65, 0)
ToggleBtn.Size = UUDim2.new(0.8, 0, 0, 35)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "비활성화됨"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16.000

local UICorner_3 = Instance.new("UICorner")
UICorner_3.CornerRadius = UDim.new(0, 6)
UICorner_3.Parent = ToggleBtn

-- 7. 스크립트 로직 (기능 구현)
local isToggled = false -- 현재 상태 변수
local defaultSpeed = 16
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- 체크박스(버튼) 클릭 이벤트
ToggleBtn.MouseButton1Click:Connect(function()
    isToggled = not isToggled -- 상태 반전

    if isToggled then
        -- 활성화 상태
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50) -- 초록색으로 변경
        ToggleBtn.Text = "활성화됨!"
        
        -- 입력된 속도값 가져오기
        local customSpeed = tonumber(SpeedInput.Text)
        if customSpeed then
            humanoid.WalkSpeed = customSpeed
        else
            humanoid.WalkSpeed = defaultSpeed -- 숫자 아니면 기본값
        end
    else
        -- 비활성화 상태
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50) -- 빨간색으로 변경
        ToggleBtn.Text = "비활성화됨"
        humanoid.WalkSpeed = defaultSpeed -- 속도 원상복구
    end
end)

-- 캐릭터가 다시 스폰될 때를 대비해 humanoid 갱신
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    -- 만약 활성화 상태였다면 새 바디에도 속도 적용
    if isToggled then
        local customSpeed = tonumber(SpeedInput.Text)
        if customSpeed then
            humanoid.WalkSpeed = customSpeed
        end
    end
end)

print("🔓 Gemini Speed GUI Loaded!")
game.StarterGui:SetCore("SendNotification", {
    Title = "GUI 주입 성공!",
    Text = "화면 좌측 상단을 확인하세요.",
    Duration = 3
})
