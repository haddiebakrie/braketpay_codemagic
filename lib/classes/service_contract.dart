class ServiceContract {
  String? message;
  Payload? payload;
  int? responseCode;
  String? status;

  ServiceContract({this.message, this.payload, this.responseCode, this.status});

  ServiceContract.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    payload =
        json['Payload'] != null ? new Payload.fromJson(json['Payload']) : null;
    responseCode = json['Response code'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    if (this.payload != null) {
      data['Payload'] = this.payload!.toJson();
    }
    data['Response code'] = this.responseCode;
    data['Status'] = this.status;
    return data;
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
  String? clientAddress;
  String? clientName;
  String? contractCreator;
  String? creatorAddress;
  String? providersName;

  Parties(
      {this.clientAddress,
      this.clientName,
      this.contractCreator,
      this.creatorAddress,
      this.providersName});

  Parties.fromJson(Map<String, dynamic> json) {
    clientAddress = json['client address'];
    clientName = json['client name'];
    contractCreator = json['contract creator'];
    creatorAddress = json['creator address'];
    providersName = json['providers name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client address'] = this.clientAddress;
    data['client name'] = this.clientName;
    data['contract creator'] = this.contractCreator;
    data['creator address'] = this.creatorAddress;
    data['providers name'] = this.providersName;
    return data;
  }
}

class Privilledges {
  String? approvalCode;
  String? confirmationCode;
  String? terminationCode;

  Privilledges(
      {this.approvalCode, this.confirmationCode, this.terminationCode});

  Privilledges.fromJson(Map<String, dynamic> json) {
    approvalCode = json['approval_code'];
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
  String? dateContractCreated;
  String? dateContractRegistered;

  States(
      {this.approvalState,
      this.closingState,
      this.dateContractCreated,
      this.dateContractRegistered});

  States.fromJson(Map<String, dynamic> json) {
    approvalState = json['approval state'];
    closingState = json['closing state'];
    dateContractCreated = json['date contract created'];
    dateContractRegistered = json['date contract registered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approval state'] = this.approvalState;
    data['closing state'] = this.closingState;
    data['date contract created'] = this.dateContractCreated;
    data['date contract registered'] = this.dateContractRegistered;
    return data;
  }
}

class Terms {
  String? aboutStages;
  String? contractTitle;
  String? deliveryLocation;
  String? downpayment;
  String? executionTimeline;
  int? numberOfServiceStages;
  String? remainderPayment;
  String? stageCompletionPayment;
  int? stagesAchieved;
  String? totalServiceAmount;

  Terms(
      {this.aboutStages,
      this.contractTitle,
      this.deliveryLocation,
      this.downpayment,
      this.executionTimeline,
      this.numberOfServiceStages,
      this.remainderPayment,
      this.stageCompletionPayment,
      this.stagesAchieved,
      this.totalServiceAmount});

  Terms.fromJson(Map<String, dynamic> json) {
    aboutStages = json['about stages'];
    contractTitle = json['contract title'];
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
    data['about stages'] = this.aboutStages;
    data['contract title'] = this.contractTitle;
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
