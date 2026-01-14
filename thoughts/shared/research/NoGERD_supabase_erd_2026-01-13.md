# NoGERD Supabase ERD 설계

**날짜**: 2026-01-13
**분석 대상**: NoGERD 앱의 4가지 기록 유형에 맞는 Supabase ERD

---

## 1. 현재 앱 기록 유형 분석

앱에서 지원하는 4가지 기록:

| 기록 유형 | 화면 | 주요 데이터 |
|----------|------|-----------|
| 증상 기록 | SymptomRecordScreen | 증상들, 강도(1-10), 시간, 메모 |
| 식사 기록 | MealRecordScreen | 식사종류, 시간, 음식목록, 트리거태그 |
| 약물 복용 | MedicationRecordScreen | 약물종류, 약물명, 시간, 효과평가 |
| 생활습관 | LifestyleRecordScreen | 수면/스트레스/활동 데이터 |

---

## 2. ERD 다이어그램

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Supabase Database                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────┐                                                    │
│  │   auth.users        │  ← Supabase 내장 인증                               │
│  │   - id (UUID)       │                                                    │
│  │   - email           │                                                    │
│  └──────────┬──────────┘                                                    │
│             │                                                               │
│             │ (1:N)                                                         │
│             │                                                               │
│  ┌──────────┼──────────┬──────────────────┬──────────────────┐              │
│  │          │          │                  │                  │              │
│  ▼          ▼          ▼                  ▼                  ▼              │
│                                                                             │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────────────┐   │
│  │ symptom_records  │  │  meal_records    │  │  medication_records      │   │
│  │ (증상 기록)       │  │  (식사 기록)      │  │  (약물 복용 기록)         │   │
│  ├──────────────────┤  ├──────────────────┤  ├──────────────────────────┤   │
│  │ id (UUID) PK     │  │ id (UUID) PK     │  │ id (UUID) PK             │   │
│  │ user_id FK       │  │ user_id FK       │  │ user_id FK               │   │
│  │ record_datetime  │  │ record_datetime  │  │ record_datetime          │   │
│  │ symptoms TEXT[]  │  │ meal_type        │  │ medication_type          │   │
│  │ severity (1-10)  │  │ foods TEXT[]     │  │ medication_name          │   │
│  │ notes            │  │ triggers TEXT[]  │  │ effectiveness            │   │
│  │ created_at       │  │ created_at       │  │ created_at               │   │
│  └──────────────────┘  └──────────────────┘  └──────────────────────────┘   │
│                                                                             │
│  ┌──────────────────────────┐  ┌─────────────────────┐                      │
│  │   lifestyle_records      │  │   user_settings     │                      │
│  │   (생활습관 기록)          │  │   (사용자 설정)      │                      │
│  ├──────────────────────────┤  ├─────────────────────┤                      │
│  │ id (UUID) PK             │  │ user_id (UUID) PK   │                      │
│  │ user_id FK               │  │ notification_enabled│                      │
│  │ record_datetime          │  │ notification_time   │                      │
│  │ category                 │  │ theme               │                      │
│  │ sleep_hours              │  │ language            │                      │
│  │ sleep_position           │  │ created_at          │                      │
│  │ late_night_meal          │  │ updated_at          │                      │
│  │ stress_level             │  └─────────────────────┘                      │
│  │ exercised                │                                               │
│  │ created_at               │                                               │
│  └──────────────────────────┘                                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. 테이블 상세 설계

### 3.1 symptom_records (증상 기록)

앱의 `SymptomRecordScreen` 기반

| 컬럼 | 타입 | 제약조건 | 설명 |
|------|------|---------|------|
| `id` | UUID | PK, DEFAULT uuid_generate_v4() | 고유 ID |
| `user_id` | UUID | FK (auth.users), NOT NULL | 사용자 ID |
| `record_datetime` | TIMESTAMPTZ | NOT NULL | 증상 발생 시간 |
| `symptoms` | TEXT[] | NOT NULL | 증상 목록 배열 |
| `severity` | INTEGER | CHECK (1-10), NOT NULL | 증상 강도 |
| `notes` | TEXT | NULLABLE | 메모 |
| `created_at` | TIMESTAMPTZ | DEFAULT NOW() | 생성 시간 |

**symptoms 배열 값** (GerdSymptom enum 기준):
```
heartburn      - 가슴쓰림
acid_reflux    - 산역류
regurgitation  - 역류
chest_pain     - 흉통
dysphagia      - 연하곤란
chronic_cough  - 만성기침
hoarseness     - 목쉼
throat_pain    - 인후통
globus_sensation - 목이물감
nausea         - 메스꺼움
bloating       - 복부팽만
burping        - 트림
```

**SQL**:
```sql
CREATE TABLE symptom_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  symptoms TEXT[] NOT NULL,
  severity INTEGER NOT NULL CHECK (severity >= 1 AND severity <= 10),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_symptom_records_user_datetime
  ON symptom_records(user_id, record_datetime DESC);

ALTER TABLE symptom_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can CRUD own symptom_records" ON symptom_records
  FOR ALL USING (auth.uid() = user_id);
```

---

### 3.2 meal_records (식사 기록)

앱의 `MealRecordScreen` 기반

| 컬럼 | 타입 | 제약조건 | 설명 |
|------|------|---------|------|
| `id` | UUID | PK | 고유 ID |
| `user_id` | UUID | FK, NOT NULL | 사용자 ID |
| `record_datetime` | TIMESTAMPTZ | NOT NULL | 식사 시간 |
| `meal_type` | TEXT | CHECK, NOT NULL | 아침/점심/저녁/간식 |
| `foods` | TEXT[] | NOT NULL | 먹은 음식 목록 |
| `triggers` | TEXT[] | NULLABLE | 트리거 음식 태그 |
| `created_at` | TIMESTAMPTZ | DEFAULT NOW() | 생성 시간 |

**meal_type 값**:
```
breakfast - 아침
lunch     - 점심
dinner    - 저녁
snack     - 간식
```

**triggers 배열 값** (TriggerFoodCategory enum 기준):
```
fatty       - 기름진 음식
acidic      - 산성 음식
spicy       - 매운 음식
caffeine    - 카페인
alcohol     - 술
carbonated  - 탄산음료
chocolate   - 초콜릿
mint        - 민트
```

**SQL**:
```sql
CREATE TABLE meal_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  meal_type TEXT NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
  foods TEXT[] NOT NULL,
  triggers TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_meal_records_user_datetime
  ON meal_records(user_id, record_datetime DESC);

ALTER TABLE meal_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can CRUD own meal_records" ON meal_records
  FOR ALL USING (auth.uid() = user_id);
```

---

### 3.3 medication_records (약물 복용 기록)

앱의 `MedicationRecordScreen` 기반

| 컬럼 | 타입 | 제약조건 | 설명 |
|------|------|---------|------|
| `id` | UUID | PK | 고유 ID |
| `user_id` | UUID | FK, NOT NULL | 사용자 ID |
| `record_datetime` | TIMESTAMPTZ | NOT NULL | 복용 시간 |
| `medication_type` | TEXT | CHECK, NOT NULL | 약물 종류 |
| `medication_name` | TEXT | NOT NULL | 약물 이름 |
| `effectiveness` | TEXT | CHECK | 효과 평가 |
| `created_at` | TIMESTAMPTZ | DEFAULT NOW() | 생성 시간 |

**medication_type 값** (MedicationType enum 기준):
```
ppi        - PPI (양성자펌프억제제)
h2_blocker - H2 차단제
antacid    - 제산제
prokinetic - 위장운동촉진제
```

**effectiveness 값**:
```
good    - 좋음
moderate - 보통
poor    - 별로
```

**SQL**:
```sql
CREATE TABLE medication_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  medication_type TEXT NOT NULL CHECK (medication_type IN ('ppi', 'h2_blocker', 'antacid', 'prokinetic')),
  medication_name TEXT NOT NULL,
  effectiveness TEXT CHECK (effectiveness IN ('good', 'moderate', 'poor')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_medication_records_user_datetime
  ON medication_records(user_id, record_datetime DESC);

ALTER TABLE medication_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can CRUD own medication_records" ON medication_records
  FOR ALL USING (auth.uid() = user_id);
```

---

### 3.4 lifestyle_records (생활습관 기록)

앱의 `LifestyleRecordScreen` 기반 (수면/스트레스/활동 통합)

| 컬럼 | 타입 | 제약조건 | 설명 |
|------|------|---------|------|
| `id` | UUID | PK | 고유 ID |
| `user_id` | UUID | FK, NOT NULL | 사용자 ID |
| `record_datetime` | TIMESTAMPTZ | NOT NULL | 기록 시간 |
| `category` | TEXT | CHECK, NOT NULL | 수면/스트레스/활동 |
| `sleep_hours` | DECIMAL(3,1) | CHECK (0-12) | 수면 시간 |
| `sleep_position` | TEXT | CHECK | 수면 자세 |
| `late_night_meal` | BOOLEAN | | 야식 여부 |
| `stress_level` | INTEGER | CHECK (1-10) | 스트레스 레벨 |
| `exercised` | BOOLEAN | | 운동 여부 |
| `created_at` | TIMESTAMPTZ | DEFAULT NOW() | 생성 시간 |

**category 값**:
```
sleep    - 수면
stress   - 스트레스
activity - 활동
```

**sleep_position 값**:
```
back        - 똑바로
left_side   - 옆으로(왼쪽)
right_side  - 옆으로(오른쪽)
prone       - 엎드려
```

**SQL**:
```sql
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

CREATE INDEX idx_lifestyle_records_user_datetime
  ON lifestyle_records(user_id, record_datetime DESC);

ALTER TABLE lifestyle_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can CRUD own lifestyle_records" ON lifestyle_records
  FOR ALL USING (auth.uid() = user_id);
```

---

### 3.5 user_settings (사용자 설정)

| 컬럼 | 타입 | 기본값 | 설명 |
|------|------|-------|------|
| `user_id` | UUID | PK, FK | 사용자 ID |
| `notification_enabled` | BOOLEAN | true | 알림 활성화 |
| `notification_time` | TIME | '21:00' | 알림 시간 |
| `theme` | TEXT | 'system' | 테마 |
| `language` | TEXT | 'ko' | 언어 |
| `created_at` | TIMESTAMPTZ | NOW() | 생성 시간 |
| `updated_at` | TIMESTAMPTZ | NOW() | 수정 시간 |

**SQL**:
```sql
CREATE TABLE user_settings (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  notification_enabled BOOLEAN DEFAULT true,
  notification_time TIME DEFAULT '21:00',
  theme TEXT DEFAULT 'system' CHECK (theme IN ('light', 'dark', 'system')),
  language TEXT DEFAULT 'ko',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- updated_at 자동 갱신 트리거
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

ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can CRUD own settings" ON user_settings
  FOR ALL USING (auth.uid() = user_id);
```

---

## 4. 테이블 관계 요약

```
auth.users (1)
│
├── (1:N) ── symptom_records    (증상 기록)
├── (1:N) ── meal_records       (식사 기록)
├── (1:N) ── medication_records (약물 복용)
├── (1:N) ── lifestyle_records  (생활습관)
└── (1:1) ── user_settings      (사용자 설정)
```

---

## 5. 전체 SQL 스크립트

```sql
-- ============================================
-- NoGERD Supabase Schema
-- ============================================

-- 1. 증상 기록
CREATE TABLE symptom_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  symptoms TEXT[] NOT NULL,
  severity INTEGER NOT NULL CHECK (severity >= 1 AND severity <= 10),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. 식사 기록
CREATE TABLE meal_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  meal_type TEXT NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'dinner', 'snack')),
  foods TEXT[] NOT NULL,
  triggers TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. 약물 복용 기록
CREATE TABLE medication_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  medication_type TEXT NOT NULL CHECK (medication_type IN ('ppi', 'h2_blocker', 'antacid', 'prokinetic')),
  medication_name TEXT NOT NULL,
  effectiveness TEXT CHECK (effectiveness IN ('good', 'moderate', 'poor')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. 생활습관 기록
CREATE TABLE lifestyle_records (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('sleep', 'stress', 'activity')),
  sleep_hours DECIMAL(3,1) CHECK (sleep_hours >= 0 AND sleep_hours <= 12),
  sleep_position TEXT CHECK (sleep_position IN ('back', 'left_side', 'right_side', 'prone')),
  late_night_meal BOOLEAN,
  stress_level INTEGER CHECK (stress_level >= 1 AND stress_level <= 10),
  exercised BOOLEAN,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. 사용자 설정
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
-- RLS 정책
-- ============================================
ALTER TABLE symptom_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE meal_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE medication_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE lifestyle_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users CRUD own data" ON symptom_records FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users CRUD own data" ON meal_records FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users CRUD own data" ON medication_records FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users CRUD own data" ON lifestyle_records FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users CRUD own data" ON user_settings FOR ALL USING (auth.uid() = user_id);

-- ============================================
-- 트리거
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
```

---

## 6. 앱 데이터 ↔ DB 매핑

### 6.1 증상 기록 화면 → symptom_records

```dart
// 앱 데이터
Set<GerdSymptom> _selectedSymptoms;  // → symptoms TEXT[]
int _severity;                        // → severity INTEGER
TimeOfDay _selectedTime;              // → record_datetime
String _noteController.text;          // → notes
```

### 6.2 식사 기록 화면 → meal_records

```dart
// 앱 데이터
String _selectedMealType;             // → meal_type TEXT
List<String> _foods;                  // → foods TEXT[]
Set<TriggerFoodCategory> _triggers;   // → triggers TEXT[]
TimeOfDay _selectedTime;              // → record_datetime
```

### 6.3 약물 복용 화면 → medication_records

```dart
// 앱 데이터
MedicationType? _selectedType;        // → medication_type TEXT
String _medicationName;               // → medication_name TEXT
TimeOfDay _selectedTime;              // → record_datetime
String _effectiveness;                // → effectiveness TEXT
```

### 6.4 생활습관 화면 → lifestyle_records

```dart
// 앱 데이터
String _selectedCategory;             // → category TEXT

// 수면
double _sleepHours;                   // → sleep_hours DECIMAL
String _sleepPosition;                // → sleep_position TEXT
bool _lateNightMeal;                  // → late_night_meal BOOLEAN

// 스트레스
int _stressLevel;                     // → stress_level INTEGER

// 활동
bool _exercisedToday;                 // → exercised BOOLEAN
```

---

## 7. 요약

| 테이블 | 앱 화면 | 핵심 필드 |
|--------|--------|----------|
| `symptom_records` | 증상 기록 | symptoms[], severity(1-10) |
| `meal_records` | 식사 기록 | meal_type, foods[], triggers[] |
| `medication_records` | 약물 복용 | medication_type, medication_name, effectiveness |
| `lifestyle_records` | 생활습관 | category, sleep/stress/activity 데이터 |
| `user_settings` | 설정 | notification, theme, language |

이 ERD는 현재 NoGERD 앱의 4가지 기록 화면에 **정확히 1:1로 매핑**됩니다.
