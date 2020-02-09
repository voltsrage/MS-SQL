UPDATE Person
SET Email = 'peterparker@hotmail.com'
OUTPUT deleted.* ,inserted.*
WHERE PersonID = 1

--See what the output of the update by using OUTPUT insert.*,deleted.*
UPDATE Person
SET Phone = '9226298931'
OUTPUT deleted.* ,inserted.*
WHERE PersonID = 4