Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A075AC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 18:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6731622510
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 18:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgLVSUE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 13:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:53406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgLVSUE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 13:20:04 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2379A22510;
        Tue, 22 Dec 2020 18:19:21 +0000 (UTC)
Date:   Tue, 22 Dec 2020 13:19:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
        <linux-trace-users@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Zamir SUN <sztsian@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, zsun@redhat.com,
        Vitaly Chikunov <vt@altlinux.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Tony Jones <tonyj@suse.de>, John Kacur <jkacur@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Al Stone <ahs3@debian.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [ANNOUNCE] libtracefs 1.0.0
Message-ID: <20201222131919.56be2da8@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtracefs has finally been officially released. The code that interacts
with the tracefs file system in trace-cmd has been extracted out into its
own library. This will facilitate other applications that need to
manipulate or simply read the trace event file formats. 

 https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/snapshot/libtracefs-1.0.0.tar.gz
 https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/

All exposed functions have man pages. We do plan on extending the functions
that tracefs will include. Some have already been added to bugzilla, but
feel free to request your own features you would like to have for your
applications, to easily manipulate ftrace.

 https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&list_id=1079173&product=Tools&resolution=---


Here are the list of functions that libtracefs provides. Along with
libtraceevent
(https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/) making
programs that interact with the ftrace file system has greatly become more
simplified!

Enjoy,

-- Steve

The following interfaces come with libtracefs 1.0.0:

const char *tracefs_tracing_dir(void);
    Return the string holding the tracefs mount point.

struct tep_handle *tracefs_local_events(const char *tracing_dir);
   This will allocate and fill in a libtraceevent tep structure with information
   on how to parse raw events. If tracing_dir is NULL, it will use the tracefs
   mount point. tracing_dir may also be a path to a copy of a tracefs file
   system taken from another machine.

struct tep_handle *tracefs_local_events_system(const char *tracing_dir,
					       const char * const *sys_names);

   Similar to tracefs_local_events(), but may filter a subset of the systems
   to be loaded, by passing in an array of system names.

int tracefs_fill_local_events(const char *tracing_dir,
			       struct tep_handle *tep, int *parsing_failures);
    Similar to tracefs_local_events() but works on an already allocated
    libtraceveent tep handle.

char *tracefs_get_tracing_file(const char *name);
     Return a file name with the tracefs mount point prefixed to it.

void tracefs_put_tracing_file(char *name);
     Free the name returned from tracefs_get_tracing_file()

struct tracefs_instance *tracefs_instance_create(const char *name);
   Create a tracing instance (sub buffer) with the given name.

void tracefs_instance_free(struct tracefs_instance *instance);
   Free an instance returned from tracefs_instance_create().

int tracefs_instance_destroy(struct tracefs_instance *instance);
   Free the instance returned from tracefs_instance_create() and also
   remove it (the sub buffer) from the tracefs file system.

bool tracefs_instance_is_new(struct tracefs_instance *instance);
   Retuns true if tracefs_instance_create() created a new instance in
   the tracefs file system, otherwise it returns false if the instance
   already existed.

const char *tracefs_instance_get_name(struct tracefs_instance *instance);
   Returns the name used to create the instance.

char * tracefs_instance_get_file(struct tracefs_instance *instance, const
char *file); Returns a file name with the path of the instance in the
tracefs file system prefixed to it. (Note, passing in NULL, will return a
   name with just the tracefs mount point prefixed, making it
   equivalent to tracefs_get_tracing_file()).

char *tracefs_instance_get_dir(struct tracefs_instance *instance);
   Returns the full path of the instance sub buffer that exists in
   the tracefs file system.

int tracefs_instance_file_write(struct tracefs_instance *instance,
				const char *file, const char *str);
   Writes a string to the file that exists in the instance sub buffer
   on the tracefs file system. Note, file is a relative path from
   the instance sub buffer location.

char *tracefs_instance_file_read(struct tracefs_instance *instance,
				 char *file, int *psize);
   Reads a string to the file that exists in the instance sub buffer
   on the tracefs file system. Note, file is a relative path from
   the instance sub buffer location.

int tracefs_instances_walk(int (*callback)(const char *, void *), void
*context); Executes the function callback() for each sub buffer instance
(does not execute on the top level mount point). It can stop the walk if
callback() returns a non-zero number.

bool tracefs_instance_exists(const char *name);
   Returns true if the given name of a instance sub buffer exists in the
tracefs file system.

bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
   Returns true if a file exists in the instance sub buffer, in the tracefs
   file system.

bool tracefs_dir_exists(struct tracefs_instance *instance, char *name);
   Returns true if a directory exists in the instance sub buffer, in the
tracefs file system.

char **tracefs_event_systems(const char *tracing_dir);
   Returns an array of event system names from the tracing_dir path. If
tracing_dir is NULL, then the tracefs mount point is used. The tracing_dir
could also be a path to a copy of the tracefs file system from another
machine.

char **tracefs_system_events(const char *tracing_dir, const char *system);
   Returns an array of events for a given system from the tracing_dir path.
If tracing_dir is NULL, then the tracefs mount point is used. The
tracing_dir could also be a path to a copy of the tracefs file system from
another machine.

void tracefs_list_free(char **list);
   Frees the list returned by tracefs_event_systems() or
tracefs_system_events().

int tracefs_iterate_raw_events(struct tep_handle *tep,
				struct tracefs_instance *instance,
				cpu_set_t *cpus, int cpu_size,
				int (*callback)(struct tep_event *,
						struct tep_record *,
						int, void *),
				void *callback_context);
   This will read the binary raw ring buffers from the tracefs file system
   and call the callback() for each event it encounters with that event
   given by a tep_record. This iterates over all CPUs or a subset of
   CPUs if a cpu_set is passed in. But the iteration will happen for one
   CPU at a time.

char **tracefs_tracers(const char *tracing_dir);
   Returns an array of available tracers. If tracing_dir is NULL, it will
use the tracefs mount point.

char *tracefs_get_clock(struct tracefs_instance *instance);
    Returns the clock name being used by a given instance, or the top level
    tracefs system if NULL is passed in.
