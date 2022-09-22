Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192BEC6FA92
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 00:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiIVA2q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 20:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiIVA2o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 20:28:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACE5A9255
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Sep 2022 17:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08ED4B83375
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 00:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2262EC433C1;
        Thu, 22 Sep 2022 00:28:39 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obA61-00Dr5B-09;
        Wed, 21 Sep 2022 20:29:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/5] tracecmd library documentation: Use star and not underscore for function names
Date:   Wed, 21 Sep 2022 20:29:36 -0400
Message-Id: <20220922002940.3302285-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922002940.3302285-1-rostedt@goodmis.org>
References: <20220922002940.3302285-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Functions referenced in man pages should be bold and not underscored.
Convert all function references in the man pages to be bold.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../libtracecmd/libtracecmd-files.txt         | 38 +++++++++----------
 .../libtracecmd/libtracecmd-instances.txt     | 32 ++++++++--------
 Documentation/libtracecmd/libtracecmd-log.txt | 12 +++---
 .../libtracecmd/libtracecmd-peer.txt          | 16 ++++----
 .../libtracecmd/libtracecmd-record.txt        | 36 +++++++++---------
 Documentation/libtracecmd/libtracecmd.txt     |  8 ++--
 6 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/Documentation/libtracecmd/libtracecmd-files.txt b/Documentation/libtracecmd/libtracecmd-files.txt
index 2de5d6dfa660..382603efd50d 100644
--- a/Documentation/libtracecmd/libtracecmd-files.txt
+++ b/Documentation/libtracecmd/libtracecmd-files.txt
@@ -22,7 +22,7 @@ void *tracecmd_close*(struct tracecmd_input pass:[*]_handle_);
 DESCRIPTION
 -----------
 This set of APIs can be used to open and close a trace file recorded by
-_trace-cmd(1)_ and containing tracing information from ftrace, the official
+*trace-cmd(1)* and containing tracing information from ftrace, the official
 Linux kernel tracer. The opened file is represented by a _tracecmd_input_
 structure, all other library APIs that work with the file require a pointer
 to the structure. The APIs for opening a trace file have a _flag_ input
@@ -33,37 +33,37 @@ is a combination of these options:
  TRACECMD_FL_LOAD_NO_SYSTEM_PLUGINS - Do not load system wide plugins, load only "local only"
 					plugins from user's home directory.
 
-The _tracecmd_open()_ function opens a given trace _file_, parses the
+The *tracecmd_open()* function opens a given trace _file_, parses the
 metadata headers from the file, allocates and initializes а _tracecmd_input_
 handler structure representing the file. It also initializes the handler
 for reading trace data from the file. The returned handler is ready to be
 used with _tracecmd_read__ APIs.
 
-The _tracecmd_open_fd()_ function does the same as _tracecmd_open()_, but
+The *tracecmd_open_fd()* function does the same as *tracecmd_open()*, but
 works with a file descriptor to a trace file, opened for reading.
 
-The _tracecmd_open_head()_ function is the same as _tracecmd_open()_, but
+The *tracecmd_open_head()* function is the same as *tracecmd_open()*, but
 does not initialize the handler for reading trace data. It reads and parses
-the metadata headers only. The _tracecmd_init_data()_ should be used before
+the metadata headers only. The *tracecmd_init_data()* should be used before
 using the _tracecmd_read__ APIs.
 
-The _tracecmd_init_data()_ function initializes a _handle_, allocated with
-_tracecmd_open_head()_, for reading trace data from the file associated with
+The *tracecmd_init_data()* function initializes a _handle_, allocated with
+*tracecmd_open_head()*, for reading trace data from the file associated with
 it. This API must be called before any of the _tracecmd_read__ APIs.
 
-The _tracecmd_close()_ function frees a _handle_, pointer to tracecmd_input
-structure, previously allocated with _tracecmd_open()_, _tracecmd_open_fd()_
-or _tracecmd_open_head()_ APIs.
+The *tracecmd_close()* function frees a _handle_, pointer to tracecmd_input
+structure, previously allocated with *tracecmd_open()*, *tracecmd_open_fd()*
+or *tracecmd_open_head()* APIs.
 
 RETURN VALUE
 ------------
-The _tracecmd_open()_, _tracecmd_open_fd()_ and _tracecmd_open_head()_
+The *tracecmd_open()*, *tracecmd_open_fd()* and *tracecmd_open_head()*
 functions return a pointer to tracecmd_input structure or NULL in case of
-an error. The returned structure must be free with _tracecmd_close()_.
-Note that if _tracecmd_open_fd()_ is used to allocate a tracecmd_input handler,
-when _tracecmd_close()_ is called to close it, that fd will be closed also.
+an error. The returned structure must be free with *tracecmd_close()*.
+Note that if *tracecmd_open_fd()* is used to allocate a tracecmd_input handler,
+when *tracecmd_close()* is called to close it, that fd will be closed also.
 
-The _tracecmd_init_data()_ function returns -1 in case of an error or
+The *tracecmd_init_data()* function returns -1 in case of an error or
 0 otherwise.
 
 EXAMPLE
@@ -139,10 +139,10 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
-_trace-cmd.dat(5)_
+*libtracefs(3)*,
+*libtraceevent(3)*,
+*trace-cmd(1)*
+*trace-cmd.dat(5)*
 
 AUTHOR
 ------
diff --git a/Documentation/libtracecmd/libtracecmd-instances.txt b/Documentation/libtracecmd/libtracecmd-instances.txt
index df8fdc4e7f66..364085fdf482 100644
--- a/Documentation/libtracecmd/libtracecmd-instances.txt
+++ b/Documentation/libtracecmd/libtracecmd-instances.txt
@@ -22,36 +22,36 @@ DESCRIPTION
 This set of APIs can be used to get information and read tracing data
 from tracing instances stored in a trace file.
 
-The _tracecmd_buffer_instances()_ function gets the number of tracing
+The *tracecmd_buffer_instances()* function gets the number of tracing
 instances recorded in a trace file. The top instance is not counted.
 The _handle_ is a tracecmd_input handler returned by
-_tracecmd_open_head()_.
+*tracecmd_open_head()*.
 
-The _tracecmd_buffer_instance_name()_ function gets the name of the
+The *tracecmd_buffer_instance_name()* function gets the name of the
 tracing instance with given index _indx_, recorded in a trace file.
 The _indx_ is a number in the interval [0 .. count-1], where count
-is the number returned by _tracecmd_buffer_instances()_. The _handle_
-is a tracecmd_input handler returned by _tracecmd_open_head()_.
+is the number returned by *tracecmd_buffer_instances()*. The _handle_
+is a tracecmd_input handler returned by *tracecmd_open_head()*.
 
-The _tracecmd_buffer_instance_handle()_ allocates and initializes a
+The *tracecmd_buffer_instance_handle()* allocates and initializes a
 tracecmd_input handle, associated with trace instance with index
 _indx_ from a trace file.  The _handle_ is a tracecmd_input handler
-returned by _tracecmd_open_head()_. The _indx_ is a number in the
+returned by *tracecmd_open_head()*. The _indx_ is a number in the
 interval [0 .. count-1], where count is the number returned by
-_tracecmd_buffer_instances()_.
+*tracecmd_buffer_instances()*.
 
 RETURN VALUE
 ------------
-The _tracecmd_buffer_instances()_ function returns the number of tracing
+The *tracecmd_buffer_instances()* function returns the number of tracing
 instances recorded in a trace file.
 
-The _tracecmd_buffer_instance_name()_ function returns a string, the name
+The *tracecmd_buffer_instance_name()* function returns a string, the name
 of a tracing instance, or NULL in case of an error The string must *not*
 be freed.
 
-The _tracecmd_buffer_instance_handle()_ function returns a pointer to
+The *tracecmd_buffer_instance_handle()* function returns a pointer to
 newly allocated tracecmd_input handler or NULL in case if an error. The
-returned handler must be closed by _tracecmd_close()(3)_
+returned handler must be closed by *tracecmd_close()(3)*
 
 EXAMPLE
 -------
@@ -99,10 +99,10 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
-_trace-cmd.dat(5)_
+*libtracefs(3)*,
+*libtraceevent(3)*,
+*trace-cmd(1)*
+*trace-cmd.dat(5)*
 
 AUTHOR
 ------
diff --git a/Documentation/libtracecmd/libtracecmd-log.txt b/Documentation/libtracecmd/libtracecmd-log.txt
index de5c277684ec..38e17bf744ff 100644
--- a/Documentation/libtracecmd/libtracecmd-log.txt
+++ b/Documentation/libtracecmd/libtracecmd-log.txt
@@ -16,8 +16,8 @@ int *tracecmd_set_loglevel*(enum tep_loglevel _level_);
 
 DESCRIPTION
 -----------
-The _tracecmd_set_loglevel()_ function sets the level of the library logs that will be printed on
-the console. See _libtraceevent(3)_ for detailed desciription of the log levels. Setting the log
+The *tracecmd_set_loglevel()* function sets the level of the library logs that will be printed on
+the console. See *libtraceevent(3)* for detailed desciription of the log levels. Setting the log
 level to specific value means that logs from the previous levels will be printed too. For example
 _TEP_LOG_WARNING_ will print any logs with severity _TEP_LOG_WARNING_, _TEP_LOG_ERROR_ and
 _TEP_LOG_CRITICAL_. The default log level is _TEP_LOG_CRITICAL_.  When a new level is set, it is
@@ -48,10 +48,10 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
-_trace-cmd.dat(5)_
+*libtracefs(3)*,
+*libtraceevent(3)*,
+*trace-cmd(1)*
+*trace-cmd.dat(5)*
 
 AUTHOR
 ------
diff --git a/Documentation/libtracecmd/libtracecmd-peer.txt b/Documentation/libtracecmd/libtracecmd-peer.txt
index 2e3232c6edb5..c9774c86945a 100644
--- a/Documentation/libtracecmd/libtracecmd-peer.txt
+++ b/Documentation/libtracecmd/libtracecmd-peer.txt
@@ -25,13 +25,13 @@ Information about peers from the session is stored in the metadata of each
 trace file. These APIs use that information to extract and synchronize
 the trace data.
 
-The _tracecmd_get_traceid()_ function returns the trace ID stored in
+The *tracecmd_get_traceid()* function returns the trace ID stored in
 the trace file metadata associated with _handle_. Each peer from a trace
 session has an ID unique for that peer and that trace session only.
 This ID is used to match multiple trace files recorded in a same trace
 session.
 
-The _tracecmd_get_guest_cpumap()_ function gets the mapping of guest
+The *tracecmd_get_guest_cpumap()* function gets the mapping of guest
 virtual CPUs (VCPU) to the host process that represents those VCPUs and is
 stored in the metadata of the trace file associated with _handle_. This
 information is gathered during a host-guest trace session and is stored
@@ -47,9 +47,9 @@ The _name_, _vcpu_count_ and _cpu_pid_ values must *not* be freed.
 
 RETURN VALUE
 ------------
-The _tracecmd_get_traceid()_ function returns a 64 bit trace ID.
+The *tracecmd_get_traceid()* function returns a 64 bit trace ID.
 
-The _tracecmd_get_guest_cpumap()_ function returns -1 in case of
+The *tracecmd_get_guest_cpumap()* function returns -1 in case of
 an error or 0 otherwise. If 0 is returned, then the _name_, _vcpu_count_
 and _cpu_pid_ parameters contain the requested information.
 
@@ -107,10 +107,10 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
-_trace-cmd.dat(5)_
+*libtracefs(3)*,
+*libtraceevent(3)*,
+*trace-cmd(1)*
+*trace-cmd.dat(5)*
 
 AUTHOR
 ------
diff --git a/Documentation/libtracecmd/libtracecmd-record.txt b/Documentation/libtracecmd/libtracecmd-record.txt
index aa1a4a662929..69439552d6ba 100644
--- a/Documentation/libtracecmd/libtracecmd-record.txt
+++ b/Documentation/libtracecmd/libtracecmd-record.txt
@@ -22,38 +22,38 @@ struct tep_handle pass:[*]*tracecmd_get_tep*(struct tracecmd_input pass:[*]_hand
 DESCRIPTION
 -----------
 This set of APIs can be used to read tracing data from a trace file opened
-with _tracecmd_open()(3)_, _tracecmd_open_fd()(3)_ or _tracecmd_open_head()(3)_.
+with *tracecmd_open()(3)*, *tracecmd_open_fd()(3)* or *tracecmd_open_head()(3)*.
 
-The _tracecmd_read_cpu_first()_ function reads the first trace record
+The *tracecmd_read_cpu_first()* function reads the first trace record
 for a given _cpu_ from a trace file associated with _handle_. The returned
-record must be freed with _tracecmd_free_record()_.
+record must be freed with *tracecmd_free_record()*.
 
-The _tracecmd_read_data()_ function reads the next trace record for
+The *tracecmd_read_data()* function reads the next trace record for
 a given _cpu_ from a trace file associated with _handle_ and increments
-the read location pointer, so that the next call to _tracecmd_read_data()_
+the read location pointer, so that the next call to *tracecmd_read_data()*
 will not read the same record again. The returned record must be freed
-with _tracecmd_free_record()_.
+with *tracecmd_free_record()*.
 
-The _tracecmd_read_at()_ function reads a trace record from a specific
+The *tracecmd_read_at()* function reads a trace record from a specific
 _offset_ within the file associated with _handle_. The CPU on which the
 recorded event occurred is stored in the _cpu_. The function does not
 change the current read location pointer. The returned record must be
-freed with _tracecmd_free_record()_.
+freed with *tracecmd_free_record()*.
 
-The _tracecmd_free_record()_ function frees a _record_ returned by any
+The *tracecmd_free_record()* function frees a _record_ returned by any
 of the _tracecmd_read__ APIs.
 
-The _tracecmd_get_tep()_ function returns a tep context for a given
+The *tracecmd_get_tep()* function returns a tep context for a given
 _handle_.
 
 RETURN VALUE
 ------------
-The _tracecmd_read_cpu_first()_, _tracecmd_read_data()_ and
-_tracecmd_read_at()_ functions return a pointer to struct tep_record or
+The *tracecmd_read_cpu_first()*, *tracecmd_read_data()* and
+*tracecmd_read_at()* functions return a pointer to struct tep_record or
 NULL in case of an error.The returned record must be freed with
-_tracecmd_free_record()_.
+*tracecmd_free_record()*.
 
-The _tracecmd_get_tep()_ function returns a pointer to tep context or
+The *tracecmd_get_tep()* function returns a pointer to tep context or
 NULL if there is no tep context for the given _handle_. The returned
 tep pointer must *not* be freed.
 
@@ -108,10 +108,10 @@ FILES
 
 SEE ALSO
 --------
-_libtracefs(3)_,
-_libtraceevent(3)_,
-_trace-cmd(1)_
-_trace-cmd.dat(5)_
+*libtracefs(3)*,
+*libtraceevent(3)*,
+*trace-cmd(1)*
+*trace-cmd.dat(5)*
 
 AUTHOR
 ------
diff --git a/Documentation/libtracecmd/libtracecmd.txt b/Documentation/libtracecmd/libtracecmd.txt
index dc528ce02aac..e9e11b32c8b6 100644
--- a/Documentation/libtracecmd/libtracecmd.txt
+++ b/Documentation/libtracecmd/libtracecmd.txt
@@ -56,10 +56,10 @@ FILES
 
 SEE ALSO
 --------
-_libtraceevent(3)_
-_libtracefs(3)_
-_trace-cmd(1)_
-_trace-cmd.dat(5)_
+*libtraceevent(3)*
+*libtracefs(3)*
+*trace-cmd(1)*
+*trace-cmd.dat(5)*
 
 AUTHOR
 ------
-- 
2.35.1

