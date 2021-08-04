Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE21C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 13:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9912C60F43
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Aug 2021 13:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbhHDNYA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Aug 2021 09:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238061AbhHDNX7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Aug 2021 09:23:59 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D760260F43;
        Wed,  4 Aug 2021 13:23:40 +0000 (UTC)
Date:   Wed, 4 Aug 2021 09:23:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH v2 00/21] libtracefs: Introducing tracefs_sql() to
 create synthetice events with an SQL line
Message-ID: <20210804092339.786315cd@oasis.local.home>
In-Reply-To: <YQqAjBCtd8MnhV1v@lx-t490>
References: <20210803042347.679499-1-rostedt@goodmis.org>
        <YQqAjBCtd8MnhV1v@lx-t490>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 4 Aug 2021 13:57:00 +0200
"Ahmed S. Darwish" <a.darwish@linutronix.de> wrote:


> Thanks a lot! Actually, I meant going even one step further ;)
> 
> I was imagining something like the following:
> 
> $ trace-cmd sql-shell		# OR
> 
> $ perf tracefs-sql-shell
> 
>   Welcome to tracefs SQL shell...
> 
>   > SELECT PNAME(common_pid),msr,val  
>     FROM write_msr
>     WHERE msr=72 OR msr=2096
> 
>   .-------------------------------------------.
>   | PNAME(common_pid)   |  msr  |    val      |
>   |---------------------|------ |-------------|
>   | qemu-system-x86     | 0x48  | 0           |
>   | qemu-system-x86     | 0x48  | 0           |
>   | qemu-system-x86     | 0x48  | 0           |
>   | kworker/u16:2       | 0x830 | 0x1000008fb |
>   | ....                | ....  | .....       |
>   +-------------------------------------------+


Well, the above looks more like a normal trace just being processed
differently. If you want that, I already have this:

  https://lore.kernel.org/linux-trace-devel/20200116104804.5d2f71e2@gandalf.local.home/

Which I created to test the idea of using SQL to create synthetic events.

It simply converts the events in a trace.dat file into a sql format
file that can be used to read into a SQL database. As the patch shows:

 $ trace-cmd sqldump > dump
 $ mysql events < dump

MariaDB [events]> show tables;
+-----------------------------+
| Tables_in_events            |
+-----------------------------+
| sched_migrate_task          |
| sched_move_numa             |
| sched_process_exec          |
| sched_process_exit          |
| sched_stat_runtime          |
| sched_switch                |
| sched_wake_idle_without_ipi |
| sched_wakeup                |
| sched_waking                |
+-----------------------------+
9 rows in set (0.001 sec)

MariaDB [events]> select * from sched_move_numa;
+-------------------+-------------+--------------+----------------------+------------+-------+-------+-------+---------+---------+---------+---------+
| common_timestamp  | common_type | common_flags | common_preempt_count | common_pid | pid   | tgid  | ngid  | src_cpu | src_nid | dst_cpu | dst_nid |
+-------------------+-------------+--------------+----------------------+------------+-------+-------+-------+---------+---------+---------+---------+
| 14943901721165973 |         305 |            0 |                    0 |      27451 | 27451 | 27451 | 27451 |       5 |       1 |      22 |       0 |
| 14943901722548756 |         305 |            0 |                    0 |       3684 |  3684 |  3684 |  3684 |      23 |       1 |      22 |       0 |
| 14943901779987828 |         305 |            0 |                    0 |      13693 | 13693 | 13677 | 13693 |       7 |       1 |      22 |       0 |
+-------------------+-------------+--------------+----------------------+------------+-------+-------+-------+---------+---------+---------+---------+
3 rows in set (0.001 sec)

I never applied the patch, but perhaps you would be interested in this?

> 
>   > SELECT MAX(end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS MaxSystemLatency_us,  
>       PNAME(common_pid)
>     FROM sched_waking AS start JOIN sched_switch AS end
>     ON start.pid = stop.next_pid


Now the above would require parsing the histogram data, which is next
on our agenda. There's two routes we can take with this:

 1) Add a "hist_raw" that shows the raw data from the kernel's
 histogram table. It would still be in ASCII, but will be formatted for
 machine readability and not for humans (like /proc/$$/stat vs /proc/$$/status)

 2) We write another bison parser to parse the current format of the
 histogram output, which looks like this:

  # sqlhist -n lat -e 'SELECT end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat
         FROM sched_waking as start JOIN sched_switch as end ON start.pid = end.next_pid'
  # trace-cmd start -e lat -R 'hist:keys=common_pid.execname,lat:sort=lat'
  # cat /sys/kernel/tracing/events/synthetic/lat/hist
# event histogram
#
# trigger info: hist:keys=common_pid.execname,lat:vals=hitcount:sort=lat:size=2048 [active]
#

{ common_pid: <idle>          [         0], lat:          2 } hitcount:          9
{ common_pid: <idle>          [         0], lat:          3 } hitcount:          3
{ common_pid: kworker/0:0     [     10041], lat:          3 } hitcount:          7
{ common_pid: kworker/0:0     [     10041], lat:          4 } hitcount:          5
{ common_pid: <idle>          [         0], lat:          4 } hitcount:          2
{ common_pid: <idle>          [         0], lat:          5 } hitcount:          9
{ common_pid: kworker/0:0     [     10041], lat:          5 } hitcount:         14
{ common_pid: kworker/0:0     [     10041], lat:          6 } hitcount:          5
{ common_pid: <idle>          [         0], lat:          6 } hitcount:         16
{ common_pid: <idle>          [         0], lat:          7 } hitcount:         19
[..]
{ common_pid: JS Helper       [      1366], lat:         96 } hitcount:          1
{ common_pid: <idle>          [         0], lat:         97 } hitcount:          1
{ common_pid: <idle>          [         0], lat:         99 } hitcount:          1
{ common_pid: <idle>          [         0], lat:        107 } hitcount:          1
{ common_pid: <idle>          [         0], lat:        108 } hitcount:          3
{ common_pid: <idle>          [         0], lat:        117 } hitcount:          1
{ common_pid: <idle>          [         0], lat:        118 } hitcount:          1
{ common_pid: sendmail        [      1739], lat:        130 } hitcount:          1

Totals:
    Hits: 2212
    Entries: 130
    Dropped: 0

That file is a user space API, and we can write up another bison parser
to parse out the data.


Between the two approaches, #1 is probably the better way, but that
requires a kernel change, and the feature will not be available in
older kernels, and not available until we actually implement it.

Approach #2 can be done today and will work for older kernels too. Also,
if we do #2, it doesn't mean we can't still do #1.


> 
>   .-------------------------------------------.
>   | MaxSystemLatency_us | PNAME(common_pid)   |
>   |---------------------|---------------------|
>   | 350                 | cyclictest          |
>   +-------------------------------------------+
> 
>   > SELECT (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) AS latency,  
>       PNAME(common_pid), PRIO(common_pid)
>     FROM sched_waking AS start JOIN sched_switch AS end
>     ON start.pid = stop.next_pid
>     ORDER BY latency DESC
>     LIMIT 5
> 
>   .----------------------------------------------------------.
>   | Latency | PNAME(common_pid)           | PRIO(common_pid) |
>   |---------|-----------------------------|------------------|
>   | 829     | cyclictest                  | SCHED_FIFO:98    |
>   | 400     | cyclictest                  | SCHED_FIFO:98    |
>   | 192     | pulseaudio-rt               | SCHED_RR:48      |
>   | 30      | firefox                     | SCHED_OTHER:0:0  |
>   | 10      | kworker/0:0H-events_highpri | SCHED_OTHER:0:-20|
>   +----------------------------------------------------------+
> 
>   > SELECT (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as MaxIRQLatency_us  
>     FROM irq_disable as start JOIN irq_enable as end
>     ON start.common_pid = end.common_pid,
>        start.parent_offs == end.parent_offs
>     ORDER BY max_irq_disable
>     LIMIT 1
> 
>   .------------------.
>   | MaxIRQLatency_us |
>   |------------------|
>   | 37               |
>   +------------------+
> 
> And so on....
> 
> The idea was that since the community already picked SQL as a
> higher-level tracing language, why hard-code the SQL language with
> synthetic events and histograms?
> 
> The language can alredy offer something *way more generic*, out of the
> box, while still covering the desired special cases.
> 
> We can support the standard SQL aggregate functions (e.g., MAX(), MIN(),
> SUM(), COUNT(), DISTINCT(), AVG(), etc.) + some kernel-specific
> functions (e.g., PROCESS_NAME(), PROCESS_PRIO(), USECS(), etc.) + the
> standard SQL keyworkds like ORDER BY, LIMIT, DESC, ASC, etc. This would
> offer some nice friendly competition to BPF tracing, while still being a
> (relatively) simple *query-only* language.
> 
> I'm not sure if you would be OK with this, but I thought a proposal
> won't hurt :)
> 
> I can also write some patches on top of this series if you are OK with
> the principle in general.
>

I'm not against it, and was thinking of implementing some kind of
 "trace-cmd sql" feature. But before we can get there, we need a way to
 get that information out from the kernel.

-- Steve

