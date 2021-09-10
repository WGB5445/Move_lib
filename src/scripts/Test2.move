script {
    use 0x1::Debug;
    use 0x2::STCHeroAdventure;
    //move publish
    //move run src/scripts/test.move --signers 0x2
    
    fun main(addr:address) {
        // STCHeroAdventure::Game_Init(account);
        //STCHeroAdventure::Game_move(account,4,0);
        //   STCHeroAdventure::Game_Find_Monster(account);
        // STCHeroAdventure::Game_Fight_Monster(account);
        Debug::print (&STCHeroAdventure::Game_Return_Hero(addr));
    }
   
}