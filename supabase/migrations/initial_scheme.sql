  -- ============================================
  -- NoGERD 데이터베이스 스키마 초기화
  -- ============================================
  -- 실행일: 2026-01-15
  -- 목적: 기존 테이블 삭제 후 코드 모델 기반 재생성
  -- ============================================

  -- ============================================
  -- 1. 기존 테이블 삭제
  -- ============================================
  DROP TABLE IF EXISTS symptom_records CASCADE;
  DROP TABLE IF EXISTS meal_records CASCADE;
  DROP TABLE IF EXISTS medication_records CASCADE;
  DROP TABLE IF EXISTS lifestyle_records CASCADE;
  DROP TABLE IF EXISTS user_recent_records CASCADE;
  DROP TABLE IF EXISTS user_settings CASCADE;

  -- ============================================
  -- 2. 테이블 생성
  -- ============================================

  -- 2.1 증상 기록 테이블
  CREATE TABLE symptom_records (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
      record_datetime TIMESTAMP WITH TIME ZONE NOT NULL,
      symptoms TEXT[] NOT NULL,
      severity INTEGER NOT NULL CHECK (severity >= 0 AND severity <= 10),
      notes TEXT,
      created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE
  );

  -- 2.2 식사 기록 테이블
  CREATE TABLE meal_records (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
      record_datetime TIMESTAMP WITH TIME ZONE NOT NULL,
      meal_type TEXT NOT NULL,
      foods TEXT[] NOT NULL,
      trigger_categories TEXT[],
      fullness_level INTEGER NOT NULL CHECK (fullness_level >= 0 AND fullness_level <= 10),
      notes TEXT,
      created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE
  );

  -- 2.3 약물 기록 테이블
  CREATE TABLE medication_records (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
      record_datetime TIMESTAMP WITH TIME ZONE NOT NULL,
      is_taken BOOLEAN DEFAULT true,
      medication_types TEXT[],
      medication_name TEXT,
      dosage TEXT,
      purpose TEXT,
      effectiveness INTEGER CHECK (effectiveness >= 0 AND effectiveness <= 10),
      notes TEXT,
      created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE
  );

  -- 2.4 생활습관 기록 테이블
  CREATE TABLE lifestyle_records (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
      record_datetime TIMESTAMP WITH TIME ZONE NOT NULL,
      lifestyle_type TEXT NOT NULL,
      details JSONB NOT NULL,
      notes TEXT,
      created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE
  );

  -- ============================================
  -- 3. 인덱스 생성
  -- ============================================

  -- 증상 기록
  CREATE INDEX idx_symptom_records_user_id ON symptom_records(user_id);
  CREATE INDEX idx_symptom_records_datetime ON symptom_records(record_datetime);

  -- 식사 기록
  CREATE INDEX idx_meal_records_user_id ON meal_records(user_id);
  CREATE INDEX idx_meal_records_datetime ON meal_records(record_datetime);
  CREATE INDEX idx_meal_records_meal_type ON meal_records(meal_type);

  -- 약물 기록
  CREATE INDEX idx_medication_records_user_id ON medication_records(user_id);
  CREATE INDEX idx_medication_records_datetime ON medication_records(record_datetime);

  -- 생활습관 기록
  CREATE INDEX idx_lifestyle_records_user_id ON lifestyle_records(user_id);
  CREATE INDEX idx_lifestyle_records_datetime ON lifestyle_records(record_datetime);
  CREATE INDEX idx_lifestyle_records_type ON lifestyle_records(lifestyle_type);

  -- ============================================
  -- 4. RLS 정책 설정
  -- ============================================

  -- 증상 기록 RLS
  ALTER TABLE symptom_records ENABLE ROW LEVEL SECURITY;
  CREATE POLICY "Users can view their own symptom records" ON symptom_records FOR SELECT USING (auth.uid() = user_id);
  CREATE POLICY "Users can insert their own symptom records" ON symptom_records FOR INSERT WITH CHECK (auth.uid() = user_id);
  CREATE POLICY "Users can update their own symptom records" ON symptom_records FOR UPDATE USING (auth.uid() = user_id);
  CREATE POLICY "Users can delete their own symptom records" ON symptom_records FOR DELETE USING (auth.uid() = user_id);

  -- 식사 기록 RLS
  ALTER TABLE meal_records ENABLE ROW LEVEL SECURITY;
  CREATE POLICY "Users can view their own meal records" ON meal_records FOR SELECT USING (auth.uid() = user_id);
  CREATE POLICY "Users can insert their own meal records" ON meal_records FOR INSERT WITH CHECK (auth.uid() = user_id);
  CREATE POLICY "Users can update their own meal records" ON meal_records FOR UPDATE USING (auth.uid() = user_id);
  CREATE POLICY "Users can delete their own meal records" ON meal_records FOR DELETE USING (auth.uid() = user_id);

  -- 약물 기록 RLS
  ALTER TABLE medication_records ENABLE ROW LEVEL SECURITY;
  CREATE POLICY "Users can view their own medication records" ON medication_records FOR SELECT USING (auth.uid() = user_id);
  CREATE POLICY "Users can insert their own medication records" ON medication_records FOR INSERT WITH CHECK (auth.uid() = user_id);
  CREATE POLICY "Users can update their own medication records" ON medication_records FOR UPDATE USING (auth.uid() = user_id);
  CREATE POLICY "Users can delete their own medication records" ON medication_records FOR DELETE USING (auth.uid() = user_id);

  -- 생활습관 기록 RLS
  ALTER TABLE lifestyle_records ENABLE ROW LEVEL SECURITY;
  CREATE POLICY "Users can view their own lifestyle records" ON lifestyle_records FOR SELECT USING (auth.uid() = user_id);
  CREATE POLICY "Users can insert their own lifestyle records" ON lifestyle_records FOR INSERT WITH CHECK (auth.uid() = user_id);
  CREATE POLICY "Users can update their own lifestyle records" ON lifestyle_records FOR UPDATE USING (auth.uid() = user_id);
  CREATE POLICY "Users can delete their own lifestyle records" ON lifestyle_records FOR DELETE USING (auth.uid() = user_id);

  -- ============================================
  -- 5. 스키마 캐시 새로고침
  -- ============================================
  NOTIFY pgrst, 'reload schema';