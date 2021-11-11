Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0531AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 19:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E06D961269
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 19:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhKKT4l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 14:56:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229710AbhKKT4l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 14:56:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 457E261241;
        Thu, 11 Nov 2021 19:53:51 +0000 (UTC)
Date:   Thu, 11 Nov 2021 14:53:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 11/12] libtracefs: Document dynamic events APIs
Message-ID: <20211111145349.7181f23f@gandalf.local.home>
In-Reply-To: <20211108080404.55814-12-tz.stoyanov@gmail.com>
References: <20211108080404.55814-1-tz.stoyanov@gmail.com>
        <20211108080404.55814-12-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  8 Nov 2021 10:04:03 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +ERRORS
> +------
> +The following errors are for all the above calls:
> +
> +*EPERM* Not run as root user

We should probably stop stating this. Because starting with 5.16, you do
not need to be root. You only need to be in the group that allows tracing.

 # groupadd tracing
 # usermod -a tracing rostedt
 # mount -t tracefs nodev /sys/krenel/tracing
 # chmod 770 /sys/kernel/tracing
 # chmod g+w /sys/kernel/tracing/*
 # chgrp -R tracing /sys/kernel/tracing

And now my "rostedt" user can have full access to tracing. We need to
update trace-cmd to allow this too.

But this is outside the scope of this patch series.

> +
> +*ENODEV* dynamic events of requested type are not configured for the running kernel.
> +
> +*ENOMEM* Memory allocation error.
> +
> +*tracefs_dynevent_create*() can fail with the following errors:
> +
> +*EINVAL*  Most likely a parsing error occurred (use *tracefs_error_last*(3) to possibly
> +          see what that error was).
> +
> +Other errors may also happen caused by internal system calls.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <sys/wait.h>
> +
> +#include <tracefs/tracefs.h>
> +
> +static struct tep_event *open_event;
> +static struct tep_format_field *file_field;
> +
> +static struct tep_event *openret_event;
> +static struct tep_format_field *ret_field;
> +
> +static int callback(struct tep_event *event, struct tep_record *record,
> +		    int cpu, void *data)
> +{
> +	struct trace_seq seq;
> +
> +	trace_seq_init(&seq);
> +	tep_print_event(event->tep, &seq, record, "%d-%s: ", TEP_PRINT_PID, TEP_PRINT_COMM);
> +
> +	if (event->id == open_event->id) {
> +		trace_seq_puts(&seq, "open file='");
> +		tep_print_field(&seq, record->data, file_field);
> +		trace_seq_puts(&seq, "'\n");
> +	} else if (event->id == openret_event->id) {
> +		unsigned long long ret;
> +		tep_read_number_field(ret_field, record->data, &ret);
> +		trace_seq_printf(&seq, "open ret=%lld\n", ret);
> +	} else {
> +		goto out;
> +	}
> +
> +	trace_seq_terminate(&seq);
> +	trace_seq_do_printf(&seq);
> +out:
> +	trace_seq_destroy(&seq);
> +
> +	return 0;
> +}
> +
> +static pid_t run_exec(char **argv, char **env)
> +{
> +	pid_t pid;
> +
> +	pid = fork();
> +	if (pid)
> +		return pid;
> +
> +	execve(argv[0], argv, env);
> +	perror("exec");
> +	exit(-1);
> +}
> +
> +const char *mykprobe = "my_kprobes";
> +
> +int main (int argc, char **argv, char **env)
> +{
> +	struct tracefs_dynevent *kprobe, *kretprobe;
> +	const char *sysnames[] = { mykprobe, NULL };
> +	struct tracefs_instance *instance;
> +	struct tep_handle *tep;
> +	pid_t pid;
> +
> +	if (argc < 2) {
> +		printf("usage: %s command\n", argv[0]);
> +		exit(-1);
> +	}
> +
> +	instance = tracefs_instance_create("exec_open");
> +	if (!instance) {
> +		perror("creating instance");
> +		exit(-1);
> +	}
> +
> +	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
> +
> +	kprobe = tracefs_kprobe_alloc(mykprobe, "open", "do_sys_openat2",
> +				      "file=+0($arg2):ustring flags=+0($arg3):x64 mode=+8($arg3):x64\n");
> +	kretprobe = tracefs_kretprobe_alloc(mykprobe, "openret", "do_sys_openat2", "ret=%ax", 0);
> +	if (!kprobe || !kretprobe) {
> +		perror("allocating dynamic events");
> +		exit(-1);
> +	}
> +
> +	if (tracefs_dynevent_create(kprobe) || tracefs_dynevent_create(kretprobe)){

Missing:

		char *err;

I can add it.

-- Steve

> +		err = tracefs_error_last(NULL);
> +		perror("Failed to create kprobes:");
> +		if (err && strlen(err))
> +			fprintf(stderr, "%s\n", err);
> +		exit(-1);
> +	}
> +
> +	tep = tracefs_local_events_system(NULL, sysnames);
> +	if (!tep) {
> +		perror("reading events");
> +		exit(-1);
> +	}
> +	open_event = tep_find_event_by_name(tep, mykprobe, "open");
> +	file_field = tep_find_field(open_event, "file");
> +
> +	openret_event = tep_find_event_by_name(tep, mykprobe, "openret");
> +	ret_field = tep_find_field(openret_event, "ret");
> +
> +	tracefs_event_enable(instance, mykprobe, NULL);
> +	pid = run_exec(&argv[1], env);
> +
> +	/* Let the child start to run */
> +	sched_yield();
> +
> +	do {
> +		tracefs_load_cmdlines(NULL, tep);
> +		tracefs_iterate_raw_events(tep, instance, NULL, 0, callback, NULL);
> +	} while (waitpid(pid, NULL, WNOHANG) != pid);
> +
> +	/* Will disable the events */
> +	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
> +	tracefs_dynevent_free(kprobe);
> +	tracefs_dynevent_free(kretprobe);
> +	tracefs_instance_destroy(instance);
> +	tep_free(tep);
> +
> +	return 0;
> +}
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*tracefs.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltracefs*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtracefs(3)_,
> +_libtraceevent(3)_,
> +_trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
> +*Yordan Karadzhov* <y.karadz@gmail.com>
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtracefs is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
> +
> +COPYING
> +-------
> +Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
> +the terms of the GNU Public License (GPL).
> diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
> index 430d02e..6850860 100644
> --- a/Documentation/libtracefs.txt
> +++ b/Documentation/libtracefs.txt
> @@ -64,6 +64,17 @@ Writing data in the trace buffer:
>  Control library logs:
>  	int *tracefs_set_loglevel*(enum tep_loglevel _level_);
>  
> +Dynamic event generic APIs:
> +	struct *tracefs_dynevent*;
> +	enum *tracefs_dynevent_type*;
> +	int *tracefs_dynevent_create*(struct tracefs_dynevent pass:[*]_devent_);
> +	int *tracefs_dynevent_destroy*(struct tracefs_dynevent pass:[*]_devent_, bool _force_);
> +	int *tracefs_dynevent_destroy_all*(unsigned int _types_, bool _force_);
> +	void *tracefs_dynevent_free*(struct tracefs_dynevent pass:[*]_devent_);
> +	void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_events_);
> +	struct tracefs_dynevent pass:[*]pass:[*]*tracefs_dynevent_get_all*(unsigned int _types_, const char pass:[*]_system_);
> +	enum tracefs_dynevent_type *tracefs_dynevent_info*(struct tracefs_dynevent pass:[*]_dynevent_, char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_, char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_, char pass:[*]pass:[*]_format_);
> +
>  Kprobes and Kretprobes:
>  	struct tracefs_dynevent pass:[*] *tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
>  	struct tracefs_dynevent pass:[*] *tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_, unsigned int _max_);

