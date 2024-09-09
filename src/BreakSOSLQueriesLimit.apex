List<List<Account>> accounts = new List<List<Account>>();

for (Integer i = 0; i < 21; i++) {
    accounts = [
            FIND :'ab'
            IN ALL FIELDS
            RETURNING Account(Id, Name)
    ];
}