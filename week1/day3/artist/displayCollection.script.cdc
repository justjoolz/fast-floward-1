import Artist from "./contract.cdc"

// Return an array of formatted Pictures that exist in the account with the a specific address.
// Return nil if that account doesn't have a Picture Collection.
pub fun main(address: Address): [String]? {
    let collectionRef = borrowReferenceFor(account: address) 
    if collectionRef == nil { return nil }
    return collectionRef!.getPictures()
}

pub fun borrowReferenceFor(account: Address) : &Artist.Collection{Artist.Viewer}? {
   return getAccount(account)
      .getCapability<&Artist.Collection{Artist.Viewer}>
      (/public/ArtistCollectionViewer)
      .borrow()
}