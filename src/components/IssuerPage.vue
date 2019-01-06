<template>
    
              <div v-if="is_registered===''">
         <div class="card-form" style="margin-left:400px;margin-top: 120px">
  <form class="signup">
    <div class="form-title">ISSUER REGISTER HERE!!!</div>
    <div class="form-body">
      <div class="row">
        <input v-model="issuer_name" type="text" placeholder="First Name*">

      </div>
      <div class="row">
      <input v-model="issuer_email" type="text" placeholder="email*">
      </div>
      <div class="row">
        <input v-model="issuer_phone" type="text" placeholder="phone number">
      </div>
      <div class="row">
        <input v-model="issuer_url" type="text" placeholder="Url">
      </div>
    </div>
    <div class="rule"></div>
    <div class="form-footer">
      <button @click="registerIssuer">SUBMIT</button>
    </div>
  </form>
</div>
</div>
 <div v-else style="background-color:rgba(244, 246, 246, 0.45);margin-left:350px;margin-right:350px;margin-top:70px">
            <h1 style="padding-top:40px;">Register certificates</h1>
            <select v-model="cert_type"><option v-for="i in certType1" v-bind:value="i">{{i}}</option></select>
            <div class="row1">
              <input type="text" v-model="cert_name" placeholder="Enter name of the certificate">

            </div>
            <div class="row1">
              <input type="text" v-model="cert_desc" placeholder="Enter description of the certificate">

            </div>
            <div class="row1">
              <input type="text" v-model="address_recipient" placeholder="Enter the address of the recipient">

            </div>

            <buttons @click="registerCertificate">Register a new certificate</buttons>

            <h1>Issue certificates</h1>
            <buttons @click="issueCertificate">Issue new certificate</buttons>

            <h1>View your certificates</h1>

            <div class="row1">
              <input type="text" v-model="view_address_recipient" placeholder="Enter recipient's address">

            </div>

            <buttons @click="getRecipient">Get recipient details </buttons>
            <br><span v-if="data_getRecipient">{{data_getRecipient | details}}</span><br><br>

            <buttons @click="getIssuerCertificates">Get all your issued certificates</buttons>

            <table v-model="cert_cname" style="margin-left: 30px;"><tr v-for="certificate in view_cert_table" v-bind:value="certificate" v-model="certID"><td>{{certificate}}</td><td><buttons @click="getCertificateIdentifier">View</buttons></td></tr> </table>
	
              <div class="row1">
              <input type="text" v-model="certID" placeholder="Enter certificate id">

            </div>

            <buttons @click="getCertificateIdentifier">Get Certificate Details</buttons>
            <br><span v-if="data_getCertificateIdentifier">{{data_getCertificateIdentifier}}</span><br><br>

		<h1>FOR Certificate</h1>
            <router-link :to="{ name: 'certPage', params: { ipfs:view_ipfs, time:view_time, issure:view_issure, recipient:view_recipent, ctype:view_ctype, cname:view_cname, cdes:view_cdes} }">Navigate to certificate</router-link>
             <br><br>

             <div class="row1">
              <input type="text" v-model="view_cert_hash" placeholder="Enter certificate hash">

            </div>
            <buttons @click="getAllRecipientOfCertificate">Get all recipient of certificate</buttons>
            <br><span v-if="data_getAllRecipientOfCertificate">{{data_getAllRecipientOfCertificate}}</span><br><br>
        </div>
    </div>
</template>

<script>
import CertChain from '@/js/certchain'
const ipfs = require('nano-ipfs-store').at('https://ipfs.infura.io:5001')
var certType = ['Domicile', 'DateOFBirth', 'Bonafide', 'Course Completion', 'Workshop Completion']
var flag = [5, 10, 15, 20, 25]
export default {
  name: 'issuerPage',
  data () {
    return {
      user: null,
      is_registered: null,
      issuer_name: null,
      issuer_email: null,
      issuer_phone: null,
      issuer_url: null,
      cert_type: null,
      cert_name: null,
      cert_desc: null,
      address_recipient: null,
      certificates: [],
      cert_hash: null,
      view_address_recipient: null,
      data_getRecipient: null,
      all_certs: null,
      data_getCertificateIdentifier: null,
      view_cert_hash: null,
      certID: null,
      data_getAllRecipientOfCertificate: null,
      temp_ipfs: null,
      view_ipfs: null,
      view_time: null,
      view_issure: null,
      view_recipent: null,
      view_cname: null,
      view_ctype: null,
      view_cdes: null,
      view_cert_table: [],
      view_cert_ID: [],
      temp_flag: null,
      certType1: ['Domicile', 'DateOFBirth', 'Bonafide', 'Course Completion', 'Workshop Completion']
    }
  },
  filters: {
    details (user) {
      return `Name: ${user.recipient_name}, Email: ${user.recipient_email}, Phone: ${user.recipient_phone}`
    }
  },
  beforeCreate: function () {
    CertChain.init().then(() => {
      console.log('contract: ' + CertChain.contract.address)
      console.log('user: ' + window.web3.eth.accounts[0])
      this.user = window.web3.eth.accounts[0]
      CertChain.getIssuer(this.user).then((ans) => {
        this.is_registered = ans
      })
    }).catch(err => {
      console.log(err)
    })
  },
  methods: {
    registerIssuer: function () {
      let data = JSON.stringify({'issuer_name': this.issuer_name, 'issuer_email': this.issuer_email, 'issuer_phone': this.issuer_phone, 'issuer_url': this.issuer_url})
      console.log(data)
      ipfs.add(data).then(ipfsHash => {
        console.log(ipfsHash)
        CertChain.registerIssuer(ipfsHash).then(tx => {
          console.log(tx)
          alert('Issuer registered')
          this.is_registered = true
        })
      })
    },
    registerCertificate: function () {
      let data = JSON.stringify({'cert_type': this.cert_type, 'cert_name': this.cert_name, 'cert_desc': this.cert_desc, 'address_recipient': this.address_recipient})
      console.log(data)
      ipfs.add(data).then(ipfsHash => {
        console.log(ipfsHash)
        CertChain.registerCertificate(ipfsHash).then(tx => {
          console.log(tx)
          alert('Certificate registered')
          this.certificates.push(ipfsHash)
          this.temp_ipfs = ipfsHash
        })
      })
    },
    issueCertificate: function () {
      console.log('CLicked on issue')
      var k = 0
      for (k = 0; k < 5; k++) {
        if (this.cert_type === certType[k]) {
          this.temp_flag = flag[k]
        }
      }
      CertChain.issueCertificate(this.address_recipient, this.temp_ipfs, this.cert_name, this.cert_type, this.cert_desc, this.temp_flag).then(tx => {
        console.log(tx)
        console.log(this.temp_flag)
        alert('Certificate issued')
        console.log('Certificate issued')
      })
    },
    getRecipient: function () {
      CertChain.getRecipient(this.view_address_recipient).then((tx) => {
        ipfs.cat(tx).then((data) => {
          this.data_getRecipient = JSON.parse(data)
          console.log(JSON.stringify(this.data_getRecipient))
        })
      })
    },
    getIssuerCertificates: function () {
      CertChain.getIssuerCertificates(this.user).then((tx) => {
        this.all_certs = tx
        console.log('hello')
        var i = 0
        var temp2 = 0
        var temp3 = 0
        var j = 0
        var k = 0
        while (this.all_certs[i] != null) {
          j = parseInt(this.all_certs[i])
          console.log(j)
          temp2 = j - (i + 1)
          i++
          for (k = 0; k < 5; k++) {
            if (temp2 === flag[k]) {
              temp3 = k
            }
          }
          this.view_cert_table.push(certType[temp3])
        }
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
          alert(this.certID)
        }
        console.log(this.data_getCertificateIdentifier)
      })
    },
    getAllRecipientOfCertificate: function () {
      console.log('here')
      CertChain.getAllRecipientOfCertificate(this.view_cert_hash).then((tx) => {
        this.data_getAllRecipientOfCertificate = tx
      })
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
      border-radius: 20px;
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
    buttons:hover {
      cursor: pointer;
    }


span {
    color: #2c3e50;
    font-weight: bold;
    font-size: 25px;
}

</style>
