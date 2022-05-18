import 'dart:io';

import 'package:intl/intl.dart';

class ProductContract {
  Payload? payload;

  ProductContract({this.payload});

  ProductContract.fromJson(Map<String, dynamic> json) {
    payload =
        json['Payload'] != null ? new Payload.fromJson(json['Payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payload != null) {
      data['Payload'] = this.payload!.toJson();
    }
    return data;
  }

  bool isService() {
    if (this.payload?.parties?.buyersName != null) {
      return false;
    } else {
      return true;
    }
  }

  bool isContractCreator(String address) {

      print(this.payload!.parties!.contractCreatorAddress);
      print(this.payload!.parties!.creatorAddress);
    if (!isService()) {
      if (this.payload!.parties!.contractCreatorAddress == address) {
        return true;
      } else {
        return false;
      }
    } else {
      if (this.payload!.parties!.creatorAddress == address) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool isProvider(String address) {
    if (this.isService()) {
      if (this.payload!.parties!.clientAddress == address) {
        return false;
      } else {
        return true;
      }
    } else {
      print('${this.payload!.parties!.buyersName} - $address');
      if (this.payload!.parties!.buyersName == address) {
        return false;
      }
      return true;
    }
  }

  String dateCreated() {
    if (this.payload!.parties!.buyersName != null) {
      final DateTime formatted =
          HttpDate.parse(this.payload!.states!.dateContractCreated ?? "");
      String date = DateFormat('MMM, dd yyyy').format(formatted);
      return date;
    } else {
      final DateTime formatted = HttpDate.parse(
          this.payload!.states!.dateContractCreatedService ?? "");
      String date = DateFormat('MMM, dd yyyy').format(formatted);
      return date;
    }
  }

  DateTime httpDate() {
    if (this.payload!.parties!.buyersName != null) {
      final DateTime formatted =
          HttpDate.parse(this.payload!.states!.dateLastChangeMade ?? "");
      return formatted;
    } else {
      final DateTime formatted = HttpDate.parse(
          this.payload!.states!.dateContractCreatedService ?? "");
      return formatted;
    }
  }

  String deliveryDate() {
    if (this.payload!.parties!.buyersName != null) {
      final DateTime formatted =
          HttpDate.parse(this.payload!.terms!.deliveryDatetime ?? "");
      String date = DateFormat('MMM, dd yyyy').format(formatted);
      return date;
    } else {
      final DateTime formatted =
          HttpDate.parse(this.payload!.terms!.deliveryDatetime ?? "");
      String date = DateFormat('MMM, dd yyyy').format(formatted);
      return date;
    }
  }

  String totalAmount() {
    return "${double.parse(this.payload!.terms!.productAmount ?? '0') + double.parse(this.payload!.terms!.logisticAmount ?? '0')}";
  }
}

class Payload {
  String? contractID;
  Parties? parties;
  Privilledges? privilledges;
  States? states;
  Terms? terms;

  Payload(
      {this.contractID,
      this.parties,
      this.privilledges,
      this.states,
      this.terms});

  Payload.fromJson(Map<String, dynamic> json) {
    contractID = json['ContractID'];
    parties =
        json['Parties'] != null ? new Parties.fromJson(json['Parties']) : null;
    privilledges = json['Privilledges'] != null
        ? new Privilledges.fromJson(json['Privilledges'])
        : null;
    states =
        json['States'] != null ? new States.fromJson(json['States']) : null;
    terms = json['Terms'] != null ? new Terms.fromJson(json['Terms']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ContractID'] = this.contractID;
    if (this.parties != null) {
      data['Parties'] = this.parties!.toJson();
    }
    if (this.privilledges != null) {
      data['Privilledges'] = this.privilledges!.toJson();
    }
    if (this.states != null) {
      data['States'] = this.states!.toJson();
    }
    if (this.terms != null) {
      data['Terms'] = this.terms!.toJson();
    }
    return data;
  }
}

class Parties {
  String? buyersName;
  String? contractCreator;
  String? contractCreatorAddress;
  String? sellersName;
  String? clientAddress;
  String? clientName;
  String? creatorAddress;
  String? providersName;

  Parties(
      {this.buyersName,
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
    clientAddress = json['client address'];
    clientName = json['client name'];
    creatorAddress = json['creator address'];
    providersName = json['providers name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buyers name'] = this.buyersName;
    data['contract creator'] = this.contractCreator;
    data['contract_creator_address'] = this.contractCreatorAddress;
    data['sellers name'] = this.sellersName;
    data['client address'] = this.clientAddress;
    data['client name'] = this.clientName;
    data['contract creator'] = this.contractCreator;
    data['creator address'] = this.creatorAddress;
    data['providers name'] = this.providersName;
    return data;
  }
}

class Privilledges {
  String? confirmationCode;
  String? terminationCode;
  String? approvalCode;

  Privilledges(
      {this.confirmationCode, this.terminationCode, this.approvalCode});

  Privilledges.fromJson(Map<String, dynamic> json) {
    approvalCode = json.containsKey('approval_code')
        ? json['approval_code']
        : json['approve_code'];
    print(json);
    confirmationCode = json['confirmation_code'];
    terminationCode = json['termination_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approval_code'] = this.approvalCode;
    data['confirmation_code'] = this.confirmationCode;
    data['termination_code'] = this.terminationCode;
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
    approvalState = json['approval state'];
    closingState = json['closing state'];
    confirmationState = json['confirmation_state'];
    dateContractRegistered = json['date contract registered'];
    dateContractCreated = json['date_contract_created'];
    dateContractCreatedService = json['date contract created'];
    dateLastChangeMade = json['date_last_change_made'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approval state'] = this.approvalState;
    data['closing state'] = this.closingState;
    data['confirmation_state'] = this.confirmationState;
    data['date contract registered'] = this.dateContractRegistered;
    data['date contract created'] = this.dateContractCreatedService;
    data['date_contract_created'] = this.dateContractCreated;
    data['date_last_change_made'] = this.dateLastChangeMade;
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
      this.totalServiceAmount});

  Terms.fromJson(Map<String, dynamic> json) {
    contractTitle = json.containsKey('contract_title')
        ? json['contract_title']
        : json['contract title'];
    deliveryDatetime = json.containsKey('delivery_datetime')
        ? json['delivery_datetime']
        : json['execution timeline'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contract_title'] = this.contractTitle;
    data['delivery_datetime'] = this.deliveryDatetime;
    data['logistic amount'] = this.logisticAmount;
    data['product amount'] = this.productAmount;
    data['product_details'] = this.productDetails;
    data['shipping destination'] = this.shippingDestination;
    data['shipping location'] = this.shippingLocation;
    data['about stages'] = this.aboutStages;
    data['delivery location'] = this.deliveryLocation;
    data['downpayment'] = this.downpayment;
    data['execution timeline'] = this.executionTimeline;
    data['number of service stages'] = this.numberOfServiceStages;
    data['remainder_payment'] = this.remainderPayment;
    data['stage_completion_payment'] = this.stageCompletionPayment;
    data['stages achieved'] = this.stagesAchieved;
    data['total service amount'] = this.totalServiceAmount;
    return data;
  }
}
