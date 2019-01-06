<template>
    <div style="margin-top:18%, padding-bottom:50px;">
        <div v-if="is_registered===''">

  <div class="card-form" style="margin-left:400px;margin-top: 200px">
  <form class="signup">
    <div class="form-title">RECEIPIENT REGISTER HERE !!!</div>
    <div class="form-body">
      <div class="row">
        <input v-model="recipient_name" type="text" placeholder="First Name*">

      </div>
      <div class="row">
      <input v-model="recipient_email" type="text" placeholder="email*">
      </div>
      <div class="row">
        <input v-model="recipient_phone" type="text" placeholder="phone number">
      </div>

    </div>
    <div class="rule"></div>
    <div class="form-footer">
      <button  @click="registerRecipient">SUBMIT</button>
    </div>
  </form>
</div>
        </div>
        <div v-else style="background-color:rgba(244, 246, 246, 0.45);margin-left:400px;margin-right:400px;margin-top:70px">

            <h1 style="padding-top:40px;">View your Certificates</h1>

            <buttons @click="getRecipientCertificates">Get All Certificates</buttons>
            <br><span v-if="data_getRecipientCertificates != []">{{data_getRecipientCertificates}}</span><br><br>

            <buttons @click="getProfileDetails">Get Your Details</buttons>
            <br><span v-if="data_getProfileDetails">{{data_getProfileDetails | details}}</span><br><br>

            <div class="row1">
              <input  type="text" v-model="certID" placeholder="Enter certificate id">

            </div>

            <buttons @click="getCertificateIdentifier">Get Certificate Details</buttons>
            <br><span v-if="data_getCertificateIdentifier">{{data_getCertificateIdentifier}}</span>
		<h4>FOR e-Certificate click here</h4>
            <router-link :to="{ name: 'certPage', params: { ipfs:view_ipfs, time:view_time, issure:view_issure, recipient:view_recipent, ctype:view_ctype, cname:view_cname, cdes:view_cdes} }">Navigate to certificate</router-link>
             <br><br>

            <div class="row1">
              <input type="text" v-model="address_issuer" placeholder="Enter address of issuer">

            </div>

            <buttons @click="getIssuer">Get Issuer Details</buttons>
            <br><span v-if="data_getIssuer">{{data_getIssuer}}</span><br><br>


            <div class="row1">
              <input type="text" v-model="hash_contract" placeholder="Enter hash of certificate">

            </div>

            <buttons @click="getIssuerOfCertificate">Get Issuer of certificate</buttons>
            <br><span v-if="data_getIssuerOfCertificate">{{data_getIssuerOfCertificate}}</span><br><br>
        </div>
    </div>
</template>

<script>
import CertChain from '@/js/certchain'
const ipfs = require('nano-ipfs-store').at('https://ipfs.infura.io:5001')
export default {
  name: 'recipientPage',
  data () {
    return {
      user: null,
      is_registered: null,
      recipient_name: null,
      recipient_email: null,
      recipient_phone: null,
      data_getRecipientCertificates: null,
      data_getProfileDetails: null,
      data_getCertificateIdentifier: null,
      certID: null,
      address_issuer: null,
      address_recipient: null,
      data_getIssuer: null,
      data_getIssuerOfCertificate: null,
      hash_contract: null,
      view_ipfs: null,
      view_time: null,
      view_issure: null,
      view_recipent: null,
      view_cname: null,
      view_ctype: null,
      view_cdes: null
    }
  },
  filters: {
    details (user) {
      return `Name: ${user.recipient_name}, Email: ${user.recipient_email}, Phone: ${user.recipient_phone}`
    //   return `${user['recipient_name']}`
    }
  },
  beforeCreate: function () {
    CertChain.init().then(() => {
      console.log('contract: ' + CertChain.contract.address)
      console.log('user: ' + window.web3.eth.accounts[0])
      this.user = window.web3.eth.accounts[0]
      CertChain.getRecipient(this.user).then((ans) => {
        this.is_registered = ans
      })
    }).catch(err => {
      console.log(err)
    })
  },
  methods: {
    registerRecipient: function () {
      let data = JSON.stringify({'recipient_name': this.recipient_name, 'recipient_email': this.recipient_email, 'recipient_phone': this.recipient_phone})
      console.log(data)
      ipfs.add(data).then(ipfsHash => {
        console.log(ipfsHash)
        CertChain.registerRecipient(ipfsHash).then(tx => {
          console.log(tx)
          alert('Recipient registered')
          this.is_registered = true
        })
      })
    },
    getRecipientCertificates: function () {
      CertChain.getRecipientCertificates(this.user).then((tx) => {
        this.data_getRecipientCertificates = tx
        console.log(JSON.stringify(this.data_getRecipientCertificates))
      })
    },
    getProfileDetails: function () {
      CertChain.getRecipient(this.user).then((tx) => {
        console.log(tx)
        ipfs.cat(tx).then((data) => {
          this.data_getProfileDetails = JSON.parse(data)
          console.log(JSON.stringify(this.data_getProfileDetails))
        })
      })
    },
    getCertificateIdentifier: function () {
      console.log(this.certID)
      CertChain.getCertificateIdentifier(this.certID).then((tx) => {
        if (tx[0] !== '') {
          this.data_getCertificateIdentifier = tx
          this.view_ipfs = tx[0]
          this.view_time = tx[1]
          this.view_issure = tx[2]
          this.view_recipent = tx[3]
          this.view_cname = tx[5]
          this.view_ctype = tx[4]
          this.view_cdes = tx[6]
        }
        console.log(this.data_getCertificateIdentifier)
      })
    },
    getIssuer: function () {
      console.log(this.address_issuer)
      CertChain.getIssuer(this.address_issuer).then((tx) => {
        if (tx[0] !== '') {
          this.data_getIssuer = tx
        }
        console.log(this.data_getIssuer)
      })
    },
    getIssuerOfCertificate: function () {
      console.log(this.hash_contract)
      CertChain.getIssuerOfCertificate(this.hash_contract).then((tx) => {
        this.data_getIssuerOfCertificate = tx
      })
      console.log(this.data_getIssuerOfCertificate)
    }
  }
}
</script>

<style scoped>
@import url(https://fonts.googleapis.com/css?family=Raleway:400,700);
body {
  display: flex;
  height: 100vh;
  justify-content: center;
  align-items: center;
  background: #c0392b;
  font-family: Raleway;
  color: white;
  letter-spacing: 1px;
}

.card-form {
  width: 500px;
  border-radius: 10px;
  background: rgba(0,0,0,0.5);
  box-shadow: 0 27px 55px 0 rgba(0, 0, 0, 0.3), 0 17px 17px 0 rgba(0, 0, 0, 0.15);

}
.card-form .form-title {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 80px;
  font-size: 20px;
  font-weight: bold;
  background: #9EBFDC  ;
  border-radius: 10px 10px 0 0;
}
.card-form .form-body {
  padding: 10px;
}
.card-form .form-body .row {
  display: flex;
  justify-content: space-around;
  padding: 10px;
}
.card-form .form-body .row input[type="text"] {
  -webkit-appearance: none;
     -moz-appearance: none;
          appearance: none;
  width: 100%;
  margin: 0 15px;
  height: 35px;
  padding: 5px 15px;
  border-radius: 20px;
  outline: none;
  border: none;
  color: black;
  font-size: 14px;
  background: rgba(223, 233, 240,0.8);
}
.card-form .rule {
  height: 2px;
  background: #e8ebed;
  margin: 0px 35px;
}
.card-form .form-footer {
  margin: 0 25px 15px 25px;
  padding: 15px 10px;
}
.card-form .form-footer a {
  display: inline-block;
  height: 40px;
  line-height: 40px;
  border: none;
  border-radius: 5px;
  padding: 5px 15px;
  background: #27ae60;
  margin-right: 10px;
  font-size: 14px;
}
.card-form .form-footer span {
  margin-left: 8px;
}
 button{
      display: inline-block;
      height: 40px;
      line-height: 40px;
      border: none;
      border-radius: 5px;
      padding: 5px 15px;
      background: #9EBFDC;
      margin-right: 10px;
      font-size: 14px;
    }
    buttons{
      display: inline-block;
      height: 40px;
      line-height: 40px;
      border: none;
      border-radius: 20px;
      padding: 5px 15px;
      background: #337BB4;
      margin-right: 10px;
      font-size: 14px;
      color: white;
    }
    .row1 input[type="text"] {
  -webkit-appearance: none;
     -moz-appearance: none;
          appearance: none;
  width: 300px;
  margin: 10px 15px;
  height: 35px;
  padding: 5px 15px;
  border-radius: 20px;
  outline: none;
  border: none;
  color: black;
  font-size: 14px;

}
buttons:hover {
      cursor: pointer;
    }
span {
    color: black;
    font-weight: bold;
    font-size: 25px;
}
</style>
