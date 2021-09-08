address 0x2{
    module Test{
        use 0x1::Signer;
        struct T has key,store{
            i:u64
        }
        public fun init(account : &signer){
            move_to(account,T{i:0})
        }
        public fun set(account : &signer,i:u64) acquires T {
            let account_address =  Signer::address_of(account);
            let t = borrow_global_mut<T>(account_address);
            t.i = i;
        }
        public fun ret(add:address):u64 acquires T{
            let t =(borrow_global<T>(add));
            t.i
        }
    }
}