@isTest
public class AccountControllerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 1; i <= 5; i++) {
            testAccounts.add(new Account(
                Name = 'Test Account ' + i,
                Type = 'Customer',
                Industry = 'Technology'
            ));
        }
        insert testAccounts;
    }
    
    @isTest
    static void testGetAccounts() {
        Test.startTest();
        List<Account> accounts = AccountController.getAccounts();
        Test.stopTest();
        
        System.assertNotEquals(null, accounts, 'Accounts list should not be null');
        System.assertEquals(5, accounts.size(), 'Should return 5 test accounts');
        System.assertEquals('Test Account 1', accounts[0].Name, 'First account name should match');
    }
    
    @isTest
    static void testCreateAccount() {
        Test.startTest();
        Id accountId = AccountController.createAccount('New Test Account', 'Prospect');
        Test.stopTest();
        
        System.assertNotEquals(null, accountId, 'Account ID should not be null');
        
        Account createdAccount = [SELECT Id, Name, Type FROM Account WHERE Id = :accountId];
        System.assertEquals('New Test Account', createdAccount.Name, 'Account name should match');
        System.assertEquals('Prospect', createdAccount.Type, 'Account type should match');
    }
    
    @isTest
    static void testCreateAccountException() {
        Test.startTest();
        try {
            // Try to create account with null name (should cause exception)
            AccountController.createAccount(null, 'Customer');
            System.assert(false, 'Exception should have been thrown');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Error creating account'), 'Exception message should contain error text');
        }
        Test.stopTest();
    }
}