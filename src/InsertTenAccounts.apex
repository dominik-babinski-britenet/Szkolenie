List<Account> accountsToAdd = new List<Account>();

for(Integer i = 0; i < 10; i++)
{
    accountsToAdd.add(new Account(Name = 'Sample Account ' + i));
}

upsert accountsToAdd Name;
