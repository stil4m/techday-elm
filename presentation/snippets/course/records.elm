person = { name = "Mats Stijlaart", "age" = 25}
company = { name = "Avisi", "location" = "Arnhem"}


person.name  -- "Mats Stijlaart"
.name person -- "Mats Stijlaart"


List.map .name people
List.map .name [person, company]


printName : { a | name : String } -> String
printName x = "Name is: " ++ x.name
printName {name} = "Name is: " ++ name


{ person | name = "Chuck Norris"}
