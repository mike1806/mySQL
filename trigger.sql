use dreamhome;
# every time we update the name then we will store the old value in table called "staff_audit"
Drop table if exists staff_audit;
CREATE TABLE Staff_audit (
id INT AUTO_INCREMENT PRIMARY KEY,
staffNo varchar(5) NOT NULL,
lastname VARCHAR(50) NOT NULL,
changedat DATETIME DEFAULT NULL,	
actions VARCHAR(50) DEFAULT NULL
);

Drop Trigger if exists before_staff_update;

DELIMITER $$
CREATE TRIGGER before_staff_update 
BEFORE UPDATE ON Staff #trigger is set on staff table
FOR EACH ROW 
		BEGIN
        INSERT INTO Staff_audit
        SET actions = 'update',
			staffNo = OLD.staffNo, # OLD is a key word
            lastname = OLD.lname,
            changedat = NOW(); # NOW current tistaff_auditstaffstaffme, when the change was applied
		END$$
DELIMITER ;

drop trigger before_staff_update;

INSERT INTO `DreamHome`.`staff` VALUES ('S26', 'Mark', 'Spencer', '22, London', '12312312', 'Manager', 'M', '1960-10-10', 60000, 'N12123', 'B3');


update  staff set lName='hujus' where staffNo='SG14'; # it has changed the value in staff and add to staff_audit the mention about change itself





#More advanced trigger
Delimiter //

Create  Trigger staffNotHandlingTooMuch
Before Insert ON Property_For_Rent
FOR EACH ROW

Begin
	DECLARE voCount int;		#see how variables are declared
    DECLARE msg varchar(128);
	select count(*) into voCount		#see how a query result is stored in a variable
	from property_For_Rent
	Where staffNo= new.staffNo;
    
	if voCount=3 Then
		set msg = concat('The member: ', cast(new.staffNo as char), ' is already Managing 3 properties');
        signal sqlstate '45000' set message_text = msg;
	End if;
End;
//
Delimiter ;

INSERT INTO `DreamHome`.`Property_For_Rent` (`PropertyNo`, `Street`, `Area`, `City`, `Pcode`, `Type`, `Rooms`, `Rent`, `OwnerNo`, `StaffNo`, `BranchNo`) VALUES ('PL96', '4 newman', 'kimbel', 'London', 'N33', 'Flat', '3', '300', 'CO87', 'SA9', 'B7');


drop trigger staffNotHandlingTooMuch;
