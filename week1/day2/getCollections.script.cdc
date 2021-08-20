import Artist from 0x02

pub fun main() {
  // Quest W1Q4  
   let accounts : [Address] = [0x01, 0x02, 0x03, 0x04, 0x05]
   var i=0
   while i < accounts.length {
      let collectionRef = borrowReferenceFor(account: accounts[i]) 
      
      if collectionRef != nil {
         log("Account: "
            .concat( accounts[i].toString() )
            .concat(" has ".concat(collectionRef!.getTotalPictures().toString())
            .concat("pictures to display"))
         )
         collectionRef!.logPictures()
      } else {
         log("Account: ".concat( accounts[i].toString() ).concat(" has no pictures to display"))
      }

      i = i + 1
   }
}

pub fun borrowReferenceFor(account: Address) : &Artist.Collection{Artist.Viewer}? {
   return getAccount(account)
      .getCapability<&Artist.Collection{Artist.Viewer}>
      (/public/ArtistCollectionViewer)
      .borrow()
}