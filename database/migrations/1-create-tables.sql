-- Create class_admin database if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'class_admin') THEN
        CREATE DATABASE class_admin;
    END IF;
END $$;

-- Create pgcrypto extension if it doesn't exist
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Create class_title type if it doesn't exist
DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'class_title') THEN
      CREATE TYPE class_title AS ENUM (
         'Tela',
         'Acro',
         'Danza Aerea',
         'Pole',
         'ALL' -- All classes
      );
   END IF;
END
$$;

-- Create payment_type type if it doesn't exist
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

-- Create promotions table if it doesn't exist
CREATE TABLE IF NOT EXISTS promotions (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY, -- Unique ID for each promotion
  class_count INT NOT NULL, -- Number of classes in the promotion (e.g., 3, 4, 8 classes)
  promo_name VARCHAR(255) NOT NULL, -- Promotion name
  price NUMERIC(10, 2) NOT NULL, -- Total price of the promotion
  payment_type payment_type NOT NULL, -- Payment method (Cash, Transfer, MercadoPago)
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Timestamp when the promotion was created
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL -- Timestamp when the promotion was last updated
);

-- Create students table if it doesn't exist
CREATE TABLE IF NOT EXISTS students (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY, -- Unique ID for each student
  user_name VARCHAR(255) NOT NULL, -- Student's username
  email VARCHAR(255) UNIQUE NOT NULL, -- Unique student email
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Timestamp when the student was created
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL -- Timestamp when the student was last updated
);

-- Create teachers table if it doesn't exist
CREATE TABLE IF NOT EXISTS teachers (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY, -- Unique ID for each teacher
  full_name VARCHAR(255) NOT NULL, -- Teacher's full name
  email VARCHAR(255) UNIQUE NOT NULL, -- Unique teacher email
  phone VARCHAR(20), -- Teacher's phone number
  specialties class_title[], -- List of teacher's specialties (class titles)
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Timestamp when the teacher was created
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL -- Timestamp when the teacher was last updated
);

-- Create classes table if it doesn't exist
CREATE TABLE IF NOT EXISTS classes (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY, -- Unique ID for each class
  title class_title NOT NULL, -- Class title (from class_title enum)
  capacity INT NOT NULL, -- Maximum number of students allowed in the class
  duration INTERVAL NOT NULL, -- Duration of the class
  days VARCHAR[] NOT NULL, -- Days the class occurs
  start_time TIME NOT NULL, -- Class start time
  teacher_id UUID NOT NULL, -- Reference to the teacher teaching the class
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Timestamp when the class was created
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Timestamp when the class was last updated
  FOREIGN KEY (teacher_id) REFERENCES teachers (id) ON DELETE CASCADE -- Foreign key reference to the teacher
);

-- Create subscriptions table if it doesn't exist
CREATE TABLE IF NOT EXISTS subscriptions (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY, -- Unique ID for each subscription
  student_id UUID NOT NULL, -- Reference to the student subscribing
  class_id UUID NOT NULL, -- Reference to the class being subscribed to
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Timestamp when the subscription was created
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Timestamp when the subscription was last updated
  FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE, -- Foreign key reference to the student
  FOREIGN KEY (class_id) REFERENCES classes (id) ON DELETE CASCADE -- Foreign key reference to the class
);

-- Create payments table if it doesn't exist
CREATE TABLE IF NOT EXISTS payments (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY, -- Unique ID for each payment
  student_id UUID NOT NULL, -- Student making the payment
  class_id UUID NOT NULL, -- Class being paid for
  promotion_id UUID, -- Promotion applied (if any)
  payment_type payment_type NOT NULL, -- Payment method (Cash, Transfer, MercadoPago)
  amount NUMERIC(10, 2) NOT NULL, -- Payment amount
  due_date TIMESTAMP NOT NULL, -- Due date for the payment
  paid_date TIMESTAMP, -- Date the payment was made
  paid_on_time BOOLEAN GENERATED ALWAYS AS (paid_date <= due_date) STORED, -- Whether the payment was made on time
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Timestamp when the payment was created
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Timestamp when the payment was last updated
  FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE, -- Foreign key reference to the student
  FOREIGN KEY (class_id) REFERENCES classes (id) ON DELETE CASCADE, -- Foreign key reference to the class
  FOREIGN KEY (promotion_id) REFERENCES promotions (id) ON DELETE CASCADE -- Foreign key reference to promotions
);

-- Create blitz_promotions table with expiration if it doesn't exist
CREATE TABLE IF NOT EXISTS blitz_promotions (
  id UUID DEFAULT gen_random_uuid () PRIMARY KEY, -- Unique ID for each blitz promotion
  student_id UUID NOT NULL, -- Reference to the student who purchased the promotion
  promotion_id UUID NOT NULL, -- Reference to the promotion purchased
  payment_type payment_type NOT NULL, -- Payment method (Cash, Transfer, MercadoPago)
  purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Date the blitz promotion was purchased
  expiration_date TIMESTAMP NOT NULL, -- Expiration date of the blitz promotion
  FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE, -- Foreign key reference to the student
  FOREIGN KEY (promotion_id) REFERENCES promotions (id) ON DELETE CASCADE -- Foreign key reference to the promotion
);
