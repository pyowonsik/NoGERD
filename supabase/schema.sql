-- ============================================
-- NoGERD Supabase Schema
-- 생성일: 2026-01-13
-- ============================================

-- ============================================
-- 1. 증상 기록 (symptom_records)
-- ============================================
CREATE TABLE symptom_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  symptoms TEXT[] NOT NULL,
  severity INTEGER NOT NULL CHECK (severity >= 1 AND severity <= 10),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 2. 식사 기록 (meal_records)
-- ============================================
CREATE TABLE meal_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  meal_type TEXT NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
  foods TEXT[] NOT NULL,
  triggers TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 3. 약물 복용 기록 (medication_records)
-- ============================================
CREATE TABLE medication_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  medication_type TEXT NOT NULL CHECK (medication_type IN ('ppi', 'h2_blocker', 'antacid', 'prokinetic')),
  medication_name TEXT NOT NULL,
  effectiveness TEXT CHECK (effectiveness IN ('good', 'moderate', 'poor')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 4. 생활습관 기록 (lifestyle_records)
-- ============================================
CREATE TABLE lifestyle_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('sleep', 'stress', 'activity')),
  -- 수면 관련
  sleep_hours DECIMAL(3,1) CHECK (sleep_hours >= 0 AND sleep_hours <= 12),
  sleep_position TEXT CHECK (sleep_position IN ('back', 'left_side', 'right_side', 'prone')),
  late_night_meal BOOLEAN,
  -- 스트레스 관련
  stress_level INTEGER CHECK (stress_level >= 1 AND stress_level <= 10),
  -- 활동 관련
  exercised BOOLEAN,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 5. 사용자 설정 (user_settings)
-- ============================================
CREATE TABLE user_settings (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  notification_enabled BOOLEAN DEFAULT true,
  notification_time TIME DEFAULT '21:00',
  theme TEXT DEFAULT 'system' CHECK (theme IN ('light', 'dark', 'system')),
  language TEXT DEFAULT 'ko',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- 인덱스
-- ============================================
CREATE INDEX idx_symptom_records_user_datetime ON symptom_records(user_id, record_datetime DESC);
CREATE INDEX idx_meal_records_user_datetime ON meal_records(user_id, record_datetime DESC);
CREATE INDEX idx_medication_records_user_datetime ON medication_records(user_id, record_datetime DESC);
CREATE INDEX idx_lifestyle_records_user_datetime ON lifestyle_records(user_id, record_datetime DESC);

-- ============================================
-- RLS (Row Level Security) 활성화
-- ============================================
ALTER TABLE symptom_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE medication_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE lifestyle_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

-- ============================================
-- RLS 정책
-- ============================================
CREATE POLICY "Users CRUD own symptom_records" ON symptom_records
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users CRUD own meal_records" ON meal_records
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users CRUD own medication_records" ON medication_records
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users CRUD own lifestyle_records" ON lifestyle_records
  FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "Users CRUD own user_settings" ON user_settings
  FOR ALL USING (auth.uid() = user_id);

-- ============================================
-- 트리거: updated_at 자동 갱신
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_settings_updated_at
  BEFORE UPDATE ON user_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
