-- by GriZzm0

function onUse(cid, item, frompos, item2, topos)
gatepos = {x=182, y=53, z=7, stackpos=1}
getgate = getThingfromPos(gatepos)
gatepos2 = {x=183, y=53, z=7, stackpos=1}
getgate2 = getThingfromPos(gatepos2)

if item.uid == 7046 and item.itemid == 1945 and getgate2.itemid == 1353 and getgate.itemid == 1353 then
 doRemoveItem(getgate.uid,1)
 doRemoveItem(getgate2.uid,1)
 doTransformItem(item.uid,item.itemid+1)
elseif item.uid == 7046 and item.itemid == 1946 and getgate.itemid == 0 and getgate2.itemid == 0 then
 doCreateItem(1353,1,gatepos)
 doCreateItem(1353,1,gatepos2)
 doTransformItem(item.uid,item.itemid-1)
else
 doPlayerSendCancel(cid,"Sorry, not possible.")
end
return 1
end