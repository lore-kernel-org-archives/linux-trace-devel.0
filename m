Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BC4C43216
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14451610A7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 22:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbhG3WSt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 18:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233017AbhG3WSk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 18:18:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DE2061050;
        Fri, 30 Jul 2021 22:18:34 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9apt-002V14-B0; Fri, 30 Jul 2021 18:18:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 00/17] libtracefs: Introducing tracefs_sql() to create synthetice events with an SQL line
Date:   Fri, 30 Jul 2021 18:18:07 -0400
Message-Id: <20210730221824.595597-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

This patch set depends on:

   https://patchwork.kernel.org/project/linux-trace-devel/list/?series=523775

Below is from the man page, which has a fully functional parser as its
example (in man page, not here. But the usage of that parser is described in
the FUNCTIONAL EXAMPLE section below).

struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
				  const char *sql_buffer, char **err);

Synthetic events are dynamically created events that attach two existing events
together via one or more matching fields between the two events. It can be used
to find the latency between the events, or to simply pass fields of the first event
on to the second event to display as one event.

The Linux kernel interface to create synthetic events is complex, and there needs
to be a better way to create synthetic events that is easy and can be understood
via existing technology.

If you think of each event as a table, where the fields are the column of the table
and each instance of the event as a row, you can understand how SQL can be used
to attach two events together and for another event (table). Utilizing the
SQL *SELECT* *FROM* *JOIN* *ON* [ *WHERE* ] syntax, a synthetic event can easily
be created from two different events.


*tracefs_sql*() takes in a *tep* handler (See _tep_local_events_(3)) that is used to
verify the events within the _sql_buffer_ expression. The _name_ is the name of the
synthetic event to create. If _err_ points to an address of a string, it will be filled
with a detailed message on any type of parsing error, including fields that do not belong
to an event, or if the events or fields are not properly compared.

The man page contains a fully functional parser where it will create a synthetic
event from a SQL syntax passed in via the command line or a file. 

The SQL format is as follows:

*SELECT* <fields> FROM <start-event> JOIN <end-event> ON <matching-fields> WHERE <filter>

Note, although the examples show the SQL commands in uppercase, they are not required to
be so. That is, you can use "SELECT" or "select" or "sElEct".

For example:
[source,c]
--
SELECT syscalls.sys_enter_read.fd, syscalls.sys_exit_read.ret FROM syscalls.sys_enter_read
   JOIN syscalls.sys_exit_read
   ON syscalls.sys_enter_read.common_pid = syscalls.sys_exit_write.common_pid
--

Will create a synthetic event that with the fields:

  u64 fd; s64 ret;

Because the function takes a _tep_ handle, and usually all event names are unique, you can
leave off the system (group) name of the event, and *tracefs_sql*() will discover the
system for you.

That is, the above statement would work with:

[source,c]
--
SELECT sys_enter_read.fd, sys_exit_read.ret FROM sys_enter_read JOIN sys_exit_read
   ON sys_enter_read.common_pid = sys_exit_write.common_pid
--

The *AS* keyword can be used to name the fields as well as to give an alias to the
events, such that the above can be simplified even more as:

[source,c]
--
SELECT start.fd, end.ret FROM sys_enter_read AS start JOIN sys_exit_read AS end ON start.common_pid = end.common_pid
--

The above aliases _sys_enter_read_ as *start* and _sys_exit_read_ as *end* and uses
those aliases to reference the event throughout the statement.

Using the *AS* keyword in the selection portion of the SQL statement will define what
those fields will be called in the synthetic event.

[source,c]
--
SELECT start.fd AS filed, end.ret AS return FROM sys_enter_read AS start JOIN sys_exit_read AS end
   ON start.common_pid = end.common_pid
--

The above labels the _fd_ of _start_ as *filed* and the _ret_ of _end_ as *return* where
the synthetic event that is created will now have the fields:

  u64 filed; s64 return;

The fields can also be calculated with results passed to the synthetic event:

[source,c]
--
select start.truesize, end.len, (start.truesize - end.len) as diff from napi_gro_receive_entry as start
   JOIN netif_receive_skb as end ON start.skbaddr = end.skbaddr
--

Which would show the *truesize" of the _napi_gro_receive_entry_ event, the actual
_len_ of the content, shown by the _netif_receive_skb_, and also the delta between
the two and expressed by the field *diff*.

The code also supports recording the timestamps at either event, and performing calculations
on them. For wakeup latency, you have:

[source,c]
--
select start.pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start
   JOIN sched_switch as end ON start.pid = end.next_pid
--

The above will create a synthetic event that records the _pid_ of the task being woken up,
and the time difference between the _sched_waking_ event and the _sched_switch_ event.
The *TIMESTAMP_USECS* will truncate the time down to microseconds as the timestamp usually
recorded in the tracing buffer has nanosecond resolution. If you do not want that
truncation, use *TIMESTAMP* instead of *TIMESTAMP_USECS*.

Finally, the *WHERE* clause can be added, that will let you add filters on either or both events.

[source,c]
--
select start.pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start
   JOIN sched_switch as end ON start.pid = end.next_pid
   WHERE start.prio < 100 && (!(end.prev_pid < 1 || end.prev_prio > 100) || end.prev_pid == 0)
--

*NOTE*

Although both events can be used together in the *WHERE* clause, they must not be mixed outside
the top most "&&" statements. You can not OR (||) the events together, where a filter of one
event is OR'd to a filter of the other event. This does not make sense, as the synthetic event
requires both events to take place to be recorded. If one is filtered out, then the synthetic
event does not execute.

[source,c]
--
select start.pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start
   JOIN sched_switch as end ON start.pid = end.next_pid
   WHERE start.prio < 100 && end.prev_prio < 100
--

The above is valid.

Where as the below is not.

[source,c]
--
select start.pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sched_waking as start
   JOIN sched_switch as end ON start.pid = end.next_pid
   WHERE start.prio < 100 || end.prev_prio < 100
--

Returns 0 on success and -1 on failure. On failure, if _err_ is defined, it will be
allocated to hold a detailed description of what went wrong if it the error was caused
by a parsing error, or that an event, field does not exist or is not compatible with
what it was combined with.

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


Steven Rostedt (VMware) (17):
  libtracefs: Added new API tracefs_sql()
  tracefs: Add unit tests for tracefs_sql()
  libtracefs: Add comparing start and end fields in tracefs_sql()
  libtracefs: Add unit test to test tracefs_sql() compare
  libtracefs: Add filtering for start and end events in tracefs_sql()
  libtracefs: Add unit test to test tracefs_sql() where clause
  libtracefs: Make sqlhist parser reentrant
  libtracefs: Make parser unique to libtracefs
  libtracefs: Add line number and index to expr structure
  libtracefs: Add a parse_error() helper function to record errors
  libtracefs: Add error message when match fields are not FROM and JOIN
    events
  libtracefs: Add error message when match or init fails from bad events
  libtracefs; Add error message for bad selections to SQL sequence
  libtracefs: Add error message when compare fields fail
  libtracefs: Add error message for grouping events in SQL filter
  libtracefs: Add error message for bad filters in SQL statement
  libtracefs: Add man page for tracefs_sql()

 Documentation/libtracefs-sql.txt |  367 +++++++++
 include/tracefs.h                |    3 +
 src/Makefile                     |   11 +
 src/sqlhist-parse.h              |   75 ++
 src/sqlhist.l                    |   95 +++
 src/sqlhist.y                    |  241 ++++++
 src/tracefs-sqlhist.c            | 1310 ++++++++++++++++++++++++++++++
 utest/tracefs-utest.c            |   78 ++
 8 files changed, 2180 insertions(+)
 create mode 100644 Documentation/libtracefs-sql.txt
 create mode 100644 src/sqlhist-parse.h
 create mode 100644 src/sqlhist.l
 create mode 100644 src/sqlhist.y
 create mode 100644 src/tracefs-sqlhist.c

-- 
2.30.2

