import "./style.css";

import initializeQuark from "@departurelabs/quark.js";

const domain =
  process.env.NODE_ENV === "development"
    ? "http://localhost:3000"
    : "https://pwwjo-6qaaa-aaaam-aadka-cai.ic0.app";
const integrator =
  process.env.NODE_ENV === "development"
    ? "rno2w-sqaaa-aaaaa-aaacq-cai" // === Quark hub ID,
    : process.env.PRODUCTS_CANISTER_ID;

const { checkout } = initializeQuark({
  authProvider: "ii",
  domain, // : "https://pwwjo-6qaaa-aaaam-aadka-cai.ic0.app",
  notify: {
    principalId: "znkhm-hyaaa-aaaah-qcnta-cai",
    methodName: "callback",
  },
  integrator, //: "znkhm-hyaaa-aaaah-qcnta-cai",
  callback: (event) => {
    console.log("event", event);
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
  console.log("purchase");
  console.log(basket);
  checkout(basket);
}

function checkoutComplete() {
  alert("Checkout Complete");
}

function checkoutFailed() {
  alert("Checkout aborted");
}
