pragma solidity ^0.4.21;

contract Trust{
    uint256 public bankAddr;
    
    struct Company{
        uint256 companyAddr;//公司
        string companyName;//公司名字
        bool trust;//是否值得信任
        uint allAccount; //资产
    }

    struct Receipt{
        uint256 to;
        uint256 from1;
        uint amount;//若为0，则该记录不存在
        uint creationDate; //账款建立日期
        uint ddl;//期限
    }
    
    mapping(uint256 => Receipt[]) public rAccounts;// 应收账款
    mapping(uint256 => Company) public companys;

    bool success; //
    Receipt receipt; //
    
    uint[] index;//
    
    constructor() public{
        bankAddr = 0x00;//金融机构
        companys[bankAddr] = Company({
            companyAddr: bankAddr,
            companyName: "Bank",
            trust: true,
            allAccount: 500000 //
        });
    }
    
    function addCompany(uint256 addr, string name, uint allaccount) public returns (uint256){
        uint256 ret_code = 0;
        bool trust = false;
        if(allaccount >= 2000){
            trust = true;
        }
        companys[addr] = Company({
            companyAddr: addr,
            companyName: name,
            trust: trust,
            allAccount: allaccount
        });
        return ret_code;
    }

    function getReceipt(uint256 addr, uint index) public returns (uint256, uint256, uint) {
        return (rAccounts[addr][index].to,rAccounts[addr][index].from1, rAccounts[addr][index].amount);
    }

    function getCompany(uint256 addr) public returns (uint256, string, uint, uint) {
        return (companys[addr].companyAddr,companys[addr].companyName, rAccounts[addr].length,companys[addr].allAccount);
    }

    //采购商品-签发应收账款
    function transaction(uint256 toCompany, uint256 fromCompany, uint account, uint limitTime) public returns (uint256){
        success = false;
        //require(msg.sender == fromCompany);
        require(toCompany != bankAddr);
        require(companys[fromCompany].trust);//需要被信任才能贷款
        uint256 ret_code = 0;

        receipt = Receipt({
            to: toCompany,
            from1: fromCompany,
            amount: account,
            creationDate: now,
            ddl: limitTime
        });
        rAccounts[toCompany].push(receipt);
        rAccounts[fromCompany].push(receipt);

        success = true;
        return ret_code;
    }

    //应收账款的转让
    //oldToCompany原持债公司 newToCompany新持债公司 fromCompany需付账款的公司 account转让账款金额
    function receiptTransfer(uint256 oldToCompany, uint256 newToCompany, uint256 fromCompany, uint account) public returns (uint256){
        success = false;
        uint256 ret_code = 0;
        if(newToCompany == oldToCompany) {
            ret_code = 1;
            return ret_code;
        }
        //if(account < 0) { //转移账款要大于0
        //    ret_code = 2;
        //    return ret_code;
        //}
        
        delete(index);
        uint curAccount = 0;
        //遍历所有账款，记录下借贷公司的所有向原持债公司借的账，直至够数
        for(uint i = 0; i < rAccounts[oldToCompany].length; i ++) {
            if(rAccounts[oldToCompany][i].from1 == fromCompany && rAccounts[oldToCompany][i].amount != 0){
                curAccount += rAccounts[oldToCompany][i].amount;
                index.push(i);//记录要转让的账款
                if(curAccount >= account){
                    break;
                }
            }
        }
        require(curAccount >= account); //持账数不足

        if(curAccount == account) {
            for(i = 0; i < index.length; i ++) {
                receipt = rAccounts[oldToCompany][index[i]];
                receipt.to = newToCompany;
                rAccounts[newToCompany].push(receipt);//新持债公司加入新债
                rAccounts[oldToCompany][index[i]].amount = 0;//旧持债公司销毁该条债务
                //借贷者的借贷对象变更
                for(uint k = 0; k < rAccounts[fromCompany].length; k ++) {
                    if(rAccounts[fromCompany][k].to == oldToCompany && rAccounts[fromCompany][k].amount == receipt.amount) {
                        rAccounts[fromCompany][k].to = newToCompany;
                        break;
                    }
                }
            }
        }else{//总账款大于需转账款
            for(i = 0; i < index.length - 1; i ++) {
                receipt = rAccounts[oldToCompany][index[i]];
                receipt.to = newToCompany;
                rAccounts[newToCompany].push(receipt);//新持债公司加入新债
                rAccounts[oldToCompany][index[i]].amount = 0;//旧持债公司销毁该条债务
                //借贷者的借贷对象变更
                for(k = 0; k < rAccounts[fromCompany].length; k ++) {
                    if(rAccounts[fromCompany][k].to == oldToCompany && rAccounts[fromCompany][k].amount == receipt.amount) {
                        rAccounts[fromCompany][k].to = newToCompany;//债主变了
                        break;
                    }
                }
            }
            //最后一条转款部分转让，不是全部
            receipt = rAccounts[oldToCompany][index[index.length - 1]];
            //借贷者的借贷对象变更
            for(k = 0; k < rAccounts[fromCompany].length; k ++) {
                if(rAccounts[fromCompany][k].to == oldToCompany && rAccounts[fromCompany][k].amount == receipt.amount) {
                    rAccounts[fromCompany][k].amount = (curAccount - account);
                    break;
                }
            }
            rAccounts[oldToCompany][index[index.length - 1]].amount = curAccount - account;//旧持债公司修改该条债务
            receipt.amount = receipt.amount - (curAccount - account);
            receipt.to = newToCompany;
            rAccounts[newToCompany].push(receipt);//新持债公司加入新债
            rAccounts[fromCompany].push(receipt);//借贷者加入新债
        }
        success = true;

        return ret_code;
    }
    
    //融资
    function financing(uint256 dstCompanyAddr, uint account) public returns (uint256){
        success = false;
        //uint256 dstCompanyAddr = msg.sender;
        require(companys[dstCompanyAddr].trust);
        uint256 ret_code = 0;
        delete(index);
        uint curAccount;
        //遍历所有账款，记录下借贷公司的所有向原持债公司借的账，看是否够数
        for(uint j = 0; j < rAccounts[dstCompanyAddr].length; j ++){ 
            curAccount += rAccounts[dstCompanyAddr][j].amount;
            index.push(j);
            if(curAccount >= account){
                break;
            }
        }
        if(curAccount < account) {
            ret_code = 1;
            return ret_code;
        }
        //相当于向银行转让账款
        if(curAccount == account){
            for(uint i = 0; i < index.length; i++){
                receiptTransfer(dstCompanyAddr, bankAddr, rAccounts[dstCompanyAddr][index[i]].from1, rAccounts[dstCompanyAddr][index[i]].amount);
            }
        }else{
            for(i = 0; i < index.length - 1; i++){
                receiptTransfer(dstCompanyAddr, bankAddr, rAccounts[dstCompanyAddr][index[i]].from1, rAccounts[dstCompanyAddr][index[i]].amount);
            }
            receiptTransfer(dstCompanyAddr, bankAddr, rAccounts[dstCompanyAddr][index.length - 1].from1, rAccounts[dstCompanyAddr][index.length - 1].amount - (curAccount - account));
        }
        companys[dstCompanyAddr].allAccount += account;
        success = true;
        return ret_code;
    }
    
    //应收账款支付结算
    function dueRepayment(uint256 dstCompanyAddr) public returns (uint256){
        success = false;
        uint256 ret_code = 0;
        for(uint i = 0; i < rAccounts[dstCompanyAddr].length; i ++){
            receipt = rAccounts[dstCompanyAddr][i];
            if(now >= receipt.creationDate + receipt.ddl && receipt.from1 == dstCompanyAddr){ //ddl到了且还款人是dstCompany
                uint curAccount = companys[dstCompanyAddr].allAccount;
                if(curAccount >= receipt.amount){//现金足够支付相应欠款
                    companys[dstCompanyAddr].allAccount -= receipt.amount;
                    companys[receipt.to].allAccount += receipt.amount;
                    rAccounts[dstCompanyAddr][i].amount = 0;//该账款条目销毁
                    for(uint k = 0; k < rAccounts[receipt.to].length; k ++) {
                        if(rAccounts[receipt.to][k].from1 == dstCompanyAddr && rAccounts[receipt.to][k].amount == receipt.amount) {
                            rAccounts[receipt.to][k].amount = 0;//该账款条目销毁
                            break;
                        }
                    }
                }else{
                    companys[dstCompanyAddr].allAccount = 0;
                    companys[receipt.to].allAccount += curAccount;
                    rAccounts[dstCompanyAddr][i].amount -= curAccount;//全部现金还款
                    for(k = 0; k < rAccounts[receipt.to].length; k ++) {
                        if(rAccounts[receipt.to][k].from1 == dstCompanyAddr && rAccounts[receipt.to][k].amount == receipt.amount) {
                            rAccounts[receipt.to][k].amount -= curAccount;//该账款条目销毁
                            break;
                        }
                    }
                    companys[dstCompanyAddr].trust = false;
                    break;
                }
            }
        }
        success = true;
        return ret_code;
    }
}