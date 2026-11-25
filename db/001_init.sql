drop table if exists message_delivery, message, student_parent, parent, student, class cascade;

create table class (
  id         serial primary key,
  name       text not null,
  teacher_id int not null references teacher(id)
);

create table student (
  id       serial primary key,
  name     text not null,
  class_id int not null references class(id)
);

create table parent (
  id          serial primary key,
  name        text not null,
  phone       text not null unique,
  sms_opt_out boolean not null default false
);

create table student_parent (
  student_id   int not null references student(id),
  parent_id    int not null references parent(id),
  relationship text,
  primary key (student_id, parent_id)
);

create table message (
  id         serial primary key,
  teacher_id int not null references teacher(id),
  class_id   int not null references class(id),
  title      text not null,
  content    text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz,
  deleted_at timestamptz
);

create table message_delivery (
  message_id          int not null references message(id),
  parent_id           int not null references parent(id),
  student_id          int references student(id),
  phone               text not null,
  channel             text not null default 'sms',
  status              text not null default 'queued'
                      check (status in ('queued', 'sent', 'delivered', 'failed')),
  provider_message_id text,
  error_message       text,
  sent_at             timestamptz,
  primary key (message_id, parent_id)
);
select table_name from information_schema.tables where table_schema = 'public' order by table_name;
insert into class (name, teacher_id) values ('5A', 1);
insert into student (name, class_id) values ('Tran Minh An', 1), ('Tran Bao Chau', 1),('Nguyen Thanh Phong', 1);
insert into parent (name, phone) values ('Tran Duc Anh','0932212342'),('Nguyen Cong Tuan','0332124567');
insert into student_parent (student_id, parent_id, relationship) values (3,2,'bo');
insert into message (teacher_id, class_id,title,content) values (1,1,'thong bao','noi dung thong bao');
insert into message_delivery (message_id,parent_id,phone) values (1,1,'0932212342');
uPDATE parent SET sms_opt_out = false WHERE id = 1;
delete from message_delivery where message_id = 1;

select * from student_parent; /*lay du lieu*/
select id, name, sms_opt_out from parent;
select c.name as lop, t.name as giao_vien from class c
join teacher t on t.id = c.teacher_id;
select s.name as hoc_sinh, c.name as lop from student s
join class c on c.id = s.class_id;

select distinct p.id as id_phu_huynh , p.name as phu_huynh, p.phone as sdt from student_parent sp
join student s on s.id = sp.student_id
join parent p on p.id = sp.parent_id
where s.class_id = 1 and p.sms_opt_out = false;
select id, title from message;

select t.name as giao_vien, c.name as lop,m.title as tieu_de from message m
join teacher t on t.id = m.teacher_id
join class c on c.id = m.class_id;

select m.title as tieu_de, p.name as phu_huynh from message_delivery d
join message m on m.id = d.message_id
join parent p on p.id = d.parent_id;

insert into message_delivery (message_id,parent_id,phone) select distinct 1, p.id, p.phone from student_parent sp
join parent p on p.id = sp.parent_id
join student s on s.id = sp.student_id

where s.class_id=1 and p.sms_opt_out = false
on conflict (message_id, parent_id) do nothing;
select * from message_delivery where message_id=1;