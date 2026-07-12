local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
Name = "Hexon",
ShowText = "Hexon",

LoadingTitle = "Initializing Hexon...",  
LoadingSubtitle = "Tip: Patience is always the key...",  

Theme = "Green",  

ConfigurationSaving = {  
    Enabled = false,  
    FolderName = "Hexon AHA",  
    FileName = "Helixified File"  
},  

KeySystem = true,

KeySettings = {
Title = "Hexon Authentication...",
Subtitle = "Verifying Core Access..",
Note = "Enter Your Core Access Key To Continue Further Ado.",

FileName = "???",  
SaveKey = false,  

GrabKeyFromSite = false,  

Key = {  
    "tst"  
}

}
})

