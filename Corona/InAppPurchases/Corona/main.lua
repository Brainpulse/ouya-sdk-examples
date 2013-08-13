-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local function updateSprite(spriteObj, x, y, xScale, yScale, alpha)

	spriteObj.x = x;
	spriteObj.y = y;
	spriteObj.xScale = xScale;
	spriteObj.yScale = yScale;
	spriteObj.alpha = alpha;

end

local function createButton (x, y, xScale, yScale, text, tx, ty, ts)

	local button =
	{
		x = x,
		y = y,
		xScale = xScale,
		yScale = yScale,
		spriteActive = display.newImage("ButtonActive.png"),
		spriteInactive = display.newImage("ButtonInactive.png"),
		txtLabel = display.newText(text, x + tx, y + ty, "Helvetica", ts),
		tx = tx,
		ty = ty,
		btnDown = nil,
		btnLeft = nil,
		btnRight = nil,
		btnUp = nil
	};
	
	updateSprite(button.spriteActive, x, y, xScale, yScale, 0);
	updateSprite(button.spriteInactive, x, y, xScale, yScale, 1);
	
	return button;
	
end

-- Fade out the sprite alpha over 500ms
local function spriteFadeOut (spriteObj)
	if spriteObj == nil then
		print("Using nil spriteObj in spriteFadeOut");
	else
		spriteObj.alpha = 1;	
		transition.to(spriteObj, { time=500, alpha=0 })
	end
end

-- Fade in the sprite alpha over 500ms
local function spriteFadeIn (spriteObj)
	if spriteObj == nil then
		print("Using nil spriteObj in spriteFadeIn");
	else
		spriteObj.alpha = 0;
		transition.to(spriteObj, { time=500, alpha=1 })
	end
end

local function setButtonFocus (btnNext)
	
	if focusButton ~= nil and focusButton ~= btnNext then
		spriteFadeOut(focusButton.spriteActive);
		spriteFadeIn(focusButton.spriteInactive);
	end
	
	if btnNext ~= nil then
		focusButton = btnNext;
	end
	
	if focusButton ~= nil then
		spriteFadeOut(focusButton.spriteInactive);
		spriteFadeIn(focusButton.spriteActive);
	end
	
end

local centerX = display.contentCenterX;

btnProducts = createButton(centerX - 400, 400, 1.5, 0.5, "Get Products", -70, -25, 24);
btnPurchase = createButton(centerX - 175, 400, 1.75, 0.5, "Request Purchase", -100, -25, 24);
btnReceipts = createButton(centerX + 50, 400, 1.5, 0.5, "Get Receipts", -70, -25, 24);
btnFetch = createButton(centerX + 275, 400, 1.75, 0.5, "Fetch Gamer UUID", -100, -25, 24);
btnPause = createButton(centerX + 450, 400, 0.75, 0.5, "Pause", -35, -25, 24);

btnProducts.btnRight = btnPurchase;
btnPurchase.btnLeft = btnProducts;
btnPurchase.btnRight = btnReceipts;
btnReceipts.btnLeft = btnPurchase;
btnReceipts.btnRight = btnFetch;
btnFetch.btnLeft = btnReceipts;
btnPause.btnLeft = btnFetch;

setButtonFocus (btnProducts);

function onAsyncCall()
        print("onAsyncCall() has succeeded")
end

-- Called when a key event has been received.
local function onKeyEvent( event )
	--print("===== onKeyEvent ======")
	
	if event.device == nil then
		print("### device = nil")
		return false;
	end
	    
	--System Button / Pause Menu
    if (event.keyName == "menu" and event.phase == "up") then
    	setButtonFocus(btnPause);
    end
	
	--DPADS
	if (event.keyName == "left" and event.phase == "down") then
		setButtonFocus(focusButton.btnLeft);
    end
    
    if (event.keyName == "right" and event.phase == "down") then
		setButtonFocus(focusButton.btnRight);
    end
        
    --end of DPADS
    
	-- BUTTONS
    
    if (event.keyName == "buttonA" and event.phase == "down") then -- OUYA BUTTON_O
    	if focusButton == btnFetch then
    		print "Invoking asyncLuaOuyaFetchGamerUUID...";
    		myTests.asyncLuaOuyaFetchGamerUUID(onAsyncCall);
    	end
    end
       
    -- End of BUTTONS
	
	return false
end

-- Add the key event listener.
Runtime:addEventListener( "key", onKeyEvent )