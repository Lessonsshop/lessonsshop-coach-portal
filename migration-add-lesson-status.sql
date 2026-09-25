alter table public.lessons
add column if not exists status text;

update public.lessons
set status = 'scheduled'
where status is null or btrim(status) = '';

alter table public.lessons
alter column status set default 'scheduled';

alter table public.lessons
alter column status set not null;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'lessons_status_check'
      and conrelid = 'public.lessons'::regclass
  ) then
    alter table public.lessons
    add constraint lessons_status_check
    check (status in ('scheduled', 'completed'));
  end if;
end $$;
