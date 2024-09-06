@isTest
public class CreateOrderOnOpportunityCloseTest {

    @isTest
    static void testCreateOrderOnOpportunityClose() {
        // Create test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Pricebook2 standardPricebook = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];

        // Create a test Product
        Product2 product = new Product2(Name = 'Test Product', isActive = TRUE);
        insert product;

        PricebookEntry pricebookEntry = new PricebookEntry(
                Pricebook2Id = standardPricebook.Id,
                Product2Id = product.Id,
                UnitPrice = 100,
                IsActive = TRUE
        );
        insert pricebookEntry;

        // Create a test Quote
        Quote quote = new Quote(
                Name = 'Test Quote',
                OpportunityId = null,
                Pricebook2Id = standardPricebook.Id,
                Status = 'Accepted'
        );
        insert quote;

        // Create Quote Line Items
        QuoteLineItem qli = new QuoteLineItem(
                QuoteId = quote.Id,
                Product2Id = product.Id,
                Quantity = 2,
                UnitPrice = 50,
                PricebookEntryId = pricebookEntry.Id
        );
        insert qli;

        // Create an Opportunity that will trigger the creation of Orders
        Opportunity opp = new Opportunity(
                Name = 'Test Opportunity',
                AccountId = acc.Id,
                StageName = 'Closed Won',
                CloseDate = Date.today()
        );
        insert opp;

        // Update Opportunity to trigger Order creation
        opp.StageName = 'Closed Won';
        update opp;

        // Verify if Order is created
        List<Order> orders = [SELECT Id, OpportunityId FROM Order WHERE OpportunityId = :opp.Id];
        System.assertEquals(1, orders.size(), 'An Order should be created for the Opportunity.');
        Order createdOrder = orders[0];

        // Verify related Order Items
        List<OrderItem> orderItems = [SELECT Id, OrderId, Product2Id, Quantity, UnitPrice FROM OrderItem WHERE OrderId = :createdOrder.Id];
        System.assertEquals(1, orderItems.size(), 'An OrderItem should be created for the Order.');
    }
}
