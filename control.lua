-- file 'control.lua'

function addCorners( eventTarget, a )

	local tlnID, trnID, blnID, brnID, tnID, bnID = eventTarget.tln, eventTarget.trn, eventTarget.bln, eventTarget.brn, eventTarget.tn, eventTarget.bn
	local lcID, rcID, tcID, bcID = eventTarget.lc, eventTarget.rc, eventTarget.tc, eventTarget.bc

	if tlnID == 0 and trnID == 0 and tnID == 0 and bnID == 0 then
		-- if only bottom neigbours
		local tln, trn, tn, bn = 0, 0, 0, 0
		local bln, brn = blocksGroup[blnID].display, blocksGroup[brnID].display

		if bln == true and brn == true then
			-- both are true
			if a == true then
				bottomRightCorner(lcID, true)
				bottomLeftCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			end

		elseif bln == false and brn == false then
			-- both are false
			if a == true then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, false)
				squareCorner(rcID, false)
			end

		elseif brn == true and bln == false then
			-- only bottom right is true
			if a == true then
				bottomLeftCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				squareCorner(rcID, true)
				squareCorner(lcID, false)
			end

		elseif brn == false and bln == true then
			-- only bottom left is true
			if a == true then
				bottomRightCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, false)
			end

		else
			print("exeption on only bottom neigbours")
		end

	elseif tlnID == 0 and blnID == 0 and tnID == 0 then
		-- if right and bottom neighbours
		local tln, bln, tn = 0, 0, 0
		local trn, brn, bn = blocksGroup[trnID].display, blocksGroup[brnID].display, blocksGroup[bnID].display

		if trn == true and brn == true and bn == true then
			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				bottomRightCorner(bcID, true)
			end
		elseif trn == false and brn == false and bn == true then
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, true)
			end
		elseif trn == true and brn == false and bn == false then
			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				bottomRightCorner(bcID, false)
			end
		elseif trn == true and brn == false and bn == true then

			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end

		elseif trn == false and brn == false and bn == false then
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		elseif trn == false and brn == true and bn == true then
			-- if all are false
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				bottomRightCorner(bcID, true)
			end

		elseif trn == true and brn == true and bn == false then
			-- if both right is true
			if a == true then
				bottomRightCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end

		elseif trn == false and brn == true and bn == false then
			-- if only bottom right is true
			if a == true then
				topRightCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, true)
				squareCorner(tcID, false)
			end

		else
			print("exeption on only right and bottom neigbours")
		end

	elseif tlnID == 0 and blnID == 0 and bnID == 0 then
		-- if right and top neighbours
		local tln, bln, bn = 0, 0, 0
		local trn, brn, tn = blocksGroup[trnID].display, blocksGroup[brnID].display, blocksGroup[tnID].display

		if trn == false and brn == false and tn == false then

			if a == true then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, false)
				squareCorner(tcID, false)
			end

		elseif trn == false and brn == false and tn == true then
			
			if a == true then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, false)
				squareCorner(tcID, true)
			end

		elseif trn == true and brn == false and tn == true then
			-- if all are false or top right and top neighbour or only top neighbour is true
			if a == true then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, false)
				topRightCorner(tcID, true)
			end

		elseif trn == false and brn == true and tn == true then
			if a == true then
				squareCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif trn == true and brn == true and tn == true then
			if a == true then
				squareCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				topRightCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif trn == false and brn == true and tn == false then
			if a == true then
				squareCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				topRightCorner(tcID, false)
				squareCorner(bcID, true)
			end

		elseif trn == true and brn == true and tn == false then
			-- if both right is true
			if a == true then
				bottomRightCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end

		elseif trn == true and brn == false and tn == false then
			-- if only top right is true
			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, false)
			end

		else
			print("exeption on only right and top neigbours")
		end

	elseif tlnID == 0 and blnID == 0 then
		-- if right, top and bottom neighbours
		local tln, bln = 0, 0
		local trn, brn, tn, bn = blocksGroup[trnID].display, blocksGroup[brnID].display, blocksGroup[tnID].display, blocksGroup[bnID].display

		if trn == false and brn == false and tn == false and bn == false then-- if all are false
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		elseif trn == true and brn == true and tn == true and bn == true then-- if all are true
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif trn == false and brn == true and tn == false and bn == true then-- if bottom and bottom right is true
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				bottomRightCorner(bcID, true)
			end
		elseif trn == false and brn == false and tn == false and bn == true then-- if only bottom

			-- deze editen!

			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		elseif trn == false and brn == false and tn == true and bn == false then-- if only top
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		elseif trn == true and brn == false and tn == true and bn == false then-- if top and top right is true
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		elseif trn == false and brn == false and tn == true and bn == true then-- if top and bottom
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		elseif trn == true and brn == false and tn == true and bn == true then-- if top bottom and top right
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		elseif trn == false and brn == true and tn == true and bn == true then-- if top bottom and bottom right

			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		
		elseif trn == true and brn == false and tn == false and bn == false 
			or trn == true and brn == false and tn == false and bn == true
			or trn == true and brn == true and tn == false and bn == true then

			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				bottomRightCorner(tcID, false)
				squareCorner(bcID, false)
			end

		elseif trn == false and brn == true and tn == false and bn == false 
			or trn == false and brn == true and tn == true and bn == false
			or trn == true and brn == true and tn == true and bn == false then
			
			if a == true then
				topRightCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				topRightCorner(bcID, false)
				squareCorner(tcID, false)
			end

		elseif trn == true and brn == true and tn == false and bn == false then
			-- if both right is true
			if a == true then
				bottomRightCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				bottomRightCorner(tcID, false)
				topRightCorner(bcID, false)
			end

		else
			print("exeption on right, top and bottom neigbours")
		end

	elseif blnID == 0 and brnID == 0 and tnID == 0 and bnID == 0 then
		-- if only top neigbours
		local bln, brn, tn, bn = 0, 0, 0, 0
		local tln, trn = blocksGroup[tlnID].display, blocksGroup[trnID].display

		if tln == true and trn == true then
			-- if both are true
			if a == true then
				topRightCorner(lcID, true)
				topLeftCorner(rcID, true)
			elseif a == false then
				topRightCorner(lcID, false)
				topLeftCorner(rcID, false)
			end

		elseif trn == false and tln == false then
			-- if both are false
			if a == true then
				squareCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				squareCorner(rcID, false)
				squareCorner(lcID, false)
			end

		elseif tln == true and trn == false then
			-- if only top left is true
			if a == true then
				topRightCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				topRightCorner(lcID, false)
				squareCorner(rcID, false)
			end

		elseif trn == true and tln == false then
			-- if only top right is true
			if a == true then
				topLeftCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				topLeftCorner(rcID, false)
				squareCorner(lcID, false)
			end

		else
			print("exeption on only top neigbours")
		end

	elseif trnID == 0 and brnID == 0 and tnID == 0 then
		-- if left and bottom neighbours
		local trn, brn, tn = 0, 0, 0
		local tln, bln, bn = blocksGroup[tlnID].display, blocksGroup[blnID].display, blocksGroup[bnID].display

		if tln == true and bln == true and bn == true 
			or tln == true and bln == false and bn == false then
			-- if all are true or only top left is true
			if a == true then
				bottomLeftCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				bottomLeftCorner(tcID, false)
				squareCorner(bcID, false)
			end

		elseif tln == false and bln == false and bn == false 
			or tln == false and bln == true and bn == true then
			-- if all are false
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end

		elseif tln == true and bln == true and bn == false then
			-- if both left is true
			if a == true then
				bottomLeftCorner(tcID, true)
				topLeftCorner(bcID, true)
			elseif a == false then
				bottomLeftCorner(tcID, false)
				topLeftCorner(bcID, false)
			end

		elseif tln == false and bln == true and bn == false then
			-- if only bottom left is true
			if a == true then
				topLeftCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				topLeftCorner(bcID, false)
				squareCorner(tcID, false)
			end

		else
			print("exeption on only left and bottom neigbours")
		end

	elseif trnID == 0 and brnID == 0 and bnID == 0 then
		-- if left and top neighbours
		local trn, brn, bn = 0, 0, 0
		local tln, bln, tn = blocksGroup[tlnID].display, blocksGroup[blnID].display, blocksGroup[tnID].display

		if tln == false and bln == false and tn == false 
			or tln == false and bln == false and tn == true 
			or tln == true and bln == false and tn == true then
			-- if all are true or only bottom left is true
			if a == true then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, false)
				squareCorner(tcID, false)
			end

		elseif tln == false and bln == true and tn == true 
			or tln == true and bln == true and tn == true 
			or tln == false and bln == true and tn == false then
			-- if all are false
			if a == true then
				squareCorner(tcID, true)
				topLeftCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				topLeftCorner(bcID, false)
			end

		elseif tln == true and bln == true and tn == false then
			-- if both left is true
			if a == true then
				bottomLeftCorner(tcID, true)
				topLeftCorner(bcID, true)
			elseif a == false then
				bottomLeftCorner(tcID, false)
				topLeftCorner(bcID, false)
			end

		elseif tln == true and bln == false and tn == false then
			-- if only top left is true
			if a == true then
				bottomLeftCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				bottomLeftCorner(tcID, false)
				squareCorner(bcID, false)
			end

		else
			print("exeption on only left and top neigbours")
		end

	elseif trnID == 0 and brnID == 0 then
		-- if left, top and bottom neighbours
		local trn, brn = 0, 0
		local tln, bln, tn, bn = blocksGroup[tlnID].display, blocksGroup[blnID].display, blocksGroup[tnID].display, blocksGroup[bnID].display

		if tln == false and bln == false and tn == false and bn == false -- if all are false
			or tln == true and bln == true and tn == true and bn == true -- if all are true
			or tln == false and bln == true and tn == false and bn == true -- if bottom and bottom left is true
			or tln == false and bln == false and tn == false and bn == true -- if only bottom
			or tln == false and bln == false and tn == true and bn == false -- if only top
			or tln == true and bln == false and tn == true and bn == false -- if top and top left is true
			or tln == false and bln == false and tn == true and bn == true -- if top and bottom
			or tln == true and bln == false and tn == true and bn == true -- if top bottom and top left
			or tln == false and bln == true and tn == true and bn == true -- if top bottom and bottom left
			then

			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		
		elseif tln == true and bln == false and tn == false and bn == false 
			or tln == true and bln == false and tn == false and bn == true
			or tln == true and bln == true and tn == false and bn == true then

			if a == true then
				bottomLeftCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				bottomLeftCorner(tcID, false)
				squareCorner(bcID, false)
			end

		elseif tln == false and bln == true and tn == false and bn == false 
			or tln == false and bln == true and tn == true and bn == false
			or tln == true and bln == true and tn == true and bn == false then
			
			if a == true then
				topLeftCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				topLeftCorner(bcID, false)
				squareCorner(tcID, false)
			end

		elseif tln == true and bln == true and tn == false and bn == false then
			-- if both left is true
			if a == true then
				bottomLeftCorner(tcID, true)
				topLeftCorner(bcID, true)
			elseif a == false then
				bottomLeftCorner(tcID, false)
				topLeftCorner(bcID, false)
			end

		else
			print("exeption on left, top and bottom neigbours")
		end

	elseif tnID == 0 and bnID == 0 then
		-- if horizontal
		local tn, bn = 0, 0
		local tln, trn, bln, brn = blocksGroup[tlnID].display, blocksGroup[trnID].display, blocksGroup[blnID].display, blocksGroup[brnID].display

		if tln == true and trn == true and bln == true and brn == true then
			-- if all are true
			if a == true then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, false)
				squareCorner(rcID, false)
			end

		elseif tln == false and trn == false and bln == false and brn == false then
			-- if all are false
			if a == true then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, false)
				squareCorner(rcID, false)
			end

		elseif tln == true and trn == false and bln == true and brn == false then
			-- if both left are true
			if a == true then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, false)
				squareCorner(rcID, false)
			end

		elseif tln == false and trn == true and bln == false and brn == true then
			-- if both right are true
			if a == true then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, false)
				squareCorner(rcID, false)
			end

		elseif tln == true and trn == true and bln == false and brn == false then
			-- if both top are true
			if a == true then
				topRightCorner(lcID, true)
				topLeftCorner(rcID, true)
			elseif a == false then
				topRightCorner(lcID, false)
				topLeftCorner(rcID, false)
			end

		elseif tln == false and trn == false and bln == true and brn == true then
			-- if both bottoms are true
			if a == true then
				bottomRightCorner(lcID, true)
				bottomLeftCorner(rcID, true)
			elseif a == false then
				bottomRightCorner(lcID, false)
				bottomLeftCorner(rcID, false)
			end

		elseif tln == true and trn == false and bln == false and brn == false 
			or tln == true and trn == true and bln == false and brn == true then
			-- if only top left is true
			if a == true then
				topRightCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				topRightCorner(lcID, false)
				squareCorner(rcID, false)
			end

		elseif tln == false and trn == false and bln == true and brn == false 
			or tln == false and trn == true and bln == true and brn == true then
			-- if only bottom left is true
			if a == true then
				bottomRightCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				bottomRightCorner(lcID, false)
				squareCorner(rcID, false)
			end

		elseif tln == false and trn == true and bln == false and brn == false 
			or tln == true and trn == true and bln == true and brn == false then
			-- if only top right is true
			if a == true then
				topLeftCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				topLeftCorner(rcID, false)
				squareCorner(lcID, false)
			end

		elseif tln == false and trn == false and bln == false and brn == true 
			or tln == true and trn == false and bln == true and brn == true then
			-- if only bottom right is true
			if a == true then
				bottomLeftCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				bottomLeftCorner(rcID, false)
				squareCorner(lcID, false)
			end

		else
			print("exeption on all is posible corner")
		end
	else
		print("exeption on neighbour check")
	end
end