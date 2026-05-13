USE RikkeiClinicDB;

DELIMITER //

    CREATE PROCEDURE AddInventory(IN p_item_id INT, IN p_quantity INT)
    BEGIN
        
            UPDATE Inventory
            SET stock_quantity = stock_quantity + p_quantity
            WHERE item_id = p_item_id;
   
    END //
    
    DELIMITER ;
    
    CALL AddInventory(10, -500);
    
    /*
    Lệnh UPDATE hiện tại thực hiện phép tính stock_quantity + p_quantity một cách máy móc mà không kiểm tra điều kiện. Khi tham số truyền vào là số âm, theo toán học cơ bản, phép cộng với số âm sẽ biến thành phép trừ (ví dụ: + (-500)),
    dẫn đến việc trừ thẳng vào tồn kho hiện tại.
    */
    DROP PROCEDURE IF EXISTS AddInventory;
    
    DELIMITER //

    CREATE PROCEDURE AddInventory(IN p_item_id INT, IN p_quantity INT)
    BEGIN
        -- Ràng buộc: Chỉ thực hiện UPDATE nếu số lượng nhập lớn hơn 0
        IF p_quantity > 0 THEN
            UPDATE Inventory
            SET stock_quantity = stock_quantity + p_quantity
            WHERE item_id = p_item_id;
        END IF;
    END //

    DELIMITER ;