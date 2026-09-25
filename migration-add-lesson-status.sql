begin;

alter table public.lessons
add column if not exists status text;

update public.lessons
set status = 'scheduled'
where status is null
   or btrim(status) = ''
   or status not in ('scheduled', 'completed');

alter table public.lessons
alter column status set default 'scheduled';

alter table public.lessons
alter column status set not null;

alter table public.lessons
drop constraint if exists lessons_status_check;

alter table public.lessons
add constraint lessons_status_check
check (status in ('scheduled', 'completed'));

commit;
