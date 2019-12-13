<template>
  <div>
    <Card>
      <h1>BlockChain</h1>
    </Card>

    <Card>
      <h2>Current Contract Infomation</h2>
      <Row style = "margin: 10px 0">
        <Col span="4" style="text-align: right"><span>deployed contract name：</span>
        </Col>
        <Col span="8">{{ this.showData[this.currentIndex].name }}</Col>
      </Row>
      <Row style = "margin: 10px 0">
        <Col span="4" style="text-align: right"><span>deployed contract address：</span>
        </Col>
        <Col span="8">{{ this.showData[this.currentIndex].contractAddress }}</Col>
      </Row>
    </Card>

    <Card>
      <h2>Contract Deployment</h2>
      <Row style = "margin: 10px 0">
        <Col span="5" offset = "3">
          <Button type="success" style="width: 100px; font-size: 10px; margin-right: 10px" @click="openAdd">DeployContract</Button>
        </Col>
      </Row>
    </Card>

    <Card>
      <h2>Account Operations</h2>
      <Row style = "margin: 10px 0">
        <Row span="10" offset = "3">
          <Button type="success" style="width: 100px; font-size: 10px; margin-right: 10px" @click="openCreate">AddCompany</Button>
          <Button type="success" style="width: 100px; font-size: 10px; margin-right: 10px" @click="openTransaction">Transaction</Button>
          <Button type="success" style="width: 100px; font-size: 10px; margin-right: 10px" @click="openTransfer">ReceiptTransfer</Button>
          <Button type="success" style="width: 100px; font-size: 10px; margin-right: 10px" @click="openSaleReceipt">Financing</Button>
          <Button type="success" style="width: 100px; font-size: 10px; margin-right: 10px" @click="openRepayment">DueRepayment</Button>
        </Row>
      </Row>
    </Card>
    <Card>
      <h2>Company Infomation Query</h2>
      <Row style = "margin: 10px 0">
        <Col span="5" offset = "1">
          <Button type="success" style="width: 100px; font-size: 11px; margin-right: 10px" @click="openGetCompany">Query</Button>
        </Col>
      </Row>
      <Col style = "margin: 10px 0">
        <Row span="3" style="text-align: left"><span>address：</span></Row>
        <Row span="2">{{ this.companyInfo[0] }}</Row>
        <Row span="3" style="text-align: left"><span>name：</span></Row>
        <Row span="2">{{ this.companyInfo[1] }}</Row>
        <Row span="3" style="text-align: left"><span>receiption num：</span></Row>
        <Row span="2">{{ this.companyInfo[2] }}</Row>
        <Row span="3" style="text-align: left"><span>account：</span></Row>
        <Row span="2">{{ this.companyInfo[3] }}</Row>
      </Col>

      <h2>Company Receiption Query</h2>
      <Row style = "margin: 10px 0">
        <Col span="5" offset = "1">
          <Button type="success" style="width: 100px; font-size: 11px; margin-right: 10px" @click="openGetReceipt">Query</Button>
        </Col>
      </Row>
      <Col style = "margin: 10px 0">
        <Row span="3" style="text-align: left"><span>debtor：</span></Row>
        <Row span="2">{{ this.receiptInfo[0] }}</Row>
        <Row span="3" style="text-align: left"><span>credit：</span></Row>
        <Row span="2">{{ this.receiptInfo[1] }}</Row>
        <Row span="3" style="text-align: left"><span>accout：</span></Row>
        <Row span="2">{{ this.receiptInfo[2] }}</Row>
      </Col>
    </Card>

  <Modal v-model="createCompany" title="AddCompany">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="address" prop="address" >
        <Input clearable v-model="addForm.address" placeholder = "Please input 公司address"/>
      </FormItem>
      <FormItem label="name" prop="name" >
        <Input clearable v-model="addForm.name" placeholder = "Please input name"/>
      </FormItem>
      <FormItem label="accout" prop="allaccount" >
        <Input clearable v-model="addForm.allaccount" placeholder = "Please input accout"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">Cancle</Button>
      <Button type="success" @click="doAdd">Ok</Button>
    </div>
  </Modal>

  <Modal v-model="isGetCompany" title="QueryCompany">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="CompanyAddress" prop="address" >
        <Input  clearable v-model="addForm.address" placeholder = "Please input CompanyAddress"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">Cancle</Button>
      <Button type="success" @click="doAdd">Ok</Button>
    </div>
  </Modal>

  <Modal v-model="isTransaction" title="Trasaction">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="Credit " prop="toCompany" >
        <Input  clearable v-model="addForm.toCompany" placeholder = "Please input Credit address"/>
      </FormItem>
      <FormItem label="debtorCompany" prop="fromCompany" >
        <Input  clearable v-model="addForm.fromCompany" placeholder = "Please input debtorCompany address"/>
      </FormItem>
      <FormItem label="accout" prop="account" >
        <Input  clearable v-model="addForm.account" placeholder = "Please input accout"/>
      </FormItem>
      <FormItem label="limit time" prop="limitTime" >
        <Input  clearable v-model="addForm.limitTime" placeholder = "Please input limit time"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">Cancle</Button>
      <Button type="success" @click="doAdd">Ok</Button>
    </div>
  </Modal>

  <Modal v-model="isReceiptTransfer" title="Receipt Transfer">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="Old Credit " prop="oldToCompany" >
        <Input  clearable v-model="addForm.oldToCompany" placeholder = "Please input Old Credit address"/>
      </FormItem>
      <FormItem label="New Credit " prop="newToCompany" >
        <Input  clearable v-model="addForm.newToCompany" placeholder = "Please input New Credit address"/>
      </FormItem>
      <FormItem label="debtorCompany" prop="fromCompany" >
        <Input  clearable v-model="addForm.fromCompany" placeholder = "Please input debtorCompany address"/>
      </FormItem>
      <FormItem label="Transfer Accout" prop="account" >
        <Input  clearable v-model="addForm.account" placeholder = "Please input Transfer Accout"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">Cancle</Button>
      <Button type="success" @click="doAdd">Ok</Button>
    </div>
  </Modal>

  <Modal v-model="isFinancing" title="Financing">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="CompanyAddress" prop="dstCompanyAddr" >
        <Input  clearable v-model="addForm.dstCompanyAddr" placeholder = "Please input Company address"/>
      </FormItem>
      <FormItem label="Accout" prop="account" >
        <Input  clearable v-model="addForm.account" placeholder = "Please input Accout"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">Cancle</Button>
      <Button type="success" @click="doAdd">Ok</Button>
    </div>
  </Modal>

  <Modal v-model="isDueRepayment" title="Due Repayment">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="CompanyAdd(need to pay)" prop="dstCompanyAddr" >
        <Input  clearable v-model="addForm.dstCompanyAddr" placeholder = "Please input CompanyAdd(need to pay) address"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">Cancle</Button>
      <Button type="success" @click="doAdd">Ok</Button>
    </div>
  </Modal>

  <Modal v-model="isGetReceipt" title="QueryReceipt">
    <Form :model="addForm" ref="addForm" :label-width="110">
      <FormItem label="querycompany" prop="address" >
        <Input  clearable v-model="addForm.address" placeholder = "Please input Company address"/>
      </FormItem>
      <FormItem label="Query Receiption_id" prop="index" >
        <Input  clearable v-model="addForm.index" placeholder = "Query Receiption id"/>
      </FormItem>
    </Form>
    <div slot="footer">
      <Button type="text" @click="cancelAdd">Cancle</Button>
      <Button type="success" @click="doAdd">Ok</Button>
    </div>
  </Modal>

  </div>
</template>


<script>
import axios from "@/libs/api.request";
export default {
  data() {
    return {
      showData: [{
        name:'',
        contractAddress:''
      }],
      currentIndex: 0,
      createCompany: false,
      addForm: {},
      isGetCompany: false,
      isGetReceipt: false,
      isTransaction: false,
      isReceiptTransfer: false,
      isFinancing: false,
      isDueRepayment: false,
      companyInfo: {},
      receiptInfo: {}
    }
  }, methods:{
      async deploy(param) {
        let self = this
        let result = {}
        let da = {
          contractName: param,
        }
        await axios.request({
          url: "deploy",
          data: da,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
        }).then(function(res) {
          console.info(res.data);
          result = res.data
          self.showData.push({name: param,contractAddress: result.contractAddress});
        });
      },
      async addCompany(param) {
        let result = {}
        let judge = ""
        await axios.request({
          url: "addCompany",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
        }).then(function(res) {
          result = res.data
        });
      },
      async getCompany(param) {
        let result = {}
        let judge = ""
        await axios.request({
          url: "getCompany",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
        }).then(function(res) {
          console.info(res.data);
          result = res.data.output
          judge = res.data.status
        });
        if(judge == "0x0") {
          this.companyInfo = result;
          this.companyInfo[3] = parseInt(result[3],16);
          console.info(this.companyInfo[3])
        }
        else {
          this.companyInfo = {0:"无",1:"无",2:"0",3:"0"}
        }
      },
      async getReceipt(param) {
        let result = {}
        let judge = ""
        await axios.request({
          url: "getReceipt",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
        }).then(function(res) {
          console.info(res.data);
          result = res.data.output
          judge = res.data.status
        });
        if(judge == "0x0") {
          this.receiptInfo = result;
          this.receiptInfo[2] = parseInt(result[2],16);
        }
        else if(judge == "0xa") {
          this.receiptInfo = {0:"无",1:"无",2:"0"}
        }
      },
      async transaction(param) {
        let result = {}
        await axios.request({
          url: "transaction",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
        }).then(function(res) {
          console.info(res.data);
          result = res.data
        });
      },
      async receiptTransfer(param) {
        let result = {}
        await axios.request({
          url: "receiptTransfer",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
        }).then(function(res) {
          console.info(res.data);
          result = res.data
        });
      },
      async financing(param) {
        let result = {}
        await axios.request({
          url: "financing",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
        }).then(function(res) {
          console.info(res.data);
          result = res.data
        });
      },
      async dueRepayment(param) {
        let result = {}
        await axios.request({
          url: "dueRepayment",
          data: param,
          headers:{
            'Content-type': 'application/x-www-form-urlencoded',
          },
          method: "post"
        }).then(function(res) {
          console.info(res.data);
          result = res.data
        });
      },

      openAdd(){
        this.deploy('Trust');
        this.currentIndex += 1;
      },
      openCreate(){
        this.createCompany = true;
        this.addForm.func = 'addCompany';
        this.addForm.addr = this.showData[this.currentIndex].contractAddress;
        this.addForm.contract = this.showData[this.currentIndex].name;
        this.addForm.name = '';
        this.addForm.address = '';
        this.addForm.allaccount = '';
        console.info(this.addForm)
      },
      openGetCompany(){
        this.isGetCompany = true;
        this.addForm.func = 'getCompany';
        this.addForm.addr = this.showData[this.currentIndex].contractAddress;
        this.addForm.contract = this.showData[this.currentIndex].name;
        this.addForm.address = '';
      },
      openTransaction(){
        this.isTransaction = true;
        this.addForm.func = 'transaction';
        this.addForm.addr = this.showData[this.currentIndex].contractAddress;
        this.addForm.contract = this.showData[this.currentIndex].name;
        this.addForm.toCompany = '';
        this.addForm.fromCompany = '';
        this.addForm.account = '';
        this.addForm.limitTime = '';
      },
      openTransfer(){
        this.isReceiptTransfer = true;
        this.addForm.func = 'receiptTransfer';
        this.addForm.addr = this.showData[this.currentIndex].contractAddress;
        this.addForm.contract = this.showData[this.currentIndex].name;
        this.addForm.oldToCompany = '';
        this.addForm.newToCompany = '';
        this.addForm.fromCompany = '';
        this.addForm.account = '';
      },
      openSaleReceipt(){
        this.isFinancing = true;
        this.addForm.func = 'financing';
        this.addForm.addr = this.showData[this.currentIndex].contractAddress;
        this.addForm.contract = this.showData[this.currentIndex].name;
        this.addForm.dstCompanyAddr = '';
        this.addForm.account = '';
      },
      openRepayment(){
        this.isDueRepayment = true;
        this.addForm.func = 'dueRepayment';
        this.addForm.addr = this.showData[this.currentIndex].contractAddress;
        this.addForm.contract = this.showData[this.currentIndex].name;
        this.addForm.dstCompanyAddr = '';
      },
      openGetReceipt(){
        this.isGetReceipt = true;
        this.addForm.func = 'getReceipt';
        this.addForm.addr = this.showData[this.currentIndex].contractAddress;
        this.addForm.contract = this.showData[this.currentIndex].name;
        this.addForm.address = '';
        this.addForm.index = '';
      },
      cancelAdd(){
        this.$refs.addForm.resetFields();
        this.addForm = {}
        this.createCompany = false
        this.isGetCompany = false
        this.isTransaction = false
        this.isReceiptTransfer = false
        this.isFinancing = false
        this.isDueRepayment = false
        this.isGetReceipt = false
      },
      doAdd(){
        console.info(this.addForm)
        if(this.addForm.func == 'addCompany') {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.name = this.addForm.name
          data.address = this.addForm.address
          data.allaccount = this.addForm.allaccount
          console.info(data)
          this.addCompany(data)
          this.$Message.success('添加公司成功')
        }
        else if(this.addForm.func == 'getCompany') {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.address = this.addForm.address
          console.info(data)
          this.getCompany(data)
          this.$Message.success('查询公司成功')
        }
        else if(this.addForm.func == 'transaction') {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.toCompany = this.addForm.toCompany
          data.fromCompany = this.addForm.fromCompany
          data.account = this.addForm.account
          data.limitTime = this.addForm.limitTime
          console.info(data)
          this.transaction(data)
          this.$Message.success('生成账单成功')
        }
        else if(this.addForm.func == 'receiptTransfer') {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.oldToCompany = this.addForm.oldToCompany
          data.newToCompany = this.addForm.newToCompany
          data.fromCompany = this.addForm.fromCompany
          data.account = this.addForm.account
          console.info(data)
          this.receiptTransfer(data)
          this.$Message.success('转移账单公司成功')
        }
        else if(this.addForm.func == 'financing') {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.dstCompanyAddr = this.addForm.dstCompanyAddr
          data.account = this.addForm.account
          this.financing(data)
          this.$Message.success('出售账单公司成功')
        }
        else if(this.addForm.func == 'dueRepayment') {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.dstCompanyAddr = this.addForm.dstCompanyAddr
          this.dueRepayment(data)
          this.$Message.success('结清账单公司成功')
        }
        else if(this.addForm.func == 'getReceipt') {
          let data = {};
          data.func = this.addForm.func
          data.addr = this.addForm.addr
          data.contract = this.addForm.contract
          data.address = this.addForm.address
          data.index = this.addForm.index
          this.getReceipt(data)
          this.$Message.success('查询账单公司成功')
        }
        this.cancelAdd();
      },
    },
    created () {
      this.currentIndex = 0;
    }
}
</script>

<style>
  span{
    font-weight:bold;
    font-size:25;
  }
</style>
