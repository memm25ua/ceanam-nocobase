-- Migration 001 — Integrity check constraints for the CRM domain model
-- Idempotent: re-runnable safely. Each ALTER is wrapped in a DO block that
-- skips creation if the constraint already exists.
--
-- Apply with:
--   psql "$DATABASE_URL" -f migrations/001_check_constraints.sql
-- or via Coolify shell on the Postgres container.

\set ON_ERROR_STOP on

-- ============================================================
-- domain_enrollments: XOR between recurrent and one-off flavors
-- Exactly one of (recurrence_pattern_id, class_session_id) must be set.
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'domain_enrollments') THEN
    RAISE NOTICE 'domain_enrollments not present yet — skipping enrollment_kind_xor';
    RETURN;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'enrollment_kind_xor'
      AND conrelid = 'domain_enrollments'::regclass
  ) THEN
    ALTER TABLE domain_enrollments
      ADD CONSTRAINT enrollment_kind_xor
      CHECK ((recurrence_pattern_id IS NULL) <> (class_session_id IS NULL));
  END IF;
END$$;

-- ============================================================
-- domain_contracts: kind <-> required fields consistency
-- regular_mensual: requires academic_level_id + weekly_hours, service_id null.
-- other kinds: requires service_id, academic_level_id + weekly_hours null.
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'domain_contracts') THEN
    RAISE NOTICE 'domain_contracts not present yet — skipping contract_kind_fields_consistent';
    RETURN;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'contract_kind_fields_consistent'
      AND conrelid = 'domain_contracts'::regclass
  ) THEN
    ALTER TABLE domain_contracts
      ADD CONSTRAINT contract_kind_fields_consistent
      CHECK (
        (kind = 'regular_mensual'
           AND academic_level_id IS NOT NULL
           AND weekly_hours IS NOT NULL
           AND service_id IS NULL)
        OR
        (kind <> 'regular_mensual'
           AND service_id IS NOT NULL
           AND academic_level_id IS NULL
           AND weekly_hours IS NULL)
      );
  END IF;
END$$;

-- ============================================================
-- domain_attendances: one row per (enrollment, session)
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'domain_attendances') THEN
    RAISE NOTICE 'domain_attendances not present yet — skipping attendance_unique_pair';
    RETURN;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'attendance_unique_pair'
      AND conrelid = 'domain_attendances'::regclass
  ) THEN
    ALTER TABLE domain_attendances
      ADD CONSTRAINT attendance_unique_pair
      UNIQUE (enrollment_id, class_session_id);
  END IF;
END$$;

-- ============================================================
-- domain_pricing_tariffs: one row per (level, weekly_hours, effective_from)
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = 'domain_pricing_tariffs') THEN
    RAISE NOTICE 'domain_pricing_tariffs not present yet — skipping tariff_unique_slot';
    RETURN;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'tariff_unique_slot'
      AND conrelid = 'domain_pricing_tariffs'::regclass
  ) THEN
    ALTER TABLE domain_pricing_tariffs
      ADD CONSTRAINT tariff_unique_slot
      UNIQUE (academic_level_id, weekly_hours, effective_from);
  END IF;
END$$;
