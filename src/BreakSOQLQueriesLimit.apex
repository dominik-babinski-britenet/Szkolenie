List<Account> accounts = new List<Account>();

for (Integer i = 0; i < 101; i++) {
    accounts = [
            SELECT Name
            FROM Account
    ];
}