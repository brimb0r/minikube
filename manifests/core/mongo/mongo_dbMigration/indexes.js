print('Creating Indexes...');

var a = db.runCommand({connectionStatus: 1}).authInfo.authenticatedUsers[0];
if (!a) {
    print('Setting feature compatibility to 4.2');
    db.getMongo().getDB("admin");
    var result = db.adminCommand({setFeatureCompatibilityVersion: "4.2"});
    print(result);
}

//NOTE: make sure every index is specified as background.  This grep will show any indexes without "background: true":
//grep "\.createIndex" indexes.js | grep -v "background: true"

//arap
db.arap.createIndex({name: 1}, {unique: true, background: true});

//audit
db.audit.createIndex({createtimestamp: -1}, {background: true});
db.audit.createIndex({"fiid": 1, "createtimestamp": 1}, {background: true});
db.audit.createIndex({"fiid": 1, "createtimestamp": -1}, {background: true});
db.audit.createIndex({"entityid": 1, "attribute": 1, "type": 1, "createtimestamp": 1}, {background: true});


//authorization
db.authorization.createIndex({traceid: 1}, {unique: false, background: true});
db.authorization.createIndex({companyid: 1, type: 1, time: -1}, {background: true});
db.authorization.createIndex({companyid: 1, type: 1, transmissiontime: -1}, {background: true});
db.authorization.createIndex({transmissiontime: 1}, {background: true});
db.authorization.createIndex({
    cardid: 1,
    type: 1,
    approved: 1,
    transmissiontime: 1,
    transactionstatus: 1
}, {background: true});
db.authorization.createIndex({transmissiontime: 1, standin: 1}, {background: true});
db.authorization.createIndex({"fiid": 1, "time": 1}, {background: true});
db.authorization.createIndex({"audittracenumber": 1, "cardid": 1}, {background: true});

//batch
db.batch.createIndex({"fileid.baseiiuniquefileid": 1}, {background: true});
db.batch.createIndex({"fileid.filereferencedate": 1, "fileid.filesequencenumber": 1}, {background: true});
db.batch.createIndex({"batchnumber": 1}, {background: true});
db.batch.createIndex({"name": 1}, {background: true});
db.batch.createIndex({type: 1, "fileid.filereferencedate": 1, "fileid.filesequencenumber": 1}, {background: true});
db.batch.createIndex({"type": 1, "created": 1}, {background: true});

//bin
db.bin.createIndex({"sre.internationalft": 1}, {background: true});
db.bin.createIndex({"fiid": 1, "binnumber": 1}, {background: true});

//card
db.card.createIndex({cardorderid: 1}, {background: true});
db.card.createIndex({hash: 1}, {unique: true, background: true});
db.card.createIndex({"companyid": 1, "type": 1, "fiid": 1, "created": -1}, {background: true});
db.card.createIndex({"override.status": 1}, {background: true});
db.card.createIndex({"created": 1}, {background: true});

//cardaccum
db.cardaccum.createIndex({cardid: 1, expires: 1}, {background: true});
db.cardaccum.createIndex({companyid: 1, expires: -1, created: -1}, {background: true});

var createExpiresAfterIndex = true;
db.cardaccum.getIndexes().forEach(function (i) {
    if (i.name === "expires_1") {
        createExpiresAfterIndex = false;
        if (!i.expireAfterSeconds) {
            db.cardaccum.dropIndex({expires: 1});
            print('dropping cardaccum expires index');
            createExpiresAfterIndex = true;
        }
    }
});
if (createExpiresAfterIndex) {
    print("Creating cardaccum.expires TTL index");
    db.cardaccum.createIndex({"expires": 1}, {expireAfterSeconds: 15780000, background: true});
}

//cardorder
db.cardorder.createIndex({"cardordergroupid": 1}, {background: true});
db.cardorder.createIndex({batchnumber: 1, companynumber: 1, finumber: 1}, {unique: true, background: true});

//cardnetwork
db.cardnetwork.createIndex({name: 1}, {unique: true, background: true});

//chargeback
db.chargeback.createIndex({cardissuerreferencedata: 1}, {unique: true, background: true});
db.chargeback.createIndex({"arapdispute.batchnumber": 1, companyid: 1}, {background: true});
db.chargeback.createIndex({"closedtime": -1, "chargebackevents.date": -1}, {background: true});
db.chargeback.createIndex({"chargebackevents.type": 1, "closedtime": -1}, {background: true});
db.chargeback.createIndex({"chargebackevents.claimid": 1}, {background: true});
db.chargeback.createIndex({"chargebackevents.relatedfinancial.authorizationtracenumber": 1}, {background: true});
db.chargeback.createIndex({"chargebackevents.visafields.vrolcasenumber": 1}, {background: true});
db.chargeback.createIndex({"companyid": 1, "chargebackevents.date": 1}, {background: true});
db.chargeback.createIndex({"chargebackevents.relatedfinancial.acquirerreferencedata": 1}, {background: true});

//client
db.client.createIndex({fiid: 1, name: 1}, {unique: true, background: true});
db.client.createIndex({name: "text"}, {background: true});
db.client.createIndex({"externalfiid": 1, "externalclientid": 1}, {background: true});

//company
db.company.createIndex({clientid: 1, name: 1}, {unique: true, background: true});
db.company.createIndex({companynumber: 1}, {unique: true, background: true});
db.company.createIndex({name: "text"}, {background: true});
db.company.createIndex({legalname: "text"}, {background: true});
db.company.createIndex({"billingfeatures.paymentmethod": 1}, {background: true});

//conversionrate
db.conversionrate.createIndex({effectivedate: 1, scheme: 1}, {unique: true, background: true});
db.conversionrate.createIndex({ratetableid: 1, effectivedate: -1, scheme: 1}, {background: true});

//event
db.event.createIndex({created: -1}, {background: true});
db.event.createIndex({name: 1}, {background: true});
db.event.createIndex({filename: 1}, {background: true});
db.event.createIndex({"name": 1, "status": 1, "expectresponse": 1, "responseeventid": 1}, {background: true});

//exception
db.exception.createIndex({tranid: 1}, {unique: true, background: true});
db.exception.createIndex({fiid: 1, settlementdate: 1, created: 1}, {background: true});
db.exception.createIndex({"postedfinancialid": 1}, {background: true});
db.exception.createIndex({"batchid": 1, "fiid": 1}, {background: true});

//failed login
db.failedlogin.createIndex({created: 1}, {expireAfterSeconds: 900, background: true});

//fi
db.fi.createIndex({name: "text"}, {background: true});
db.fi.createIndex({name: 1}, {unique: true, background: true});

//fileinfo
db.fileinfo.createIndex({created: 1}, {background: true});

//financial
db.financial.createIndex({clearedtime: -1}, {background: true});
db.financial.createIndex({cardid: 1}, {background: true});
db.financial.createIndex({companyid: 1}, {background: true});
db.financial.createIndex({clientid: 1}, {background: true});
db.financial.createIndex({postedtime: 1}, {background: true});
db.financial.createIndex({fiid: 1, settlementdate: 1, created: 1}, {background: true});
db.financial.createIndex({fiid: 1, settlementdate: 1, posteddate: 1}, {background: true});
db.financial.createIndex({acquirerreferencedata: 1, cardlastfour: 1}, {background: true});
db.financial.createIndex({cardissuerreferencedata: 1, cardlastfour: 1}, {background: true});
db.financial.createIndex({"companyid": 1, "postedtime": 1}, {background: true});
db.financial.createIndex({"companyid": 1, "fiid": 1, "created": -1}, {background: true});
db.financial.createIndex({"batchid": 1, "fiid": 1, "companyid": 1}, {background: true});
db.financial.createIndex({
    "bin": 1,
    "debitcredit": 1,
    "postedtime": 1,
    "regionalarrangementtype": 1
}, {background: true});
db.financial.createIndex({"fiid": 1, "reasoncode": 1, "postedtime": 1}, {background: true});
db.financial.createIndex({"companyid": 1, "fiid": 1, "postedtime": 1}, {background: true});
db.financial.createIndex({"reversedbyfinancialid": 1}, {background: true});
db.financial.createIndex({"sourcetransactionid": 1}, {background: true});
db.financial.createIndex({"idempotencykey": 1}, {background: true});
db.financial.createIndex({
    "fiid": 1,
    "subtype": 1,
    "visafields.usagecode": 1,
    "wassentafterclosesecondpresentment" : 1
},{background: true});

//fraud
db.fraud.createIndex({authid: 1}, {background: true});
db.fraud.createIndex({transactionid: 1}, {background: true});

//genericdetailaddenda
db.genericdetailaddenda.createIndex({"batchid": 1, "fiid": 1}, {background: true});

//idempotentrequestcache
db.idempotentrequestcache.createIndex({"origin": 1, "key": 1}, {background: true, unique: true});
db.idempotentrequestcache.createIndex({"created": 1}, {background: true, expireAfterSeconds: 86400});

//lodgingaddenda
db.lodgingaddenda.createIndex({"batchid": 1, "fiid": 1}, {background: true});

//mcc
db.mcc.createIndex({fiid: 1}, {sparse: true, background: true});
db.mcc.createIndex({clientid: 1}, {sparse: true, background: true});
db.mcc.createIndex({companyid: 1}, {sparse: true, background: true});

//oauthtoken
db.oauthtoken.createIndex({accesstoken: 1}, {unique: true, background: true});

//partner
db.partner.createIndex({name: 1}, {unique: true, background: true});

//performancemetric
db.performancemetric.createIndex({starttime: 1}, {background: true});

//purchasedetailaddenda
db.purchasedetailaddenda.createIndex({"batchid": 1, "fiid": 1}, {background: true});
db.purchasedetailaddenda.createIndex({"sourcetransactionid": 1}, {background: true});

//purchaseheaderaddenda
db.purchaseheaderaddenda.createIndex({"batchid": 1, "fiid": 1}, {background: true});

//corporatefleetaddenda
db.corporatefleetaddenda.createIndex({"sourcetransactionid": 1}, {background: true});

//queuelock (expire after 24 hours)
db.queuelock.createIndex({createdat: 1}, {expireAfterSeconds: 86400, background: true});

//report
db.report.createIndex({"created": 1}, {background: true});

//role
db.role.createIndex({name: 1, fiid: 1}, {unique: true, background: true});
db.role.createIndex({name: "text"}, {background: true});

//statement
db.statement.createIndex({enddate: -1}, {background: true});
db.statement.createIndex({statementdate: -1, companyid: 1}, {background: true});
db.statement.createIndex({companyid: 1, enddate: -1}, {background: true});
db.statement.createIndex({"s3key": 1, "created": -1}, {background: true});

//statementchronos
db.statementchronos.createIndex({enddate: -1}, {background: true});
db.statementchronos.createIndex({statementdate: -1, companyid: 1}, {background: true});
db.statementchronos.createIndex({companyid: 1, corecardstatementid: -1}, {background: true});
db.statementchronos.createIndex({companyid: 1, enddate: -1}, {background: true});

//transaction
db.transaction.createIndex({batchid: 1}, {background: true});
db.transaction.createIndex({batchid: 1, messagenumber: 1}, {background: true});
db.transaction.createIndex({"created": 1}, {background: true});

//traveldetailairlineaddenda
db.traveldetailairlineaddenda.createIndex({"batchid": 1, "fiid": 1}, {background: true});

//traveldetailrailaddenda
db.traveldetailrailaddenda.createIndex({"batchid": 1, "fiid": 1}, {background: true});

//travelheaderaddenda
db.travelheaderaddenda.createIndex({"batchid": 1, "fiid": 1}, {background: true});

//vehicleaddenda
db.vehicleaddenda.createIndex({"batchid": 1, "fiid": 1}, {background: true});

//membersettlementdata
db.membersettlementdata.createIndex({"reporttype": 1, "reportdate": 1}, {background: true});

//user
db.user.createIndex({username: 1}, {unique: true, background: true});
db.user.createIndex({username: "text"}, {background: true});

db.batch.createIndex({"fileid.baseiiuniquefileid": 1}, {background: true});
db.batch.createIndex({type: 1, "fileid.filereferencedate": 1, "fileid.filesequencenumber": 1}, {background: true});
db.batch.createIndex({type: 1, "name": 1}, {background: true});

// companybalanceatmidnight
db.companybalanceatmidnight.createIndex({"created": 1}, {expireAfterSeconds: 63072000, background: true});  // Expire after 2 years
db.companybalanceatmidnight.createIndex({"companyid": 1, "date": 1}, {unique: true, background: true});
db.companybalanceatmidnight.createIndex({"companyid": 1, "date": -1}, {background: true});

// Chronos
db.aging_event.createIndex({"entityid": 1, "date": 1}, {background: true});
db.aging_event.createIndex({"sourceid": 1}, {background: true});

print('...done creating indexes');
