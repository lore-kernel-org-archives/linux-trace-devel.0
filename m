Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E50C4320E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4BB8610FE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbhHCRG7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 13:06:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237510AbhHCRGU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 13:06:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD08E60230;
        Tue,  3 Aug 2021 17:06:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxrj-002ubN-Fk; Tue, 03 Aug 2021 13:06:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 00/22] libtracefs: Introducing tracefs_sql() to create synthetice events with an SQL line
Date:   Tue,  3 Aug 2021 13:05:44 -0400
Message-Id: <20210803170606.694085-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Special thanks to:

  Lukas Bulwahn for first introducing the idea at RT Summit on the Summit
    Spring of 2019.
    
  Daniel Black for sorting out the syntax of mapping the synthetic
    event creations into SQL statements at Linux Plumbers, Fall of 2019.

This patch set depends on:

   https://patchwork.kernel.org/project/linux-trace-devel/list/?series=525783

Lots of bug fixes. Full diff of changes since v2 at bottom of this email.

Below is from the man page, which has a fully functional parser as its
example (in man page, not here. But the usage of that parser is described in
the FUNCTIONAL EXAMPLE section below).

Also, see patch 18, which extracts the program from the man page and builds
it via:

    make sqlhist

For easy testing of this feature.

struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
				  const char *sql_buffer, char **err);

struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
                                  const char *sql_buffer, char **err);

Synthetic events are dynamically created events that attach two existing
events together via one or more matching fields between the two events. It
can be used to find the latency between the events, or to simply pass fields
of the first event on to the second event to display as one event.

The Linux kernel interface to create synthetic events is complex, and there
needs to be a better way to create synthetic events that is easy and can be
understood via existing technology.

If you think of each event as a table, where the fields are the column of
the table and each instance of the event as a row, you can understand how
SQL can be used to attach two events together and for another event (table).
Utilizing the SQL SELECT FROM JOIN ON [ WHERE ] syntax, a synthetic event
can easily be created from two different events.

For simple SQL queries to make a histogram instead of a synthetic event, see
HISTOGRAMS below.

tracefs_sql() takes in a tep handler (See tep_local_events(3)) that is used
to verify the events within the sql_buffer expression. The name is the name
of the synthetic event to create. If err points to an address of a string,
it will be filled with a detailed message on any type of parsing error,
including fields that do not belong to an event, or if the events or fields
are not properly compared.

The example program below is a fully functional parser where it will create
a synthetic event from a SQL syntax passed in via the command line or a
file.

The SQL format is as follows:

    SELECT <fields> FROM <start-event> JOIN <end-event> ON <matching-fields> WHERE <filter>

Note, although the examples show the SQL commands in uppercase, they are not
required to be so. That is, you can use "SELECT" or "select" or "sElEct".

For example:

    SELECT syscalls.sys_enter_read.fd, syscalls.sys_exit_read.ret FROM syscalls.sys_enter_read
       JOIN syscalls.sys_exit_read
       ON syscalls.sys_enter_read.common_pid = syscalls.sys_exit_write.common_pid

Will create a synthetic event that with the fields:

    u64 fd; s64 ret;

Because the function takes a tep handle, and usually all event names are
unique, you can leave off the system (group) name of the event, and
tracefs_sql() will discover the system for you.

That is, the above statement would work with:

    SELECT sys_enter_read.fd, sys_exit_read.ret FROM sys_enter_read JOIN sys_exit_read
       ON sys_enter_read.common_pid = sys_exit_write.common_pid

The AS keyword can be used to name the fields as well as to give an alias to
the events, such that the above can be simplified even more as;

    SELECT start.fd, end.ret FROM sys_enter_read AS start JOIN sys_exit_read AS end ON start.common_pid = end.common_pid

The above aliases sys_enter_read as start and sys_exit_read as end and uses
those aliases to reference the event throughout the statement.

Using the AS keyword in the selection portion of the SQL statement will
define what those fields will be called in the synthetic event.

    SELECT start.fd AS filed, end.ret AS return FROM sys_enter_read AS start JOIN sys_exit_read AS end
       ON start.common_pid = end.common_pid

The above labels the fd of start as filed and the ret of end as return where
the synthetic event that is created will now have the fields:

    u64 filed; s64 return;

The fields can also be calculated with results passed to the synthetic event:

    select start.truesize, end.len, (start.truesize - end.len) as diff from napi_gro_receive_entry as start
       JOIN netif_receive_skb as end ON start.skbaddr = end.skbaddr

Which would show the truesize" of the napi_gro_receive_entry event, the
actual len of the content, shown by the netif_receive_skb, and alse the
delta between the two and expressed by the field *diff.

The code also supports recording the timestamps at either event, and
performing calculations on them. For wakeup latency, you have:

    select start.pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start
       JOIN sched_switch as end ON start.pid = end.next_pid

The above will create a synthetic event that records the pid of the task
being woken up, and the time difference between the sched_waking event and
the sched_switch event. The TIMESTAMP_USECS will truncate the time down to
microseconds as the timestamp usually recorded in the tracing buffer has
nanosecond resolution. If you do not want that truncation, use TIMESTAMP
instead of TIMESTAMP_USECS.

Finally, the WHERE clause can be added, that will let you add filters on
either or both events.

    select start.pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start
       JOIN sched_switch as end ON start.pid = end.next_pid
       WHERE start.prio < 100 && (!(end.prev_pid < 1 || end.prev_prio > 100) || end.prev_pid == 0)

NOTE

Although both events can be used together in the WHERE clause, they must not
be mixed outside the top most "&&" statements. You can not OR (||) the
events together, where a filter of one event is OR’d to a filter of the
other event. This does not make sense, as the synthetic event requires both
events to take place to be recorded. If one is filtered out, then the
synthetic event does not execute.

    select start.pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start
       JOIN sched_switch as end ON start.pid = end.next_pid
       WHERE start.prio < 100 && end.prev_prio < 100

The above is valid.

Where as the below is not.

    select start.pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start
       JOIN sched_switch as end ON start.pid = end.next_pid
       WHERE start.prio < 100 || end.prev_prio < 100

KEYWORDS AS EVENT FIELDS

In some cases, an event may have a keyword. For example,
regcache_drop_region has "from" as a field and the following will not work

      select from from regcache_drop_region

In such cases, add a backslash to the conflicting field, and this will tell
the parser that the "from" is a field and not a keyword:

      select \from from regcache_drop_region

HISTOGRAMS

Simple SQL statements without the JOIN ON may also be used, which will
create a histogram instead. When doing this, the struct tracefs_hist
descriptor can be retrieved from the returned synthetic event descriptor via
the tracefs_synth_get_start_hist(3).

In order to utilize the histogram types (see xxx) the CAST command of SQL
can be used.

That is:

      select CAST(common_pid AS comm), CAST(id AS syscall) FROM sys_enter

Which produces:

     # echo 'hist:keys=common_pid.execname,id.syscall' > events/raw_syscalls/sys_enter/trigger

     # cat events/raw_syscalls/sys_enter/hist

    { common_pid: bash            [     18248], id: sys_setpgid                   [109] } hitcount:          1
    { common_pid: sendmail        [      1812], id: sys_read                      [  0] } hitcount:          1
    { common_pid: bash            [     18247], id: sys_getpid                    [ 39] } hitcount:          1
    { common_pid: bash            [     18247], id: sys_dup2                      [ 33] } hitcount:          1
    { common_pid: gmain           [     13684], id: sys_inotify_add_watch         [254] } hitcount:          1
    { common_pid: cat             [     18247], id: sys_access                    [ 21] } hitcount:          1
    { common_pid: bash            [     18248], id: sys_getpid                    [ 39] } hitcount:          1
    { common_pid: cat             [     18247], id: sys_fadvise64                 [221] } hitcount:          1
    { common_pid: sendmail        [      1812], id: sys_openat                    [257] } hitcount:          1
    { common_pid: less            [     18248], id: sys_munmap                    [ 11] } hitcount:          1
    { common_pid: sendmail        [      1812], id: sys_close                     [  3] } hitcount:          1
    { common_pid: gmain           [      1534], id: sys_poll                      [  7] } hitcount:          1
    { common_pid: bash            [     18247], id: sys_execve                    [ 59] } hitcount:          1

Note, string fields may not be cast.

The possible types to cast to are:

HEX - convert the value to use hex and not decimal

SYM - convert a pointer to symbolic (kallsyms values)

SYM-OFFSET - convert a pointer to symbolic and include the offset.

SYSCALL - convert the number to the mapped system call name

EXECNAME or COMM - can only be used with the common_pid field. Will show the
task name of the process.

LOG or LOG2 - bucket the key values in a log 2 values (1, 2, 3-4, 5-8, 9-16, 17-32, ...)

The above fields are not case sensitive, and "LOG2" works as good as "log".

A special CAST to COUNTER or COUNTER will make the field a value and not a
key. For example:

      SELECT common_pid, CAST(bytes_req AS _COUNTER_) FROM kmalloc

Which will create

      echo 'hist:keys=common_pid:vals=bytes_req' > events/kmem/kmalloc/trigger

      cat events/kmem/kmalloc/hist

    { common_pid:       1812 } hitcount:          1  bytes_req:         32
    { common_pid:       9111 } hitcount:          2  bytes_req:        272
    { common_pid:       1768 } hitcount:          3  bytes_req:       1112
    { common_pid:          0 } hitcount:          4  bytes_req:        512
    { common_pid:      18297 } hitcount:         11  bytes_req:       2004

RETURN VALUE

Returns 0 on success and -1 on failure. On failure, if err is defined, it
will be allocated to hold a detailed description of what went wrong if it
the error was caused by a parsing error, or that an event, field does not
exist or is not compatible with what it was combined with.

FUNCTIONAL EXAMPLE:
-------------------

After applying this patch, and installing it. If you compile the example from the man
page (calling it sqlhist.c):

 >$ gcc -o sqlhist sqlhist.c `pkg-config --cflags --libs libtracefs`
 >$ su
 ># ./sqlhist -n syscall_wait -e 'select start.id, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat  
    from sys_enter as start join sys_exit as end on start.common_pid = end.common_pid
    where start.id != 23 && start.id != 7 && start.id != 61 && start.id != 230 &&
          start.id != 232 && start.id != 270 && start.id != 271 && start.id != 202'


(All the start.id filtering is hiding the syscalls that block for a long time)

 ># echo 'hist:keys=id.syscall,lat.buckets=10:sort=lat' > /sys/kernel/tracing/events/synthetic/syscall_wait/trigger  

<wait a while>

 ># cat /sys/kernel/tracing/events/synthetic/syscall_wait/hist  
 # event histogram
 #
 # trigger info: hist:keys=id.syscall,lat.buckets=10:vals=hitcount:sort=lat.buckets=10:size=2048 [active]
 #

{ id: sys_fadvise64                 [221], lat: ~ 0-9 } hitcount:          1
{ id: sys_fcntl                     [ 72], lat: ~ 0-9 } hitcount:          5
{ id: sys_read                      [  0], lat: ~ 0-9 } hitcount:         51
{ id: sys_dup2                      [ 33], lat: ~ 0-9 } hitcount:          1
{ id: sys_newfstat                  [  5], lat: ~ 0-9 } hitcount:          7
{ id: sys_getpid                    [ 39], lat: ~ 0-9 } hitcount:         18
{ id: sys_openat                    [257], lat: ~ 0-9 } hitcount:          3
{ id: sys_newstat                   [  4], lat: ~ 0-9 } hitcount:         22
{ id: sys_newlstat                  [  6], lat: ~ 0-9 } hitcount:         44
{ id: sys_write                     [  1], lat: ~ 0-9 } hitcount:         23
{ id: sys_brk                       [ 12], lat: ~ 0-9 } hitcount:          4
{ id: sys_readlink                  [ 89], lat: ~ 0-9 } hitcount:         11
{ id: sys_close                     [  3], lat: ~ 0-9 } hitcount:         21
{ id: sys_mprotect                  [ 10], lat: ~ 0-9 } hitcount:          4
{ id: sys_arch_prctl                [158], lat: ~ 0-9 } hitcount:          2
{ id: sys_getuid                    [102], lat: ~ 0-9 } hitcount:         12
{ id: sys_rt_sigaction              [ 13], lat: ~ 0-9 } hitcount:        105
{ id: sys_statfs                    [137], lat: ~ 0-9 } hitcount:          8
{ id: sys_rt_sigprocmask            [ 14], lat: ~ 0-9 } hitcount:        121
{ id: sys_inotify_add_watch         [254], lat: ~ 0-9 } hitcount:          7
{ id: sys_mmap                      [  9], lat: ~ 0-9 } hitcount:         10
{ id: sys_ioctl                     [ 16], lat: ~ 0-9 } hitcount:         32
{ id: sys_pread64                   [ 17], lat: ~ 0-9 } hitcount:          4
{ id: sys_setpgid                   [109], lat: ~ 0-9 } hitcount:          2
{ id: sys_lseek                     [  8], lat: ~ 0-9 } hitcount:         11
{ id: sys_access                    [ 21], lat: ~ 0-9 } hitcount:          1
{ id: sys_rt_sigprocmask            [ 14], lat: ~ 10-19 } hitcount:          9
{ id: sys_munmap                    [ 11], lat: ~ 10-19 } hitcount:          1
{ id: sys_newstat                   [  4], lat: ~ 10-19 } hitcount:          1
{ id: sys_rt_sigaction              [ 13], lat: ~ 10-19 } hitcount:          1
{ id: sys_read                      [  0], lat: ~ 10-19 } hitcount:         11
{ id: sys_openat                    [257], lat: ~ 10-19 } hitcount:         13
{ id: sys_getpid                    [ 39], lat: ~ 10-19 } hitcount:          1
{ id: sys_inotify_add_watch         [254], lat: ~ 10-19 } hitcount:          2
{ id: sys_write                     [  1], lat: ~ 10-19 } hitcount:         10
{ id: sys_read                      [  0], lat: ~ 20-29 } hitcount:          4
{ id: sys_pipe                      [ 22], lat: ~ 20-29 } hitcount:          1
{ id: sys_write                     [  1], lat: ~ 20-29 } hitcount:         11
{ id: sys_write                     [  1], lat: ~ 30-39 } hitcount:          2
{ id: sys_inotify_add_watch         [254], lat: ~ 30-39 } hitcount:          1
{ id: sys_write                     [  1], lat: ~ 40-49 } hitcount:          1
{ id: sys_inotify_add_watch         [254], lat: ~ 40-49 } hitcount:          1
{ id: sys_openat                    [257], lat: ~ 40-49 } hitcount:          1
{ id: sys_read                      [  0], lat: ~ 70-79 } hitcount:          8
{ id: sys_read                      [  0], lat: ~ 80-89 } hitcount:          1
{ id: sys_read                      [  0], lat: ~ 110-119 } hitcount:          2
{ id: sys_clone                     [ 56], lat: ~ 240-249 } hitcount:          1
{ id: sys_execve                    [ 59], lat: ~ 350-359 } hitcount:          1
{ id: sys_write                     [  1], lat: ~ 1960-1969 } hitcount:          1

Totals:
    Hits: 615
    Entries: 49
    Dropped: 0

Steven Rostedt (VMware) (22):
  libtracefs: Added new API tracefs_sql()
  tracefs: Add unit tests for tracefs_sql()
  libtracefs: Add comparing start and end fields in tracefs_sql()
  libtracefs: Add unit test to test tracefs_sql() compare
  libtracefs: Add filtering for start and end events in tracefs_sql()
  libtracefs: Add unit test to test tracefs_sql() where clause
  libtracefs: Make sqlhist parser reentrant
  libtracefs: Make parser unique to libtracefs
  libtracefs: Add line number and index to expr structure
  libtracefs: Add error message when match fields are not FROM and JOIN
    events
  libtracefs: Add error message when match or init fails from bad events
  libtracefs; Add error message for bad selections to SQL sequence
  libtracefs: Add error message when compare fields fail
  libtracefs: Add error message for grouping events in SQL filter
  libtracefs: Add error message for bad filters in SQL statement
  libtracefs: Add error message when calculation has no label
  libtracefs: Add man page for tracefs_sql()
  libtracefs: Add Makefile rule to create sqlhist
  libtracefs: Allow for simple SQL statements to create a histogram
  libtracefs: Allow trace_sql() to take keywords for fields with
    backslash
  libtracefs: Add CAST() syntax to SQL parsing for histogram types
  libtracefs: Add CAST(x AS _COUNTER_) syntax to create values in
    histograms

 Documentation/libtracefs-sql.txt |  504 ++++++++++
 Makefile                         |   10 +
 include/tracefs-local.h          |    9 +
 include/tracefs.h                |    6 +
 src/Makefile                     |   13 +
 src/sqlhist-parse.h              |   76 ++
 src/sqlhist.l                    |   98 ++
 src/sqlhist.y                    |  250 +++++
 src/tracefs-hist.c               |  163 ++-
 src/tracefs-sqlhist.c            | 1622 ++++++++++++++++++++++++++++++
 utest/tracefs-utest.c            |   78 ++
 11 files changed, 2790 insertions(+), 39 deletions(-)
 create mode 100644 Documentation/libtracefs-sql.txt
 create mode 100644 src/sqlhist-parse.h
 create mode 100644 src/sqlhist.l
 create mode 100644 src/sqlhist.y
 create mode 100644 src/tracefs-sqlhist.c

-- 
2.30.2



diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 7b616fa..91c99d7 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -42,7 +42,7 @@ with a detailed message on any type of parsing error, including fields that do n
 to an event, or if the events or fields are not properly compared.
 
 The example program below is a fully functional parser where it will create a synthetic
-event from a SQL syntax passed in via the command line or a file. 
+event from a SQL syntax passed in via the command line or a file.
 
 The SQL format is as follows:
 
diff --git a/Makefile b/Makefile
index 96d7f55..7f382c3 100644
--- a/Makefile
+++ b/Makefile
@@ -364,11 +364,21 @@ $(bdir)/libtracefs.so.$(TRACEFS_VERSION): force
 	$(Q)mkdir -p $(bdir)
 	$(Q)$(MAKE) -C $(src)/src libtracefs.so
 
+$(bdir)/sqlhist.c: Documentation/libtracefs-sql.txt
+	cat $< | sed -ne '/^EXAMPLE/,/FILES/ { /EXAMPLE/,+2d ; /^FILES/d ;  /^--/d ; p}' > $@
+
+$(bdir)/sqlhist.o: $(bdir)/sqlhist.c
+	$(CC) -g -Wall -c -o $@ $^ -Iinclude/ $(LIBTRACEEVENT_INCLUDES)
+
+sqlhist: $(bdir)/sqlhist.o $(LIBTRACEFS_STATIC)
+	$(CC) -o $@ $^ $(LIBTRACEEVENT_LIBS)
+
 clean:
 	$(MAKE) -C $(src)/utest clean
 	$(MAKE) -C $(src)/src clean
 	$(RM) $(TARGETS) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.so.* $(bdir)/*.o $(bdir)/.*.d
 	$(RM) $(PKG_CONFIG_FILE)
 	$(RM) $(VERSION_FILE)
+	$(RM) $(bdir)/sqlhist.o $(bdir)/sqlhist.c sqlhist
 
 .PHONY: clean
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index c3aecf9..7f9cf38 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1468,7 +1468,7 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 			hist = tracefs_hist_alloc(tep, system, event,
 						  key, type);
 			if (!hist)
-				break;
+				return NULL;
 		}
 	}
 
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 1a3cf37..6224677 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -36,7 +36,8 @@ enum alias_type {
 struct field {
 	struct expr		*next;	/* private link list */
 	const char		*system;
-	const char		*event;
+	const char		*event_name;
+	struct tep_event	*event;
 	const char		*raw;
 	const char		*label;
 	const char		*field;
@@ -515,89 +516,175 @@ __hidden int table_start(struct sqlhist_bison *sb)
 	return 0;
 }
 
-static int update_vars(struct sql_table *table, struct field *event)
+static int test_event_exists(struct tep_handle *tep,
+			     struct sqlhist_bison *sb,
+			     struct expr *expr, struct tep_event **pevent)
+{
+	struct field *field = &expr->field;
+	const char *system = field->system;
+	const char *event = field->event_name;
+
+	if (!field->event)
+		field->event = tep_find_event_by_name(tep, system, event);
+	if (pevent)
+		*pevent = field->event;
+
+	if (field->event)
+		return 0;
+
+	sb->line_no = expr->line;
+	sb->line_idx = expr->idx;
+
+	parse_error(sb, field->raw, "event not found\n");
+	return -1;
+}
+
+static int test_field_exists(struct tep_handle *tep,
+			     struct sqlhist_bison *sb,
+			     struct expr *expr)
+{
+	struct field *field = &expr->field;
+	struct tep_format_field *tfield;
+	char *field_name;
+	const char *p;
+
+	if (!field->event) {
+		if (test_event_exists(tep, sb, expr, NULL))
+			return -1;
+	}
+
+	/* The field could have a conversion */
+	p = strchr(field->field, '.');
+	if (p)
+		field_name = strndup(field->field, p - field->field);
+	else
+		field_name = strdup(field->field);
+
+	if (!field_name)
+		return -1;
+
+	if (!strcmp(field_name, TRACEFS_TIMESTAMP) ||
+	    !strcmp(field->field, TRACEFS_TIMESTAMP_USECS))
+		tfield = (void *)1L;
+	else
+		tfield = tep_find_any_field(field->event, field_name);
+	free(field_name);
+
+	if (tfield)
+		return 0;
+
+	sb->line_no = expr->line;
+	sb->line_idx = expr->idx;
+
+	parse_error(sb, field->raw,
+		    "Field '%s' not part of event %s\n",
+		    field->field, field->event_name);
+	return -1;
+}
+
+static int update_vars(struct tep_handle *tep,
+		       struct sql_table *table,
+		       struct expr *expr)
 {
 	struct sqlhist_bison *sb = table->sb;
-	struct expr *expr;
+	struct field *event_field = &expr->field;
+	struct tep_event *event;
 	struct field *field;
 	const char *label;
-	const char *p, *r;
-	char *system;
-	int len;
+	const char *raw = event_field->raw;
+	const char *event_name;
+	const char *system;
+	const char *p;
+	int label_len = 0, event_len, system_len;
 
-	p = strchr(event->raw, '.');
+	p = strchr(raw, '.');
 	if (p) {
-		system = strndup(event->raw, p - event->raw);
-		if (!system)
+		char *str;
+
+		str = strndup(raw, p - raw);
+		if (!str)
 			return -1;
-		event->system = store_str(sb, system);
-		free(system);
-		if (!event->system)
+		event_field->system = store_str(sb, str);
+		free(str);
+		if (!event_field->system)
 			return -1;
 		p++;
 	} else {
-		p = event->raw;
+		p = raw;
 	}
 
-	event->event = store_str(sb, p);
-	if (!event->event)
+	event_field->event_name = store_str(sb, p);
+	if (!event_field->event_name)
+		return -1;
+
+	if (test_event_exists(tep, sb, expr, &event))
+		return -1;
+
+	if (!event_field->system)
+		event_field->system = store_str(sb, event->system);
+
+	if (!event_field->system)
 		return -1;
 
-	if (!event->label)
-		event->label = event->event;
+	label = event_field->label;
+	if (label)
+		label_len = strlen(label);
+
+	system = event_field->system;
+	system_len = strlen(system);
 
-	label = event->label;
-	len = strlen(label);
+	event_name = event_field->event_name;
+	event_len = strlen(event_name);
 
 	for_each_field(expr, field, table) {
+		int len;
+
 		field = &expr->field;
 
 		if (field->event)
 			continue;
 
-		p = strchr(field->raw, '.');
-		if (p) {
-			/* Does this field have a system */
-			r = strchr(p + 1, '.');
-			if (r) {
-				/* This has a system, and is not a alias */
-				system = strndup(field->raw, p - field->raw);
-				if (!system)
-					return -1;
-				field->system = store_str(sb, system);
-				free(system);
-				if (!field->system)
-					return -1;
-
-				/* save the event as well */
-				p++;
-				system = strndup(p, r - p);
-				if (!system)
-					return -1;
-				field->event = store_str(sb, system);
-				free(system);
-				if (!field->event)
-					return -1;
-				r++;
-				field->field = store_str(sb, r);
-				goto check_timestamps;
-			}
+		raw = field->raw;
+
+		/*
+		 * The field could be:
+		 *     system.event.field...
+		 *     event.field...
+		 *     label.field...
+		 * We check label first.
+		 */
+
+		len = label_len;
+		if (label && !strncmp(raw, label, len) &&
+		    raw[len] == '.') {
+			/* Label matches and takes precedence */
+			goto found;
 		}
 
-		if (strncmp(field->raw, label, len))
-			continue;
+		if (!strncmp(raw, system, system_len) &&
+		    raw[system_len] == '.') {
+			raw += system_len + 1;
+			/* Check the event portion next */
+		}
 
-		if (field->raw[len] != '.')
+		len = event_len;
+		if (strncmp(raw, event_name, len) ||
+		    raw[len] != '.') {
+			/* Does not match */
 			continue;
+		}
+ found:
+		field->system = system;
+		field->event_name = event_name;
+		field->event = event;
+		field->field = raw + len + 1;
 
-		field->system = event->system;
-		field->event = event->event;
-		field->field = field->raw + len + 1;
- check_timestamps:
 		if (!strcmp(field->field, "TIMESTAMP"))
 			field->field = store_str(sb, TRACEFS_TIMESTAMP);
-		else if (!strcmp(field->field, "TIMESTAMP_USECS"))
+		if (!strcmp(field->field, "TIMESTAMP_USECS"))
 			field->field = store_str(sb, TRACEFS_TIMESTAMP_USECS);
+		if (test_field_exists(tep, sb, expr))
+			return -1;
 	}
 
 	return 0;
@@ -608,29 +695,29 @@ static int update_vars(struct sql_table *table, struct field *event)
  * selections can be fields and not mention the event itself.
  */
 static int update_fields(struct tep_handle *tep,
-			 struct sql_table *table, struct field *event_field)
+			 struct sql_table *table,
+			 struct expr *expr)
 {
+	struct field *event_field = &expr->field;
 	struct sqlhist_bison *sb = table->sb;
 	struct tep_format_field *tfield;
 	struct tep_event *event;
-	struct expr *expr;
 	struct field *field;
 	const char *p;
 	int len;
 
-	/* First update fields with aliases an such */
-	update_vars(table, event_field);
+	/* First update fields with aliases an such and add event */
+	update_vars(tep, table, expr);
 
-	/* The update_vars already updated event->system and event->event */
-	event = tep_find_event_by_name(tep, event_field->system,
-				       event_field->event);
 	/*
 	 * If event is not found, the creation of the synth will
 	 * add a proper error, so return "success".
 	*/
-	if (!event)
+	if (!event_field->event)
 		return 0;
 
+	event = event_field->event;
+
 	for_each_field(expr, field, table) {
 		const char *field_name;
 
@@ -659,7 +746,8 @@ static int update_fields(struct tep_handle *tep,
 			continue;
 
 		field->system = event_field->system;
-		field->event = event_field->event;
+		field->event_name = event_field->event_name;
+		field->event = event;
 		field->field = field_name;
 	}
 
@@ -746,7 +834,7 @@ static void assign_match(const char *system, const char *event,
 	rval = &match->rval->field;
 
 	if (lval->system == system &&
-	    lval->event == event) {
+	    lval->event_name == event) {
 		*start_match = lval->field;
 		*end_match = rval->field;
 	} else {
@@ -772,7 +860,7 @@ static int build_compare(struct tracefs_synth *synth,
 	rval = &compare->rval->field;
 
 	if (lval->system == system &&
-	    lval->event == event) {
+	    lval->event_name == event) {
 		start_field = lval->field;
 		end_field = rval->field;
 		calc = TRACEFS_SYNTH_DELTA_START;
@@ -829,12 +917,12 @@ static int do_verify_filter(struct sqlhist_bison *sb, struct filter *filter,
 	 */
 	if (!*system && !*event) {
 		*system = filter->lval->field.system;
-		*event = filter->lval->field.event;
+		*event = filter->lval->field.event_name;
 		return 0;
 	}
 
 	if (filter->lval->field.system != *system ||
-	    filter->lval->field.event != *event)
+	    filter->lval->field.event_name != *event)
 		return verify_filter_error(sb, filter->lval, *event);
 
 	return 0;
@@ -1035,45 +1123,6 @@ static int build_filter(struct tep_handle *tep, struct sqlhist_bison *sb,
 	return ret;
 }
 
-static int test_event_exists(struct tep_handle *tep, struct sqlhist_bison *sb,
-			     struct expr *expr, struct tep_event **pevent)
-{
-	const char *system = expr->field.system;
-	const char *event_name = expr->field.event;
-	struct tep_event *event;
-
-	event = tep_find_event_by_name(tep, system, event_name);
-	if (pevent)
-		*pevent = event;
-	if (event)
-		return 0;
-
-	sb->line_no = expr->line;
-	sb->line_idx = expr->idx;
-
-	parse_error(sb, expr->field.raw, "event not found\n");
-	return -1;
-}
-
-static int test_field_exists(struct tep_handle *tep, struct sqlhist_bison *sb,
-			     struct expr *expr)
-{
-	struct tep_event *event;
-
-	if (test_event_exists(tep, sb, expr, &event))
-		return -1;
-
-	if (trace_verify_event_field(event, expr->field.field, NULL))
-		return 0;
-
-	sb->line_no = expr->line;
-	sb->line_idx = expr->idx;
-
-	parse_error(sb, expr->field.raw, "Field '%s' not part of event %s\n",
-		    expr->field.field, expr->field.event);
-	return -1;
-}
-
 static void *field_match_error(struct tep_handle *tep, struct sqlhist_bison *sb,
 			       struct match *match)
 {
@@ -1233,11 +1282,11 @@ static int verify_field_type(struct tep_handle *tep,
 	sb->line_no = expr->line;
 	sb->line_idx = expr->idx;
 
-	event = tep_find_event_by_name(tep, field->system, field->event);
+	event = tep_find_event_by_name(tep, field->system, field->event_name);
 	if (!event) {
 		parse_error(sb, field->raw,
 			    "Event '%s' not found\n",
-			    field->event ? : "(null)");
+			    field->event_name ? : "(null)");
 		return -1;
 	}
 
@@ -1339,12 +1388,12 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 
 	/* This could be a simple SQL statement to only build a histogram */
 	if (!table->to) {
-		ret = update_fields(tep, table, &table->from->field);
+		ret = update_fields(tep, table, table->from);
 		if (ret < 0)
 			return NULL;
 
 		start_system = table->from->field.system;
-		start_event = table->from->field.event;
+		start_event = table->from->field.event_name;
 
 		synth = synth_init_from(tep, start_system, start_event);
 		if (!synth)
@@ -1352,12 +1401,16 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 		goto hist_only;
 	}
 
-	ret = update_vars(table, &table->from->field);
+	ret = update_vars(tep, table, table->from);
+	if (ret < 0)
+		return NULL;
+
+	ret = update_vars(tep, table, table->to);
 	if (ret < 0)
 		return NULL;
 
 	start_system = table->from->field.system;
-	start_event = table->from->field.event;
+	start_event = table->from->field.event_name;
 
 	match = table->matches;
 	if (!match)
@@ -1368,7 +1421,7 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 		return NULL;
 
 	end_system = table->to->field.system;
-	end_event = table->to->field.event;
+	end_event = table->to->field.event_name;
 
 	assign_match(start_system, start_event, match,
 		     &start_match, &end_match);
@@ -1404,7 +1457,7 @@ static struct tracefs_synth *build_synth(struct tep_handle *tep,
 			ret = -1;
 			field = &expr->field;
 			if (field->system == start_system &&
-			    field->event == start_event) {
+			    field->event_name == start_event) {
 				int type;
 				type = verify_field_type(tep, table->sb, expr);
 				if (type < 0)
diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 645c84c..09bb8f2 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -51,7 +51,7 @@
 #define SQL_2_SQL	"select woke.next_pid as woke_pid, wake.common_pid as waking_pid from sched_waking as wake join sched_switch as woke on woke.next_pid = wake.pid"
 
 #define SQL_3_EVENT	"wakeup_lat"
-#define SQL_3_SQL	"select start.pid, end.next_prio as prio, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid"
+#define SQL_3_SQL	"select sched_switch.next_prio as prio, end.prev_prio as pprio, (sched.sched_waking.common_timestamp.usecs - end.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid"
 
 #define SQL_4_EVENT	"wakeup_lat_2"
 #define SQL_4_SQL	"select start.pid, end.next_prio as prio, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start join sched_switch as end on start.pid = end.next_pid where (start.prio >= 1 && start.prio < 100) || !(start.pid >= 0 && start.pid <= 1) && end.prev_pid != 0"
