-- Insertar estudiantes
INSERT INTO
  students (user_name, email)
VALUES
  ('Juan Perez', 'juan.perez@email.com'),
  ('Ana Lopez', 'ana.lopez@email.com'),
  ('Carlos García', 'carlos.garcia@email.com');

-- Default teachers
INSERT INTO
  teachers (full_name, email, phone, specialties)
VALUES
  (
    'Pedro Martínez',
    'pedro.martinez@email.com',
    '1234567890',
    ARRAY['Tela', 'Acro']
  ),
  (
    'Laura Fernández',
    'laura.fernandez@email.com',
    '0987654321',
    ARRAY['Danza Aerea']
  ),
  (
    'Marta Gómez',
    'marta.gomez@email.com',
    '1122334455',
    ARRAY['Pole', 'Danza Aerea']
  );

-- Default classes
INSERT INTO
  classes (
    title,
    capacity,
    duration,
    days,
    start_time,
    teacher_id
  )
VALUES
  (
    'Tela',
    15,
    '1 hour',
    ARRAY['Lunes', 'Miércoles'],
    '10:00:00',
    (
      SELECT
        id
      FROM
        teachers
      WHERE
        email = 'pedro.martinez@email.com'
    )
  ),
  (
    'Acro',
    12,
    '1 hour 30 minutes',
    ARRAY['Martes', 'Jueves'],
    '12:00:00',
    (
      SELECT
        id
      FROM
        teachers
      WHERE
        email = 'pedro.martinez@email.com'
    )
  ),
  (
    'Pole',
    10,
    '2 hours',
    ARRAY['Miércoles', 'Viernes'],
    '10:00:00',
    (
      SELECT
        id
      FROM
        teachers
      WHERE
        email = 'marta.gomez@email.com'
    )
  ),
  (
    'Danza Aerea',
    8,
    '1 hour 30 minutes',
    ARRAY['Lunes', 'Viernes'],
    '12:00:00',
    (
      SELECT
        id
      FROM
        teachers
      WHERE
        email = 'laura.fernandez@email.com'
    )
  );

-- Default suscriptions
INSERT INTO
  subscriptions (student_id, class_id)
VALUES
  (
    (
      SELECT
        id
      FROM
        students
      WHERE
        email = 'juan.perez@email.com'
    ),
    (
      SELECT
        id
      FROM
        classes
      WHERE
        title = 'Tela'
    )
  ),
  (
    (
      SELECT
        id
      FROM
        students
      WHERE
        email = 'ana.lopez@email.com'
    ),
    (
      SELECT
        id
      FROM
        classes
      WHERE
        title = 'Acro'
    )
  ),
  (
    (
      SELECT
        id
      FROM
        students
      WHERE
        email = 'carlos.garcia@email.com'
    ),
    (
      SELECT
        id
      FROM
        classes
      WHERE
        title = 'Pole'
    )
  );

-- Default payments
INSERT INTO
  payments (
    student_id,
    class_id,
    payment_type,
    amount,
    due_date,
    paid_date
  )
VALUES
  (
    (
      SELECT
        id
      FROM
        students
      WHERE
        email = 'juan.perez@email.com'
    ),
    (
      SELECT
        id
      FROM
        classes
      WHERE
        title = 'Tela'
    ),
    'Efectivo',
    100.00,
    '2025-03-01 10:00:00',
    '2025-03-01 10:00:00'
  ),
  (
    (
      SELECT
        id
      FROM
        students
      WHERE
        email = 'ana.lopez@email.com'
    ),
    (
      SELECT
        id
      FROM
        classes
      WHERE
        title = 'Acro'
    ),
    'Transferencia',
    150.00,
    '2025-03-01 12:00:00',
    NULL
  ),
  (
    (
      SELECT
        id
      FROM
        students
      WHERE
        email = 'carlos.garcia@email.com'
    ),
    (
      SELECT
        id
      FROM
        classes
      WHERE
        title = 'Pole'
    ),
    'Mercadopago',
    120.00,
    '2025-03-02 10:00:00',
    '2025-03-02 10:30:00'
  );

-- Insert some promotions
INSERT INTO
  promotions (class_count, price, payment_type)
VALUES
  (3, '3 CLASES CASH', 600.00, 'Efectivo'), -- 3 classes, Cash payment
  (4, '4 CLASES TRANSFER', 750.00, 'Transferencia'), -- 4 classes, Transfer payment
  (8, '8 CLASES MP', 1500.00, 'Mercadopago');

-- 8 classes, MercadoPago payment
-- Insert a payment with a promotion
INSERT INTO
  payments (
    student_id,
    class_id,
    promotion_id,
    payment_type,
    amount,
    due_date
  )
VALUES
  (
    (
      SELECT
        id
      FROM
        students
      WHERE
        email = 'estudiante@email.com'
    ), -- Student
    (
      SELECT
        id
      FROM
        classes
      WHERE
        title = 'Tela'
        AND teacher_id = (
          SELECT
            id
          FROM
            teachers
          WHERE
            full_name = 'Profesor X'
        )
    ), -- Class
    (
      SELECT
        id
      FROM
        promotions
      WHERE
        class_count = 4
        AND payment_type = 'Efectivo'
    ), -- Promotion (4 classes, Cash payment)
    'Efectivo', -- Payment type
    600.00, -- Paid amount (e.g., discounted for cash payment)
    CURRENT_TIMESTAMP + INTERVAL '1 month'
  );
