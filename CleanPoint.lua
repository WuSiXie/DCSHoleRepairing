---群组名带修复者的飞机F10菜单里会有修复飞机的选项（只有修复者的1号机能修飞机）
local repairing = {}
repairing.repairer = {}
repairing.repairingm = {}
repairing.repairingGroupNames = {}
local repairingCallback = {}
function repairing.findRepairman()
	for i = 1,99 do
		if (Group.getByName("修复者-"..tostring(i))) then
			table.insert(repairing.repairer,Group.getByName("修复者-"..tostring(i)))
		end
	end
end

function repairing.repairNow(repaire)
	local unit = repaire:getUnit(1)
	trigger.action.outTextForUnit(unit:getID(),"正在修复坑洞",20,true)
	local cleanPoint = unit:getPoint()
	cleanPoint.y = land.getHeight({x = unit:getPoint().x, y = unit:getPoint().z})
	local searchVolume = {
		id = world.VolumeType.SPHERE,
		params = {
			point = cleanPoint,
			radius = 120 --这个可以更改维修半径（米）
			}
		}
	world.removeJunk(searchVolume)
	trigger.action.outTextForUnit(unit:getID(),"修复完成",20,true)
end


function repairing.addcommandForRepairer()
	for i, repaier in pairs(repairing.repairer) do
		local missionTable = missionCommands.addCommandForGroup(repaier:getID(),"亲自修复周围坑洞",nil,repairing.repairNow,repaier)
		table.insert(repairing.repairingGroupNames,repaier:getName())
		table.insert(repairing.repairingm,missionTable)
	end
end

function repairing.SingleaddcommandForRepairer(repaier)
	local missionTable = missionCommands.addCommandForGroup(repaier:getID(),"亲自修复周围坑洞",nil,repairing.repairNow,repaier)
	table.insert(repairing.repairingGroupNames,repaier:getName())
	table.insert(repairing.repairingm,missionTable)
end

function repairingCallback:onEvent(Event)
	if (Event.id == 15) then
		local group = Event.initiator:getGroup()
		local groupName = group:getName()
		--trigger.action.outTextForUnit(Event.initiator:getID(),"出生",20,true)
		if (string.find(groupName,"修复者",1,true)) then
			--trigger.action.outTextForUnit(Event.initiator:getID(),"是修复者",20,true)
			for i, repaierName in pairs(repairing.repairingGroupNames) do
				if repaierName == groupName then
					return
				end
			end
			repairing.SingleaddcommandForRepairer(group)
		end
	end
end

repairing.findRepairman()
repairing.addcommandForRepairer()
world.addEventHandler(repairingCallback)