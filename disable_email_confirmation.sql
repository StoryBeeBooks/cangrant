-- ============================================================================
-- DISABLE EMAIL CONFIRMATION REQUIREMENT
-- This allows users to sign up and use the app immediately without
-- clicking a confirmation link in their email
-- ============================================================================

-- Run this in Supabase SQL Editor to disable email confirmation

-- This is a Supabase configuration change that needs to be done in the Dashboard
-- Go to: Authentication → Email Auth → "Confirm email" toggle to OFF

-- However, you can also manually confirm existing users:

-- 1. Find the user who tried to sign up
SELECT id, email, email_confirmed_at, confirmed_at 
FROM auth.users 
WHERE email = 'support@storybee.space';

-- 2. Manually confirm their email (if they already signed up)
-- Note: confirmed_at is auto-generated, so we only update email_confirmed_at
UPDATE auth.users 
SET email_confirmed_at = NOW()
WHERE email = 'support@storybee.space';

-- 3. Verify the user is now confirmed
SELECT id, email, email_confirmed_at, confirmed_at 
FROM auth.users 
WHERE email = 'support@storybee.space';

-- ============================================================================
-- DASHBOARD SETTINGS (RECOMMENDED)
-- ============================================================================
-- 
-- Instead of running SQL, go to Supabase Dashboard:
-- 1. Click on your project: "CanGrant"
-- 2. Go to: Authentication → Providers → Email
-- 3. Scroll down to "Confirm email"
-- 4. Toggle OFF "Enable email confirmations"
-- 5. Click Save
--
-- This will allow all future users to sign up without email confirmation.
-- ============================================================================
