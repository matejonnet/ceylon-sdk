"A link in a singly linked list."
serializable class Cell<Element>(element, rest) {
    "The element belonging to this link."
    shared variable Element element;
    "The next link in the list."
    shared variable Cell<Element>? rest;
    // shallow clone
    shared Cell<Element> clone()
            => Cell(element, rest?.clone());
}

class CellIterator<Element>(iter) 
        satisfies Iterator<Element> {
    variable Cell<Element>? iter;
    
    shared actual Element|Finished next() {
        if (exists iter = iter) {
            this.iter = iter.rest;
            return iter.element;
        }
        return finished;
    }
}

"A link in a singly linked list with an attribute to cache 
 hash codes."
serializable class CachingCell<Element>(element, keyHash, rest) {
    "The element belonging to this link."
    shared variable Element element;
    "The hash code of the element (sets) or key (maps) for 
     this cell."
    shared variable small Integer keyHash;
    "The next link in the list."
    shared variable CachingCell<Element>? rest;
    // shallow clone
    shared CachingCell<Element> clone()
            => CachingCell(element, keyHash, rest?.clone());
}

class CachingCellIterator<Element>(iter) 
        satisfies Iterator<Element> {
    variable CachingCell<Element>? iter;
    
    shared actual Element|Finished next() {
        if (exists iter = iter) {
            this.iter = iter.rest;
            return iter.element;
        }
        return finished;
    }
}