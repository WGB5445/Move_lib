address 0x2{
    module STCHeroAdventure{
        use 0x1::Signer;
        use 0x1::Vector;
        // use 0x1::Block;
        use 0x1::Timestamp;
        use 0x1::Hash;
        // use 0x1::Account;

        const ERR_MOVE_NEW_EQ_OLD           :u64        = 1000;
        
        const ERR_MOVE_IS_MOVING            :u64        = 1001;
        const ERR_MOVE_IS_SLEEP            :u64        = 1002;
        const ERR_MOVE_IS_FIGHT            :u64        = 1003;
        const ERR_MOVE_IS_void              :u64        = 1004;
        const ERR_HERO_UPGRADE_EXP_TO_LESS  :u64        = 1101;
        const ERR_HERO_UPGRADE_LEVEL_IS_MAX :u64        = 1102;

        struct Monster has key,store,drop,copy{
            KIND    :u8,
            LEVEL   :u8,
            EXP     :u8,
            ATT     :Att,
            GFT     :Gift
        }

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
            STATUS  :u8,
            ATT     :Att,
            WEP     :Wep,
            GFT     :Gift,
            TASK    :Task,
            ACT     :Action,
            MSTR    :Monster
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
        public fun Get_Rand_Hero(account:&signer):Hero{
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

            let monster = Monster{
                KIND    :0,
                LEVEL   :0,
                EXP     :10,
                ATT     :Att{
                            ATK     :0,
                            DEF     :0,
                            AGL     :0,
                            HP      :0,
                        },
                GFT     :Gift{
                            ATK     :0,
                            DEF     :0,
                            AGL     :0,
                            HP      :0,
                        }
            };

            let hero = Hero{
                LEVEL   :0,
                EXP     :0,
                TIMES   :0,
                STATUS  :0,
                ATT     :att,
                WEP     :wep,
                GFT     :gift,
                TASK    :task,
                ACT     :act,
                MSTR    :monster,
            };
            hero
        }

        public fun Get_Rand(_account:&signer):vector<u8>{
            // let parent_hash = Block::get_parent_hash();
            // let time        = Timestamp::now_seconds();

            // let account_address =  Signer::address_of(account);
            // let account_key = Account::authentication_key(account_address);
            //Vector::append(&mut parent_hash,account_key);
            let v = Vector::empty<u8>();
            Vector::push_back<u8>(&mut v,8);
            let hash = Hash::keccak_256(v);
            hash
        }
        
        
        /*Monster function*/

        public fun Monster_Att_compute(monster:&Monster):Att{
            let att = Get_Monster_ATT(monster);
            let gift = Get_Monster_GFT(monster);
            let level = Get_Monster_LEVEL(monster);
            /*              ATK     :0,
                            DEF     :0,
                            AGL     :0,
                            HP      :0,*/
            let atk = Get_Att_ATK(&att) + Get_Gift_ATK(&gift) *  level;
            let def = Get_Att_DEF(&att) + Get_Gift_DEF(&gift) *  level;
            let agl = Get_Att_AGL(&att) + Get_Gift_AGL(&gift) *  level;
            let hp  = Get_Att_HP(&att) + Get_Gift_HP(&gift) *  level;
            
            Set_Att_HP(&mut att,hp);
            Set_Att_ATK(&mut att,atk);
            Set_Att_DEF(&mut att,def);
            Set_Att_AGL(&mut att,agl);

            return att
        }



        public fun Get_Rand_Monster(account:&signer):Monster{
            let rand = Get_Rand(account);
            let rand1 = *Vector::borrow(&rand,10);
            let rand2 = *Vector::borrow(&rand,11);
            let rand3 = *Vector::borrow(&rand,12);
            let rand4 = *Vector::borrow(&rand,13);
            let rand5 = *Vector::borrow(&rand,14);
            let kind = rand1 % 5 + 1;
            let att = if(kind == 1){
                            Att{
                                ATK     :2,
                                DEF     :2,
                                AGL     :20,
                                HP      :5,
                            }
                        }else if(kind == 2){
                            Att{
                                ATK     :12,
                                DEF     :7,
                                AGL     :7,
                                HP      :15,
                            }
                        }else if(kind == 3){
                            Att{
                                ATK     :13,
                                DEF     :10,
                                AGL     :5,
                                HP      :16,
                            }
                        }else if(kind == 4){
                            Att{
                                ATK     :12,
                                DEF     :10,
                                AGL     :11,
                                HP      :8,
                            }
                        }else {
                            Att{
                                ATK     :12,
                                DEF     :10,
                                AGL     :11,
                                HP      :8,
                            }
                        };
            let gift = Gift{
                ATK     :(rand2%5 ) + 1,
                DEF     :(rand3%5 ) + 1,
                AGL     :(rand4%5 ) + 1,
                HP      :(rand5%5 ) + 1,
            };
            let monster = Monster{
                KIND    :kind,
                LEVEL   :0,
                EXP     :10,
                ATT     :att,
                GFT     :gift
            };
            monster
        }
        public fun Get_Rand_Monster_by_hero(account:&signer,hero:&Hero):Monster{
            let rand = Get_Rand(account);
            // let rand1 = *Vector::borrow(&rand,10);
            let rand2 = *Vector::borrow(&rand,11);
            let rand3 = *Vector::borrow(&rand,12);
            let rand4 = *Vector::borrow(&rand,13);
            let rand5 = *Vector::borrow(&rand,14);
            let kind = Get_Action_INIT(& Get_Hero_ACT(hero));
            let att = if(kind == 2){
                            Att{
                                ATK     :2,
                                DEF     :2,
                                AGL     :20,
                                HP      :5,
                            }
                        }else if(kind == 3){
                            Att{
                                ATK     :12,
                                DEF     :7,
                                AGL     :7,
                                HP      :15,
                            }
                        }else if(kind == 4){
                            Att{
                                ATK     :13,
                                DEF     :10,
                                AGL     :5,
                                HP      :16,
                            }
                        }else if(kind == 5){
                            Att{
                                ATK     :12,
                                DEF     :10,
                                AGL     :11,
                                HP      :8,
                            }
                        }else {
                            Att{
                                ATK     :12,
                                DEF     :10,
                                AGL     :11,
                                HP      :8,
                            }
                        };
            let gift = Gift{
                ATK     :(rand2%5 ) + 1,
                DEF     :(rand3%5 ) + 1,
                AGL     :(rand4%5 ) + 1,
                HP      :(rand5%5 ) + 1,
            };
            let monster = Monster{
                KIND    :kind - 1,
                LEVEL   :Get_Hero_LEVEL(hero),
                EXP     :10,
                ATT     :att,
                GFT     :gift
            };
            monster
        }
        public fun Reset_Monster(monster:&mut Monster){
                Set_Monster_KIND    ( monster    , 0);
                Set_Monster_LEVEL  ( monster    , 0);
                Set_Monster_EXP    ( monster    , 10);
        }

        public fun Get_Monster_KIND(monster:&Monster):u8{
            (*monster).KIND
        }
        public fun Get_Monster_LEVEL(monster:&Monster):u8{
            (*monster).LEVEL
        }
        public fun Get_Monster_EXP(monster:&Monster):u8{
            (*monster).EXP
        }
        public fun Get_Monster_ATT(monster:&Monster):Att{
            *&monster.ATT
        }
        public fun Get_Monster_GFT(monster:&Monster):Gift{
            *&monster.GFT
        }


        public fun Set_Monster_Monster(monster1:&mut Monster,monster2:&Monster){
            Set_Monster_KIND(monster1,Get_Monster_KIND(monster2));
            Set_Monster_LEVEL(monster1,Get_Monster_LEVEL(monster2));
            Set_Monster_EXP(monster1,Get_Monster_EXP(monster2));
            Set_Monster_ATT(monster1,&Get_Monster_ATT(monster2));
            Set_Monster_GFT(monster1,&Get_Monster_GFT(monster2));
        }
         public fun Set_Monster_KIND(monster:&mut Monster,kind:u8){
            monster.KIND = kind;
        }
        public fun Set_Monster_LEVEL(monster:&mut Monster,level:u8){
            monster.LEVEL = level;
        }
        public fun Set_Monster_EXP(monster:&mut Monster,exp:u8){
            monster.EXP  = exp;
        }
        public fun Set_Monster_ATT(monster:&mut Monster,att:&Att){
            Set_Att_Att(&mut monster.ATT,att);
        }
        public fun Set_Monster_GFT(monster:&mut Monster,gift:&Gift){
            Set_Gift_Gift(&mut monster.GFT,gift);
        }
        /*Monster function end */

        /* Hero function*/

         public fun Hero_Att_compute(hero:&Hero):Att{
            let att = Get_Hero_ATT(hero);
            let gift = Get_Hero_GFT(hero);
            let level = Get_Hero_LEVEL(hero);
            /*              ATK     :0,
                            DEF     :0,
                            AGL     :0,
                            HP      :0,*/
            let atk = Get_Att_ATK(&att) + Get_Gift_ATK(&gift) *  level;
            let def = Get_Att_DEF(&att) + Get_Gift_DEF(&gift) *  level;
            let agl = Get_Att_AGL(&att) + Get_Gift_AGL(&gift) *  level;
            let hp  = Get_Att_HP(&att) + Get_Gift_HP(&gift) *  level;
            
            Set_Att_HP(&mut att,hp);
            Set_Att_ATK(&mut att,atk);
            Set_Att_DEF(&mut att,def);
            Set_Att_AGL(&mut att,agl);

            return att
        }




        public fun Reset_Hero(hero:&mut Hero){
                Set_Hero_LEVEL  ( hero    , 0);
                Set_Hero_EXP    ( hero    , 0);
                let times =     Get_Hero_TIMES(hero);
                Set_Hero_TIMES  ( hero    ,   times + 1);
                Set_Hero_TASK   ( hero    ,   &Create_init_Task());
        }

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
        public fun Get_Hero_STATUS(hero:&Hero):u8{
            *&hero.STATUS
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
        public fun Get_Hero_MSTR(hero:&Hero):Monster{
            *&hero.MSTR
        }

        public fun Set_Hero_LEVEL(hero:&mut Hero,level:u8){
            hero.LEVEL = level;
        }
        public fun Set_Hero_EXP(hero:&mut Hero,exp:u8){
            hero.EXP   = exp;
        }
        
        public fun Set_Hero_TIMES(hero:&mut Hero,times:u8){
            hero.TIMES = times;
        }
        public fun Set_Hero_STATUS(hero:&mut Hero,status:u8){
            hero.STATUS = status;
        }
        public fun Set_Hero_ATT(hero:&mut Hero,att:&Att){
            Set_Att_Att     (   &mut hero.ATT   ,   att);
        }

        public fun Set_Hero_WEP(hero:&mut Hero,wep:&Wep){
            Set_Wep_Wep     (   &mut hero.WEP   ,   wep);
        }

        public fun Set_Hero_GFT(hero:&mut Hero,gift:&Gift){
            Set_Gift_Gift   (   &mut hero.GFT   ,   gift);
        }
        public fun Set_Hero_TASK(hero:&mut Hero,task:&Task){
            Set_Task_Task   (   &mut hero.TASK  ,   task);
        }
        public fun Set_Hero_ACT(hero:&mut Hero,action:&Action){
            Set_Action_Action(  &mut hero.ACT   ,   action);
        }
        public fun Set_Hero_MSTR(hero:&mut Hero,monster:&Monster){
            Set_Monster_Monster(  &mut hero.MSTR   ,   monster);
        }

        /* Hero function end*/

        /* Att function*/
        
        /* Att Get function*/

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

        /* Att Set function*/

        public fun Set_Att_Att(att1:&mut Att,att2:&Att){
            Set_Att_ATK ( att1,Get_Att_ATK  (   att2    )    );
            Set_Att_DEF ( att1,Get_Att_DEF  (   att2    )    );
            Set_Att_AGL ( att1,Get_Att_AGL  (   att2    )    );
            Set_Att_HP  ( att1,Get_Att_HP  (   att2    )    );
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



        /* Gift function */

        /* Gift Get function */
        
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
        /* Gift Set function */
        public fun Set_Gift_Gift(gift1:&mut Gift,gift2:&Gift){
            Set_Gift_ATK(   gift1   ,   Get_Gift_ATK(   gift2   )   );
            Set_Gift_DEF(   gift1   ,   Get_Gift_DEF(   gift2   )   );
            Set_Gift_AGL(   gift1   ,   Get_Gift_AGL(   gift2   )   );
            Set_Gift_HP (   gift1   ,   Get_Gift_HP (   gift2   )   );
        }

        public fun Set_Gift_ATK(gift:&mut Gift,atk:u8){
            gift.ATK = atk;
        }
        public fun Set_Gift_DEF(gift:&mut Gift,def:u8){
            gift.DEF = def;
        }
        public fun Set_Gift_AGL(gift:&mut Gift,agl:u8){
            gift.AGL = agl;
        }
        public fun Set_Gift_HP(gift:&mut Gift,hp:u8){
            gift.HP = hp;
        }
        /* Gift function end*/
        
        /* Wep function */
        /*
        struct Wep has key,store,drop,copy{
            WEAP:u8,
            BRE:u8,
            BOT:u8,
        }
        */


        public fun Create_init_Wep():Wep{
            Wep{
                WEAP:0,
                BRE:0,
                BOT:0,
            }
        }
        public fun Reset_Wep(wep:&mut Wep){
            Set_Wep_WEAP(   wep    ,   0);
            Set_Wep_BRE (   wep    ,   0);
            Set_Wep_BOT (   wep    ,   0);
        }


        /* Wep Get function */

        public fun Get_Wep_WEAP(wep:&Wep):u8{
            (*wep).WEAP
        }
        public fun Get_Wep_BRE(wep:&Wep):u8{
            (*wep).BRE
        }
        public fun Get_Wep_BOT(wep:&Wep):u8{
            (*wep).BOT
        }

        /* Wep Set function */
        
        public fun Set_Wep_Wep(wep1:&mut Wep,wep2:&Wep){
            Set_Wep_WEAP(   wep1 ,   Get_Wep_WEAP(   wep2    ));
            Set_Wep_BRE (   wep1 ,   Get_Wep_BRE (   wep2    ));
            Set_Wep_BOT (   wep1 ,   Get_Wep_BOT (   wep2    ));
        }
        public fun Set_Wep_Wep_withRarity(wep1:&mut Wep,wep2:&Wep){
            if(Check_Rarity(Get_Wep_WEAP(wep2)) > Check_Rarity(Get_Wep_WEAP(wep1))) {
                Set_Wep_WEAP(   wep1 ,   Get_Wep_WEAP(   wep2    ));
            };
            if(Check_Rarity(Get_Wep_BRE(wep2)) > Check_Rarity(Get_Wep_BRE(wep1))) {
                Set_Wep_BRE(   wep1 ,   Get_Wep_BRE(   wep2    ));
            };
            if(Check_Rarity(Get_Wep_BOT(wep2)) > Check_Rarity(Get_Wep_BOT(wep1))) {
                Set_Wep_BOT(   wep1 ,   Get_Wep_BOT(   wep2    ));
            }; 
        }
        public fun Set_Wep_WEAP(wep:&mut Wep,weap:u8){
            wep.WEAP    =   weap;
        }
        public fun Set_Wep_BRE(wep:&mut Wep,bre:u8){
            wep.BRE     =   bre;
        }
        public fun Set_Wep_BOT(wep:&mut Wep,bot:u8){
            wep.BOT     =   bot;
        }
        /* Wep function end*/

        /* Action function */
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
            Set_Action_INIT     (    action  ,   init           );
            Set_Action_DES      (    action  ,   des            );
            Set_Action_INIT_TIME(    action  ,   init_time      );
            Set_Action_DES_TIME (    action  ,   des_time       );
        }

        /* Action Get function */

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

        /* Action Set function */
        public fun Set_Action_Action(action1:&mut Action,action2:&Action){
            Set_Action_INIT         (   action1     ,   Get_Action_INIT     (    action2 ));
            Set_Action_DES          (   action1     ,   Get_Action_DES      (    action2 ));
            Set_Action_INIT_TIME    (   action1     ,   Get_Action_INIT_TIME(    action2 ));
            Set_Action_DES_TIME     (   action1     ,   Get_Action_DES_TIME (    action2 ));
        }

        public fun Set_Action_INIT(action:&mut Action,init:u8){
            action.INIT     =   init;
        }
        public fun Set_Action_DES(action:&mut Action,des:u8){
            action.DES      =   des;
        }
        public fun Set_Action_INIT_TIME(action:&mut Action,init_time:u64){
            action.INIT_TIME    =   init_time;
        }
        public fun Set_Action_DES_TIME(action:&mut Action,des_time:u64){
            action.DES_TIME     =   des_time;
        }

        /* Action function end*/
        

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
        /* Task function */
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
       
        public fun Reset_Task(task:&mut Task){
            Set_Task_TARGET (    task    ,   0 );
            Set_Task_TIMES  (    task    ,   0 );
            Set_Task_WEP    (    task    ,   &Create_init_Wep() );
            Set_Task_EXP    (    task    ,   0 );
        }
        /* Task Get function */
        public fun Get_Rand_Task(account:&signer,task:&mut Task){
            let rand    = Get_Rand(account);
            let rand1   = *Vector::borrow(&rand,5);
            let rand2   = *Vector::borrow(&rand,6);
            let rand3   = *Vector::borrow(&rand,7);
            let rand4   = *Vector::borrow(&rand,8);
            // let rand5   = *Vector::borrow(&rand,9);
            let target  = ( rand1 % 5 ) + 1;
            let times   = ( rand2 % 3 ) + 1;
            let rarity  = ( rand3 % 5 ) + 1;
            let wep_t   = ( rand4 % 3 ) + 1;
            let wep     = if(wep_t == 1){
                            Wep {
                                WEAP    : rarity << 3 | 2,//( rand5 % 3 ) + 1 ,
                                BRE     : 0 ,
                                BOT     : 0 ,
                            }
                          }else if(wep_t == 2){
                            Wep {
                                WEAP    : 0 ,
                                BRE     : rarity << 3 | 2,//( rand5 % 3 ) + 1 ,
                                BOT     : 0 ,
                            }
                          }else {
                            Wep {
                                WEAP    : 0 ,
                                BRE     : 0 ,
                                BOT     : rarity << 3 | 2,//( rand5 % 3 ) + 1 ,
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

        /* Task Set function */
        public fun Set_Task_Task(task1:&mut Task,task2:&Task){
            Set_Task_TARGET (   task1   ,   Get_Task_TARGET(    task2   ));
            Set_Task_TIMES  (   task1   ,   Get_Task_TIMES(    task2   ));
            Set_Task_WEP    (   task1   ,   &Get_Task_WEP(    task2   ));
            Set_Task_EXP    (   task1   ,   Get_Task_EXP(    task2   ));

        }

        public fun Set_Task_TARGET(task:&mut Task,target:u8){
            task.TARGET     = target;
        }
        public fun Set_Task_TIMES(task:&mut Task,times:u8){
            task.TIMES      = times;
        }
        public fun Set_Task_WEP(task:&mut Task,wep:&Wep){
            Set_Wep_Wep     (   &mut  task.WEP    ,   wep );
        }
        public fun Set_Task_EXP(task:&mut Task,exp:u8){
            task.EXP        = exp;
        }
        /* Task function  end*/

        /* Rarity identification  function*/
        public fun Check_Rarity(r:u8):u8{
            return ((   r & 56 ) >> 3)
        }
        /* Rarity identification  function end*/
        /* Position , Regional inspection  function */
        public fun Check_Position   (p:u8):u8{
            return ( p & 7 )
        }
        public fun Check_Regional   (r:u8):u8{
            return (( r & 56 ) >> 3)
        }
        /* Position , Regional inspection function end*/

        public fun  Get_Now_Times(i:u64):u64{
            if(i > 0){
                return i
            };    
            return    Timestamp::now_seconds()
        }

        /*Game function*/
        public fun  Game_init(account:&signer):Hero{
            let hero = Get_Rand_Hero(account);
            let task = Create_init_Task();
            Get_Rand_Task(account,&mut task);
            Set_Hero_TASK(  &mut hero , &task);
            hero
        }
        public fun Game_Hero_Status_machine(hero:&mut Hero){
            let status = Get_Hero_STATUS(hero);
            if(status == 0){
                ();
            }else if(status == 1){
                ();
            }else if(status == 2){
                Game_Hero_move_Arrive(hero);
            }else if(status == 3){
                ();
            };
        }
        public fun Game_Hero_find_Monster(account:&signer,hero:&mut Hero){
            if(Game_Hero_IsCan_findMonster(hero)){
                let monster = Get_Rand_Monster_by_hero(account,hero);
                Set_Hero_MSTR(hero,&monster);
                Set_Hero_STATUS(hero,3);
            }else {
                ()
            };
        }
        public fun Game_Hero_Fight_Monster(hero:&mut Hero){
            if(Get_Hero_STATUS(hero) != 3){
                return  
            };
            
            let hero_att = Hero_Att_compute(hero);
        
            let monster = Get_Hero_MSTR(hero);
            let monster_att = Monster_Att_compute(&monster);
            let res = Game_Hero_Fight_Monster_compute(&hero_att,&monster_att);
            if (res){
                Set_Hero_STATUS(hero,0);
               
                if(!Game_Hero_EXP_IsMax(hero)){
                    let exp = Get_Hero_EXP(hero);
                    
                    Set_Hero_EXP(hero,(exp + Get_Monster_EXP(&monster)));
                    if(Game_Hero_IsCan_upgrade(hero)){
                        Game_Hero_upgrade(hero);
                    };
                };
                if(Game_Hero_IsHave_task(hero)){
                    let task = Get_Hero_TASK(hero);
                    if(Get_Task_TARGET(&task) == Get_Monster_KIND(&monster)){
                        let task_times = Get_Task_TIMES(&task);
                        Set_Task_TIMES(&mut task, task_times);
                        if(Game_Hero_IsFinish_task(hero)){
                            Game_Hero_task_Finish(hero);
                        }
                    };
                };

                Reset_Monster(&mut monster);
                Set_Hero_MSTR(hero,&monster);
            }else{
                Set_Hero_STATUS(hero,0);
                Reset_Monster(&mut monster);
                Set_Hero_MSTR(hero,&monster);
            };
            
        }
        public fun Game_Hero_Fight_Monster_compute(att1:&Att,att2:&Att):bool{
            /*              ATK     :0,
                            DEF     :0,
                            AGL     :0,
                            HP      :0,*/
            let att1_atk = Get_Att_ATK(att1) * 2;
            let att1_def = Get_Att_DEF(att1) * 2;
            let att1_agl = Get_Att_AGL(att1) * 1;
            let att1_hp  = Get_Att_HP(att1)  * 1;

            let att2_atk = Get_Att_ATK(att2) * 2;
            let att2_def = Get_Att_DEF(att2) * 1;
            let att2_agl = Get_Att_AGL(att2) * 1;
            let att2_hp  = Get_Att_HP(att2)  * 1;

            if(att2_atk >= (att1_def + att1_agl) ){
                let _hp =   att2_atk - (att1_def + att1_agl);
                if(_hp >= att1_hp){
                    return false
                };
            };
            if(att1_atk >= (att2_def + att2_agl) ){
                let _hp = att1_atk - (att2_def + att2_agl);
                if(_hp >= att2_hp ){
                    return true
                };
            };
            return false
        }
        public fun Game_Hero_IsCan_findMonster(hero:&Hero):bool{
            let status =   Get_Hero_STATUS(hero);
            if(status != 0){
                return false
            };
            
            let action =   Get_Hero_ACT(hero);
            let position = Check_Position(Get_Action_INIT(&action));
            let regional = Check_Regional(Get_Action_INIT(&action));
            if(regional != 0){
                return false
            };
            if (position != 0 && position != 1 && position <= 6) {
                return true
            };
            return false
        }
        public fun Game_Hero_move(hero:&mut Hero,position:u8,regional:u8){
            let action = Get_Hero_ACT(  hero  );
            let pos_old     = Get_Action_INIT(&action);
            let status      = Get_Hero_STATUS(hero);
            if(status == 1){
                abort(ERR_MOVE_IS_SLEEP)
            }else if(status == 2){
                abort(ERR_MOVE_IS_MOVING)
            }else if(status == 3){
                abort(ERR_MOVE_IS_FIGHT)
            };
            if(Check_Position(pos_old) == position && Check_Regional(pos_old) == regional){
                abort(ERR_MOVE_NEW_EQ_OLD)
            };
            if(Check_Regional(pos_old) ==  regional){
                Set_Action_DES(&mut action  ,   position);
                let now_time  = Get_Now_Times(1);
                let des_time = now_time + 5 * 60 * (position as u64);
                Set_Action_DES_TIME(&mut action,des_time);
                Set_Action_INIT_TIME(&mut action,now_time);
            };
            Set_Hero_ACT(hero,&action);
            Set_Hero_STATUS(hero,2);
        }
        public fun Game_Hero_IsCan_move(hero:&Hero):bool{
            let status = Get_Hero_STATUS(hero);
            return status == 0
        }
        public fun Game_Hero_move_Arrive(hero:&mut Hero){
            if(!Game_Hero_move_IsArrive(hero)){
                return
            };
            let action = Get_Hero_ACT(hero);
            let des     = Get_Action_DES(&action);
            Set_Action_INIT(&mut action,des);
            Set_Hero_ACT(hero,&action);
            Set_Hero_STATUS(hero,0);
        }
        public fun Game_Hero_move_IsArrive(hero:&Hero):bool{
            let status      = Get_Hero_STATUS(hero);
            if(status == 0){
                return false
            }else if(status == 1){
                return false
            }else if(status == 3){
                return false
            };
            let now_time    = Get_Now_Times(602);
            let action      =   Get_Hero_ACT(hero);
            
            return (now_time >= Get_Action_DES_TIME(&action))
            
        }
        public fun Game_Hero_task_Finish(hero:&mut Hero){
            if(!Game_Hero_IsFinish_task(hero)){
                return 
            };
            let task = Get_Hero_TASK(hero);
            
            if(!Game_Hero_EXP_IsMax(hero)){
                let exp  = Get_Hero_EXP(hero) + Get_Task_EXP(&task);
                Set_Hero_EXP(hero,exp);
            };
            let wep = Get_Hero_WEP(hero);
            let task_wep = Get_Task_WEP(&task);
            Set_Wep_Wep_withRarity(&mut wep,&task_wep);
            Set_Hero_WEP(hero,&wep);
            Reset_Task(&mut task);
            Set_Hero_TASK(hero,&task);
        }
        public fun Game_Hero_task_Get(account:&signer,hero:&mut Hero){
            if(Game_Hero_IsHave_task(hero)){
                return
            };
            let task = Get_Hero_TASK(hero);
            Get_Rand_Task(account,&mut task);
            Set_Hero_TASK(hero,&task);
        }
        public fun Game_Hero_IsHave_task(hero:&Hero):bool{
            let task = Get_Hero_TASK(hero);
            if(Get_Task_TARGET(&task) == 0){
                return false
            };
            return true
        }
        public fun Game_Hero_IsFinish_task(hero:&Hero):bool{
            let task = Get_Hero_TASK(hero);
            if (Game_Hero_IsHave_task(hero) == false){
                return false
            };
            if(Get_Task_TIMES(&task) == 0){
                return true
            };
            return false
        }
        public fun Game_Hero_upgrade(hero:&mut Hero){
            let exp = Get_Hero_EXP(hero);
            let level = Get_Hero_LEVEL(hero);
            if(exp < 100){
                abort(ERR_HERO_UPGRADE_EXP_TO_LESS)
            };
            if(level >= 10){
                abort(ERR_HERO_UPGRADE_LEVEL_IS_MAX)
            };
            if(exp == 100){
                Set_Hero_EXP    (   hero    ,   0           );
                Set_Hero_LEVEL  ( hero      ,   level + 1   ); 
            }else if(exp > 100 && exp < 200){
                let exp_more = exp - 100;
                Set_Hero_EXP    (   hero       ,   exp_more   );
                Set_Hero_LEVEL  (   hero       ,   level + 1);
            }else {
                let exp_more = exp - 200;
                if(level <= 9 ){
                    Set_Hero_LEVEL  (   hero        ,   level + 1);
                }else if(level < 9){
                    Set_Hero_LEVEL  (   hero        ,   level + 2);
                };
                Set_Hero_EXP    (   hero    ,   exp_more);
            }
        }
        public fun Game_Hero_IsCan_upgrade(hero:& Hero):bool{
            return (( !Game_Hero_LEVEL_IsMax(hero) )&&  Game_Hero_EXP_IsMax(hero) )
        }
        public fun Game_Hero_EXP_IsMax(hero:&Hero):bool{
            return Get_Hero_EXP(hero) >= 100
        }
        public fun Game_Hero_LEVEL_IsMax(hero:&Hero):bool{
            return Get_Hero_LEVEL(hero) >= 10
        }

        public (script) fun Game_Init(account:signer)acquires Hero{
            let account_address =  Signer::address_of(&account);
            
            if(exists<Hero>(account_address)){
                let Hero {   
                        LEVEL   :_,
                        EXP     :_,
                        TIMES   :_,
                        STATUS  :_,
                        ATT     :_,
                        WEP     :_,
                        GFT     :_,
                        TASK    :_,
                        ACT     :_,
                        MSTR    :_,
                 } = move_from(account_address);
            };
            let hero = Game_init(&account);
            move_to(&account,hero);
        }

        /*Game function end */
    }
    
}