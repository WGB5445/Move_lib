address 0x7a9704AAf75FaC779dF5e7f802b121b0{
    module STCHeroNFT{
        use 0x1::NFT;
        use 0x1::Block;
        use 0x1::Vector;
        use 0x1::Signer;
        use 0x1::NFTGallery;
        use 0x1::Errors;
        use 0x1::Account;

        const ERR_STCHERO_TOO_MUCH: u64 = 1000;
        const ERR_NOT_CapAddress : u64 = 1001;
        const ERR_HEIGHT_TOO_SMALL : u64 = 1002;
        const ERR_YOUR_HERO_TOO_MUCH : u64 = 1003;

        struct STCHeroReservationPass has drop ,store,key{
            height:u64,
        }
        struct STCHeroAttribute has key,store,copy,drop{
            Str:u8,
            Int:u8,
            Dex:u8,
            Vil:u8,
            Talent:u8
        }

        struct HeroExtend has copy,store,drop{

        }

        struct STCHero has copy,store,drop{

        }
        struct ShardMinCap has key, store{
            cap: NFT::MintCapability<STCHeroAttribute>,
        }
        fun create_STCHeroAttribute(account:&signer):STCHeroAttribute{
        
           let parent_hash = Block::get_parent_hash();
             let account_address =  Signer::address_of(account);
             let account_key = Account::authentication_key(account_address);
             let res = Vector::empty<u8>();
              let i = 1;
               while(i < 6){
                   
                let value1= *Vector::borrow<u8>(& account_key,i) ;
                let value2 = *Vector::borrow<u8>(& parent_hash,i);
                let _value = 0;
                if(value1 >= (255 - value2 )){
                 let value =  (value2  -  (255 - value1)) % 51;
                 Vector::push_back(&mut res,value);
                }
                else{
                  let  value = (value1 + value2) % 51;
                  Vector::push_back(&mut res,value);
                };
                
                
                   i = i + 1;
               };

            return   STCHeroAttribute{
                Str:*Vector::borrow<u8>(& res,0),
                Int:*Vector::borrow<u8>(& res,1),
                Dex:*Vector::borrow<u8>(& res,2),
                Vil:*Vector::borrow<u8>(& res,3),
                Talent:*Vector::borrow<u8>(& res,4)
            }
        }
        fun create_STCHeroNFT(account:&signer):NFT::NFT<STCHeroAttribute,HeroExtend> acquires ShardMinCap{
               let heroAttribute = create_STCHeroAttribute(account);
               let nFTmeta       = NFT::new_meta(Vector::empty<u8>(),Vector::empty<u8>());
               let account_address =  Signer::address_of(account);
               let capAddress  : address  = @0x7a9704AAf75FaC779dF5e7f802b121b0;
                let cap = borrow_global_mut<ShardMinCap>(capAddress);
                let heroNft = NFT::mint_with_cap<STCHeroAttribute, HeroExtend, STCHero>(account_address, &mut cap.cap, nFTmeta, heroAttribute, HeroExtend{});
               return heroNft
        }
         fun get_STCHeroReservationPass_height(pass:&STCHeroReservationPass):u64{
                pass.height
        }
         fun create_STCHeroReservationPass(height:u64):STCHeroReservationPass{
                return STCHeroReservationPass{
                    height:height
                }
        }


          fun  mint1(account:&signer){
            let account_address =  Signer::address_of(account);

            if(!NFTGallery::is_accept<STCHeroAttribute,HeroExtend>(account_address)){
                    NFTGallery::accept<STCHeroAttribute,HeroExtend>(account);
                };
            
        }

          fun  mint2(account:&signer){
            let account_address =  Signer::address_of(account);

            assert(NFTGallery::count_of<STCHeroAttribute,HeroExtend>(account_address) < 10,  Errors::invalid_argument(ERR_YOUR_HERO_TOO_MUCH));

        }
          fun  mint3(_account:&signer){
            let new_id = NFT::nft_type_info_counter<STCHeroAttribute,STCHero>();

            assert(new_id < 10000,  Errors::invalid_argument(ERR_STCHERO_TOO_MUCH));
        }
          fun  mint4(account:&signer)acquires STCHeroReservationPass,ShardMinCap{
            let account_address =  Signer::address_of(account);

            if(exists<STCHeroReservationPass>(account_address)){
                mint6(account);
                mint7(account)
            }else{
                mint5(account)
            }
        
        }
          fun  mint5(account:&signer){

                let block_number = Block::get_current_block_number();
                let new_block_number = block_number + 3;
                let reservationPass = create_STCHeroReservationPass(new_block_number);
                move_to(account,reservationPass);
        
        }
         fun  mint6(account:&signer)acquires STCHeroReservationPass{
            let block_number = Block::get_current_block_number();
            let account_address =  Signer::address_of(account);
            let reservationPass = borrow_global<STCHeroReservationPass>(account_address);
            assert(get_STCHeroReservationPass_height(reservationPass) < block_number, Errors::invalid_argument(ERR_HEIGHT_TOO_SMALL));

        }
            fun  mint7(account:&signer)acquires ShardMinCap,STCHeroReservationPass{
            //   let account_address =  Signer::address_of(account);
                let nft = create_STCHeroNFT(account);
                // let reservationPass = borrow_global_mut<STCHeroReservationPass>(account_address);
                NFTGallery::deposit<STCHeroAttribute,HeroExtend>(account,nft);
                let STCHeroReservationPass {   height:_ } = move_from(Signer::address_of(account));
          }
        public (script) fun  mint(account:signer) acquires STCHeroReservationPass , ShardMinCap{
                mint1(&account);
                mint2(&account);
                mint3(&account);
                mint4(&account);
            // let account_address =  Signer::address_of(&account);

            // if(!NFTGallery::is_accept<STCHeroAttribute,HeroExtend>(account_address)){
            //         NFTGallery::accept<STCHeroAttribute,HeroExtend>(&account);
            //     };

            // assert(NFTGallery::count_of<STCHeroAttribute,HeroExtend>(account_address) < 10,  Errors::invalid_argument(ERR_YOUR_HERO_TOO_MUCH));

            

            // let new_id = NFT::nft_type_info_counter<STCHeroAttribute,STCHero>();

            // assert(new_id < 10,  Errors::invalid_argument(ERR_STCHERO_TOO_MUCH));

            // let reservationPass = borrow_global<STCHeroReservationPass>(account_address);

            

            // if(exists<STCHeroReservationPass>(account_address)){
            //     let block_number = Block::get_current_block_number();

            //     assert(get_STCHeroReservationPass_height(reservationPass) < block_number, Errors::invalid_argument(ERR_HEIGHT_TOO_SMALL));

            //     let nft = create_STCHeroNFT(&account);

            //     NFTGallery::deposit<STCHeroAttribute,HeroExtend>(&account,nft);

            //     let STCHeroReservationPass {
            //         height:_

            //     } = reservationPass ;

            // }else{
            //     let block_number = Block::get_current_block_number();
            //     let new_block_number = block_number + 5;
            //     let reservationPass = create_STCHeroReservationPass(new_block_number);
            //     move_to(&account,reservationPass);
            // }
            
            
        }
        public (script) fun init(account:signer){
            let capAddress  : address  = @0x7a9704AAf75FaC779dF5e7f802b121b0;
            let account_address =  Signer::address_of(&account);

            assert(capAddress == account_address,  Errors::invalid_argument(ERR_NOT_CapAddress));
            
                
            NFT::register<STCHeroAttribute,STCHero>(&account,STCHero{},NFT::empty_meta());
            let nft_mint_cap = NFT::remove_mint_capability<STCHeroAttribute>(&account);
            move_to(&account, ShardMinCap {cap:nft_mint_cap});
        }
       
        
    }
}