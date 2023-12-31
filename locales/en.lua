local Translations = {
    error = {
        ["canceled"]                            = "Canceled",
        ["no_key"]                              = "You don't have the key",
        ["no_case"]                             = "You don't have the case",
        ["someone_recently_did_this"]           = "No New Info",
        ["you_failed"]                          = "You failed!",
        ["you_dont_have_enough_money"]          = "You Don't Have Enough Money",
        ["not_opened"]                          = "The timer on the case is still ticking!",
    },
    success = {
        ["you_removed_first_security_case"]     = "You secured the case",
        ["you_got_paid"]                        = "You got paid",
        ["payment_success"]                     = "We got the payment. Sending you the details",
        ["caseAquired"]                         = "There something beeping in the case",
        ["contentAquired"]                      = "The beeping stopped.",
    },
    info = {
        ["talking_to_boss"]                     = "Talking to boss..",
        ["unlocking_case"]                      = "Securing the Case..",
        ["turn_in_goods"]                       = "Turn in goods.",
        ["unlock_first"]                        = "Secure Case",
        ["search_key"]                          = "Grab Key",
        ["picked_up_key"]                       = "You picked up the key",
        ["cancel_job"]                          = "Cancel current job",
        ["job_canceled"]                        = "The raid job was canceled",
        ["canceling_job"]                       = "Canceling Job",
    },
    mailstart = {
        ["sender"]                              = "Unknown",
        ["subject"]                             = "?",
        ["message"]                             = "Updated your gps with the location to the case.",
    },
    mailSecond = {
        ["sender"]                              = "Unknown",
        ["subject"]                             = "Case Collection",
        ["message"]                             = "Looks like you got the case. There is a tracker. Wait until it's over then open the case with the key",
    },
    mailEnd = {
        ["sender"]                              = "Unknown",
        ["subject"]                             = "Case Collection",
        ["message"]                             = "Good job. Bring me the goods and make sure no cops are nearby.",
    },
    police = {
        ["alert"]                               = "Theft in progress (Tracker active): "
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
