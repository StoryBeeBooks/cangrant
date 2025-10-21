# SQL Requirements for Supabase AI Copilot

Copy and paste this into Supabase AI Copilot to generate the SQL code:

---

## REQUIREMENT 1: Create Grants Table

**Prompt for AI:**

```
Create a PostgreSQL table called "grants" with the following structure:

- id: serial primary key
- title: text, required
- list_summary: text, required (short description for list view)
- full_details: text, required (full grant description)
- status: text, required, must be one of: 'Open', 'Closed', 'Coming Soon', 'Rolling Basis'
- application_open_date: date, optional
- deadline: date, optional
- amount_max: integer, required (maximum grant amount in dollars)
- issuing_body: text, required (government department or organization name)
- grant_link: text, required (URL to application page)
- created_at: timestamp with timezone, default now()
- updated_at: timestamp with timezone, default now()
- is_active: boolean, default true

Add these indexes for performance:
- Index on status column
- Index on deadline column
- Index on is_active column
- Index on updated_at column

Enable Row Level Security (RLS) on this table.

Create a policy that allows anyone (including unauthenticated users) to read grants where is_active = true.

Create a trigger function to automatically update the updated_at column whenever a row is modified.
```

---

## REQUIREMENT 2: Create Tag Tables (Eligibility, Industry, Type)

**Prompt for AI:**

```
Create three separate tag tables with many-to-many relationships to the grants table:

1. eligibility_tags table:
   - id: serial primary key
   - name: text, required, unique

2. industry_tags table:
   - id: serial primary key
   - name: text, required, unique

3. type_tags table:
   - id: serial primary key
   - name: text, required, unique

Create junction tables for many-to-many relationships:

1. grant_eligibility:
   - grant_id: integer, references grants(id), cascade delete
   - tag_id: integer, references eligibility_tags(id), cascade delete
   - Primary key: (grant_id, tag_id)
   - Index on grant_id

2. grant_industries:
   - grant_id: integer, references grants(id), cascade delete
   - tag_id: integer, references industry_tags(id), cascade delete
   - Primary key: (grant_id, tag_id)
   - Index on grant_id

3. grant_types:
   - grant_id: integer, references grants(id), cascade delete
   - tag_id: integer, references type_tags(id), cascade delete
   - Primary key: (grant_id, tag_id)
   - Index on grant_id

Enable Row Level Security on all 6 tables (3 tag tables + 3 junction tables).

Create policies that allow anyone to read all tag tables and junction tables.
```

---

## REQUIREMENT 3: Create Admin System

**Prompt for AI:**

```
I have an existing "profiles" table. Add the following to it:

Add a new column called "role" with these properties:
- Type: text
- Default value: 'user'
- Must be one of: 'user' or 'admin'
- Check constraint to enforce allowed values

Check if the role column already exists before adding it (use IF NOT EXISTS logic).

Then create policies for the grants table:
- Only users with role = 'admin' can INSERT, UPDATE, or DELETE grants
- The admin check should use: EXISTS (SELECT 1 FROM profiles WHERE profiles.user_id = auth.uid() AND profiles.role = 'admin')

Create similar admin-only modification policies for:
- eligibility_tags table
- industry_tags table  
- type_tags table
- grant_eligibility table
- grant_industries table
- grant_types table
```

---

## REQUIREMENT 4: Insert Initial Tag Data

**Prompt for AI:**

```
Insert the following initial tag data, using ON CONFLICT DO NOTHING to prevent duplicates:

Eligibility tags:
- Corporation
- Non-profit
- Charity

Industry tags:
- Art
- Education
- Environment
- Employment

Type tags:
- Federal
- Provincial
- Company
- City
```

---

## REQUIREMENT 5: Insert Sample Grant Data

**Prompt for AI:**

```
Insert 4 sample grants with the following data:

Grant 1:
- title: "Funding for Art"
- list_summary: "Federal funding for corporations seeking great artists for art projects."
- full_details: "Funding for Art - seeking great artists. Administered by the Government of Canada, this fund is dedicated to supporting incorporated artistic ventures."
- status: "Closed"
- application_open_date: September 1, 2025
- deadline: September 20, 2025
- amount_max: 5000
- issuing_body: "Government of Canada"
- grant_link: "www.storybee.space"
- Tags: eligibility="Corporation", industry="Art", type="Federal"

Grant 2:
- title: "Funding for Provincial Education"
- list_summary: "Provincial funding from Ontario for organizations seeking to hire teachers."
- full_details: "Funding for Provincial Education - seeking teachers. The Ontario government offers this grant to support educational initiatives across the province."
- status: "Open"
- application_open_date: September 2, 2025
- deadline: November 23, 2025
- amount_max: 20000
- issuing_body: "Ontario"
- grant_link: "www.nridl.org"
- Tags: eligibility="Non-profit", industry="Education", type="Provincial"

Grant 3:
- title: "Funding for Women Entrepreneurs"
- list_summary: "Corporate funding from BMO to encourage gender equity and support charitable environmental causes."
- full_details: "Funding for Women Entrepreneurs - Encourage gender equity. BMO initiative for Women Entrepreneurs."
- status: "Open"
- application_open_date: August 11, 2024
- deadline: November 12, 2025
- amount_max: 3400
- issuing_body: "BMO"
- grant_link: "www.irpartners.ca"
- Tags: eligibility="Charity", industry="Environment", type="Company"

Grant 4:
- title: "Funding for Employment"
- list_summary: "Municipal funding from the City of Toronto to encourage the hiring of local employees."
- full_details: "Funding for Employment - encourage local employees. The City of Toronto provides this grant on a rolling basis."
- status: "Rolling Basis"
- application_open_date: null (no specific date)
- deadline: null (rolling basis)
- amount_max: 8700
- issuing_body: "City of Toronto"
- grant_link: "www.allcornerstone.com"
- Tags: eligibility="Corporation" and "Non-profit", industry="Employment", type="City"

Use ON CONFLICT DO NOTHING to prevent duplicates if this runs multiple times.

After inserting grants, link them to their tags using the junction tables:
- Link each grant to its eligibility tags
- Link each grant to its industry tags
- Link each grant to its type tags
```

---

## REQUIREMENT 6: Create Query Helper Function (Optional)

**Prompt for AI:**

```
Create a PostgreSQL function called "get_grants_with_tags" that returns all active grants with their associated tags in a single query.

The function should return:
- All columns from grants table
- An array of eligibility tag names
- An array of industry tag names  
- An array of type tag names

Only return grants where is_active = true.

Order results by:
1. status (Open first, then Rolling Basis, then Coming Soon, then Closed)
2. deadline ascending (nulls last)

This will make it easier for the Flutter app to fetch grants with all their tags in one API call.
```

---

## How to Use These Prompts

### Option A: Use Supabase AI Copilot (Recommended)

1. Go to Supabase SQL Editor
2. Look for the AI Copilot button/feature
3. Copy and paste EACH requirement above (one at a time!)
4. Let the AI generate the SQL
5. Review the generated SQL
6. Click "Run" to execute

**Do them IN ORDER** (1 through 6) because later requirements depend on earlier ones!

### Option B: Manual Approach

If the AI doesn't work well, I can provide you the exact SQL code again, but broken into smaller, simpler chunks that are easier to debug.

---

## Verification Queries

After running all requirements, run these to verify everything worked:

### Check tables were created:
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('grants', 'eligibility_tags', 'industry_tags', 'type_tags', 'grant_eligibility', 'grant_industries', 'grant_types');
```

Should show all 7 tables.

### Check grants were inserted:
```sql
SELECT id, title, status, deadline FROM grants;
```

Should show 4 grants.

### Check tags were created:
```sql
SELECT 'eligibility' as type, name FROM eligibility_tags
UNION ALL
SELECT 'industry', name FROM industry_tags
UNION ALL
SELECT 'type', name FROM type_tags;
```

Should show 10 tags total.

### Check grant-tag relationships:
```sql
SELECT g.title, et.name as eligibility
FROM grants g
JOIN grant_eligibility ge ON g.id = ge.grant_id
JOIN eligibility_tags et ON ge.tag_id = et.id
ORDER BY g.id;
```

Should show each grant with its eligibility tags.

---

## Tips for Using AI Copilot

1. **Copy one requirement at a time** - Don't paste all 6 at once
2. **Run in order** - Start with Requirement 1, then 2, then 3, etc.
3. **Check after each** - Run the verification query before moving to next
4. **If error occurs** - Share the error message and I can help fix
5. **Be patient** - AI might take a few seconds to generate code

---

## What If AI Doesn't Understand?

If Supabase AI struggles with any requirement, tell me which one (1-6) and I'll give you the exact SQL code for that specific part.

Good luck! 🚀
