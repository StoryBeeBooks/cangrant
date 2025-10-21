-- ============================================================================
-- FIX SUPABASE SECURITY WARNINGS AND BUSINESS PROFILE UPDATE
-- Run this in Supabase SQL Editor to fix the security warnings
-- ============================================================================

-- Fix 1: Update the handle_new_user function with proper search_path
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER 
SECURITY DEFINER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.profiles (user_id, email, free_views_remaining, role)
  VALUES (NEW.id, NEW.email, 3, 'user');
  RETURN NEW;
END;
$$;

-- Fix 2: Update the update_updated_at_column function with proper search_path
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
SET search_path = public
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

-- Fix 3: Check the current RLS policies on profiles table
SELECT schemaname, tablename, policyname, roles, cmd, qual 
FROM pg_policies 
WHERE tablename = 'profiles';

-- Fix 4: Ensure UPDATE policy allows users to update their own business_profile
-- Drop existing update policy and recreate it
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;

CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- Fix 5: Verify the policy was created correctly
SELECT * FROM pg_policies WHERE tablename = 'profiles' AND policyname = 'Users can update own profile';

-- ============================================================================
-- TESTING QUERIES
-- Run these to test if the update works
-- ============================================================================

-- 1. Check your current profile
SELECT user_id, email, business_profile, role 
FROM profiles 
WHERE email = 'marioxu@yahoo.ca';

-- 2. Test manual update (as admin, this should work)
-- UPDATE profiles 
-- SET business_profile = '{"test": "value"}'::jsonb
-- WHERE email = 'marioxu@yahoo.ca';

-- 3. Check if update worked
-- SELECT user_id, email, business_profile 
-- FROM profiles 
-- WHERE email = 'marioxu@yahoo.ca';
