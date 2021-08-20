import SomeContract from "./some_contract.cdc"

transaction {
    prepare(account: AuthAccount) {
        // Area 4
        log("Transaction read scope: a,b")
        log(SomeContract.testStruct.a)
        log(SomeContract.testStruct.b)

        log("Write scope: a")
        SomeContract.testStruct.a = "A transaction set this :)"

        // Functions accessible: publicFunc, structFunc 
        SomeContract.testStruct.publicFunc()
        SomeContract.testStruct.structFunc()

        let someResource <- SomeContract.createSomeResource()
        someResource.resourceFunc() // sets A + E
        log(someResource.e)
        destroy someResource

        log(SomeContract.testStruct.a)
    }
}
