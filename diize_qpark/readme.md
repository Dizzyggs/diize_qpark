Thanks for downloading, below is some info you might need:

You can choose what notification + billing system you use in Config.lua.

---

## ----------------OKOKBILLING INSTRUCTIONS----------------

## --------------------------------------------------------

1. If you are using okokBilling: head to Config.lua and set Config.okokB to true.... Config.okokB = true
2. head to okokBilling -> server.lua, and paste this in wherever and choose a notification system in the code:

RegisterServerEvent("okokBilling:qPark")
AddEventHandler("okokBilling:qPark", function(target, price, notes)
local xTarget = target
local webhookData = {}
MySQL.Async.insert('INSERT INTO okokBilling (receiver_identifier, receiver_name, author_identifier, author_name, society, society_name, item, invoice_value, status, notes, sent_date, limit_pay_date) VALUES (@receiver_identifier, @receiver_name, @author_identifier, @author_name, @society, @society_name, @item, @invoice_value, @status, @notes, CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL @limit_pay_date DAY))', {
['@receiver_identifier'] = xTarget.identifier,
['@receiver_name'] = xTarget.getName(),
['@author_identifier'] = "QPARK",
['@author_name'] = "QPARK",
['@society'] = "QPARK",
['@society_name'] = "QPARK",
['@item'] = "Felparkering",
['@invoice_value'] = price,
['@status'] = "unpaid",
['@notes'] = notes,
['@limit_pay_date'] = 'N/A'
}, function(result)
if result then
-- CHOOSE ONE OF THE NOTIFICATIONS BELOW.
TriggerClientEvent('okokNotify:Alert', target.source, "BILLING", "New bill received.", 10000, 'info')
-- TriggerClientEvent('esx:showNotification', target.source, "New bill received.")
-- TriggerClientEvent('mythic_notify:client:SendAlert', target.source, { type = 'inform', text = "New bill received.", style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
else
end
end)
end)

## ----------------ESX_BILLING INSTRUCTIONS----------------

## --------------------------------------------------------

1. If you are using esx_billing: head to Config.lua and set Config.okokB to false.... Config.okokB = false.
2. head to esx_billing/server/main.lua and paste this in wherever and choose a notification system in the code:

RegisterServerEvent('esx_billing:diize_qpark')
AddEventHandler('esx_billing:diize_qpark', function(target, amount, label)

    			MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
    				['@identifier'] = target.identifier,
    				['@sender'] = "QPARK",
    				['@target_type'] = 'society',
    				['@target'] = target.identifier,
    				['@label'] = label,
    				['@amount'] = amount
    			}, function(result)
    				if result then
    -- CHOOSE ONE OF THE NOTIFICATIONS BELOW.
      TriggerClientEvent('okokNotify:Alert', target.source, "BILLING", "New bill received.", 10000, 'info')
    --   TriggerClientEvent('esx:showNotification', target.source, "New bill received.")
    -- TriggerClientEvent('mythic_notify:client:SendAlert', target.source, { type = 'inform', text = "New bill received.", style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })

    else
    	print("not online")
    		end
    	end)
    end)
