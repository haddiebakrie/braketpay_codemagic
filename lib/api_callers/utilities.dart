List mtn_data_plan = ["500", "M1024", "M2024", "3000", "5000", "10000", "mtn-20hrs-1500","mtn-30gb-8000", "mtn-40gb-10000", "mtn-75gb-15000"];
List glo_data_plan = ["glo100x","glo200x","G500", "G2000", "G1000", "G2500","G3000", "G4000", "G5000", "G8000", "glo10000"];
List airtel_data_plan = ["airt-500", "airt-300x", "airt-500x","airt-1200","airt-1500-2","AIR1000", "Air1500", "AIR2000", "Air3000", "Air5000", "Air100000"];
List nine_mobile_data_plan = ["9MOB1000", "9MOB34500", "9MOB8000", "9MOB5000"];

Map<String, dynamic> data_plan_rate = {"Network": {
                    "mtn":{
                        "500":{"third_party_price": 149.0, "braket_charges": 151.0, "total_price":300.0, "about":"500 = MTN Data 500MB (SME) - 30 Days"}, 
                        "M1024":{"third_party_price": 249.0, "braket_charges": 251.0, "total_price": 500.0, "about":"M1024 = MTN Data 1GB (SME) - 30 Days"},
                        "M2024":{"third_party_price": 499.0, "braket_charges": 501.0, "total_price": 1000.0, "about":"M2024 = MTN Data 2GB (SME) - 30 Days"},
                        "3000":{"third_party_price": 749.0, "braket_charges": 451.0, "total_price":1200.0, "about":"3000 = MTN Data 3GB (SME) - 30 Days"}, 

                        "5000":{"third_party_price": 1249.0, "braket_charges": 251.0, "total_price": 1500.0, "about":"5000 = MTN Data 5GB (SME) - 30 Days"},
                        "mtn-20hrs-1500":{"third_party_price": 1489.0, "braket_charges": 211.0, "total_price": 1700.0, "about":"mtn-20hrs-1500 = MTN Data 6GB - 7 Days"},
                        "10000":{"third_party_price": 2499.0, "braket_charges": 701, "total_price": 3200.0, "about":"=MTN SME Data 10GB - 30 Days"},
                        "mtn-30gb-8000 ":{"third_party_price": 7899.0, "braket_charges": 101.0, "total_price": 8000.0, "about":"mtn-30gb-8000 = MTN Data 30GB - 30 Days"},
                        "mtn-40gb-10000 ":{"third_party_price": 9859.0, "braket_charges": 141.0, "total_price": 10000.0, "about":"mtn-40gb-10000 = MTN Data 40GB - 30 Days"},
                        "mtn-75gb-150000 ":{"third_party_price": 14899.0, "braket_charges": 101.0, "total_price": 15000.0, "about":"mtn-75gb-15000 = MTN Data 75GB - 30 Days"}},
                      "glo":{
                            "glo100x":{"third_party_price":98.0 , "braket_charges": 2.0, "total_price": 100.0, "about":"=Glo Data 1GB - 5 Nights"}, 
                            "glo200x":{"third_party_price": 198.0, "braket_charges": 2.0, "total_price": 200.0, "about":"glo200x = Glo Data 1.25GB - 1 Day (Sunday)"},
                            "G500":{"third_party_price": 485.0, "braket_charges": 15.0, "total_price": 500.0, "about":"G500 = Glo Data 1.35GB - 14 Days"},
                            "G1000":{"third_party_price": 969.0, "braket_charges": 231.0, "total_price": 1200, "about":"G1000 = Glo Data 2.9GB - 30 Days"},
                            "G2000":{"third_party_price": 1939.0, "braket_charges": 561.0, "total_price": 2500.0, "about":"G2000 = Glo Data 5.8GB - 30 Days"}, 
                            "G2500":{"third_party_price": 2439.0, "braket_charges": 561.0, "total_price": 3000.0, "about": "G2500 = Glo Data 7.7GB - 30 Days"},
                            "G3000":{"third_party_price": 2939.0, "braket_charges": 561.0, "total_price": 3500.0, "about":"G3000 = Glo Data 10GB - 30 Days"},
                            "G4000":{"third_party_price": 3879.0, "braket_charges": 121.0, "total_price": 4000.0, "about":"G4000 = Glo Data 13.25GB - 30 Days"},
                            "G5000":{"third_party_price": 4839.0, "braket_charges": 161.0, "total_price": 5000.0, "about":"G5000 = Glo Data 18.25GB - 30 Days"},
                            "G8000":{"third_party_price": 7779.0, "braket_charges": 221.0, "total_price": 8000.0, "about":"G8000 = Glo Data 29.5GB - 30 Days"},
                            "glo10000":{"third_party_price": 9859.0, "braket_charges": 141.0, "total_price": 10000.0, "about":"glo10000 = Glo Data 50GB - 30 Days"},
                            },

                      "airtel":{
                            "airt-500":{"third_party_price": 499.0, "braket_charges": 101.0, "total_price":600.0, "about":"=Airtel Data 750MB - 14 Days"}, 
                            "airt-300x":{"third_party_price": 299.0, "braket_charges": 51.0, "total_price": 350.0, "about":"airt-300x = Airtel Data 1GB - 1 Day"},
                            "airt-500x":{"third_party_price": 499.0, "braket_charges": 99.0, "total_price": 600.0, "about":"airt-500x = Airtel Data 2GB - 2 Days"},
                            "airt-1200":{"third_party_price": 1189.0, "braket_charges": 111.0, "total_price": 1300.0, "about":"airt-1200 = Airtel Data 2GB - 30 Days"},
                            "Air1500":{"third_party_price": 1489.0, "braket_charges": 11.0, "total_price": 1500.0, "about":"Air1500 = Airtel Data 3GB - 30 Days"},
                            "airt-1500-2":{"third_party_price": 1489.0, "braket_charges": 11.0, "total_price": 1500.0, "about":"airt-1500-2 = Airtel Data 6GB - 7 Days"},
                            "Air3000":{"third_party_price": 2959.0, "braket_charges": 241.0, "total_price": 3200.0, "about":"Air3000 = Airtel Data 10GB - 30 Days"},
                            "Air5000":{"third_party_price": 4899.0, "braket_charges": 101.0, "total_price": 5000.0, "about":"Air5000 = Airtel Data 20GB - 30 Days"},
                            "Air100000 ":{"third_party_price": 9799.0, "braket_charges": 201.0, "total_price": 10000.0, "about":"Air100000 = Airtel Data 40GB - 30 Days"},
                            "AIR1000":{"third_party_price": 969.0, "braket_charges": 31.0, "total_price": 10000.0, "about":"AIR1000 = Airtel Data 1.5GB - 30 Days"},
                            "AIR2000":{"third_party_price": 1939.0, "braket_charges": 61.0, "total_price": 20000.0, "about":"AIR2000 = Airtel Data 4.5GB - 30 Days"}},
                            
                      "etisalat":{
                                "9MOB1000":{"third_party_price": 979.0, "braket_charges": 21.0, "total_price":1000.0, "about":"9MOB1000 = 9mobile Data 1GB - 30 Days"}, 
                                "9MOB34500":{"third_party_price": 1979.0, "braket_charges": 221.0, "total_price": 2200.0,"about":"9MOB34500 = 9mobile Data 2.5GB - 30 Days"},
                                "9MOB8000":{"third_party_price": 7899.0, "braket_charges": 101.0, "total_price": 8000.0, "about":"9MOB8000 = 9mobile Data 11.5GB - 30 Days"}, 
                                "9MOB5000":{"third_party_price": 9859.0, "braket_charges": 141.0, "total_price": 10000.0, "about":"9MOB5000 = 9mobile Data 15GB - 30 Days"}}

                     }};



List dstv_plan_list = [
                    "dstv-padi","dstv-yanga","dstv-confam","dstv6","dstv79","dstv7","dstv3","dstv10","dstv9","confam-extra","yanga-extra","padi-extra",
                    "com-asia","dstv30","com-frenchtouch","dstv33","dstv40","com-frenchtouch-extra","com-asia-extra","dstv43","complus-frenchtouch",
                    "dstv45","complus-french-extraview","dstv47","dstv48","dstv61","dstv62","hdpvr-access-service","frenchplus-addon","asia-addon",
                    "frenchtouch-addon","extraview-access","french11"];

List gotv_plan_list = ["gotv-smallie","gotv-jinja","gotv-jolli","gotv-max","gotv-supa"];
List startime_plan_list = ["nova","basic","smart","classic","super"];


Map<String, dynamic> cable_tv_plan_rate = {"Cable_TV": {
                        "dstv":{
                                "dstv-padi":{"third_party_price": 2128.5, "braket_charges": 21.5, "total_price":2150.0, "about":"dstv-padi = DStv Padi"}, 
                                "dstv-yanga":{"third_party_price": 2920.5, "braket_charges": 29.5, "total_price": 2950.0, "about":"dstv-yanga = DStv Yanga"},
                                "dstv-confam":{"third_party_price": 5247.0, "braket_charges": 53.0, "total_price": 5300.0, "about":"dstv-confam = DStv Confam"},
                                "dstv6":{"third_party_price": 7029.0, "braket_charges": 71.0, "total_price": 7100.0, "about":"dstv6 = DStv Asia"},
                                "dstv79":{"third_party_price": 8910.0, "braket_charges": 90.0, "total_price": 9000.0, "about":"dstv79 = DStv Compact"},
                                "dstv7":{"third_party_price": 14107.5, "braket_charges": 142.5, "total_price": 14250.0, "about":"dstv7 = DStv Compact Plus"},
                                "dstv3":{"third_party_price": 20790.0, "braket_charges": 210.0, "total_price": 21000.0, "about":"dstv3 = DStv Premium"},
                                "dstv10":{"third_party_price": 23265.0, "braket_charges": 235.0, "total_price":23500.0, "about":"dstv10 = DStv Premium Asia"},
                                "dstv9":{"third_party_price": 29007.0, "braket_charges": 293.0, "total_price": 29300.0, "about":"dstv9 = DStv Premium-French"},
                                "confam-extra":{"third_party_price": 8118.0, "braket_charges": 82.0, "total_price": 8200.0, "about":"confam-extra = DStv Confam + ExtraViewa"},
                                "yanga-extra ":{"third_party_price": 5265.0, "braket_charges": 58.5, "total_price": 5850.0, "about":"yanga-extra = DStv Yanga + ExtraView"},
                                "padi-extra ":{"third_party_price": 4999.5, "braket_charges": 50.5, "total_price": 5050.0, "about":"padi-extra = DStv Padi + ExtraView"},
                                "com-asia":{"third_party_price": 15939.0, "braket_charges": 161.0, "total_price": 16100.0, "about":"com-asia = DStv Compact + Asia"},
                                "dstv30":{"third_party_price": 11781.0, "braket_charges": 119.0, "total_price": 11900.0, "about":"dstv30 = DStv Compact + Extra View"},
                                "com-frenchtouch ":{"third_party_price": 11533.5, "braket_charges": 116.5, "total_price": 11650.0, "about":"com-frenchtouch = DStv Compact + French Touch"},
                                "dstv33":{"third_party_price": 23661.0, "braket_charges": 239.0, "total_price": 23900.0, "about":"dstv33 = DStv Premium - Extra View"},
                                "dstv40":{"third_party_price": 21118.5, "braket_charges": 213.5, "total_price": 21350.0, "about":"dstv40 = DStv Compact Plus - Asia"},
                                "com-frenchtouch-extra":{"third_party_price": 14404.5, "braket_charges": 145.5, "total_price": 14550.0, "about":"com-frenchtouch-extra = DStv Compact + French Touch + ExtraView"},
                                "com-asia-extra":{"third_party_price": 18810.0, "braket_charges": 190.0, "total_price": 19000.0, "about":"com-asia-extra = DStv Compact + Asia + ExtraView"},
                                "dstv43 ":{"third_party_price": 23314.5, "braket_charges": 235.5, "total_price": 23550.0, "about":"dstv43 = DStv Compact Plus + French Plus"},
                                "complus-frenchtouch":{"third_party_price": 16731.0, "braket_charges": 169.0, "total_price": 16900.0, "about":"complus-frenchtouch = DStv Compact Plus + French Touch"},
                                "dstv45":{"third_party_price": 16978.5, "braket_charges": 171.5, "total_price": 17150.0, "about":"dstv45 = DStv Compact Plus - Extra View"},
                                "complus-french-extraview":{"third_party_price":26185.5 , "braket_charges": 264.5 , "total_price": 26450.0, "about":"complus-french-extraview = DStv Compact Plus + FrenchPlus + Extra View"},
                                "dstv47":{"third_party_price": 11533.5, "braket_charges": 183.0, "total_price": 18300.0, "about":"dstv47 = DStv Compact + French Plus"},
                                "dstv48":{"third_party_price": 24007.5, "braket_charges": 242.5, "total_price": 24250.0, "about":"dstv48 = DStv Compact Plus + Asia + ExtraView"},
                                "dstv61":{"third_party_price": 2790.0, "braket_charges": 310.0, "total_price": 31000.0, "about":"dstv61 = DStv Premium + Asia + Extra View"},
                                "dstv62":{"third_party_price": 2898.0, "braket_charges": 322.0, "total_price": 32200.0, "about":"dstv62 = DStv Premium + French + Extra View"},
                                "hdpvr-access-service":{"third_party_price": 2871.0, "braket_charges": 29.0, "total_price": 2900.0, "about":"hdpvr-access-service = DStv HDPVR Access Service"},
                                "frenchplus-addon":{"third_party_price": 9207.0, "braket_charges": 93.0, "total_price": 9300.0, "about":"frenchplus-addon = DStv French Plus Add-on"},
                                "asia-addon":{"third_party_price": 7029.0, "braket_charges": 71.0, "total_price": 7100.0, "about":"asia-addon = DStv Asian Add-on"},
                                "frenchtouch-addon":{"third_party_price": 2623.5, "braket_charges": 26.5, "total_price": 2650.0, "about":"frenchtouch-addon = DStv French Touch Add-on"},
                                "extraview-access":{"third_party_price": 2871.0, "braket_charges": 29.0, "total_price": 2900.0, "about":"extraview-access = ExtraView Access"},
                                "french11":{"third_party_price": 4059.0, "braket_charges": 41.0, "total_price": 4100.0, "about":"french11 = DStv French 11"}},
                          "gotv":{
                                "gotv-smallie":{"third_party_price": 891.0, "braket_charges": 9.0, "total_price": 900.0, "about":"gotv-smallie monthly = GOtv Small Monthly"},
                                "gotv-jinja":{"third_party_price": 1881.0, "braket_charges": 19.0, "total_price": 1900.0, "about":"gotv-jinja = GOtv Jinja"},
                                "gotv-jolli":{"third_party_price": 2772.0, "braket_charges": 28.0, "total_price": 2800.0, "about":"gotv-jolli = GOtv Jolli"},
                                "gotv-max":{"third_party_price": 4108.5, "braket_charges": 41.5, "total_price": 4150.0, "about":"gotv-max = GOtv Max"}, 
                                "gotv-supa":{"third_party_price": 5445.0, "braket_charges": 55.0, "total_price": 5500.0, "about":"gotv-supa = GOtv Supa"}},

                          "startimes":{
                                "nova":{"third_party_price": 886.5, "braket_charges": 13.5, "total_price":900.0, "about":"nova = Startimes Nova"},
                                "basic":{"third_party_price": 1674.5, "braket_charges": 25.5, "total_price": 1700.0, "about":"basic = Startimes Basic"},
                                "smart":{"third_party_price": 2167.0, "braket_charges": 33.0, "total_price":2200.0, "about":"smart = Startimes Smart"},
                                "classic":{"third_party_price": 2462.5, "braket_charges": 37.5, "total_price": 2500.0, "about":"classic = Startimes Classic"},
                                "super":{"third_party_price": 4137.0, "braket_charges": 63.0, "total_price": 4200.0, "about":"super = Startimes Super"}},

                     }};


Map<String, dynamic> electricity_plan_rate = {
        "ServiceType":{
            "abuja-electric":{"third_party_price": 1990.0, "braket_charges": 10.0, "total_price":2000.0, "about":"=Abuja (AEDC)"}, 
            "eko-electric":{"third_party_price": 1994.0, "braket_charges": 6.0, "total_price":2000.0, "about":"=Eko (EKEDC)"},
            "ibadan-electric":{"third_party_price": 1990.0, "braket_charges":10.0, "total_price": 2000.0, "about":"=Ibadan (IBEDC)"},
            "ikeja-electric":{"third_party_price":1980.0, "braket_charges": 20.0, "total_price": 2000.0, "about":"=Ikeja (IKEDC)"}, 
            "jos-electric":{"third_party_price": 1992.0, "braket_charges": 8.0, "total_price": 2000.0, "about":"=Jos (JED)"},
            "kaduna-electric":{"third_party_price": 1986.0 , "braket_charges": 14.0, "total_price": 2000.0, "about":"=Kaduna (KAEDCO)"},
            "kano-electric":{"third_party_price": 1990.0, "braket_charges": 10.0, "total_price": 2000.0, "about":"=Kano (KEDCO)"},
            "portharcout-electric":{"third_party_price": 1980.0 , "braket_charges":20.0, "total_price": 2000.0, "about":"=Portharcout (PHED)"}
        }};

// Future