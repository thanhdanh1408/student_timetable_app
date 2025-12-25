-- ============================================
-- FIX RLS POLICIES FOR USER REGISTRATION
-- Run this in Supabase SQL Editor
-- ============================================

-- Drop existing users policies
DROP POLICY IF EXISTS "Users can view own data" ON users;
DROP POLICY IF EXISTS "Users can update own data" ON users;
DROP POLICY IF EXISTS "Users can insert own data" ON users;

-- Allow authenticated users to INSERT (during registration via Supabase Auth)
-- The user_id must match auth.uid()
CREATE POLICY "Users can insert during registration" ON users
    FOR INSERT 
    TO authenticated
    WITH CHECK (auth.uid()::text = user_id::text);

-- Allow users to view their own data
CREATE POLICY "Users can view own data" ON users
    FOR SELECT 
    TO authenticated
    USING (auth.uid()::text = user_id::text);

-- Allow users to update their own data
CREATE POLICY "Users can update own data" ON users
    FOR UPDATE 
    TO authenticated
    USING (auth.uid()::text = user_id::text);

-- ============================================
-- FIX USER_SETTINGS POLICIES
-- ============================================

DROP POLICY IF EXISTS "Users can view own settings" ON user_settings;
DROP POLICY IF EXISTS "Users can insert own settings" ON user_settings;
DROP POLICY IF EXISTS "Users can update own settings" ON user_settings;

CREATE POLICY "Users can insert own settings" ON user_settings
    FOR INSERT 
    TO authenticated
    WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can view own settings" ON user_settings
    FOR SELECT 
    TO authenticated
    USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update own settings" ON user_settings
    FOR UPDATE 
    TO authenticated
    USING (auth.uid()::text = user_id::text);

-- ============================================
-- VERIFICATION
-- ============================================
-- Check policies:
-- SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
-- FROM pg_policies 
-- WHERE schemaname = 'public' AND tablename IN ('users', 'user_settings')
-- ORDER BY tablename, policyname;
