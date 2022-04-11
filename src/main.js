import initializeQuark from "@departurelabs/quark.js";

const domain =
  process.env.NODE_ENV === "development"
    ? "http://localhost:3000"
    : "https://pwwjo-6qaaa-aaaam-aadka-cai.ic0.app";
const integrator =
  process.env.NODE_ENV === "development"
    ? // Quark history canister ID
      // TODO: why do we do this again? Place comment
      "zklby-kaaaa-aaaah-qcntq-cai"
    : process.env.COOKIE_CANISTER_ID;

const { checkout } = initializeQuark({
  authProvider: "ii",
  domain, //: "https://pwwjo-6qaaa-aaaam-aadka-cai.ic0.app",
  notify: {
    principalId: "sbzkb-zqaaa-aaaaa-aaaiq-cai", // process.env.COOKIE_CANISTER_ID,
    methodName: "callback",
  },
  integrator, //: "znkhm-hyaaa-aaaah-qcnta-cai",
  callback: (event) => {
    if (event.type === "checkoutComplete") {
      if (event.data.result === "Accepted") {
        checkoutComplete();
      } else {
        checkoutFailed();
      }
    }
  },
});

const basket = [
  {
    name: "1.4 mg of chocolate in capsule format",
    description: "Sustinance for the soul",
    value: 100000,
    token: "ICP",
  },
];
document.getElementById("myBtn").addEventListener("click", purchase);

function purchase() {
  checkout(basket);
}

function checkoutComplete() {
  alert("Checkout Complete");
}

function checkoutFailed() {
  alert("Checkout aborted");
}
