local config = {
	[10005] = {
		items = {
			{itemid = 2424} -- silver mace
		},
	},
	[10006] = {
		items = {
			{itemid = 2091, actionid = 5000}, 	-- golden key, demon quest
			{itemid = 1948},					-- parchment
			{itemid = 2229},					-- skull
			{itemid = 2230},					-- bone
			{itemid = 2151, type = 2},			-- talon
			{itemid = 2165}						-- ring
		},
	},
--	[10018] = {
--		items = {
--			{itemid = 1955, text = "Hardek *\nBozo *\nSam ****\nOswald\nPartos ***\nQuentin *\nTark ***\nHarsky ***\nStutch *\nFerumbras *\nFrodo **\nNoodles ****"} -- amber notebook
--		},
--	}
}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	local useItem = config[item.uid]
	if not useItem then
		return true
	end
	
	if not useItem.storage then
		useItem.storage = item.uid
	end

	if getPlayerStorageValue(cid, useItem.storage) ~= (useItem.formerValue or -1) then
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "It is empty.")
		return true
	end

	local items, reward = useItem.items
	local size = #items
	if size == 1 then
		if items[1].actionid then
			reward = doCopyItem(items[1], true)
		else
			reward = doCopyItem(items[1], false)
		end
	end

	local result = ''
	if reward then
		local ret = getItemDescriptions(reward.itemid)
		if (reward.type > 0 and isItemRune(reward.itemid)) then
			result = reward.type .. " charges " .. ret.name
		elseif(reward.type > 1 and isItemStackable(reward.itemid)) then
			result = reward.type .. " " .. ret.plural
		else
			result = ret.article .. " " .. ret.name
		end
	else
		if size > 8 then
			reward = getThing(doCreateItemEx(1988, 1))
			result = "a backpack"
		else
			reward = getThing(doCreateItemEx(1987, 1))
			result = "a bag"
		end

		for i = 1, size do
			if items[i].actionid then
				tmp = doCopyItem(items[i], true)
			else
				tmp = doCopyItem(items[i], false)
			end
			if(doAddContainerItemEx(reward.uid, tmp.uid) ~= RETURNVALUE_NOERROR) then
				print("[Warning] QuestSystem:", "Could not add quest reward")
			end
		end
		
	end
	
	if(doPlayerAddItemEx(cid, reward.uid, false) ~= RETURNVALUE_NOERROR) then
		if getPlayerFreeCap(cid) < getItemWeight(reward.uid) then
			result = "You have found a reward weighing " .. string.format("%.2f",getItemWeight(reward.uid)) .. " oz. It is too heavy."
		else
			result = "You have not enough space."
		end
	else
		result = "You have found " .. result .. "."
		setPlayerStorageValue(cid, useItem.storage, 1)
	end

	doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, result)
	return true
end
