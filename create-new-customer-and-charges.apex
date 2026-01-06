// Create a brand new customer
Customer__c newCustomer = new Customer__c();
newCustomer.Name = 'Horizon Technologies';
newCustomer.Billing_Street__c = '500 Innovation Way';
newCustomer.Billing_City__c = 'Seattle';
newCustomer.Billing_State__c = 'WA';
newCustomer.Billing_Zip__c = '98101';

insert newCustomer;

// Query it back to get the auto-generated customer number
newCustomer = [SELECT Id, Name, Customer_Number__c FROM Customer__c WHERE Id = :newCustomer.Id];
System.debug('Created new customer: ' + newCustomer.Name + ' (' + newCustomer.Customer_Number__c + ', ID: ' + newCustomer.Id + ')');

// Create unbilled charges for this customer
List<Charge__c> charges = new List<Charge__c>();

charges.add(new Charge__c(
    Customer__c = newCustomer.Id,
    Description__c = 'Cloud Infrastructure Services - January 2026',
    Amount__c = 3200.00,
    Charge_Date__c = Date.newInstance(2026, 1, 3)
));

charges.add(new Charge__c(
    Customer__c = newCustomer.Id,
    Description__c = 'Technical Support - Q1 2026',
    Amount__c = 1800.00,
    Charge_Date__c = Date.newInstance(2026, 1, 4)
));

charges.add(new Charge__c(
    Customer__c = newCustomer.Id,
    Description__c = 'Security Audit Services',
    Amount__c = 2500.00,
    Charge_Date__c = Date.newInstance(2026, 1, 5)
));

insert charges;
System.debug('Created ' + charges.size() + ' unbilled charges');
System.debug('Total amount: $' + (3200.00 + 1800.00 + 2500.00));
System.debug('');
System.debug('New customer is ready! Look for "Horizon Technologies" in your Salesforce org.');
System.debug('Customer Number: ' + newCustomer.Customer_Number__c);
System.debug('Expected invoice total: $7,500.00');
