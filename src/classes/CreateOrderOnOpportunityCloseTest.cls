@isTest
public class CreateOrderOnOpportunityCloseTest {

    @isTest
    static void testCreateOrderOnOpportunityClose() {
        // Create test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];

        // Create a test Quote
        Product2 product = new Product2(Name = 'Test Product', isActive = TRUE);
        insert product;

        PricebookEntry pricebookEntry = new PricebookEntry(
                Pricebook2Id = standardPricebook.Id,
                Product2Id = product.Id,
                UnitPrice = 100,
                IsActive = TRUE
        );
        insert pricebookEntry;

        Quote quote = new Quote(
                Name = 'Test Quote',
                OpportunityId = null,
                Pricebook2Id = standardPricebook.Id,
                Status = 'Accepted'
        );
        insert quote;

        Opportunity opp = new Opportunity(
                Name = 'Test Opportunity',
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today()
        );
        insert opp;

        quote.OpportunityId = opp.Id;
        update quote;

        // Transition Opportunity to 'Closed Won'
        opp.StageName = 'Closed Won';
        update opp;

        // Verify if Order is created
        List<Order> orders = [SELECT Id, OpportunityId, AccountId, Status, QuoteId FROM Order WHERE OpportunityId = :opp.Id];
        System.assertEquals(1, orders.size(), 'An Order should be created.');
        Order createdOrder = orders[0];

        System.assertEquals(opp.Id, createdOrder.OpportunityId, 'The Order should have the correct OpportunityId.');
        System.assertEquals(acc.Id, createdOrder.AccountId, 'The Order should have the correct AccountId.');
        System.assertEquals('Draft', createdOrder.Status, 'The Order should have the status "Draft".');
        System.assertEquals(quote.Id, createdOrder.QuoteId, 'The Order should have the correct QuoteId.');
        System.assertEquals(standardPricebook.Id, createdOrder.Pricebook2Id, 'The Order should have the correct Pricebook2Id.');
    }

    @isTest
    static void testOpportunityWithoutApprovedQuotes() {
        // Create test data
        Account acc = new Account(Name = 'Test Account No Quotes');
        insert acc;

        Opportunity opp = new Opportunity(
                Name = 'Test Opportunity No Quotes',
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today()
        );
        insert opp;

        // Transition Opportunity to 'Closed Won'
        opp.StageName = 'Closed Won';
        update opp;

        // Verify no Orders are created
        List<Order> orders = [SELECT Id FROM Order WHERE OpportunityId = :opp.Id];
        System.assertEquals(0, orders.size(), 'No Orders should be created for Opportunity without approved Quotes.');
    }

    @isTest
    static void testOpportunityNotClosingWon() {
        // Create test data
        Account acc = new Account(Name = 'Test Account Not Closing Won');
        insert acc;

        Opportunity opp = new Opportunity(
                Name = 'Test Opportunity Not Closing Won',
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today()
        );
        insert opp;

        // Update Opportunity without changing stage to 'Closed Won'
        opp.StageName = 'Negotiation/Review';
        update opp;

        // Verify no Orders are created
        List<Order> orders = [SELECT Id FROM Order WHERE OpportunityId = :opp.Id];
        System.assertEquals(0, orders.size(), 'No Orders should be created for Opportunity not closing to "Closed Won".');
    }
}
