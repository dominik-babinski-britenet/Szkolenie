List<Account> accounts = [
        SELECT Name, (
                SELECT Name
                FROM Contacts
        )
        FROM Account
        WHERE Name LIKE '%a%'
];

for(Account acc : accounts)
{
    System.debug(acc + ' ' + acc.Contacts);
}
