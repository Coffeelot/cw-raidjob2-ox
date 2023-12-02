Config = {}

Config.Debug = false
Config.Enabled = true
Config.CleanupTimer = 20000

Config.UseTokens = false

Config.UseMZSkills = false
Config.Skill = 'Street Reputation'
Config.SkillAmount = 0

Config.UseRenewedPhoneGroups = true
Config.MaxGroupSize = 4 -- only used if UseRenewedPhoneGroups is true
Config.SpawnDistance = 400

Config.UseRenewedCrypto = false
Config.CryptoType = 'GDE'
Config.BossTalkTime = 2000

Config.Cooldown = 600 --- Cooldown until next allowed run (in seconds)
Config.DefaultValues = {
    armor = 30,
    accuracy = 60,
}

local lowLoc = {
    burroHeights = {
        name = 'burroHeights',
        coords = vector3(1455.68, -2592.61, 48.63),
        Guards = {
            { model = 'a_m_m_soucent_01', weapon = 'WEAPON_PISTOL' },
            { model = 'g_m_m_armlieut_01', weapon = 'WEAPON_SMG' },
            { model = 'g_m_importexport_01', weapon = 'WEAPON_PUMPSHOTGUN_MK2', accuracy = 5 },
            { model = 'g_m_importexport_01', weapon = 'WEAPON_APPISTOL', accuracy = 50 },
        },
        GuardPositions = {
            vector4(1455.68, -2592.61, 48.63, 308.67),
            vector4(1456.46, -2605.76, 48.54, 58.43),
            vector4(1457.92, -2622.27, 48.67, 359.41),
            vector4(1425.02, -2621.2, 47.29, 143.41),
            vector4(1437.89, -2587.03, 48.11, 105.84),
            vector4(1425.79, -2581.05, 47.98, 23.34),
            vector4(1437.89, -2591.51, 48.13, 67.2),
        },
        GuardCars = {
            { model = 'dominator8', coords = vector4(1440.42, -2610.3, 48.26, 167.29) },
            { model = 'rapidgt3', coords = vector4(1443.48, -2612.07, 48.32, 164.42) },
            { model = 'landstalker2', coords = vector4(1454.43, -2600.34, 48.46, 18.42) },
            { model = 'cavalcade', coords = vector4(1448.66, -2589.8, 48.27, 58.67) },
            { model = 'burrito', coords = vector4(1441.72, -2593.62, 48.0, 86.87) },
            { model = 'sultan', coords = vector4(1434.61, -2605.74, 47.96, 325.5) },
            { model = 'elegy2', coords = vector4(1433.41, -2593.35, 48.09, 137.91) },
            { model = 'jb7002', coords = vector4(1453.71, -2614.1, 48.53, 163.54) }
        },
        CasePositions = {
            vector3(1439.7, -2595.05, 47.17),
            vector3(1440.8, -2608.26, 48.19),
            vector3(1453.63, -2602.26, 47.46),
            vector3(1452.61, -2618.12, 47.54),
            vector3(1442.78, -2614.56, 47.33),
        }
    },
    sandyDesert = {
        name = 'sandyDesert',
        coords = vector3(2470.31, 3451.51, 49.83),
        Guards = {
            { model = 'a_m_m_soucent_01', weapon = 'WEAPON_PISTOL', },
            { model = 'g_m_m_armlieut_01', weapon = 'WEAPON_SMG' },
            { model = 'g_m_importexport_01', weapon = 'WEAPON_PUMPSHOTGUN_MK2', accuracy = 5 },
        },
        GuardPositions = {
            vector4(2470.31, 3451.51, 49.83, 30.78),
            vector4(2486.22, 3444.64, 51.07, 238.82),
            vector4(2485.66, 3447.15, 51.07, 10.14),
            vector4(2483.65, 3446.7, 51.07, 223.21),
            vector4(2486.95, 3446.1, 51.07, 271.15),
            vector4(2470.0, 3444.06, 49.95, 316.65),
            vector4(2483.16, 3449.77, 51.07, 43.09),
            vector4(2483.91, 3448.53, 51.07, 217.75)
        },
        GuardCars = {
            { model = 'ratloader', coords = vector4(2464.06, 3447.82, 49.77, 27.66) },
            { model = 'dune', coords = vector4(2459.66, 3449.5, 49.02, 229.02) }
         },
        CasePositions = {
            vector3(2473.03, 3442.45, 48.94),
            vector3(2471.13, 3440.62, 48.95),
            vector3(2479.1, 3441.87, 49.8),
            vector3(2488.43, 3445.33, 49.16),
            vector3(2486.09, 3444.26, 50.07),
            vector3(2476.58, 3448.51, 49.72),
        }
    },
    windFarm = {
        name = 'windFarm',
        coords = vector3(2101.46, 2331.92, 94.29),
        Guards = {
            { model = 'g_m_y_lost_01', weapon = 'WEAPON_PUMPSHOTGUN_MK2' },
            { model = 'g_m_y_lost_02', weapon = 'WEAPON_PISTOL' },
            { model = 'g_m_y_lost_03', weapon = 'WEAPON_MACHINEPISTOL', accuracy = 5 },
        },
        GuardPositions = {
            vector4(2101.46, 2331.92, 94.29, 91.23),
            vector4(2093.2, 2345.21, 94.29, 112.51),
            vector4(2112.93, 2347.26, 94.28, 305.5),
            vector4(2112.4, 2333.58, 94.28, 267.88),
            vector4(2112.26, 2309.86, 94.28, 190.62),
            vector4(2088.9, 2312.1, 94.29, 110.07),
            vector4(2094.43, 2320.3, 94.29, 210.42),
            vector4(2092.98, 2325.9, 94.29, 75.52),
            vector4(2102.97, 2326.06, 94.29, 271.86),
        },
        GuardCars = {
            { model = 'ratloader2', coords = vector4(2082.53, 2343.54, 93.43, 228.78) },
            { model = 'gburrito', coords = vector4(2080.72, 2321.15, 93.93, 151.73) }
         },
        CasePositions = {
            vector3(2105.57, 2324.87, 93.29),
            vector3(2106.5, 2335.82, 93.32),
            vector3(2100.87, 2342.57, 93.29),
            vector3(2098.33, 2325.94, 93.29),
            vector3(2094.94, 2327.1, 93.38),
            vector3(2093.95, 2320.7, 93.29),
            vector3(2108.31, 2320.22, 93.39),
            vector3(2103.11, 2342.92, 93.29),
        }
    },
    stabCity= {
        name = 'stabCity',
        coords = vector3(57.85, 3714.48, 39.75),
        Guards = {
            { model = 'g_m_y_lost_01', weapon = 'WEAPON_PUMPSHOTGUN_MK2' },
            { model = 'g_m_y_lost_02', weapon = 'WEAPON_PISTOL' },
            { model = 'g_f_y_lost_01', weapon = 'WEAPON_PISTOL_MK2' },
            { model = 'g_m_y_lost_03', weapon = 'WEAPON_MACHINEPISTOL', accuracy = 5 },
        },
        GuardPositions = {
            vector4(71.22, 3701.36, 39.75, 77.72),
            vector4(79.09, 3707.85, 41.08, 55.63),
            vector4(84.39, 3720.98, 39.74, 313.18),
            vector4(75.1, 3725.95, 39.73, 87.79),
            vector4(57.54, 3725.29, 39.72, 171.93),
            vector4(54.86, 3724.28, 39.71, 190.04),
            vector4(45.4, 3719.58, 39.69, 280.37),
            vector4(46.04, 3704.8, 39.76, 324.24),
            vector4(65.31, 3710.84, 39.75, 336.34)

        },
        GuardCars = {
            { model = 'gburrito', coords = vector4(59.15, 3703.93, 39.57, 20.73) },
            { model = 'slamvan2', coords = vector4(67.15, 3722.95, 39.55, 309.42) },
            { model = 'daemon', coords = vector4(55.01, 3721.63, 39.22, 166.31) },
            { model = 'daemon', coords = vector4(48.59, 3717.84, 39.21, 227.84) },
            { model = 'daemon', coords = vector4(61.81, 3711.45, 39.23, 9.75) },
         },
        CasePositions = {
            vector3(63.6, 3713.31, 40.0),
            vector3(66.55, 3713.76, 39.15),
            vector3(66.43, 3711.66, 39.34),
            vector3(62.96, 3707.13, 39.09),
            vector3(67.57, 3704.71, 39.56),
            vector3(76.32, 3708.75, 39.7),

        }
    },
    hippyVillage = {
        name = 'hippyVillage',
        coords = vector3(2337.59, 2546.38, 47.72),
        Guards = {
            { model = 'a_m_y_hippy_01', weapon = 'WEAPON_PUMPSHOTGUN_MK2' },
            { model = 'a_f_y_hippie_01', weapon = 'WEAPON_PISTOL_MK2' },
            { model = 'a_m_o_acult_01', weapon = 'WEAPON_PISTOL' },
            { model = 'u_m_y_hippie_01', weapon = 'WEAPON_MACHINEPISTOL', accuracy = 5 },
        },
        GuardPositions = {
            vector4(2343.24, 2534.84, 46.57, 58.5),
            vector4(2346.92, 2541.96, 46.67, 23.07),
            vector4(2359.04, 2548.46, 47.17, 85.01),
            vector4(2339.6, 2550.34, 46.67, 86.5),
            vector4(2322.74, 2533.52, 46.52, 331.85),
            vector4(2320.54, 2542.84, 46.67, 329.68),
            vector4(2324.68, 2562.22, 46.67, 221.9),
            vector4(2334.69, 2553.04, 46.67, 319.31),
            vector4(2340.84, 2553.5, 46.67, 350.14)

        },
        GuardCars = {
            { model = 'youga2', coords = vector4(2338.98, 2532.62, 46.56, 358.08) },
            { model = 'youga', coords = vector4(2327.08, 2559.5, 46.63, 219.78) },
            { model = 'journey', coords = vector4(2351.01, 2532.57, 46.04, 70.3) },
         },
        CasePositions = {
            vector3(2340.07, 2553.59, 46.41),
            vector3(2331.63, 2561.36, 45.68),
            vector3(2335.71, 2548.94, 45.67),
            vector3(2322.49, 2543.36, 45.67),
            vector3(2315.86, 2550.56, 45.67),
        }
    },
    cultHome = {
        name = 'cultHome',
        coords = vector3(-1150.57, 4924.01, 221.4),
        Guards = {
            { model = 'a_m_m_acult_01', weapon = 'WEAPON_PUMPSHOTGUN_MK2' },
            { model = 'a_f_m_fatcult_01', weapon = 'WEAPON_PISTOL' },
            { model = 'a_m_y_acult_02', weapon = 'WEAPON_MACHINEPISTOL', accuracy = 5 },
        },
        GuardPositions = {
            vector4(-1134.38, 4930.64, 219.91, 150.41),
            vector4(-1141.51, 4912.86, 220.97, 25.64),
            vector4(-1157.46, 4918.93, 221.75, 345.28),
            vector4(-1170.63, 4926.76, 224.31, 88.52),
            vector4(-1166.62, 4929.09, 223.2, 184.91),
            vector4(-1146.91, 4938.87, 222.27, 163.26),
            vector4(-1142.94, 4933.65, 220.77, 171.76),

        },
        GuardCars = {
            { model = 'ratloader', coords = vector4(-1135.13, 4917.48, 219.07, 357.49) },
            { model = 'beatertulip', coords = vector4(-1156.71, 4913.8, 219.93, 328.04) },
            { model = 'emperor2', coords = vector4(-1125.71, 4936.78, 218.43, 206.85) }
         },
        CasePositions = {
            vector3(-1162.92, 4927.56, 222.67),
            vector3(-1147.86, 4914.8, 219.86),
            vector3(-1147.52, 4940.51, 222.44),
            vector3(-1166.55, 4926.02, 222.03),
            vector3(-1159.53, 4920.99, 221.66),
        }
    },
    cliffGarage = {
        name = 'cliffGarage',
        coords = vector3(-1991.17, -308.75, 44.11),
        Guards = {
            { model = 'g_m_y_ballaeast_01', weapon = 'WEAPON_PUMPSHOTGUN_MK2' },
            { model = 'g_m_y_ballaorig_01', weapon = 'WEAPON_PISTOL' },
            { model = 'g_m_y_famdnf_01', weapon = 'WEAPON_PISTOL_MK2' },
            { model = 'g_m_y_famca_01', weapon = 'WEAPON_MACHINEPISTOL', accuracy = 5 },
        },
        GuardPositions = {
            vector4(-1999.4, -309.29, 44.11, 225.63),
            vector4(-1992.45, -318.21, 44.11, 35.34),
            vector4(-2003.76, -315.29, 44.11, 258.65),
            vector4(-2004.27, -320.21, 44.11, 277.4),
            vector4(-1997.23, -326.92, 44.11, 3.11),
            vector4(-1991.08, -322.96, 44.11, 35.88),
            vector4(-1987.12, -318.82, 44.11, 54.43),
            vector4(-1972.5, -287.76, 44.11, 328.39),
            vector4(-1983.07, -282.98, 44.11, 183.82)


        },
        GuardCars = {
            { model = 'voodoo', coords = vector4(-1990.7, -311.34, 43.55, 238.67) },
            { model = 'greenwood', coords = vector4(-1997.15, -307.64, 43.56, 233.4) },
            { model = 'broadway', coords = vector4(-1994.84, -323.61, 43.43, 11.07) },
            { model = 'blade', coords = vector4(-2003.07, -318.03, 43.54, 261.95) }

         },
        CasePositions = {
            vector3(-1995.63, -308.99, 43.97),
            vector3(-2001.3, -318.26, 44.18),
            vector3(-2000.45, -318.56, 43.11),
            vector3(-1995.95, -321.04, 43.11),
            vector3(-2001.11, -311.27, 43.11),
            vector3(-1991.32, -318.84, 43.11),
            vector3(-1997.2, -318.99, 43.11)
        }
    },
}

local midLoc = {
    docks = {
        name = 'docks',
        coords = vector3(1239.43, -2944.41, 8.32),
        Guards = {
            { model = 'g_m_m_armgoon_01', weapon = 'WEAPON_PISTOL', accuracy = 5 },
            { model = 'g_m_m_armgoon_01', weapon = 'WEAPON_PISTOL', accuracy = 5 },
            { model = 'g_m_m_armlieut_01', weapon = 'WEAPON_MICROSMG', accuracy = 1 },
            { model = 'g_m_m_armboss_01', weapon = 'WEAPON_HEAVYPISTOL', accuracy = 10 },
        },
        GuardPositions = {
            vector4(1228.3, -2959.73, 12.18, 86.21),
            vector4(1228.37, -2963.74, 12.18, 88.69),
            vector4(1227.31, -2934.02, 9.32, 171.56),
            vector4(1227.18, -2935.75, 9.32, 11.75),
            vector4(1204.38, -2942.83, 5.89, 106.86),
            vector4(1221.36, -2952.69, 5.87, 130.62),
            vector4(1223.08, -2970.03, 5.87, 33.35),
            vector4(1227.38, -2983.06, 9.32, 46.26),
            vector4(1227.0, -2967.29, 9.32, 85.89)
        },
        GuardCars = {
            { model = 'cavalcade', coords = vector4(1219.49, -2955.24, 5.68, 303.25) },
            { model = 'cavalcade', coords = vector4(1213.39, -2956.42, 5.68, 236.51) },
            { model = 'baller', coords = vector4(1218.35, -2936.82, 5.84, 33.78) },
            { model = 'cog55', coords = vector4(1212.91, -2937.16, 5.84, 213.91) },
        },
        CasePositions = {
            vector3(1227.41, -2944.39, 9.31),
            vector3(1227.21, -2970.31, 9.29),
            vector3(1227.3, -2986.29, 9.32),
            vector3(1227.24, -2999.08, 9.29),
            vector3(1227.87, -3007.4, 9.25),
            vector3(1242.15, -2949.3, 8.91),
            vector3(1228.32, -2956.67, 11.19),
        }
    },
    ogmeth = {
        name = 'ogmeth',
        coords = vector3(3813.02, 4462.52, 4.08),
        Guards = {
            { model = 'g_m_y_lost_01', weapon = 'WEAPON_PUMPSHOTGUN_MK2', },
            { model = 'g_m_y_lost_02', weapon = 'WEAPON_SMG' },
            { model = 'g_m_y_lost_03', weapon = 'WEAPON_PISTOL50', accuracy = 5 },
            { model = 'g_m_y_lost_02', weapon = 'WEAPON_SMG' },
            { model = 'g_m_y_lost_03', weapon = 'WEAPON_MACHINEPISTOL', accuracy = 5 },
        },
        GuardPositions = {
            vector4(3801.4, 4474.58, 5.99, 122.4),
            vector4(3797.37, 4478.01, 5.99, 120.72),
            vector4(3808.2, 4477.65, 5.99, 203.02),
            vector4(3820.34, 4483.36, 5.99, 247.86),
            vector4(3819.53, 4470.82, 5.78, 137.56),
            vector4(3837.09, 4462.28, 2.65, 26.16),
            vector4(3820.03, 4451.96, 5.27, 49.67),
            vector4(3801.47, 4446.92, 4.23, 18.61),
            vector4(3792.14, 4453.03, 5.06, 48.72)
        },
        GuardCars = {
            { model = 'gburrito', coords = vector4(3791.62, 4463.33, 5.52, 171.5) },
            { model = 'ratloader', coords = vector4(3799.85, 4458.75, 4.06, 249.94) },
            { model = 'slamvan', coords = vector4(3818.29, 4460.94, 3.39, 325.08) },
            { model = 'paradise', coords = vector4(3815.48, 4466.15, 3.43, 55.41) },
        },
        CasePositions = {
            vector3(3818.01, 4474.57, 3.15),
            vector3(3828.08, 4481.5, 2.83),
            vector3(3827.94, 4470.56, 3.01),
            vector3(3830.3, 4473.03, 3.01),
            vector3(3821.19, 4460.02, 2.58),
            vector3(3825.78, 4474.69, 5.18),
            vector3(3824.56, 4450.58, 3.65),
            vector3(3817.74, 4464.29, 2.74),
        }
    },
}

local highLoc = {
    lafuenta = {
         name = 'lafuenta',
         coords = vector3(1388.11, 1136.84, 114.3),
         Guards = {
             { model = 'cs_manuel', weapon = 'WEAPON_PISTOL50', coords = vector4(1420.13, 1151.03, 114.67, 252.27)},
             { model = 'g_m_y_mexgang_01', weapon = 'WEAPON_MACHINEPISTOL' },
             { model = 'g_m_y_mexgang_01', weapon = 'WEAPON_PISTOL' },
             { model = 'g_m_y_mexgang_01', weapon = 'WEAPON_SMG' },
             { model = 'g_m_y_mexgang_01', weapon = 'WEAPON_PUMPSHOTGUN_MK2' },
             { model = 'g_m_y_mexgang_01', weapon = 'WEAPON_SMG' },
         },
         GuardPositions = {
             vector4(1381.07, 1149.81, 114.33, 87.54),
             vector4(1386.84, 1126.88, 114.33, 89.23),
             vector4(1414.17, 1138.47, 114.33, 278.73),
             vector4(1430.9, 1125.33, 114.27, 243.4),
             vector4(1427.85, 1175.72, 114.09, 326.71),
             vector4(1387.27, 1176.44, 114.38, 102.63),
             vector4(1391.82, 1154.31, 114.44, 101.95),
             vector4(1398.65, 1122.17, 114.84, 169.99),
             vector4(1401.89, 1122.27, 114.84, 177.42),
             vector4(1409.85, 1131.96, 114.33, 275.09),
             vector4(1409.08, 1160.04, 114.33, 271.73)
         },
         GuardCars = {
             { model = 'baller4', coords = vector4(1335.64, 1137.98, 110.81, 99.93) },
             { model = 'baller4', coords = vector4(1337.75, 1149.41, 112.36, 167.32) }
         },
         CasePositions = {
             vector3(1416.75, 1144.57, 114.26),
             vector3(1413.48, 1149.45, 114.16),
             vector3(1414.94, 1162.04, 114.6),
             vector3(1415.09, 1166.34, 114.6),
             vector3(1419.58, 1132.47, 113.4),
         }
    },
    lakevinewood = {
        name = 'lakevinewood',
        coords = vector3(-83.57, 958.0, 231.49),
        Guards = {
            { model = 'g_m_m_mexboss_02', weapon = 'WEAPON_PUMPSHOTGUN' },
            { model = 'g_m_m_mexboss_02', weapon = 'WEAPON_APPISTOL' },
            { model = 'g_m_y_armgoon_02', weapon = 'WEAPON_PISTOL50' },
            { model = 'g_m_y_armgoon_02', weapon = 'WEAPON_SMG' },
            { model = 'g_m_y_armgoon_02', weapon = 'WEAPON_PUMPSHOTGUN_MK2' },
            { model = 'g_m_y_armgoon_02', weapon = 'WEAPON_MACHINEPISTOL', accuracy = 5 },
        },
        GuardPositions = {
            vector4(-113.27, 983.92, 235.76, 108.41),
            vector4(-105.51, 974.53, 235.76, 200.63),
            vector4(-102.46, 975.78, 235.76, 199.94),
            vector4(-91.7, 944.77, 233.03, 338.29),
            vector4(-83.68, 944.54, 233.03, 40.37),
            vector4(-103.18, 1011.38, 235.76, 103.97),
            vector4(-97.14, 1017.25, 235.82, 289.04),
            vector4(-99.28, 975.88, 235.76, 194.21),
            vector4(-94.41, 964.25, 232.81, 81.4),
            vector4(-98.62, 952.28, 232.81, 345.5),
            vector4(-75.37, 940.4, 232.81, 353.36),
            vector4(-84.16, 941.73, 233.03, 91.99),
            vector4(-91.07, 942.47, 233.03, 188.21)
        },
        GuardCars = {
            { model = 'landstalker2', coords = vector4(-136.02, 977.28, 235.27, 219.36) },
            { model = 'landstalker2', coords = vector4(-129.89, 978.94, 235.25, 147.02) },
            { model = 'entityxf', coords = vector4(-123.52, 1007.19, 235.13, 200.9) }
        },
        CasePositions = {
            vector3(-81.94, 944.58, 232.03),
            vector3(-87.51, 939.06, 232.45),
            vector3(-89.69, 940.13, 232.46),
            vector3(-100.77, 944.03, 233.28),
            vector3(-71.86, 966.04, 232.2),
            vector3(-83.07, 967.3, 232.24),
        }
    },
    lakevinewood2 = {
        name = 'lakevinewood2',
        coords = vector3(-156.61, 883.19, 232.46),
        Guards = {
            { model = 'mp_m_securoguard_01', weapon = 'WEAPON_PISTOL' },
            { model = 'mp_m_securoguard_01', weapon = 'WEAPON_SMG' },
            { model = 'mp_m_securoguard_01', weapon = 'WEAPON_PUMPSHOTGUN_MK2' },
            { model = 'mp_m_securoguard_01', weapon = 'WEAPON_SMG' },
            { model = 'mp_m_securoguard_01', weapon = 'WEAPON_PISTOL50' },
        },
        GuardPositions = {
            vector4(-135.76, 899.35, 235.66, 283.48),
            vector4(-139.0, 881.63, 233.48, 133.12),
            vector4(-156.64, 858.4, 232.23, 312.35),
            vector4(-143.41, 868.75, 232.7, 117.22),
            vector4(-152.87, 911.94, 235.66, 16.73),
            vector4(-139.17, 868.74, 232.7, 165.32),
            vector4(-148.29, 881.29, 239.02, 181.17),
            vector4(-143.51, 884.97, 239.02, 295.21),
            vector4(-181.85, 883.65, 233.46, 111.9),
            vector4(-182.27, 851.97, 232.7, 312.59),
            vector4(-148.25, 880.31, 239.02, 189.06),
            vector4(-170.82, 889.88, 237.14, 140.57),
        },
        GuardCars = {
            { model = 'baller4', coords = vector4(-141.67, 910.2, 235.8, 243.79) },
            { model = 'granger', coords = vector4(-120.49, 910.81, 235.43, 19.1) }
        },
        CasePositions = {
            vector3(-156.47, 883.21, 232.46),
            vector3(-160.4, 879.45, 232.14),
            vector3(-137.59, 869.99, 232.45),
            vector3(-171.53, 857.15, 232.04),
            vector3(-179.45, 878.35, 232.46),
            vector3(-165.83, 886.73, 236.14),
            vector3(-157.39, 879.11, 236.77),
        }
    },
    butcher = { -- MADE BY x58k#7833
        name = 'butcher',
        coords = vector3(-104.81, 6202.87, 31.03),
        Guards = {
            { model = 's_m_m_linecook', weapon = 'WEAPON_PISTOL', accuracy = 5 },
            { model = 's_f_y_factory_01', weapon = 'WEAPON_PISTOL50', accuracy = 5 },
            { model = 's_m_y_factory_01', weapon = 'WEAPON_PUMPSHOTGUN_MK2', accuracy = 5 },
            { model = 's_f_y_factory_01', weapon = 'WEAPON_SMG', accuracy = 1 },
            { model = 's_m_y_factory_01', weapon = 'WEAPON_HEAVYPISTOL', accuracy = 10 },
        },
        GuardPositions = {
            vector4(-97.83, 6209.5, 31.03, 315.65),
            vector4(-79.51, 6220.15, 31.09, 302.15),
            vector4(-88.32, 6237.05, 31.09, 240.14),
            vector4(-67.85, 6242.73, 31.08, 305.97),
            vector4(-68.74, 6254.76, 31.09, 191.24),
            vector4(-115.88, 6179.85, 31.02, 132.97),
            vector4(-133.22, 6162.08, 31.02, 131.32),
            vector4(-152.25, 6153.47, 31.21, 130.59),
            vector4(-149.3, 6144.9, 32.34, 239.12)
        },
        GuardCars = {
            { model = 'cavalcade', coords = vector4(-128.89, 6148.29, 31.33, 295.18) },
            { model = 'cavalcade', coords = vector4(-151.55, 6125.54, 31.39, 149.78) },
            { model = 'baller', coords = vector4(-79.29, 6272.63, 31.38, 93.53) },
            { model = 'bison', coords = vector4(-76.02, 6276.57, 31.43, 19.61) },
        },
        CasePositions = {
            vector3(-114.73, 6200.85, 30.03),
            vector3(-106.39, 6196.85, 30.28),
            vector3(-110.3, 6199.88, 30.28),
            vector3(-101.62, 6214.28, 30.21),
            vector3(-94.43, 6216.9, 30.28),
            vector3(-101.94, 6193.03, 30.53),
            vector3(-106.23, 6192.65, 30.53),
        }
    },
}

Config.Locations = {
    low = lowLoc,
    mid = midLoc,
    high = highLoc
}

Config.Items = {
    key = 'cw_raidjob_key',
    caseItem = 'cw_raidjob_case',
    caseProp = 'prop_idol_case_02',
    caseContent = 'cw_raidjob_content',
}

local lowJob = {
    paymentType = 'cash', -- what type of payment to enter, can be cash, band or crypto
    paymentItem = "smallnote", -- ONLY used if you choose to trade an item to start mission.
    runCost = 500, -- cost to take run
    payoutType = 'cash', -- type of payment, can be cash, bank or crypto
    payout = math.random(1900, 2100), -- how much money you get
    copBonus = 100,
    lowTime = 15000,
    highTime = 60000,
    token = 'raidlow',
    description = 'Get Information.',
    minimumPolice = 1,
    minLimit = 175, -- used for mz-skill check if enabled
    icon = 'fas fa-skull',
    Minigame = {
        game = 'Circle',
        variables = { 5, 20 }
    },
    Messages = {
        Start = {
            sender = '?',
            subject = 'For sure legal stuff',
            message = "Go to the location and do the deed"
        },
        Aquired = {
            sender = '?',
            subject = 'For sure legal stuff',
            message = "Looks like you got the case. It's got a tracker on it. It'll stop soon. I'll send you a text when it's open. Don't show up here until you got the goods and cops are off your tail!"
        },
        Finish = {
            sender = '?',
            subject = 'For sure legal stuff',
            message = "Good shit. Now unlock it with the key and bring the goods here when 5-0 is off your back"
        },
    },
    Boss = {
        coords = vector4(2546.04, 382.09, 108.61, 88.68),
        model = 'g_f_importexport_01',
        animation = 'WORLD_HUMAN_SMOKING_POT', -- OPTIONAL https://pastebin.com/6mrYTdQv
    },
    Rewards = {
        { item = 'cokebaggy', amount = math.random(1, 5), chance = 10 },
        { item = '10kgoldchain', amount = 1, chance = 20 }
    }
}

local midJob = {
    paymentType = 'cash', -- what type of payment to enter, can be cash, band or crypto
    runCost = 5000, -- cost to take run
    payoutType = 'cash', -- type of payment, can be cash, bank or crypto
    payout = math.random(10000,15000), -- how much money you get
    copBonus = 200,
    lowTime = 30000,
    highTime = 60000,
    token = 'raidmid',
    description = 'Raidjob2 for not as poor people',
    minimumPolice = 3,
    minLimit = 1000, -- used for mz-skill check if enabled
    icon = 'fas fa-skull',
    Minigame = {
        game = 'Circle',
        variables = { 3 , 20 }
    },
    Messages = {
        Start = {
            sender = '?',
            subject = 'For sure legal stuff',
            message = "Go to the location and do the deed"
        },
        Aquired = {
            sender = '?',
            subject = 'For sure legal stuff',
            message = "Looks like you got the case. It's got a tracker on it. It'll stop soon. I'll send you a text when it's open. Don't show up here until you got the goods and cops are off your tail!"
        },
        Finish = {
            sender = '?',
            subject = 'For sure legal stuff',
            message = "Good shit. Now unlock it with the key and bring the goods here when 5-0 is off your back"
        },
    },
    Boss = {
        coords = vector4(-903.84, -363.97, 130.28, 27.2),
        model = 'g_m_m_armlieut_01',
        missionTitle = "Accept weed raid",
        animation = 'WORLD_HUMAN_HANG_OUT_STREET', -- OPTIONAL https://pastebin.com/6mrYTdQv
    },
    Rewards = {
        { item = 'cokebaggy', amount = math.random(1, 5), chance = 10 },
        { item = '10kgoldchain', amount = 1, chance = 20 }
    }
}
local highJob = {
    paymentType = 'cash', -- what type of payment to enter, can be cash, band or crypto
    runCost = 10000, -- cost to take run
    payoutType = 'cash', -- type of payment, can be cash, bank or crypto
    payout = math.random(18000,24000), -- how much money you get
    copBonus = 300,
    lowTime = 30000,
    highTime = 60000,
    token = 'raidhigh',
    description = 'Raidjob2 for not as poor people',
    minimumPolice = 5,
    minLimit = 1000, -- used for mz-skill check if enabled
    icon = 'fas fa-skull',
    Minigame = {
        game = 'Circle',
        variables = { 3 , 20 }
    },
    Messages = {
        Start = {
            sender = '?',
            subject = 'For sure legal stuff',
            message = "Go to the location and do the deed"
        },
        Aquired = {
            sender = '?',
            subject = 'For sure legal stuff',
            message = "Looks like you got the case. It's got a tracker on it. It'll stop soon. I'll send you a text when it's open. Don't show up here until you got the goods and cops are off your tail!"
        },
        Finish = {
            sender = '?',
            subject = 'For sure legal stuff',
            message = "Good shit. Now unlock it with the key and bring the goods here when 5-0 is off your back"
        },
    },
    Boss = {
        coords = vector4(-902.6, -363.26, 130.28, 7.22),
        model = 'g_m_y_korlieut_01',
        missionTitle = "Accept weed raid",
        animation = 'WORLD_HUMAN_HANG_OUT_STREET', -- OPTIONAL https://pastebin.com/6mrYTdQv
    },
    Rewards = {
        { item = 'cokebaggy', amount = math.random(1, 5), chance = 10 },
        { item = '10kgoldchain', amount = 1, chance = 20 }
    }
}

Config.Jobs = {
    low = lowJob,
    mid = midJob,
    high = highJob
}