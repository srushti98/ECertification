 <template>
  <div id="outer">
  <div id="outer2">
    <span id="h2">CERTIFICATE</span><span id="h2"></span>
    <div id="inner" style="margin-top:50px;font-size: 20px">
      This certificate of {{ cname }} <br>
      is issued to {{ recipient }} <br>
      by {{ issure }} <br>
      and is declared as valid.<br>
      Description: {{cdes}}<br><br>
      <br><p align="center">
      <qr-code text="Bonafide Certificate" size=125 color="#000000"></qr-code></p>
    </div>

  </div>
<a style="cursor: pointer; text-decoration: underline" v-on:click="navigate()">Navigate to Page1</a>
  </div>

</template>


<script>
import router from '../router'
import Vue from 'vue'
import VueQRCodeComponent from 'vue-qrcode-component'
Vue.component('qr-code', VueQRCodeComponent)
export default {
  name: 'recipientPage',
  data () {
    return {
      id: 0,
      msg: 'certificate',
      qrText: null
    }
  },
  created () {
    this.ipfs = this.$route.params.ipfs
    this.time = this.$route.params.time
    this.issure = this.$route.params.issure
    this.recipient = this.$route.params.recipient
    this.ctype = this.$route.params.ctype
    this.cname = this.$route.params.cname
    this.cdes = this.$route.params.cdes
    this.qrText = 'Hash: ' + this.ipfs + ' Issuer: ' + this.issure + ' Recipient: ' + this.recipient + '\n' + 'Certificate Type: ' + this.ctype + ' Certificate Name: ' + this.cname + ' Certificate Description: ' + this.cdes + '\n'
    console.log(this.qrText)
  },
  methods: {
    navigate () {
      router.go(-1)
    }
  }
}
</script>

<style scoped>

#inner {
    margin-left: 150px;
    width: 50%;

}
#outer {
   
    background-color:white;
    border: 1px solid;
    border-color:black;
    height:600px;
    width:800px;
    margin-left:300px;
    margin-top:50px;
    box-shadow: 3px 3px 4px
}
#outer2 {
    border: 5px solid;
    color: black;
    padding: 50px;
    text-align: center;
    margin: 5px;
    height:480px;
}

#h1 {
  font-weight: bold;
  /*color: #2e7a58;*/
  color: #17202A;
  font-size: 80px;
  padding-top:100px;
}
#h2 {
  font-weight: bold;
  /*color: #2e7a58;*/
  color: #17202A;
  font-size: 50px;
}
p {
  font-size: 25px;
  font-weight: bold;
  /*color: #2e7a58;*/
  color: #17202A;
  align: left;
}
</style>

