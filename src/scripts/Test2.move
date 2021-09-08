script {
    use 0x1::Debug;
    use 0x2::Test;
    use 0x1::Signer;
    //move publish
    //move run src/scripts/test.move --signers 0x2
    fun main(account: signer,i:u64) {
        Test::set(&account,i);
        let account_address =  Signer::address_of(&account);
        Debug::print<u64>(&Test::ret(account_address))
    }
}