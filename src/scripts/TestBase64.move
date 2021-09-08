script {
    use 0x1::Vector;
    use 0x1::Debug;
    use 0x2::Base64;
    //move publish
    //move run src/scripts/test.move --signers 0x2
    fun main(_account: signer) {
        let str = Vector::empty<u8>();
        Vector::push_back(&mut str,66);
        Vector::push_back(&mut str,114);
        Vector::push_back(&mut str,100);
        Debug::print(&Base64::encode(str));
    }
}