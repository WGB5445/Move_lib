
script {
    use 0x1::Debug;
    use 0x2::STCHeroAdventure;
    //move publish
    //move run src/scripts/test.move --signers 0x2
    fun main(account: signer) {
        let hero = STCHeroAdventure::Game_init(&account);

        // Debug::print(&STCHeroAdventure::Check_Rarity(STCHeroAdventure::Get_Wep_WEAP(&STCHeroAdventure::Get_Task_WEP(&task))));
        Debug::print(&hero);
        Debug::print(&STCHeroAdventure::Game_Hero_IsCan_findMonster(&hero));
        STCHeroAdventure::Game_Hero_find_Monster(&account,&mut hero);
        Debug::print(&hero);
        Debug::print(&STCHeroAdventure::Game_Hero_IsCan_move(&hero)) ;
        STCHeroAdventure::Game_Hero_move(&mut hero,2,0);
        STCHeroAdventure::Game_Hero_find_Monster(&account,&mut hero);
        Debug::print(&hero);
        Debug::print(&STCHeroAdventure::Game_Hero_IsCan_move(&hero)) ;
        
        Debug::print(&STCHeroAdventure::Game_Hero_move_IsArrive(&hero)) ;
        STCHeroAdventure::Game_Hero_move_Arrive(&mut hero);
        STCHeroAdventure::Game_Hero_find_Monster(&account,&mut hero);
        Debug::print(&hero);  
    }
}