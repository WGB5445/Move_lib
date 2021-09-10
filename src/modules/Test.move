address 0x2{
    module Test{
        use 0x1::Signer;
        struct B has key,store,drop,copy{
            d : u64
        }
        struct T has  key,store{
            i:u64,
            b:B,
        }
        public fun init(account : &signer){
            move_to(account,T{i:0,b:B{d :1}})
        }
        public fun set(account : &signer,_i:u64) acquires T {
            let account_address =  Signer::address_of(account);
            let t = borrow_global_mut<T>(account_address);
            let b = B{d :100};
            set_TB( t,&b);
        }
        public fun ret_i(add:address):u64 acquires T{
            let t =(borrow_global<T>(add));
            t.i
        }
        public fun ret_B(add:address):u64 acquires T{
            let t =(borrow_global<T>(add));
            t.b.d
        }
        public fun set_B(b:&mut B){
                b.d = 2; 
        }
       public fun set_TB(t:&mut T,b:& B){
           SET_B(&mut t.b,b);
       }
       public fun SET_B(b:&mut B,b1:&B){
           b.d = b1.d;
       }
    }
}