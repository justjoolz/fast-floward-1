import SomeContract from "./some_contract.cdc"

pub fun main() {
  log("Read scope: a,b")
  log(SomeContract.testStruct.a)
  log(SomeContract.testStruct.b)

  // Trick question? :)
  SomeContract.questsAreFun() // temporarily writes to variables but doesn't commit to chain 

  // Area 4
  // 
  log("Trick question?")
  log("Read scope: a,b")
  log(SomeContract.testStruct.a)
  log(SomeContract.testStruct.b)

  log("Write scope: kinda 'a' kinda none :)")
  log("if this was a transaction writes to SomeContract.testStruct.a would be persisted")
  SomeContract.testStruct.a = "A script can temporarily/virtually write!"
  log(SomeContract.testStruct.a)


  // Functions accessible: publicFunc 
  SomeContract.testStruct.publicFunc()
}
