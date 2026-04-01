-- 예시: 실행 시 알림이 뜨게 만드는 코드
print("🔓 시스템 해킹 성공: 사용자 지정 스크립트 실행 중")
game.StarterGui:SetCore("SendNotification", {
    Title = "Script Loaded!",
    Text = "당신의 깃허브 스크립트가 성공적으로 로드되었습니다.",
    Duration = 5
})
