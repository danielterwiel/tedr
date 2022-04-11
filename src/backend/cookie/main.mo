import Array "mo:base/Array";
import Result "mo:base/Result";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";

actor {

// Transaction callback types

// Your metadata. Do not trust these values
// always verify things make sense
public type BasketValue = Text;

// Token being sent and amount sent
public type BalanceValue = {
    #ICP : {e8s : Nat64};
};

public type NotificationValue = {
    id           : Nat;          // Transaction Id
    basket       : BasketValue;  // Metadata. Verify Correctness! 
    amount       : BalanceValue; // Amount actually sent. Verify Correctness!
    receivedAt   : Int;          // In nanoseconds
    integrator   : Principal;    // Payee. Verify Correctness!
};

public type Notification = {
    #Request  : NotificationValue;

    #Failed  : {
        #Canceled : NotificationValue;
        #TimedOut : NotificationValue;
    };

    #Success : NotificationValue;
};

// Hub Interactions
public type Action = {
    #Accept : {id : Nat}; // id, transaction id
    #Reject : {id : Nat; reason : Text}; 
    // id, transaction id. reason, short error message to display in 
    // quark checkout
};

public type ActionError = {
    #Unauthorized;
    #NotFound : Nat;
    #WrongState;
};

public type ActionResult = Result.Result<(), ActionError>;

public type QuarkHub = actor {
	transactionAction : shared Action -> async ActionResult
};

// example callback function in your actor you'd pass via the frontend libary
// You must provide quarkHubPrincipal

let quarkHubPrincipal : Principal = Principal.fromText("renrk-eyaaa-aaaaa-aaada-cai");
let ourPrincipalId :Principal = Principal.fromText("zklby-kaaaa-aaaah-qcntq-cai");

// testnet_principal_id : pwwjo-6qaaa-aaaam-aadka-cai
public shared ({caller}) func callback(notification : Notification) : async () {
    Debug.print(debug_show "callback called");
    switch(notification){
        case(#Request(value)){
            Debug.print(debug_show "caller");
            Debug.print(debug_show caller);
            Debug.print(debug_show "quarkHubPrincipal");
            Debug.print(debug_show quarkHubPrincipal);

            Debug.print(debug_show "value.integrator");
            Debug.print(debug_show value.integrator);
            Debug.print(debug_show "ourPrincipalId");
            Debug.print(debug_show ourPrincipalId);
	        if(caller == quarkHubPrincipal and value.integrator == ourPrincipalId) {
		        let quarkHub : QuarkHub = actor (Principal.toText(caller));

            Debug.print(debug_show "callback 3");
						
            // Note : Await snapshots all above ^
	          switch(await quarkHub.transactionAction(#Accept({id = value.id}))){
	              case(#ok()){
	                 // Tokens are now in your account. Place all success code here.
                     Debug.print(debug_show "callback 4");
                    
	              };
	              case(#err(_)){
									 // Something went wrong. Tokens are NOT in your account.
                   // Maybe user cancelled. 
                   Debug.print(debug_show "callback 5");
                  
	              };
	          };
		     } else {
						 // Caller doesn't have permissions to invoke this function!
	           assert false;
	       };
       };
      case(_){
				// Handle other Notification types!
      };
    };
};
}
