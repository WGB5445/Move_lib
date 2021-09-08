address 0x2 {
    module Base64{
        use 0x1::Vector;
        use 0x1::Debug;
        public fun encode(str:vector<u8>):vector<u8>{
            if(Vector::is_empty(&str)){
                return Vector::empty<u8>()
            };
            let size = Vector::length(& str);
            let len64  =  if(size % 3 == 0)  {
                (size/3*4)  
            }  
            else{  
                (size/3+1)*4
            };
            let str_buf = str;

            Vector::push_back(&mut str_buf,0);
            let base64_table = Vector::empty<u8>();
            let big_word = 65;
            while(big_word < 91){
                Vector::push_back(&mut base64_table,big_word);
                big_word = big_word + 1;
            };
            let l_word = 97;
            while(l_word < 123){
                Vector::push_back(&mut base64_table,l_word);
                l_word = l_word + 1;
            };
            Vector::push_back(&mut base64_table,43);
            Vector::push_back(&mut base64_table,47);
            let eq:u8 = 61;
            let res = Vector::empty<u8>();
            let l = 0;
            while(l < len64){
                Vector::push_back(&mut res,0);
                l = l + 1;
            };

            let m = 0 ; 
            let n = 0 ;
            while(m < len64 - 2){
                *Vector::borrow_mut(&mut res,m)     = *Vector::borrow(& base64_table,((*Vector::borrow(&str_buf,n) >> 2) as u64));
                *Vector::borrow_mut(&mut res,m + 1) = *Vector::borrow(& base64_table,((((*Vector::borrow(&str_buf,n) & 3) << 4)  | (*Vector::borrow(&str_buf,n + 1) >> 4) )as u64));
                *Vector::borrow_mut(&mut res,m + 2) = *Vector::borrow(& base64_table,((((*Vector::borrow(&str_buf,n + 1) & 15) << 2) | (*Vector::borrow(&str_buf,n + 2) >> 6))as u64));
                *Vector::borrow_mut(&mut res,m + 3) = *Vector::borrow(& base64_table,(((*Vector::borrow(&str_buf,n + 2) & 63))as u64));
                
                m = m + 4;
                n = n + 3;
            };
            if(size % 3 == 1){
                *Vector::borrow_mut(&mut res,m - 2) = eq;
                *Vector::borrow_mut(&mut res,m - 1) = eq;   
            }
            else if(size % 3 == 2){
                *Vector::borrow_mut(&mut res,m - 1) = eq;
            };

            return res
        }
    }
}