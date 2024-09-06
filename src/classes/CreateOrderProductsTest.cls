@isTest
public class CreateOrderProductsTest {

    @isTest
    static void testCreateOrderProducts() {
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

        // Create an Order associated with the Quote
        Order order = new Order(
                Name = 'Test Order',
                AccountId = acc.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                QuoteId = quote.Id
        );
        insert order;

        // Verify if OrderItem is created
        List<OrderItem> orderItems = [SELECT Id, OrderId, Product2Id, Quantity, UnitPrice, PricebookEntryId, QuoteLineItemId FROM OrderItem WHERE OrderId = :order.Id];
        System.assertEquals(1, orderItems.size(), 'An OrderItem should be created.');
        OrderItem createdOrderItem = orderItems[0];

        System.assertEquals(order.Id, createdOrderItem.OrderId, 'The OrderItem should have the correct OrderId.');
        System.assertEquals(product.Id, createdOrderItem.Product2Id, 'The OrderItem should have the correct Product2Id.');
        System.assertEquals(2, createdOrderItem.Quantity, 'The OrderItem should have the correct Quantity.');
        System.assertEquals(50, createdOrderItem.UnitPrice, 'The OrderItem should have the correct UnitPrice.');
        System.assertEquals(pricebookEntry.Id, createdOrderItem.PricebookEntryId, 'The OrderItem should have the correct PricebookEntryId.');
        System.assertEquals(qli.Id, createdOrderItem.QuoteLineItemId, 'The OrderItem should have the correct QuoteLineItemId.');
    }

    @isTest
    static void testOrderWithoutQuote() {
        // Create test data
        Account acc = new Account(Name = 'Test Account No Quote');
        insert acc;

        // Create an Order without QuoteId
        Order order = new Order(
                Name = 'Test Order No Quote',
                AccountId = acc.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                QuoteId = null
        );
        insert order;

        // Verify no OrderItems are created
        List<OrderItem> orderItems = [SELECT Id FROM OrderItem WHERE OrderId = :order.Id];
        System.assertEquals(0, orderItems.size(), 'No OrderItems should be created for Order without QuoteId.');
    }

    @isTest
    static void testOrderWithNonexistentQuote() {
        // Create test data
        Account acc = new Account(Name = 'Test Account Nonexistent Quote');
        insert acc;

        // Create an Order with a non-existent QuoteId
        Order order = new Order(
                Name = 'Test Order Nonexistent Quote',
                AccountId = acc.Id,
                EffectiveDate = Date.today(),
                Status = 'Draft',
                QuoteId = 'a000000000000000' // Non-existent QuoteId
        );
        insert order;

        // Verify no OrderItems are created
        List<OrderItem> orderItems = [SELECT Id FROM OrderItem WHERE OrderId = :order.Id];
        System.assertEquals(0, orderItems.size(), 'No OrderItems should be created for Order with non-existent QuoteId.');
    }
}
