using System;
 
namespace Tastier { 

public class Obj { // properties of declared symbol
   public string name; // its name
   public int kind;    // var, proc or scope
   public int type;    // its type if var (undef for proc)
   public int level;   // lexic level: 0 = global; >= 1 local
   public int adr;     // address (displacement) in scope 
   public Obj next;    // ptr to next object in scope
   public int mutability; // whether it is a constant or not
   public int arraySize;   // size of one dimen array
   // if its an array this will be a int
   // otherwise it will be null
   // for scopes
   public Obj outer;   // ptr to enclosing scope
   public Obj locals;  // ptr to locally declared objects
   public int nextAdr; // next free address in scope
   public int numParams;   // the number of param going into a function
   public Obj [] parameters;    // the types of each param - going to make it so it can have a max of 30 params

}

public class SymbolTable {

   const int
      mutable=0, immutable =1;

   const int // object kinds
      var = 0, proc = 1, scope = 2, array= 3, constant=4; 

   const int // types
      undef = 0, integer = 1, boolean = 2;
   

   public Obj topScope; // topmost procedure scope
   public int curLevel; // nesting level of current scope
   public Obj undefObj; // object node for erroneous symbols

   public bool mainPresent;
   
   Parser parser;
   
   public SymbolTable(Parser parser) {
      curLevel = -1; 
      topScope = null;
      undefObj = new Obj();
      undefObj.name = "undef";
      undefObj.kind = var;
      undefObj.type = undef;
      undefObj.level = 0;
      undefObj.adr = 0;
      undefObj.next = null;
      this.parser = parser;
      mainPresent = false;
   }

// open new scope and make it the current scope (topScope)
   public void OpenScope() {
      Obj scop = new Obj();
      scop.name = "";
      scop.kind = scope; 
      scop.outer = topScope; 
      scop.locals = null;
      scop.nextAdr = 0;
      topScope = scop; 
      curLevel++;
   }

// close current scope
   public void CloseScope() {
      Obj current = topScope.locals;
      while(current!=null){
         Console.WriteLine("           ;"+ current.name + " type : " + current.type + " scope : " +current.level);  // level : 0 global - 1 local
         current = current.next;
      }
      topScope = topScope.outer;
      curLevel--;
   }

// open new sub-scope and make it the current scope (topScope)
   public void OpenSubScope() {
   // lexic level remains unchanged
      Obj scop = new Obj();
      scop.name = "";
      scop.kind = scope;
      scop.outer = topScope;
      scop.locals = null;
   // next available address in stack frame remains unchanged
      scop.nextAdr = topScope.nextAdr;
      topScope = scop;
   }

// close current sub-scope
   public void CloseSubScope() {
      Obj current = topScope.locals;
      while(current!=null){
         Console.WriteLine("           ;"+ current.name + " type : " + current.type + " scope : " +current.level);  // level : 0 global - 1 local
         current = current.next;
      }
   // update next available address in enclosing scope
      topScope.outer.nextAdr = topScope.nextAdr;
   // lexic level remains unchanged
      topScope = topScope.outer;
   }

// create new object node in current scope
   public Obj NewObj(string name, int kind, int type) {
      Obj p, last; 
      Obj obj = new Obj();
      obj.name = name; obj.kind = kind;
      obj.type = type; obj.level = curLevel; 
      obj.next = null; 
      p = topScope.locals; last = null;
      while (p != null) { 
         if (p.name == name)
            parser.SemErr("name declared twice");
         last = p; p = p.next;
      }
      if (last == null)
         topScope.locals = obj; else last.next = obj;
      if (kind == var){
         obj.adr = topScope.nextAdr++;
         obj.mutability = mutable;           // assume vars are mutable
         }
      else if(kind == proc){
         obj.parameters = new Obj[30];                // max number of params
      } 
      // if(obj.kind == constant){
      //    obj.mutability = immutable;          // constants are immutable
      // }
      return obj;
   }
   public Obj NewObjParam(string name, int kind, int type){       // doesnt update address
      Obj p, last; 
      Obj obj = new Obj();
      obj.name = name; obj.kind = kind;
      obj.type = type; obj.level = curLevel; 
      obj.next = null; 
      p = topScope.locals; last = null;
      while (p != null) { 
         if (p.name == name)
            parser.SemErr("name declared twice");
         last = p; p = p.next;
      }
      if (last == null)
         topScope.locals = obj; else last.next = obj;
      // if(obj.kind == constant){
      //    obj.mutability = immutable;          // constants are immutable
      // }
      return obj;
   }
   public void updateAddressParam(Obj obj, int address){
     // parser.SemErr("obj adress = " +obj.adr + "address = " +address);
      obj.adr = address;
   }
   public Obj getParameterObject(Obj obj, int count){
      return obj.parameters[count];
   }


   public void addNextTypeToFunc(Obj obj, String name){    // adds types of params to the array
      Obj toAdd = Find(name);
      obj.parameters[obj.numParams] = toAdd;
      toAdd = obj.parameters[obj.numParams];
   }
   public void checkTypeIsSame(Obj obj, int type, int count){                     // checks that the param being sent in has the same type as described
      if(obj.parameters[count].type!=type){
         parser.SemErr("The parameter at " + count + " of type "+ type +" does not match "+ obj.parameters[count].type);
      }
   }
   
   public void allocateArrayAdrs(Obj obj){
      obj.adr = topScope.nextAdr++;
      topScope.nextAdr =topScope.nextAdr+(obj.arraySize-1);
   }
// search for name in open scopes and return its object node
   public Obj Find(string name) {
      Obj obj, scope;
      scope = topScope;
      while (scope != null) { // for all open scopes
         obj = scope.locals;
         while (obj != null) { // for all objects in this scope
            if (obj.name == name) return obj;
            obj = obj.next;
         }
         scope = scope.outer;
      }
      parser.SemErr(name + " is undeclared");
      return undefObj;
   }
   //stuff for arrays...
   public bool isValidArrayAccess(Obj obj, int index){
      return false;
   }
   public void addArraySize(int Expr){
      return; 
   } 

} // end SymbolTable

} // end namespace
