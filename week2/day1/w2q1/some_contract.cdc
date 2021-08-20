access(all) contract SomeContract {
    pub var testStruct: SomeStruct

    pub struct SomeStruct {
        // 4 Variables
        //
        pub(set) var a: String

        pub var b: String

        access(contract) var c: String

        access(self) var d: String

        // 3 Functions
        //
        pub fun publicFunc() {}

        access(self) fun privateFunc() {}

        access(contract) fun contractFunc() {}


        pub fun structFunc() {
            // Area 1
            // Read scope: a,b,c,d
            log(self.a)
            log(self.b)
            log(self.c)
            log(self.d)
            // Write scope: a,b,c,d
            self.a = "A structFunc set this"
            self.b = "B structFunc set this"
            self.c = "C structFunc set this"
            // Functions accessible: publicFunc, privateFun, contractFunc 
            self.publicFunc()
            self.privateFunc()
            self.contractFunc()
        }

        init() {
            self.a = "a"
            self.b = "b"
            self.c = "c"
            self.d = "d"
        }
    }

    pub resource SomeResource {
        pub var e: Int

        pub fun resourceFunc() {
            // Area 2
            log("Resource Func() {")
            log("Read scope: a,b,c,e")
            log("   ".concat(SomeContract.testStruct.a))
            log("   ".concat(SomeContract.testStruct.b))
            log("   ".concat(SomeContract.testStruct.c))
            log("   ".concat(self.e.toString()))
            log("   ".concat("Write scope: a (if called by transaction)"))
            // if call by transaction will be modified
            SomeContract.testStruct.a = "A! resourceFunc set this!"
            self.e = 0 
            // Functions accessible: publicFunc, contractFunc 
            SomeContract.testStruct.publicFunc()
            SomeContract.testStruct.contractFunc()
            log("}")
        }

        init() {
            self.e = 17
        }
    }

    pub fun createSomeResource(): @SomeResource {
        return <- create SomeResource()
    }

    pub fun questsAreFun() {
        log("QuestsAreFun() {")
        // Area 3
        log("   Read scope: a,b,c") 
        log("   ".concat(self.testStruct.a))
        log("   ".concat(self.testStruct.b))
        log("   ".concat(self.testStruct.c))    
        log("   Write scope: a - if call by transaction will be persisted")
        self.testStruct.a = "~~~ A ~~~ ! Oh My this has actually changed! **BUT** change is only persisted to the chain when called from a transaction......"
        // Functions accessible: publicFunc, contractFunc 
        SomeContract.testStruct.publicFunc()
        SomeContract.testStruct.contractFunc()
        log("}")
    }

    init() {
        self.testStruct = SomeStruct()
    }
}
