-- ============================================
-- NoGERD Supabase Schema Migration Script
-- 작성일: 2026-01-14
-- 목적: 기존 스키마를 Flutter Entity와 호환되도록 수정
-- ============================================

-- ============================================
-- 1. 모든 테이블에 updated_at 컬럼 추가
-- ============================================
ALTER TABLE symptom_records ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;
ALTER TABLE meal_records ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;
ALTER TABLE medication_records ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;
ALTER TABLE lifestyle_records ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;

-- ============================================
-- 2. meal_records 테이블 수정
-- ============================================
-- fullness_level 컬럼 추가 (포만감 레벨 1-10)
ALTER TABLE meal_records ADD COLUMN IF NOT EXISTS fullness_level INTEGER;
ALTER TABLE meal_records ADD CONSTRAINT meal_fullness_check CHECK (fullness_level >= 1 AND fullness_level <= 10);

-- notes 컬럼 추가
ALTER TABLE meal_records ADD COLUMN IF NOT EXISTS notes TEXT;

-- meal_type에 'lateNight' (야식) 옵션 추가
ALTER TABLE meal_records DROP CONSTRAINT IF EXISTS meal_records_meal_type_check;
ALTER TABLE meal_records ADD CONSTRAINT meal_records_meal_type_check
  CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack', 'lateNight'));

-- ============================================
-- 3. medication_records 테이블 수정
-- ============================================
-- dosage 컬럼 추가 (용량 정보)
ALTER TABLE medication_records ADD COLUMN IF NOT EXISTS dosage TEXT;

-- purpose 컬럼 추가 (복용 목적)
ALTER TABLE medication_records ADD COLUMN IF NOT EXISTS purpose TEXT;

-- notes 컬럼 추가
ALTER TABLE medication_records ADD COLUMN IF NOT EXISTS notes TEXT;

-- effectiveness를 TEXT → INTEGER로 변경
-- 기존: 'good', 'moderate', 'poor'
-- 신규: 1-10 숫자 척도
ALTER TABLE medication_records DROP COLUMN IF EXISTS effectiveness;
ALTER TABLE medication_records ADD COLUMN effectiveness INTEGER;
ALTER TABLE medication_records ADD CONSTRAINT medication_effectiveness_check
  CHECK (effectiveness >= 1 AND effectiveness <= 10);

-- ============================================
-- 4. lifestyle_records 테이블 수정
-- ============================================
-- notes 컬럼 추가
ALTER TABLE lifestyle_records ADD COLUMN IF NOT EXISTS notes TEXT;

-- category 옵션 확장
-- 기존: 'sleep', 'stress', 'activity'
-- 신규: 'sleep', 'exercise', 'stress', 'smoking', 'posture'
ALTER TABLE lifestyle_records DROP CONSTRAINT IF EXISTS lifestyle_records_category_check;
ALTER TABLE lifestyle_records ADD CONSTRAINT lifestyle_records_category_check
  CHECK (category IN ('sleep', 'exercise', 'stress', 'smoking', 'posture', 'activity'));

-- ============================================
-- 5. updated_at 자동 갱신 함수 및 트리거
-- ============================================
-- 함수 생성
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 트리거 생성
DROP TRIGGER IF EXISTS update_symptom_records_updated_at ON symptom_records;
CREATE TRIGGER update_symptom_records_updated_at
    BEFORE UPDATE ON symptom_records
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_meal_records_updated_at ON meal_records;
CREATE TRIGGER update_meal_records_updated_at
    BEFORE UPDATE ON meal_records
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_medication_records_updated_at ON medication_records;
CREATE TRIGGER update_medication_records_updated_at
    BEFORE UPDATE ON medication_records
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_lifestyle_records_updated_at ON lifestyle_records;
CREATE TRIGGER update_lifestyle_records_updated_at
    BEFORE UPDATE ON lifestyle_records
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 6. RLS 정책 개선 (더 세밀한 권한 제어)
-- ============================================

-- 기존 정책 제거 (FOR ALL 대신 개별 작업별로 분리)
DROP POLICY IF EXISTS "Users CRUD own symptom_records" ON symptom_records;
DROP POLICY IF EXISTS "Users CRUD own meal_records" ON meal_records;
DROP POLICY IF EXISTS "Users CRUD own medication_records" ON medication_records;
DROP POLICY IF EXISTS "Users CRUD own lifestyle_records" ON lifestyle_records;
DROP POLICY IF EXISTS "Users CRUD own user_settings" ON user_settings;

-- === symptom_records 정책 ===
CREATE POLICY "symptom_records_select" ON symptom_records
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "symptom_records_insert" ON symptom_records
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "symptom_records_update" ON symptom_records
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "symptom_records_delete" ON symptom_records
    FOR DELETE USING (auth.uid() = user_id);

-- === meal_records 정책 ===
CREATE POLICY "meal_records_select" ON meal_records
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "meal_records_insert" ON meal_records
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "meal_records_update" ON meal_records
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "meal_records_delete" ON meal_records
    FOR DELETE USING (auth.uid() = user_id);

-- === medication_records 정책 ===
CREATE POLICY "medication_records_select" ON medication_records
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "medication_records_insert" ON medication_records
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "medication_records_update" ON medication_records
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "medication_records_delete" ON medication_records
    FOR DELETE USING (auth.uid() = user_id);

-- === lifestyle_records 정책 ===
CREATE POLICY "lifestyle_records_select" ON lifestyle_records
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "lifestyle_records_insert" ON lifestyle_records
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "lifestyle_records_update" ON lifestyle_records
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "lifestyle_records_delete" ON lifestyle_records
    FOR DELETE USING (auth.uid() = user_id);

-- === user_settings 정책 ===
CREATE POLICY "user_settings_select" ON user_settings
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "user_settings_insert" ON user_settings
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_settings_update" ON user_settings
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "user_settings_delete" ON user_settings
    FOR DELETE USING (auth.uid() = user_id);

-- ============================================
-- 7. 인덱스 추가 최적화
-- ============================================

-- 기존 인덱스는 유지되며, 추가 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_symptom_records_created_at ON symptom_records(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_meal_records_created_at ON meal_records(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_medication_records_created_at ON medication_records(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_lifestyle_records_created_at ON lifestyle_records(created_at DESC);

-- severity 기반 검색 (증상 심각도별 필터링)
CREATE INDEX IF NOT EXISTS idx_symptom_records_severity ON symptom_records(user_id, severity);

-- ============================================
-- 8. 유용한 View 생성 (선택사항)
-- ============================================

-- 사용자별 최근 기록 요약 View
CREATE OR REPLACE VIEW user_recent_records AS
SELECT
    user_id,
    'symptom' as record_type,
    id,
    record_datetime,
    created_at
FROM symptom_records
UNION ALL
SELECT
    user_id,
    'meal' as record_type,
    id,
    record_datetime,
    created_at
FROM meal_records
UNION ALL
SELECT
    user_id,
    'medication' as record_type,
    id,
    record_datetime,
    created_at
FROM medication_records
UNION ALL
SELECT
    user_id,
    'lifestyle' as record_type,
    id,
    record_datetime,
    created_at
FROM lifestyle_records
ORDER BY record_datetime DESC;

-- ============================================
-- 9. 데이터 정합성 확인 함수 (개발/디버깅용)
-- ============================================

-- 사용자의 총 기록 수 확인
CREATE OR REPLACE FUNCTION get_user_record_count(p_user_id UUID)
RETURNS TABLE(
    symptom_count BIGINT,
    meal_count BIGINT,
    medication_count BIGINT,
    lifestyle_count BIGINT,
    total_count BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        (SELECT COUNT(*) FROM symptom_records WHERE user_id = p_user_id) as symptom_count,
        (SELECT COUNT(*) FROM meal_records WHERE user_id = p_user_id) as meal_count,
        (SELECT COUNT(*) FROM medication_records WHERE user_id = p_user_id) as medication_count,
        (SELECT COUNT(*) FROM lifestyle_records WHERE user_id = p_user_id) as lifestyle_count,
        (SELECT COUNT(*) FROM symptom_records WHERE user_id = p_user_id) +
        (SELECT COUNT(*) FROM meal_records WHERE user_id = p_user_id) +
        (SELECT COUNT(*) FROM medication_records WHERE user_id = p_user_id) +
        (SELECT COUNT(*) FROM lifestyle_records WHERE user_id = p_user_id) as total_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 사용 예시:
-- SELECT * FROM get_user_record_count(auth.uid());

-- ============================================
-- 10. 기존 데이터 마이그레이션 (필요 시)
-- ============================================

-- effectiveness 값 변환 (TEXT → INTEGER)
-- 'good' → 8-10, 'moderate' → 5-7, 'poor' → 1-4
-- 주의: 기존 데이터가 있을 경우에만 실행
-- UPDATE medication_records
-- SET effectiveness = CASE
--     WHEN effectiveness::TEXT = 'good' THEN 8
--     WHEN effectiveness::TEXT = 'moderate' THEN 6
--     WHEN effectiveness::TEXT = 'poor' THEN 3
--     ELSE NULL
-- END
-- WHERE effectiveness IS NOT NULL;

-- ============================================
-- 완료 확인
-- ============================================
-- 마이그레이션이 성공적으로 완료되었는지 확인
SELECT
    'symptom_records' as table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'symptom_records'
  AND table_schema = 'public'
ORDER BY ordinal_position;

-- 트리거 확인
SELECT
    trigger_name,
    event_manipulation,
    event_object_table
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

-- RLS 정책 확인
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    cmd
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
