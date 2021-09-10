script {
    use 0x1::Debug;
    use 0x2::Test;
    use 0x1::Signer;
    //move publish
    //move run src/scripts/test.move --signers 0x2
    fun main(account: signer) {
        Test::init(&account);
        let account_address =  Signer::address_of(&account);
        Debug::print<u64>(&Test::ret_i(account_address));
         Debug::print<u64>(&Test::ret_B(account_address));
        Test::set(&account,1);
        Debug::print<u64>(&Test::ret_i(account_address));
        Debug::print<u64>(&Test::ret_B(account_address));
    }
}