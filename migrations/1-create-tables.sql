-- Create extension pgcrypto if it does not already exist
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Create class_title type
DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'class_title') THEN
      CREATE TYPE class_title AS ENUM (
         'Tela',
         'Acro',
         'Danza Aerea',
         'Pole',
         'ALL' -- all classes
      );
   END IF;
END
$$;

-- Create payment_type type
DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'payment_type') THEN
      CREATE TYPE payment_type AS ENUM (
         'Efectivo',
         'Transferencia',
         'Mercadopago'
      );
   END IF;
END
$$;

-- Create students table
CREATE TABLE IF NOT EXISTS students (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
  user_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Create teachers table
CREATE TABLE IF NOT EXISTS teachers (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(20),
  specialties class_title[], -- Disciplines list
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Create classes table
CREATE TABLE IF NOT EXISTS classes (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
  title class_title NOT NULL,
  capacity INT NOT NULL,
  duration INTERVAL NOT NULL, -- classe duration
  days VARCHAR[] NOT NULL, -- classes days
  start_time TIME NOT NULL, -- classe start time
  teacher_id UUID NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  FOREIGN KEY (teacher_id) REFERENCES teachers (id) ON DELETE CASCADE
);

-- Create subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
  student_id UUID NOT NULL,
  class_id UUID NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,
  FOREIGN KEY (class_id) REFERENCES classes (id) ON DELETE CASCADE
);

-- Create payments table
CREATE TABLE IF NOT EXISTS payments (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
  student_id UUID NOT NULL, -- Student making the payment
  class_id UUID NOT NULL, -- Class being paid for
  promotion_id UUID, -- Promotion applied (if any)
  payment_type payment_type NOT NULL, -- Payment type (Cash, Transfer, MercadoPago)
  amount NUMERIC(10, 2) NOT NULL, -- Payment amount
  due_date TIMESTAMP NOT NULL, -- Due date for the payment
  paid_date TIMESTAMP, -- Payment date
  paid_on_time BOOLEAN GENERATED ALWAYS AS (paid_date <= due_date) STORED, -- Whether the payment was on time
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Creation date
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Update date
  FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE, -- Reference to students
  FOREIGN KEY (class_id) REFERENCES classes (id) ON DELETE CASCADE, -- Reference to classes
  FOREIGN KEY (promotion_id) REFERENCES promotions (id) ON DELETE CASCADE -- Reference to promotions
);

-- Promotions
CREATE TABLE IF NOT EXISTS promotions (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
  class_count INT NOT NULL, -- Number of classes in the promotion (e.g., 3, 4, 8 classes)
  promo_name VARCHAR(255) NOT NULL,
  price NUMERIC(10, 2) NOT NULL, -- Total price of the promotion
  payment_type payment_type NOT NULL, -- Payment type (Cash, Transfer, MercadoPago)
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Creation date
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL -- Update date
);

-- Promotions with expiration
CREATE TABLE IF NOT EXISTS blitz_promotions (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY,
  student_id UUID NOT NULL, -- ID del estudiante
  promotion_id UUID NOT NULL, -- ID de la promoción comprada
  payment_type payment_type NOT NULL, -- Tipo de pago (Efectivo, Transferencia, MercadoPago)
  purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de compra
  expiration_date TIMESTAMP NOT NULL, -- Fecha de expiración de la promoción
  FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,
  FOREIGN KEY (promotion_id) REFERENCES promotions (id) ON DELETE CASCADE
);
