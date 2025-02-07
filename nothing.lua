while true do
    task.wait()
    style.Value = "Kaiser"
    desc.Text = "The Emperor"
    slot.ImageColor3 = Color3.new(0,0,0)
    txt.Text = "Kaiser"
    txt.TextColor3 = Color3.new(255,255,255)
    slot.Text.Text = "Kaiser"
    skills["1"].Timer.Text = "Kaiser Impact"
    skills["2"].Timer.Text = "Godly Dribble"
end

if skills["1"]:FindFirstChild("Cooldown") or skills["2"]:FindFirstChild("Cooldown") then
    skills["2"]:FindFirstChild("Cooldown"):Destroy()
    skills["1"]:FindFirstChild("Cooldown"):Destroy()
end
