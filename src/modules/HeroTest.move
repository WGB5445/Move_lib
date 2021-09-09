address 0x2{
    module STCHeroAdventure{
        use 0x1::Signer;
        use 0x1::Vector;
        use 0x1::Block;
        // use 0x1::Timestamp;
        use 0x1::Hash;
        use 0x1::Account;
        //Att: attribute
        //ATK:Attack
        //DEF:Defense
        //AGL:Agility
        //HP:Hit Point
        struct Att has key,store,drop,copy{
                ATK:u8,
                DEF:u8,
                AGL:u8,
                HP:u8,
        }
        //Gift max is 5 and min is 1
        struct Gift has key,store,drop,copy{
             ATK:u8,
             DEF:u8,
             AGL:u8,
             HP:u8,
        }
        //Wep:weaponry
        //WEAP:Weapon
        //BRE:Breastplate
        //BOT:Boots
        struct Wep has key,store,drop,copy{
            WEAP:u8,
            BRE:u8,
            BOT:u8,
        }
        //LEVEL:LEVEL      max is 10 
        //EXP:Experience   max is 100
        //GFT:gift         max is 5
        struct Hero has key,store,drop,copy{
            LEVEL   :u8,
            EXP     :u8,
            TIMES   :u8,
            ATT     :Att,
            WEP     :Wep,
            GFT     :Gift,
            TASK    :Task,
            ACT     :Action,
        }

        struct Task has key,store,drop,copy{
            TARGET  :u8,
            TIMES   :u8,
            RARITY  :u8,
            WEP     :Wep,
            EXP     :u8,
        }

        //INIT:     Initially
        //DES:      destination
        struct Action has key,store,drop,copy{
            INIT        :u8,
            DES         :u8,
            INIT_TIME   :u64,
            DES_TIME    :u64
        }


        //common Rare Epic Legendary Myth
        //0 0 0 0   0 0 0 0 
        //            0 0 0 is kind of type
        //    0 0   0       is rarity  
        fun init_Hero(account:&signer):Hero{
            let rand = Get_Rand(account);
            let rand1 = *Vector::borrow(&rand,1);
            let rand2 = *Vector::borrow(&rand,2);
            let rand3 = *Vector::borrow(&rand,3);
            let rand4 = *Vector::borrow(&rand,4);
            
            let att = Att{
                ATK     :10,
                DEF     :10,
                AGL     :10,
                HP      :10,
            };

            let gift = Gift{
                ATK     :(rand1%5 ) + 1,
                DEF     :(rand2%5 ) + 1,
                AGL     :(rand3%5 ) + 1,
                HP      :(rand4%5 ) + 1,
            };

            let wep = Wep{
                WEAP    :0,
                BRE     :0,
                BOT     :0,
            };

            let task = Task{
                TARGET  :0,
                TIMES   :0,
                RARITY  :0,
                WEP     :Wep{
                            WEAP    :0,
                            BRE     :0,
                            BOT     :0,
                        },
                EXP     :0,
            };

            let act = Action{
                INIT        :1,
                DES         :1,
                INIT_TIME   :0,
                DES_TIME    :0
            };

            let hero = Hero{
                LEVEL   :0,
                EXP     :0,
                TIMES   :0,
                ATT     :att,
                WEP     :wep,
                GFT     :gift,
                TASK    :task,
                ACT     :act,
            };
            hero
        }

        public fun Reset_Hero(_hero:&Hero){

        }
        
        public fun Set_Hero_LEVEL(hero:&mut Hero,level:u8){
            hero.LEVEL = level;
        }
        public fun Set_Hero_EXP(hero:&mut Hero,exp:u8){
            hero.EXP = exp;
        }
        public fun Set_Hero_TIMES(hero:&mut Hero,times:u8){
            hero.TIMES = times;
        }
        public fun Set_Hero_ATT(hero:&mut Hero,att:&Att){
            Set_Att_Att(&mut hero.ATT,att);
        }


        /* Hero function*/
        public fun Get_Hero_LEVEL(hero:&Hero):u8{
            (*hero).LEVEL
        }
        public fun Get_Hero_EXP(hero:&Hero):u8{
            (*hero).EXP
        }
        public fun Get_Hero_ATT(hero:&Hero):Att{
            *&hero.ATT
        }
        public fun Get_Hero_TIMES(hero:&Hero):u8{
            *&hero.TIMES
        }
        public fun Get_Hero_WEP(hero:&Hero):Wep{
            *&hero.WEP
        }
        public fun Get_Hero_GFT(hero:&Hero):Gift{
            *&hero.GFT
        }
        public fun Get_Hero_TASK(hero:&Hero):Task{
            *&hero.TASK
        }
        public fun Get_Hero_ACT(hero:&Hero):Action{
            *&hero.ACT
        }
        /* Hero function end*/
        
        /* Att function*/
        public fun Set_Att_Att(att1:&mut Att,att2:&Att){
            Set_Att_ATK ( att1,Get_Att_ATK  (   att2    )    );
            Set_Att_DEF ( att1,Get_Att_ATK  (   att2    )    );
            Set_Att_AGL ( att1,Get_Att_ATK  (   att2    )    );
            Set_Att_HP  ( att1,Get_Att_ATK  (   att2    )    );
        }
        public fun Get_Att_ATK(att:&Att):u8{
            (*att).ATK
        }
        public fun Get_Att_DEF(att:&Att):u8{
            (*att).DEF
        }
        public fun Get_Att_AGL(att:&Att):u8{
            (*att).AGL
        }
        public fun Get_Att_HP(att:&Att):u8{
            (*att).HP
        }

        public fun Set_Att_ATK(att:&mut Att,atk:u8){
            att.ATK = atk;
        }
        public fun Set_Att_DEF(att:&mut Att,def:u8){
            att.DEF = def;
        }
        public fun Set_Att_AGL(att:&mut Att,agl:u8){
            att.AGL = agl;
        }
        public fun Set_Att_HP(att:&mut Att,hp:u8){
            att.HP = hp;
        }
        /* Att function end*/

        public fun Get_Gift_ATK(gift:&Gift):u8{
            (*gift).ATK
        }
        public fun Get_Gift_DEF(gift:&Gift):u8{
            (*gift).DEF
        }
        public fun Get_Gift_AGL(gift:&Gift):u8{
            (*gift).AGL
        }
        public fun Get_Gift_HP(gift:&Gift):u8{
            (*gift).HP
        }

        public fun Create_Wep():u8{
            0
        }
        public fun Reset_Wep(wep:&mut Wep){
                wep.WEAP = 0;
                wep.BRE  = 0;
                wep.BOT  = 0;
        }

        public fun Get_Wep_WEAP(wep:&Wep):u8{
            (*wep).WEAP
        }
        public fun Get_Wep_BRE(wep:&Wep):u8{
            (*wep).BRE
        }
        public fun Get_Wep_BOT(wep:&Wep):u8{
            (*wep).BOT
        }
        public fun Create_init_Action():Action{
            let act = Action{
                INIT        :1,
                DES         :1,
                INIT_TIME   :0,
                DES_TIME    :0
            };
            act
        }
        public fun Reset_Action(action:&mut Action){
            Set_Action(action,1,1,0,0);
        }
        public fun Set_Action(action:&mut Action,init:u8,des:u8,init_time:u64,des_time:u64){
            action.INIT         = init;
            action.DES          = des;
            action.INIT_TIME    = init_time;
            action.DES_TIME     = des_time;
        }


        public fun Get_Action_INIT(action:&Action):u8{
            (*action).INIT
        }
        public fun Get_Action_DES(action:&Action):u8{
            (*action).DES
        }
        public fun Get_Action_INIT_TIME(action:&Action):u64{
            (*action).INIT_TIME
        }
        public fun Get_Action_DES_TIME(action:&Action):u64{
            (*action).DES_TIME
        }


        public fun Get_Rand(account:&signer):vector<u8>{
            let parent_hash = Block::get_parent_hash();
            // let time        = Timestamp::now_seconds();
            let account_address =  Signer::address_of(account);
            let account_key = Account::authentication_key(account_address);
            Vector::append(&mut parent_hash,account_key);
            let hash = Hash::keccak_256(parent_hash);
            hash
        }

        //let task = Task{
        //      TARGET  :0,
        //      TIMES   :0,
        //      RARITY  :0,
        //      WEP     :Wep{
        //                  WEAP    :0,
        //                  BRE     :0,
        //                  BOT     :0,
        //              },
        //      EXP     :0,
        //  };
        public fun Create_init_Task():Task{
            let task = Task{
                TARGET  :0,
                TIMES   :0,
                RARITY  :0,
                WEP     :Wep{
                            WEAP    :0,
                            BRE     :0,
                            BOT     :0,
                        },
                EXP     :0,
            };
            task
        }
        public fun Set_Task(account:&signer,task:&mut Task){
            let rand    = Get_Rand(account);
            let rand1   = *Vector::borrow(&rand,5);
            let rand2   = *Vector::borrow(&rand,6);
            let rand3   = *Vector::borrow(&rand,7);
            let rand4   = *Vector::borrow(&rand,8);
            let rand5   = *Vector::borrow(&rand,9);
            let target  = ( rand1 % 5 ) + 1;
            let times   = ( rand2 % 3 ) + 1;
            let rarity  = ( rand3 % 5 ) + 1;
            let wep_t   = ( rand4 % 3 ) + 1;
            let wep     = if(wep_t == 1){
                            Wep {
                                WEAP    : rarity << 3 | ( rand5 % 3 ) + 1 ,
                                BRE     : 0 ,
                                BOT     : 0 ,
                            }
                          }else if(wep_t == 2){
                            Wep {
                                WEAP    : 0 ,
                                BRE     : rarity << 3 | ( rand5 % 3 ) + 1 ,
                                BOT     : 0 ,
                            }
                          }else {
                            Wep {
                                WEAP    : 0 ,
                                BRE     : 0 ,
                                BOT     : rarity << 3 | ( rand5 % 3 ) + 1 ,
                            }
                          };
            let exp     = if(rarity == 1){
                            20
                          }else if(rarity == 2){
                            30
                          }else if(rarity == 3){
                            40
                          }else if(rarity == 4){
                            50
                          }else {
                            60
                          };
            // let task = Task{
            //     TARGET  :target,
            //     TIMES   :times,
            //     RARITY  :rarity,
            //     WEP     :wep,
            //     EXP     :exp,
            // };
            task.TARGET = target;
            task.TIMES = times;
            task.RARITY = rarity;   
            task.WEP = wep;   
            task.EXP = exp;      
        }
        public fun Reset_Task(task:&mut Task){
            task.TARGET  = 0;
            task.TIMES   = 0;
            Reset_Wep(&mut task.WEP);
            task.RARITY   = 0;
            task.EXP   = 0;
        }
        public fun Get_Task_TARGET(task:&Task):u8{
            (*task).TARGET
        }
        public fun Get_Task_TIMES(task:&Task):u8{
            (*task).TIMES
        }
        public fun Get_Task_WEP(task:&Task):Wep{
            *&task.WEP
        }
        public fun Get_Task_EXP(task:&Task):u8{
            (*task).EXP
        }
    }
}