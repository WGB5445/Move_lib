address 0x2{
    module STCHeroAdventure{
        use 0x1::Signer;
        use 0x1::Vector;
        use 0x1::Block;
        use 0x1::Timestamp;
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
        //LEVEL:LEVEL
        //EXP:Experience
        //GFT:gift
        struct User has key,store,drop,copy{
            LEVEL:u8,
            EXP:u8,
            ATT:Att,
            WEP:Wep,
            GFT:Gift
        }
        //common Rare Epic Legendary Myth
        //0 0 0 0   0 0 0 0 
        //            0 0 0 is kind of type
        //    0 0   0       is rarity  
        fun init_User(account:&signer){
            let rand = Get_Rand(account);
            let rand1 = *Vector::borrow(&rand,1);
            let rand2 = *Vector::borrow(&rand,2);
            let rand3 = *Vector::borrow(&rand,3);
            let rand4 = *Vector::borrow(&rand,4);
            let att = Att{
                ATK:10,
                DEF:10,
                AGL:10,
                HP:10,
            };
            let gift = Gift{
                ATK:(rand1%5 ) + 1,
                DEF:(rand2%5 ) + 1,
                AGL:(rand3%5 ) + 1,
                HP: (rand4%5 ) + 1,
            };
        }

        fun Get_Rand(account:&signer):vector<u8>{
            let parent_hash = Block::get_parent_hash();
            let time        = Timestamp::now_seconds();
            let account_address =  Signer::address_of(account);
            let account_key = Account::authentication_key(account_address);
            Vector::append(&mut parent_hash,account_key);
            let hash = Hash::keccak_256(parent_hash);
            hash
        }
    }
}