import 'dart:io';

import 'package:intl/intl.dart';

class ProductContract {
  Payload? payload;

  ProductContract({this.payload});

  ProductContract.fromJson(Map<String, dynamic> json) {
    payload =
        json['Payload'] != null ? Payload.fromJson(json['Payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (payload != null) {
      data['Payload'] = payload!.toJson();
    }
    return data;
  }

  int contractType() {
    /* 
    0 - Product
    1 - Service
    2 - Loan
    */
    if (payload?.parties?.buyersName!=null) {
      return 0;
    } else if (payload?.parties?.clientName!=null) {
      return 1;
    } else if (payload?.parties!=null) {
      return 2;
      
    } else {
      return 3;
    }
  }

  bool isService() {
    if (payload?.parties?.buyersName != null) {
      return false;
    } else {
      return true;
    }
  }

  bool isContractCreator(String address) {
    if (contractType()==0) {
      if (payload!.parties!.contractCreatorAddress == address) {
        return true;
      } else {
        return false;
      }
    } else if (contractType()==2) {
      if (payload!.parties!.lenderWalletAddress == address) {
        return true;
      } else {
        return false;
      }
  }
    
    else {
      if (payload!.parties!.creatorAddress == address) {
        return true;
      } else {
        return false;
      }
    }
  }

  String getSecondParty(String name) {
    if (payload!.parties==null){
      return '';
    }
        print(contractType()==2);
    if (contractType()==1) {
      if (payload!.parties!.clientName == name) {
        return payload!.parties!.providersName??'';
      } else {
        return payload!.parties!.clientName ??"";
      }
    } else if (contractType()==2) {
      if (payload!.parties!.lenderName == name) {
        return payload!.parties!.borrowerName??"";

      } else {
        return payload!.parties!.lenderName??'';
      }
    } 
    
    else {
      // print("$name dasd");
      if (payload!.parties!.buyersName == name) {
        return payload!.parties!.sellersName??'';
      } else {
        return payload!.parties!.buyersName??'';
      }
    }
  }

  bool isProvider(String address) {
    if (contractType()==1) {
      if (payload!.parties!.clientAddress == address) {
        return false;
      } else {
        return true;
      }
      
    } else if (contractType()==2) {
      if (payload!.parties!.borrowerWalletAddress==address) {
        return false;

      } else {return true;}
    }
    
    else {
      if (payload!.parties!.buyersName == address) {
        return false;
      }
      return true;
    }
  }

  String dateCreated() {
    if (payload!.terms == null) {
      return '';
    }
    if (payload!.parties!.buyersName != null) {
      final DateTime formatted =
          HttpDate.parse(payload!.states!.dateContractCreated ?? "");
      String date = DateFormat('MMM, dd yyyy').format(formatted);
      return date;
    } else if(payload!.parties!.borrowerName != null){
      final DateTime formatted = DateTime.parse(
          payload!.states!.dateLastChangeMade ?? "");
          String date = DateFormat('MMM, dd yyyy').format(formatted);
      return date;
    }  else {
      final DateTime formatted = HttpDate.parse(
          payload!.states!.dateContractCreatedService ?? "");
      String date = DateFormat('MMM, dd yyyy').format(formatted);
      return date;
    }
  }

  DateTime httpDate() {
    if (payload!.parties!.buyersName != null) {
      final DateTime formatted =
          HttpDate.parse(payload!.states!.dateLastChangeMade ?? "");
      return formatted;
    
    } else if(payload!.parties!.clientName != null){
      final DateTime formatted = HttpDate.parse(
          payload!.states!.dateContractCreatedService ?? "");
      return formatted;

    } else if(payload!.parties!.borrowerName != null){
      print("${payload!.contractID}7777");
      final DateTime formatted = DateTime.parse(
          payload!.states!.dateLastChangeMade ?? "");
      return formatted;
    } 
    
     else {
      final DateTime formatted = HttpDate.parse(
          payload!.states!.dateContractCreatedService ?? "");
      return formatted;
    }
  }

  DateTime formattedHttpDate() => DateTime(httpDate().year, httpDate().month, httpDate().day);
  String deliveryDate() {
    if (payload!.parties!.buyersName != null) {
      final DateTime formatted =
          HttpDate.parse(payload!.terms!.deliveryDatetime ?? "");
      String date = DateFormat('MMM, dd yyyy').format(formatted);
      return date;
    } else {
      final DateTime formatted =
          HttpDate.parse(payload!.terms!.deliveryDatetime ?? "");
      String date = DateFormat('MMM, dd yyyy').format(formatted);
      return date;
    }
  }

  String totalAmount() {
    return "${double.parse(payload!.terms!.productAmount ?? '0') + double.parse(payload!.terms!.logisticAmount ?? '0')}";
  }
}

class Payload {
  String? contractID;
  Parties? parties;
  Privilledges? privilledges;
  States? states;
  Terms? terms;
  String? approvalState;

  Payload(
      {this.contractID,
      this.parties,
      this.privilledges,
      this.states,
      this.approvalState,
      this.terms});

  Payload.fromJson(Map<String, dynamic> json) {
    contractID = json.containsKey('contract_id') ? json['contract_id'] : json['ContractID'];
    parties =
        json['Parties'] != null ? Parties.fromJson(json['Parties']) : null;
    privilledges = json['Privilledges'] != null
        ? Privilledges.fromJson(json['Privilledges'])
        : null;
    states =
        json['States'] != null ? States.fromJson(json['States']) : null;
    terms = json['Terms'] != null ? Terms.fromJson(json['Terms']) : null;
    approvalState = json['approval_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ContractID'] = contractID;
    if (parties != null) {
      data['Parties'] = parties!.toJson();
    }
    if (privilledges != null) {
      data['Privilledges'] = privilledges!.toJson();
    }
    if (states != null) {
      data['States'] = states!.toJson();
    }
    if (terms != null) {
      data['Terms'] = terms!.toJson();
    }
    return data;
  }
}

class Parties {
  String? buyersName;
  String? borrowerName;
  String? borrowerWalletAddress;
  String? lenderBizID;
  String? lenderName;
  String? lenderWalletAddress;
  String? contractCreator;
  String? contractCreatorAddress;
  String? sellersName;
  String? clientAddress;
  String? clientName;
  String? creatorAddress;
  String? providersName;

  Parties(
      {this.buyersName,
      this.borrowerName,
      this.borrowerWalletAddress,
      this.lenderBizID,
      this.lenderName,
      this.lenderWalletAddress,
      this.contractCreator,
      this.contractCreatorAddress,
      this.sellersName,
      this.clientAddress,
      this.clientName,
      this.creatorAddress,
      this.providersName});

  Parties.fromJson(Map<String, dynamic> json) {
    buyersName = json['buyers name'];
    contractCreator = json['contract creator'];
    contractCreatorAddress = json['contract_creator_address'];
    sellersName = json['sellers name'];
    borrowerName = json['borrower_name'];
    borrowerWalletAddress = json['borrower_wallet_address'];
    lenderBizID = json['lender_business_id'];
    lenderName = json['lender_name'];
    lenderWalletAddress = json['lender_wallet_address'];
    clientAddress = json['client address'];
    clientName = json['client name'];
    creatorAddress = json['creator address'];
    providersName = json['providers name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['buyers name'] = buyersName;
    data['contract creator'] = contractCreator;
    data['contract_creator_address'] = contractCreatorAddress;
    data['sellers name'] = sellersName;
    data['borrower_name'] = borrowerName;
    data['borrower_wallet_address'] = borrowerWalletAddress;
    data['lender_name'] = lenderName;
    data['lender_business_id'] = lenderBizID;
    data['lender_wallet_address'] = lenderWalletAddress;
    data['client address'] = clientAddress;
    data['client name'] = clientName;
    data['contract creator'] = contractCreator;
    data['creator address'] = creatorAddress;
    data['providers name'] = providersName;
    return data;
  }
}

class Privilledges {
  String? confirmationCode;
  String? terminationCode;
  String? approvalCode;
  String? borrowerRepayment;
  String? loanStages;
  String? totalRepayment;
  String? borrowerRepaymentStatus;


  Privilledges(
      {this.confirmationCode, this.terminationCode, this.approvalCode, this.borrowerRepayment, this.borrowerRepaymentStatus});
  Privilledges.fromJson(Map<String, dynamic> json) {
    approvalCode = json.containsKey('approval_code')
        ? json['approval_code']
        : json['approve_code'];
    confirmationCode = json['confirmation_code'];
    loanStages = json['loan_stages'];
    terminationCode = json['termination_code'];
    totalRepayment = json.containsKey("total_braket_repayments") ? json['total_braket_repayments'] : json['total_borrower_repayments'];
    borrowerRepayment = json.containsKey('borrower_repayments') ? json['borrower_repayments'] : json['braket_repayments'];
    borrowerRepaymentStatus = json.containsKey("borrower_repayment_status") ? json['borrower_repayment_status'] : json['braket_repayment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['approval_code'] = approvalCode;
    data['confirmation_code'] = confirmationCode;
    data['borrower_repayments'] = borrowerRepayment;
    data['loan_stages'] = loanStages;
    data['borrower_repayment_status'] = borrowerRepaymentStatus;
    data['termination_code'] = terminationCode;
    return data;
  }
}

class States {
  String? approvalState;
  String? closingState;
  String? confirmationState;
  String? dateContractRegistered;
  String? dateContractCreated;
  String? dateLastChangeMade;
  String? dateContractCreatedService;

  States(
      {this.approvalState,
      this.closingState,
      this.confirmationState,
      this.dateContractRegistered,
      this.dateContractCreatedService,
      this.dateContractCreated,
      this.dateLastChangeMade});

  States.fromJson(Map<String, dynamic> json) {
    approvalState = json.containsKey('approval state') ? json['approval state'] : json['approval_state'];
    closingState = json['closing state'];
    confirmationState = json['confirmation_state'];
    dateContractRegistered = json['date contract registered'];
    dateContractCreated = json['date_contract_created'];
    dateContractCreatedService = json['date contract created'];
    dateLastChangeMade = json['date_last_change_made'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['approval state'] = approvalState;
    data['closing state'] = closingState;
    data['confirmation_state'] = confirmationState;
    data['date contract registered'] = dateContractRegistered;
    data['date contract created'] = dateContractCreatedService;
    data['date_contract_created'] = dateContractCreated;
    data['date_last_change_made'] = dateLastChangeMade;
    return data;
  }
}

class Terms {
  String? contractTitle;
  String? deliveryDatetime;
  String? logisticAmount;
  String? productAmount;
  String? productDetails;
  String? shippingDestination;
  String? shippingLocation;
  String? aboutStages;
  String? deliveryLocation;
  String? downpayment;
  String? executionTimeline;
  int? numberOfServiceStages;
  String? remainderPayment;
  String? stageCompletionPayment;
  int? stagesAchieved;
  String? totalServiceAmount;
  String? balance;
  String? interestRate;
  String? loanAmount;
  String? loanPeriod;
  String? loanType;
  String? paymentLeft;
  String? periodLeft;

  Terms(
      {this.contractTitle,
      this.deliveryDatetime,
      this.logisticAmount,
      this.productAmount,
      this.productDetails,
      this.shippingDestination,
      this.shippingLocation,
      this.aboutStages,
      this.deliveryLocation,
      this.downpayment,
      this.executionTimeline,
      this.numberOfServiceStages,
      this.remainderPayment,
      this.stageCompletionPayment,
      this.stagesAchieved,
      this.totalServiceAmount,
      this.balance,
      this.interestRate,
      this.loanAmount,
      this.loanPeriod,
      this.loanType,
      this.paymentLeft,
      this.periodLeft,
      });

  Terms.fromJson(Map<String, dynamic> json) {
    print(json['loan_title']);
    contractTitle = json.containsKey('loan_title') ? json['loan_title'] : json.containsKey('contract_title')
        ? json['contract_title']
        : json['contract title'];
    deliveryDatetime = json.containsKey('delivery_datetime')
        ? json['delivery_datetime']
        : json['execution timeline'];
    balance = json['balance'];
    interestRate = json['interest_rate'];
    loanAmount = json['loan_amount'];
    loanPeriod = json['loan_period'];
    loanType = json['loan_type'];
    paymentLeft = json['payment_left'];
    periodLeft = json['period_left'];
    logisticAmount = json['logistic amount'];
    productAmount = json['product amount'];
    productDetails = json['product_details'];
    shippingDestination = json['shipping destination'];
    shippingLocation = json['shipping location'];
    aboutStages = json['about stages'];
    deliveryLocation = json['delivery location'];
    downpayment = json['downpayment'];
    executionTimeline = json['execution timeline'];
    numberOfServiceStages = json['number of service stages'];
    remainderPayment = json['remainder_payment'];
    stageCompletionPayment = json['stage_completion_payment'];
    stagesAchieved = json['stages achieved'];
    totalServiceAmount = json['total service amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['contract_title'] = contractTitle;
    data['delivery_datetime'] = deliveryDatetime;
    data['logistic amount'] = logisticAmount;
    data['balance'] = balance;
    data['loan_type'] = loanType;
    data['interest_rate'] = interestRate;
    data['payment_left'] = paymentLeft;
    data['loan_amount'] = loanAmount;
    data['period_left'] = periodLeft;
    data['product amount'] = productAmount;
    data['product_details'] = productDetails;
    data['shipping destination'] = shippingDestination;
    data['shipping location'] = shippingLocation;
    data['about stages'] = aboutStages;
    data['delivery location'] = deliveryLocation;
    data['downpayment'] = downpayment;
    data['execution timeline'] = executionTimeline;
    data['number of service stages'] = numberOfServiceStages;
    data['remainder_payment'] = remainderPayment;
    data['stage_completion_payment'] = stageCompletionPayment;
    data['stages achieved'] = stagesAchieved;
    data['total service amount'] = totalServiceAmount;
    return data;
  }
}
