Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEB8C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CA092063F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732113AbfCZPnk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:43:40 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40484 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfCZPnk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 11:43:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id t5so14870331wri.7;
        Tue, 26 Mar 2019 08:43:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TeT4YxuXMtnGB5/lJHUfA3dvBb3nN8RwadSqbsdTJxE=;
        b=EvWVw1d7zPh8irsMr4giATCogkQtEIuP7z1AA9vy3ahQTFV8Jgrq+HbzWvMWGKhk2N
         XFoR8qpti4JS0eY3KjyW9G8IzZ3rp5UG1k0yTOi07OicLqdlt7phww+Z0obiwdCTUk1O
         PcZJsCQNGcWV+Ltd5zjTBE8//JTAIUUy6vXmdfa8dx2wVNefthlsWCCg7qUuA1xAZNHF
         uMx3KcXbcxG++StPZ9YRVpwLCKh5ZmCcyBIX9ToY7JkjjDkWRzwL1i52UZFLOYqoNxDF
         HnhSlCB6AZNSIPMlq8dV19F4tiOEyDAeQ/Og9q2G/vWWV4UqJEQlAd4opRVFwbw65xWP
         K3kw==
X-Gm-Message-State: APjAAAXldn9dhmZJSC4MCVufdJ9XUk2F5V7vXOIQvQNRvf9qYbmH8t9p
        EwhNG6rpcVnTwtonyYxAXEiYd9Si
X-Google-Smtp-Source: APXvYqxEFYlGpVfTMeE20+CI4aGe2ws2JvH4HznNthMFjtXznIdLPFhYN/q683uL+5fdm4Fvo2HgQQ==
X-Received: by 2002:adf:f102:: with SMTP id r2mr2839026wro.136.1553615014774;
        Tue, 26 Mar 2019 08:43:34 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n11sm31927685wrt.63.2019.03.26.08.43.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Mar 2019 08:43:34 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] tools/lib/traceevent: rename input arguments of libtraceevent APIs from pevent to tep
Date:   Tue, 26 Mar 2019 17:43:24 +0200
Message-Id: <20190326154328.28718-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190326154328.28718-1-tstoyanov@vmware.com>
References: <20190326154328.28718-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch renames "struct tep_handle *pevent" input arguments of libtraceevent
APIs to "struct tep_handle *tep". This makes the API consistent with the chosen
naming convention: tep (trace event parser), instead of the old pevent.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c     | 132 +++---
 tools/lib/traceevent/event-parse-local.h   |   6 +-
 tools/lib/traceevent/event-parse.c         | 475 ++++++++++-----------
 tools/lib/traceevent/event-parse.h         | 120 +++---
 tools/lib/traceevent/event-plugin.c        |   8 +-
 tools/lib/traceevent/parse-filter.c        |   8 +-
 tools/lib/traceevent/plugin_cfg80211.c     |   8 +-
 tools/lib/traceevent/plugin_function.c     |   8 +-
 tools/lib/traceevent/plugin_hrtimer.c      |  12 +-
 tools/lib/traceevent/plugin_jbd2.c         |  12 +-
 tools/lib/traceevent/plugin_kmem.c         |  28 +-
 tools/lib/traceevent/plugin_kvm.c          |  44 +-
 tools/lib/traceevent/plugin_mac80211.c     |   8 +-
 tools/lib/traceevent/plugin_sched_switch.c |  16 +-
 tools/lib/traceevent/plugin_scsi.c         |   8 +-
 tools/lib/traceevent/plugin_xen.c          |   8 +-
 16 files changed, 450 insertions(+), 451 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index 1fe284b1fac8..70b9bdb246fe 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -92,11 +92,11 @@ bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
 	return false;
 }
 
-unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data)
+unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
 {
 	unsigned short swap;
 
-	if (!pevent || pevent->host_bigendian == pevent->file_bigendian)
+	if (!tep || tep->host_bigendian == tep->file_bigendian)
 		return data;
 
 	swap = ((data & 0xffULL) << 8) |
@@ -105,11 +105,11 @@ unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data)
 	return swap;
 }
 
-unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data)
+unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
 {
 	unsigned int swap;
 
-	if (!pevent || pevent->host_bigendian == pevent->file_bigendian)
+	if (!tep || tep->host_bigendian == tep->file_bigendian)
 		return data;
 
 	swap = ((data & 0xffULL) << 24) |
@@ -121,11 +121,11 @@ unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data)
 }
 
 unsigned long long
-tep_data2host8(struct tep_handle *pevent, unsigned long long data)
+tep_data2host8(struct tep_handle *tep, unsigned long long data)
 {
 	unsigned long long swap;
 
-	if (!pevent || pevent->host_bigendian == pevent->file_bigendian)
+	if (!tep || tep->host_bigendian == tep->file_bigendian)
 		return data;
 
 	swap = ((data & 0xffULL) << 56) |
@@ -142,15 +142,15 @@ tep_data2host8(struct tep_handle *pevent, unsigned long long data)
 
 /**
  * tep_get_header_page_size - get size of the header page
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns size of the header page
- * If @pevent is NULL, 0 is returned.
+ * If @tep is NULL, 0 is returned.
  */
-int tep_get_header_page_size(struct tep_handle *pevent)
+int tep_get_header_page_size(struct tep_handle *tep)
 {
-	if (pevent)
-		return pevent->header_page_size_size;
+	if (tep)
+		return tep->header_page_size_size;
 	return 0;
 }
 
@@ -170,163 +170,163 @@ int tep_get_header_timestamp_size(struct tep_handle *tep)
 
 /**
  * tep_get_cpus - get the number of CPUs
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns the number of CPUs
- * If @pevent is NULL, 0 is returned.
+ * If @tep is NULL, 0 is returned.
  */
-int tep_get_cpus(struct tep_handle *pevent)
+int tep_get_cpus(struct tep_handle *tep)
 {
-	if (pevent)
-		return pevent->cpus;
+	if (tep)
+		return tep->cpus;
 	return 0;
 }
 
 /**
  * tep_set_cpus - set the number of CPUs
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This sets the number of CPUs
  */
-void tep_set_cpus(struct tep_handle *pevent, int cpus)
+void tep_set_cpus(struct tep_handle *tep, int cpus)
 {
-	if (pevent)
-		pevent->cpus = cpus;
+	if (tep)
+		tep->cpus = cpus;
 }
 
 /**
  * tep_get_long_size - get the size of a long integer on the traced machine
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns the size of a long integer on the traced machine
- * If @pevent is NULL, 0 is returned.
+ * If @tep is NULL, 0 is returned.
  */
-int tep_get_long_size(struct tep_handle *pevent)
+int tep_get_long_size(struct tep_handle *tep)
 {
-	if (pevent)
-		return pevent->long_size;
+	if (tep)
+		return tep->long_size;
 	return 0;
 }
 
 /**
  * tep_set_long_size - set the size of a long integer on the traced machine
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  * @size: size, in bytes, of a long integer
  *
  * This sets the size of a long integer on the traced machine
  */
-void tep_set_long_size(struct tep_handle *pevent, int long_size)
+void tep_set_long_size(struct tep_handle *tep, int long_size)
 {
-	if (pevent)
-		pevent->long_size = long_size;
+	if (tep)
+		tep->long_size = long_size;
 }
 
 /**
  * tep_get_page_size - get the size of a memory page on the traced machine
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns the size of a memory page on the traced machine
- * If @pevent is NULL, 0 is returned.
+ * If @tep is NULL, 0 is returned.
  */
-int tep_get_page_size(struct tep_handle *pevent)
+int tep_get_page_size(struct tep_handle *tep)
 {
-	if (pevent)
-		return pevent->page_size;
+	if (tep)
+		return tep->page_size;
 	return 0;
 }
 
 /**
  * tep_set_page_size - set the size of a memory page on the traced machine
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  * @_page_size: size of a memory page, in bytes
  *
  * This sets the size of a memory page on the traced machine
  */
-void tep_set_page_size(struct tep_handle *pevent, int _page_size)
+void tep_set_page_size(struct tep_handle *tep, int _page_size)
 {
-	if (pevent)
-		pevent->page_size = _page_size;
+	if (tep)
+		tep->page_size = _page_size;
 }
 
 /**
  * tep_is_file_bigendian - return the endian of the file
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns true if the file is in big endian order
- * If @pevent is NULL, false is returned.
+ * If @tep is NULL, false is returned.
  */
-bool tep_is_file_bigendian(struct tep_handle *pevent)
+bool tep_is_file_bigendian(struct tep_handle *tep)
 {
-	if (pevent)
-		return (pevent->file_bigendian == TEP_BIG_ENDIAN);
+	if (tep)
+		return (tep->file_bigendian == TEP_BIG_ENDIAN);
 	return false;
 }
 
 /**
  * tep_set_file_bigendian - set if the file is in big endian order
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  * @endian: non zero, if the file is in big endian order
  *
  * This sets if the file is in big endian order
  */
-void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian)
+void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian)
 {
-	if (pevent)
-		pevent->file_bigendian = endian;
+	if (tep)
+		tep->file_bigendian = endian;
 }
 
 /**
  * tep_is_local_bigendian - return the endian of the saved local machine
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
- * This returns true if the saved local machine in @pevent is big endian.
- * If @pevent is NULL, false is returned.
+ * This returns true if the saved local machine in @tep is big endian.
+ * If @tep is NULL, false is returned.
  */
-bool tep_is_local_bigendian(struct tep_handle *pevent)
+bool tep_is_local_bigendian(struct tep_handle *tep)
 {
-	if (pevent)
-		return (pevent->host_bigendian == TEP_BIG_ENDIAN);
+	if (tep)
+		return (tep->host_bigendian == TEP_BIG_ENDIAN);
 	return 0;
 }
 
 /**
  * tep_set_local_bigendian - set the stored local machine endian order
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  * @endian: non zero, if the local host has big endian order
  *
  * This sets the endian order for the local machine.
  */
-void tep_set_local_bigendian(struct tep_handle *pevent, enum tep_endian endian)
+void tep_set_local_bigendian(struct tep_handle *tep, enum tep_endian endian)
 {
-	if (pevent)
-		pevent->host_bigendian = endian;
+	if (tep)
+		tep->host_bigendian = endian;
 }
 
 /**
  * tep_is_latency_format - get if the latency output format is configured
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  *
  * This returns true if the latency output format is configured
- * If @pevent is NULL, false is returned.
+ * If @tep is NULL, false is returned.
  */
-bool tep_is_latency_format(struct tep_handle *pevent)
+bool tep_is_latency_format(struct tep_handle *tep)
 {
-	if (pevent)
-		return !!(pevent->latency_format);
+	if (tep)
+		return !!(tep->latency_format);
 	return false;
 }
 
 /**
  * tep_set_latency_format - set the latency output format
- * @pevent: a handle to the tep_handle
+ * @tep: a handle to the tep_handle
  * @lat: non zero for latency output format
  *
  * This sets the latency output format
   */
-void tep_set_latency_format(struct tep_handle *pevent, int lat)
+void tep_set_latency_format(struct tep_handle *tep, int lat)
 {
-	if (pevent)
-		pevent->latency_format = lat;
+	if (tep)
+		tep->latency_format = lat;
 }
 
 /**
diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index c5c8eb4c4ab7..6e16cdb3f555 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -94,8 +94,8 @@ struct tep_handle {
 void tep_free_event(struct tep_event *event);
 void tep_free_format_field(struct tep_format_field *field);
 
-unsigned short tep_data2host2(struct tep_handle *pevent, unsigned short data);
-unsigned int tep_data2host4(struct tep_handle *pevent, unsigned int data);
-unsigned long long tep_data2host8(struct tep_handle *pevent, unsigned long long data);
+unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data);
+unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data);
+unsigned long long tep_data2host8(struct tep_handle *tep, unsigned long long data);
 
 #endif /* _PARSE_EVENTS_INT_H */
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 4144c4e20e4e..6265d3bb72a1 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -200,13 +200,13 @@ static const char *find_cmdline(struct tep_handle *pevent, int pid)
 
 /**
  * tep_is_pid_registered - return if a pid has a cmdline registered
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @pid: The pid to check if it has a cmdline registered with.
  *
  * Returns true if the pid has a cmdline mapped to it
  * false otherwise.
  */
-bool tep_is_pid_registered(struct tep_handle *pevent, int pid)
+bool tep_is_pid_registered(struct tep_handle *tep, int pid)
 {
 	const struct tep_cmdline *comm;
 	struct tep_cmdline key;
@@ -214,13 +214,13 @@ bool tep_is_pid_registered(struct tep_handle *pevent, int pid)
 	if (!pid)
 		return true;
 
-	if (!pevent->cmdlines && cmdline_init(pevent))
+	if (!tep->cmdlines && cmdline_init(tep))
 		return false;
 
 	key.pid = pid;
 
-	comm = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
-		       sizeof(*pevent->cmdlines), cmdline_cmp);
+	comm = bsearch(&key, tep->cmdlines, tep->cmdline_count,
+		       sizeof(*tep->cmdlines), cmdline_cmp);
 
 	if (comm)
 		return true;
@@ -288,13 +288,13 @@ static int add_new_comm(struct tep_handle *pevent,
 	return 0;
 }
 
-static int _tep_register_comm(struct tep_handle *pevent,
+static int _tep_register_comm(struct tep_handle *tep,
 			      const char *comm, int pid, bool override)
 {
 	struct cmdline_list *item;
 
-	if (pevent->cmdlines)
-		return add_new_comm(pevent, comm, pid, override);
+	if (tep->cmdlines)
+		return add_new_comm(tep, comm, pid, override);
 
 	item = malloc(sizeof(*item));
 	if (!item)
@@ -309,17 +309,17 @@ static int _tep_register_comm(struct tep_handle *pevent,
 		return -1;
 	}
 	item->pid = pid;
-	item->next = pevent->cmdlist;
+	item->next = tep->cmdlist;
 
-	pevent->cmdlist = item;
-	pevent->cmdline_count++;
+	tep->cmdlist = item;
+	tep->cmdline_count++;
 
 	return 0;
 }
 
 /**
  * tep_register_comm - register a pid / comm mapping
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @comm: the command line to register
  * @pid: the pid to map the command line to
  *
@@ -327,14 +327,14 @@ static int _tep_register_comm(struct tep_handle *pevent,
  * a given pid. The comm is duplicated. If a command with the same pid
  * already exist, -1 is returned and errno is set to EEXIST
  */
-int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
+int tep_register_comm(struct tep_handle *tep, const char *comm, int pid)
 {
-	return _tep_register_comm(pevent, comm, pid, false);
+	return _tep_register_comm(tep, comm, pid, false);
 }
 
 /**
  * tep_override_comm - register a pid / comm mapping
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @comm: the command line to register
  * @pid: the pid to map the command line to
  *
@@ -342,19 +342,19 @@ int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid)
  * a given pid. The comm is duplicated. If a command with the same pid
  * already exist, the command string is udapted with the new one
  */
-int tep_override_comm(struct tep_handle *pevent, const char *comm, int pid)
+int tep_override_comm(struct tep_handle *tep, const char *comm, int pid)
 {
-	if (!pevent->cmdlines && cmdline_init(pevent)) {
+	if (!tep->cmdlines && cmdline_init(tep)) {
 		errno = ENOMEM;
 		return -1;
 	}
-	return _tep_register_comm(pevent, comm, pid, true);
+	return _tep_register_comm(tep, comm, pid, true);
 }
 
-int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock)
+int tep_register_trace_clock(struct tep_handle *tep, const char *trace_clock)
 {
-	pevent->trace_clock = strdup(trace_clock);
-	if (!pevent->trace_clock) {
+	tep->trace_clock = strdup(trace_clock);
+	if (!tep->trace_clock) {
 		errno = ENOMEM;
 		return -1;
 	}
@@ -472,15 +472,14 @@ struct func_resolver {
 
 /**
  * tep_set_function_resolver - set an alternative function resolver
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @resolver: function to be used
  * @priv: resolver function private state.
  *
  * Some tools may have already a way to resolve kernel functions, allow them to
- * keep using it instead of duplicating all the entries inside
- * pevent->funclist.
+ * keep using it instead of duplicating all the entries inside tep->funclist.
  */
-int tep_set_function_resolver(struct tep_handle *pevent,
+int tep_set_function_resolver(struct tep_handle *tep,
 			      tep_func_resolver_t *func, void *priv)
 {
 	struct func_resolver *resolver = malloc(sizeof(*resolver));
@@ -491,23 +490,23 @@ int tep_set_function_resolver(struct tep_handle *pevent,
 	resolver->func = func;
 	resolver->priv = priv;
 
-	free(pevent->func_resolver);
-	pevent->func_resolver = resolver;
+	free(tep->func_resolver);
+	tep->func_resolver = resolver;
 
 	return 0;
 }
 
 /**
  * tep_reset_function_resolver - reset alternative function resolver
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  *
  * Stop using whatever alternative resolver was set, use the default
  * one instead.
  */
-void tep_reset_function_resolver(struct tep_handle *pevent)
+void tep_reset_function_resolver(struct tep_handle *tep)
 {
-	free(pevent->func_resolver);
-	pevent->func_resolver = NULL;
+	free(tep->func_resolver);
+	tep->func_resolver = NULL;
 }
 
 static struct func_map *
@@ -531,18 +530,18 @@ find_func(struct tep_handle *pevent, unsigned long long addr)
 
 /**
  * tep_find_function - find a function by a given address
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @addr: the address to find the function with
  *
  * Returns a pointer to the function stored that has the given
  * address. Note, the address does not have to be exact, it
  * will select the function that would contain the address.
  */
-const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr)
+const char *tep_find_function(struct tep_handle *tep, unsigned long long addr)
 {
 	struct func_map *map;
 
-	map = find_func(pevent, addr);
+	map = find_func(tep, addr);
 	if (!map)
 		return NULL;
 
@@ -551,7 +550,7 @@ const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr
 
 /**
  * tep_find_function_address - find a function address by a given address
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @addr: the address to find the function with
  *
  * Returns the address the function starts at. This can be used in
@@ -559,11 +558,11 @@ const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr
  * name and the function offset.
  */
 unsigned long long
-tep_find_function_address(struct tep_handle *pevent, unsigned long long addr)
+tep_find_function_address(struct tep_handle *tep, unsigned long long addr)
 {
 	struct func_map *map;
 
-	map = find_func(pevent, addr);
+	map = find_func(tep, addr);
 	if (!map)
 		return 0;
 
@@ -572,7 +571,7 @@ tep_find_function_address(struct tep_handle *pevent, unsigned long long addr)
 
 /**
  * tep_register_function - register a function with a given address
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @function: the function name to register
  * @addr: the address the function starts at
  * @mod: the kernel module the function may be in (NULL for none)
@@ -580,7 +579,7 @@ tep_find_function_address(struct tep_handle *pevent, unsigned long long addr)
  * This registers a function name with an address and module.
  * The @func passed in is duplicated.
  */
-int tep_register_function(struct tep_handle *pevent, char *func,
+int tep_register_function(struct tep_handle *tep, char *func,
 			  unsigned long long addr, char *mod)
 {
 	struct func_list *item = malloc(sizeof(*item));
@@ -588,7 +587,7 @@ int tep_register_function(struct tep_handle *pevent, char *func,
 	if (!item)
 		return -1;
 
-	item->next = pevent->funclist;
+	item->next = tep->funclist;
 	item->func = strdup(func);
 	if (!item->func)
 		goto out_free;
@@ -601,8 +600,8 @@ int tep_register_function(struct tep_handle *pevent, char *func,
 		item->mod = NULL;
 	item->addr = addr;
 
-	pevent->funclist = item;
-	pevent->func_count++;
+	tep->funclist = item;
+	tep->func_count++;
 
 	return 0;
 
@@ -617,23 +616,23 @@ int tep_register_function(struct tep_handle *pevent, char *func,
 
 /**
  * tep_print_funcs - print out the stored functions
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  *
  * This prints out the stored functions.
  */
-void tep_print_funcs(struct tep_handle *pevent)
+void tep_print_funcs(struct tep_handle *tep)
 {
 	int i;
 
-	if (!pevent->func_map)
-		func_map_init(pevent);
+	if (!tep->func_map)
+		func_map_init(tep);
 
-	for (i = 0; i < (int)pevent->func_count; i++) {
+	for (i = 0; i < (int)tep->func_count; i++) {
 		printf("%016llx %s",
-		       pevent->func_map[i].addr,
-		       pevent->func_map[i].func);
-		if (pevent->func_map[i].mod)
-			printf(" [%s]\n", pevent->func_map[i].mod);
+		       tep->func_map[i].addr,
+		       tep->func_map[i].func);
+		if (tep->func_map[i].mod)
+			printf(" [%s]\n", tep->func_map[i].mod);
 		else
 			printf("\n");
 	}
@@ -713,14 +712,14 @@ find_printk(struct tep_handle *pevent, unsigned long long addr)
 
 /**
  * tep_register_print_string - register a string by its address
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @fmt: the string format to register
  * @addr: the address the string was located at
  *
  * This registers a string by the address it was stored in the kernel.
  * The @fmt passed in is duplicated.
  */
-int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
+int tep_register_print_string(struct tep_handle *tep, const char *fmt,
 			      unsigned long long addr)
 {
 	struct printk_list *item = malloc(sizeof(*item));
@@ -729,7 +728,7 @@ int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 	if (!item)
 		return -1;
 
-	item->next = pevent->printklist;
+	item->next = tep->printklist;
 	item->addr = addr;
 
 	/* Strip off quotes and '\n' from the end */
@@ -747,8 +746,8 @@ int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 	if (strcmp(p, "\\n") == 0)
 		*p = 0;
 
-	pevent->printklist = item;
-	pevent->printk_count++;
+	tep->printklist = item;
+	tep->printk_count++;
 
 	return 0;
 
@@ -760,21 +759,21 @@ int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
 
 /**
  * tep_print_printk - print out the stored strings
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  *
  * This prints the string formats that were stored.
  */
-void tep_print_printk(struct tep_handle *pevent)
+void tep_print_printk(struct tep_handle *tep)
 {
 	int i;
 
-	if (!pevent->printk_map)
-		printk_map_init(pevent);
+	if (!tep->printk_map)
+		printk_map_init(tep);
 
-	for (i = 0; i < (int)pevent->printk_count; i++) {
+	for (i = 0; i < (int)tep->printk_count; i++) {
 		printf("%016llx %s\n",
-		       pevent->printk_map[i].addr,
-		       pevent->printk_map[i].printk);
+		       tep->printk_map[i].addr,
+		       tep->printk_map[i].printk);
 	}
 }
 
@@ -1184,7 +1183,7 @@ static enum tep_event_type read_token(char **tok)
 }
 
 /**
- * tep_read_token - access to utilities to use the pevent parser
+ * tep_read_token - access to utilities to use the tep parser
  * @tok: The token to return
  *
  * This will parse tokens from the string given by
@@ -3357,14 +3356,14 @@ tep_find_any_field(struct tep_event *event, const char *name)
 
 /**
  * tep_read_number - read a number from data
- * @pevent: handle for the pevent
+ * @tep: a handle to the trace event parser context
  * @ptr: the raw data
  * @size: the size of the data that holds the number
  *
  * Returns the number (converted to host) from the
  * raw data.
  */
-unsigned long long tep_read_number(struct tep_handle *pevent,
+unsigned long long tep_read_number(struct tep_handle *tep,
 				   const void *ptr, int size)
 {
 	unsigned long long val;
@@ -3373,12 +3372,12 @@ unsigned long long tep_read_number(struct tep_handle *pevent,
 	case 1:
 		return *(unsigned char *)ptr;
 	case 2:
-		return tep_data2host2(pevent, *(unsigned short *)ptr);
+		return tep_data2host2(tep, *(unsigned short *)ptr);
 	case 4:
-		return tep_data2host4(pevent, *(unsigned int *)ptr);
+		return tep_data2host4(tep, *(unsigned int *)ptr);
 	case 8:
 		memcpy(&val, (ptr), sizeof(unsigned long long));
-		return tep_data2host8(pevent, val);
+		return tep_data2host8(tep, val);
 	default:
 		/* BUG! */
 		return 0;
@@ -3499,28 +3498,28 @@ static int events_id_cmp(const void *a, const void *b);
 
 /**
  * tep_find_event - find an event by given id
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @id: the id of the event
  *
  * Returns an event that has a given @id.
  */
-struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
+struct tep_event *tep_find_event(struct tep_handle *tep, int id)
 {
 	struct tep_event **eventptr;
 	struct tep_event key;
 	struct tep_event *pkey = &key;
 
 	/* Check cache first */
-	if (pevent->last_event && pevent->last_event->id == id)
-		return pevent->last_event;
+	if (tep->last_event && tep->last_event->id == id)
+		return tep->last_event;
 
 	key.id = id;
 
-	eventptr = bsearch(&pkey, pevent->events, pevent->nr_events,
-			   sizeof(*pevent->events), events_id_cmp);
+	eventptr = bsearch(&pkey, tep->events, tep->nr_events,
+			   sizeof(*tep->events), events_id_cmp);
 
 	if (eventptr) {
-		pevent->last_event = *eventptr;
+		tep->last_event = *eventptr;
 		return *eventptr;
 	}
 
@@ -3529,7 +3528,7 @@ struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
 
 /**
  * tep_find_event_by_name - find an event by given name
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @sys: the system name to search for
  * @name: the name of the event to search for
  *
@@ -3537,19 +3536,19 @@ struct tep_event *tep_find_event(struct tep_handle *pevent, int id)
  * @sys. If @sys is NULL the first event with @name is returned.
  */
 struct tep_event *
-tep_find_event_by_name(struct tep_handle *pevent,
+tep_find_event_by_name(struct tep_handle *tep,
 		       const char *sys, const char *name)
 {
 	struct tep_event *event = NULL;
 	int i;
 
-	if (pevent->last_event &&
-	    strcmp(pevent->last_event->name, name) == 0 &&
-	    (!sys || strcmp(pevent->last_event->system, sys) == 0))
-		return pevent->last_event;
+	if (tep->last_event &&
+	    strcmp(tep->last_event->name, name) == 0 &&
+	    (!sys || strcmp(tep->last_event->system, sys) == 0))
+		return tep->last_event;
 
-	for (i = 0; i < pevent->nr_events; i++) {
-		event = pevent->events[i];
+	for (i = 0; i < tep->nr_events; i++) {
+		event = tep->events[i];
 		if (strcmp(event->name, name) == 0) {
 			if (!sys)
 				break;
@@ -3557,10 +3556,10 @@ tep_find_event_by_name(struct tep_handle *pevent,
 				break;
 		}
 	}
-	if (i == pevent->nr_events)
+	if (i == tep->nr_events)
 		event = NULL;
 
-	pevent->last_event = event;
+	tep->last_event = event;
 	return event;
 }
 
@@ -5172,7 +5171,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 
 /**
  * tep_data_latency_format - parse the data for the latency format
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @s: the trace_seq to write to
  * @record: the record to read from
  *
@@ -5180,7 +5179,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
  * need rescheduling, in hard/soft interrupt, preempt count
  * and lock depth) and places it into the trace_seq.
  */
-void tep_data_latency_format(struct tep_handle *pevent,
+void tep_data_latency_format(struct tep_handle *tep,
 			     struct trace_seq *s, struct tep_record *record)
 {
 	static int check_lock_depth = 1;
@@ -5195,13 +5194,13 @@ void tep_data_latency_format(struct tep_handle *pevent,
 	int softirq;
 	void *data = record->data;
 
-	lat_flags = parse_common_flags(pevent, data);
-	pc = parse_common_pc(pevent, data);
+	lat_flags = parse_common_flags(tep, data);
+	pc = parse_common_pc(tep, data);
 	/* lock_depth may not always exist */
 	if (lock_depth_exists)
-		lock_depth = parse_common_lock_depth(pevent, data);
+		lock_depth = parse_common_lock_depth(tep, data);
 	else if (check_lock_depth) {
-		lock_depth = parse_common_lock_depth(pevent, data);
+		lock_depth = parse_common_lock_depth(tep, data);
 		if (lock_depth < 0)
 			check_lock_depth = 0;
 		else
@@ -5210,9 +5209,9 @@ void tep_data_latency_format(struct tep_handle *pevent,
 
 	/* migrate_disable may not always exist */
 	if (migrate_disable_exists)
-		migrate_disable = parse_common_migrate_disable(pevent, data);
+		migrate_disable = parse_common_migrate_disable(tep, data);
 	else if (check_migrate_disable) {
-		migrate_disable = parse_common_migrate_disable(pevent, data);
+		migrate_disable = parse_common_migrate_disable(tep, data);
 		if (migrate_disable < 0)
 			check_migrate_disable = 0;
 		else
@@ -5255,67 +5254,67 @@ void tep_data_latency_format(struct tep_handle *pevent,
 
 /**
  * tep_data_type - parse out the given event type
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @rec: the record to read from
  *
  * This returns the event id from the @rec.
  */
-int tep_data_type(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_type(struct tep_handle *tep, struct tep_record *rec)
 {
-	return trace_parse_common_type(pevent, rec->data);
+	return trace_parse_common_type(tep, rec->data);
 }
 
 /**
  * tep_data_pid - parse the PID from record
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @rec: the record to parse
  *
  * This returns the PID from a record.
  */
-int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_pid(struct tep_handle *tep, struct tep_record *rec)
 {
-	return parse_common_pid(pevent, rec->data);
+	return parse_common_pid(tep, rec->data);
 }
 
 /**
  * tep_data_preempt_count - parse the preempt count from the record
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @rec: the record to parse
  *
  * This returns the preempt count from a record.
  */
-int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_preempt_count(struct tep_handle *tep, struct tep_record *rec)
 {
-	return parse_common_pc(pevent, rec->data);
+	return parse_common_pc(tep, rec->data);
 }
 
 /**
  * tep_data_flags - parse the latency flags from the record
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @rec: the record to parse
  *
  * This returns the latency flags from a record.
  *
  *  Use trace_flag_type enum for the flags (see event-parse.h).
  */
-int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec)
+int tep_data_flags(struct tep_handle *tep, struct tep_record *rec)
 {
-	return parse_common_flags(pevent, rec->data);
+	return parse_common_flags(tep, rec->data);
 }
 
 /**
  * tep_data_comm_from_pid - return the command line from PID
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @pid: the PID of the task to search for
  *
  * This returns a pointer to the command line that has the given
  * @pid.
  */
-const char *tep_data_comm_from_pid(struct tep_handle *pevent, int pid)
+const char *tep_data_comm_from_pid(struct tep_handle *tep, int pid)
 {
 	const char *comm;
 
-	comm = find_cmdline(pevent, pid);
+	comm = find_cmdline(tep, pid);
 	return comm;
 }
 
@@ -5337,7 +5336,7 @@ pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct tep_cmdline
 
 /**
  * tep_data_pid_from_comm - return the pid from a given comm
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @comm: the cmdline to find the pid from
  * @next: the cmdline structure to find the next comm
  *
@@ -5348,7 +5347,7 @@ pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct tep_cmdline
  * next pid.
  * Also, it does a linear search, so it may be slow.
  */
-struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
+struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *tep, const char *comm,
 					   struct tep_cmdline *next)
 {
 	struct tep_cmdline *cmdline;
@@ -5357,25 +5356,25 @@ struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char
 	 * If the cmdlines have not been converted yet, then use
 	 * the list.
 	 */
-	if (!pevent->cmdlines)
-		return pid_from_cmdlist(pevent, comm, next);
+	if (!tep->cmdlines)
+		return pid_from_cmdlist(tep, comm, next);
 
 	if (next) {
 		/*
 		 * The next pointer could have been still from
 		 * a previous call before cmdlines were created
 		 */
-		if (next < pevent->cmdlines ||
-		    next >= pevent->cmdlines + pevent->cmdline_count)
+		if (next < tep->cmdlines ||
+		    next >= tep->cmdlines + tep->cmdline_count)
 			next = NULL;
 		else
 			cmdline  = next++;
 	}
 
 	if (!next)
-		cmdline = pevent->cmdlines;
+		cmdline = tep->cmdlines;
 
-	while (cmdline < pevent->cmdlines + pevent->cmdline_count) {
+	while (cmdline < tep->cmdlines + tep->cmdline_count) {
 		if (strcmp(cmdline->comm, comm) == 0)
 			return cmdline;
 		cmdline++;
@@ -5385,12 +5384,13 @@ struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char
 
 /**
  * tep_cmdline_pid - return the pid associated to a given cmdline
+ * @tep: a handle to the trace event parser context
  * @cmdline: The cmdline structure to get the pid from
  *
  * Returns the pid for a give cmdline. If @cmdline is NULL, then
  * -1 is returned.
  */
-int tep_cmdline_pid(struct tep_handle *pevent, struct tep_cmdline *cmdline)
+int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline)
 {
 	struct cmdline_list *cmdlist = (struct cmdline_list *)cmdline;
 
@@ -5401,9 +5401,9 @@ int tep_cmdline_pid(struct tep_handle *pevent, struct tep_cmdline *cmdline)
 	 * If cmdlines have not been created yet, or cmdline is
 	 * not part of the array, then treat it as a cmdlist instead.
 	 */
-	if (!pevent->cmdlines ||
-	    cmdline < pevent->cmdlines ||
-	    cmdline >= pevent->cmdlines + pevent->cmdline_count)
+	if (!tep->cmdlines ||
+	    cmdline < tep->cmdlines ||
+	    cmdline >= tep->cmdlines + tep->cmdline_count)
 		return cmdlist->pid;
 
 	return cmdline->pid;
@@ -5453,14 +5453,14 @@ static bool is_timestamp_in_us(char *trace_clock, bool use_trace_clock)
 
 /**
  * tep_find_event_by_record - return the event from a given record
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @record: The record to get the event from
  *
  * Returns the associated event for a given record, or NULL if non is
  * is found.
  */
 struct tep_event *
-tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
+tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record)
 {
 	int type;
 
@@ -5469,21 +5469,21 @@ tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record)
 		return NULL;
 	}
 
-	type = trace_parse_common_type(pevent, record->data);
+	type = trace_parse_common_type(tep, record->data);
 
-	return tep_find_event(pevent, type);
+	return tep_find_event(tep, type);
 }
 
 /**
  * tep_print_event_task - Write the event task comm, pid and CPU
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
  * @record: The record to get the event from
  *
  * Writes the tasks comm, pid and CPU to @s.
  */
-void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_task(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record)
 {
@@ -5491,27 +5491,26 @@ void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
 	const char *comm;
 	int pid;
 
-	pid = parse_common_pid(pevent, data);
-	comm = find_cmdline(pevent, pid);
+	pid = parse_common_pid(tep, data);
+	comm = find_cmdline(tep, pid);
 
-	if (pevent->latency_format) {
-		trace_seq_printf(s, "%8.8s-%-5d %3d",
-		       comm, pid, record->cpu);
-	} else
+	if (tep->latency_format)
+		trace_seq_printf(s, "%8.8s-%-5d %3d", comm, pid, record->cpu);
+	else
 		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
 }
 
 /**
  * tep_print_event_time - Write the event timestamp
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
  * @record: The record to get the event from
- * @use_trace_clock: Set to parse according to the @pevent->trace_clock
+ * @use_trace_clock: Set to parse according to the @tep->trace_clock
  *
  * Writes the timestamp of the record into @s.
  */
-void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_time(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record,
 			  bool use_trace_clock)
@@ -5522,19 +5521,18 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 	int p;
 	bool use_usec_format;
 
-	use_usec_format = is_timestamp_in_us(pevent->trace_clock,
-							use_trace_clock);
+	use_usec_format = is_timestamp_in_us(tep->trace_clock, use_trace_clock);
 	if (use_usec_format) {
 		secs = record->ts / NSEC_PER_SEC;
 		nsecs = record->ts - secs * NSEC_PER_SEC;
 	}
 
-	if (pevent->latency_format) {
-		tep_data_latency_format(pevent, s, record);
+	if (tep->latency_format) {
+		tep_data_latency_format(tep, s, record);
 	}
 
 	if (use_usec_format) {
-		if (pevent->flags & TEP_NSEC_OUTPUT) {
+		if (tep->flags & TEP_NSEC_OUTPUT) {
 			usecs = nsecs;
 			p = 9;
 		} else {
@@ -5554,14 +5552,14 @@ void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
 
 /**
  * tep_print_event_data - Write the event data section
- * @pevent: a handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @s: the trace_seq to write to
  * @event: the handle to the record's event
  * @record: The record to get the event from
  *
  * Writes the parsing of the record's data to @s.
  */
-void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_data(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record)
 {
@@ -5578,15 +5576,15 @@ void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
 	tep_event_info(s, event, record);
 }
 
-void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
 		     struct tep_record *record, bool use_trace_clock)
 {
 	struct tep_event *event;
 
-	event = tep_find_event_by_record(pevent, record);
+	event = tep_find_event_by_record(tep, record);
 	if (!event) {
 		int i;
-		int type = trace_parse_common_type(pevent, record->data);
+		int type = trace_parse_common_type(tep, record->data);
 
 		do_warning("ug! no event found for type %d", type);
 		trace_seq_printf(s, "[UNKNOWN TYPE %d]", type);
@@ -5596,9 +5594,9 @@ void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
 		return;
 	}
 
-	tep_print_event_task(pevent, s, event, record);
-	tep_print_event_time(pevent, s, event, record, use_trace_clock);
-	tep_print_event_data(pevent, s, event, record);
+	tep_print_event_task(tep, s, event, record);
+	tep_print_event_time(tep, s, event, record, use_trace_clock);
+	tep_print_event_data(tep, s, event, record);
 }
 
 static int events_id_cmp(const void *a, const void *b)
@@ -5649,29 +5647,30 @@ static int events_system_cmp(const void *a, const void *b)
 	return events_id_cmp(a, b);
 }
 
-struct tep_event **tep_list_events(struct tep_handle *pevent, enum tep_event_sort_type sort_type)
+struct tep_event **tep_list_events(struct tep_handle *tep,
+				   enum tep_event_sort_type sort_type)
 {
 	struct tep_event **events;
 	int (*sort)(const void *a, const void *b);
 
-	events = pevent->sort_events;
+	events = tep->sort_events;
 
-	if (events && pevent->last_type == sort_type)
+	if (events && tep->last_type == sort_type)
 		return events;
 
 	if (!events) {
-		events = malloc(sizeof(*events) * (pevent->nr_events + 1));
+		events = malloc(sizeof(*events) * (tep->nr_events + 1));
 		if (!events)
 			return NULL;
 
-		memcpy(events, pevent->events, sizeof(*events) * pevent->nr_events);
-		events[pevent->nr_events] = NULL;
+		memcpy(events, tep->events, sizeof(*events) * tep->nr_events);
+		events[tep->nr_events] = NULL;
 
-		pevent->sort_events = events;
+		tep->sort_events = events;
 
 		/* the internal events are sorted by id */
 		if (sort_type == TEP_EVENT_SORT_ID) {
-			pevent->last_type = sort_type;
+			tep->last_type = sort_type;
 			return events;
 		}
 	}
@@ -5690,8 +5689,8 @@ struct tep_event **tep_list_events(struct tep_handle *pevent, enum tep_event_sor
 		return events;
 	}
 
-	qsort(events, pevent->nr_events, sizeof(*events), sort);
-	pevent->last_type = sort_type;
+	qsort(events, tep->nr_events, sizeof(*events), sort);
+	tep->last_type = sort_type;
 
 	return events;
 }
@@ -5950,7 +5949,7 @@ static void parse_header_field(const char *field,
 
 /**
  * tep_parse_header_page - parse the data stored in the header page
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @buf: the buffer storing the header page format string
  * @size: the size of @buf
  * @long_size: the long size to use if there is no header
@@ -5960,7 +5959,7 @@ static void parse_header_field(const char *field,
  *
  * /sys/kernel/debug/tracing/events/header_page
  */
-int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
+int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
 			  int long_size)
 {
 	int ignore;
@@ -5970,22 +5969,22 @@ int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long si
 		 * Old kernels did not have header page info.
 		 * Sorry but we just use what we find here in user space.
 		 */
-		pevent->header_page_ts_size = sizeof(long long);
-		pevent->header_page_size_size = long_size;
-		pevent->header_page_data_offset = sizeof(long long) + long_size;
-		pevent->old_format = 1;
+		tep->header_page_ts_size = sizeof(long long);
+		tep->header_page_size_size = long_size;
+		tep->header_page_data_offset = sizeof(long long) + long_size;
+		tep->old_format = 1;
 		return -1;
 	}
 	init_input_buf(buf, size);
 
-	parse_header_field("timestamp", &pevent->header_page_ts_offset,
-			   &pevent->header_page_ts_size, 1);
-	parse_header_field("commit", &pevent->header_page_size_offset,
-			   &pevent->header_page_size_size, 1);
-	parse_header_field("overwrite", &pevent->header_page_overwrite,
+	parse_header_field("timestamp", &tep->header_page_ts_offset,
+			   &tep->header_page_ts_size, 1);
+	parse_header_field("commit", &tep->header_page_size_offset,
+			   &tep->header_page_size_size, 1);
+	parse_header_field("overwrite", &tep->header_page_overwrite,
 			   &ignore, 0);
-	parse_header_field("data", &pevent->header_page_data_offset,
-			   &pevent->header_page_data_size, 1);
+	parse_header_field("data", &tep->header_page_data_offset,
+			   &tep->header_page_data_size, 1);
 
 	return 0;
 }
@@ -6191,7 +6190,7 @@ __parse_event(struct tep_handle *pevent,
 
 /**
  * tep_parse_format - parse the event format
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @eventp: returned format
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
@@ -6204,17 +6203,17 @@ __parse_event(struct tep_handle *pevent,
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum tep_errno tep_parse_format(struct tep_handle *pevent,
+enum tep_errno tep_parse_format(struct tep_handle *tep,
 				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys)
 {
-	return __parse_event(pevent, eventp, buf, size, sys);
+	return __parse_event(tep, eventp, buf, size, sys);
 }
 
 /**
  * tep_parse_event - parse the event format
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
  * @sys: the system the event belongs to
@@ -6226,15 +6225,15 @@ enum tep_errno tep_parse_format(struct tep_handle *pevent,
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
+enum tep_errno tep_parse_event(struct tep_handle *tep, const char *buf,
 			       unsigned long size, const char *sys)
 {
 	struct tep_event *event = NULL;
 	enum tep_errno ret;
 
-	ret = __parse_event(pevent, &event, buf, size, sys);
+	ret = __parse_event(tep, &event, buf, size, sys);
 	if (ret != TEP_ERRNO__SUCCESS)
-		pevent->parsing_failures++;
+		tep->parsing_failures++;
 
 	return ret;
 }
@@ -6476,7 +6475,7 @@ static void free_func_handle(struct tep_function_handler *func)
 
 /**
  * tep_register_print_function - register a helper function
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @func: the function to process the helper function
  * @ret_type: the return type of the helper function
  * @name: the name of the helper function
@@ -6489,7 +6488,7 @@ static void free_func_handle(struct tep_function_handler *func)
  * The @parameters is a variable list of tep_func_arg_type enums that
  * must end with TEP_FUNC_ARG_VOID.
  */
-int tep_register_print_function(struct tep_handle *pevent,
+int tep_register_print_function(struct tep_handle *tep,
 				tep_func_handler func,
 				enum tep_func_arg_type ret_type,
 				char *name, ...)
@@ -6501,7 +6500,7 @@ int tep_register_print_function(struct tep_handle *pevent,
 	va_list ap;
 	int ret;
 
-	func_handle = find_func_handler(pevent, name);
+	func_handle = find_func_handler(tep, name);
 	if (func_handle) {
 		/*
 		 * This is most like caused by the users own
@@ -6509,7 +6508,7 @@ int tep_register_print_function(struct tep_handle *pevent,
 		 * system defaults.
 		 */
 		pr_stat("override of function helper '%s'", name);
-		remove_func_handler(pevent, name);
+		remove_func_handler(tep, name);
 	}
 
 	func_handle = calloc(1, sizeof(*func_handle));
@@ -6556,8 +6555,8 @@ int tep_register_print_function(struct tep_handle *pevent,
 	}
 	va_end(ap);
 
-	func_handle->next = pevent->func_handlers;
-	pevent->func_handlers = func_handle;
+	func_handle->next = tep->func_handlers;
+	tep->func_handlers = func_handle;
 
 	return 0;
  out_free:
@@ -6568,7 +6567,7 @@ int tep_register_print_function(struct tep_handle *pevent,
 
 /**
  * tep_unregister_print_function - unregister a helper function
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @func: the function to process the helper function
  * @name: the name of the helper function
  *
@@ -6576,14 +6575,14 @@ int tep_register_print_function(struct tep_handle *pevent,
  *
  * Returns 0 if the handler was removed successully, -1 otherwise.
  */
-int tep_unregister_print_function(struct tep_handle *pevent,
+int tep_unregister_print_function(struct tep_handle *tep,
 				  tep_func_handler func, char *name)
 {
 	struct tep_function_handler *func_handle;
 
-	func_handle = find_func_handler(pevent, name);
+	func_handle = find_func_handler(tep, name);
 	if (func_handle && func_handle->func == func) {
-		remove_func_handler(pevent, name);
+		remove_func_handler(tep, name);
 		return 0;
 	}
 	return -1;
@@ -6614,7 +6613,7 @@ static struct tep_event *search_event(struct tep_handle *pevent, int id,
 
 /**
  * tep_register_event_handler - register a way to parse an event
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @id: the id of the event to register
  * @sys_name: the system name the event belongs to
  * @event_name: the name of the event
@@ -6635,14 +6634,14 @@ static struct tep_event *search_event(struct tep_handle *pevent, int id,
  *  negative TEP_ERRNO_... in case of an error
  *
  */
-int tep_register_event_handler(struct tep_handle *pevent, int id,
+int tep_register_event_handler(struct tep_handle *tep, int id,
 			       const char *sys_name, const char *event_name,
 			       tep_event_handler_func func, void *context)
 {
 	struct tep_event *event;
 	struct event_handler *handle;
 
-	event = search_event(pevent, id, sys_name, event_name);
+	event = search_event(tep, id, sys_name, event_name);
 	if (event == NULL)
 		goto not_found;
 
@@ -6677,8 +6676,8 @@ int tep_register_event_handler(struct tep_handle *pevent, int id,
 	}
 
 	handle->func = func;
-	handle->next = pevent->handlers;
-	pevent->handlers = handle;
+	handle->next = tep->handlers;
+	tep->handlers = handle;
 	handle->context = context;
 
 	return TEP_REGISTER_SUCCESS;
@@ -6705,7 +6704,7 @@ static int handle_matches(struct event_handler *handler, int id,
 
 /**
  * tep_unregister_event_handler - unregister an existing event handler
- * @pevent: the handle to the pevent
+ * @tep: a handle to the trace event parser context
  * @id: the id of the event to unregister
  * @sys_name: the system name the handler belongs to
  * @event_name: the name of the event handler
@@ -6719,7 +6718,7 @@ static int handle_matches(struct event_handler *handler, int id,
  *
  * Returns 0 if handler was removed successfully, -1 if event was not found.
  */
-int tep_unregister_event_handler(struct tep_handle *pevent, int id,
+int tep_unregister_event_handler(struct tep_handle *tep, int id,
 				 const char *sys_name, const char *event_name,
 				 tep_event_handler_func func, void *context)
 {
@@ -6727,7 +6726,7 @@ int tep_unregister_event_handler(struct tep_handle *pevent, int id,
 	struct event_handler *handle;
 	struct event_handler **next;
 
-	event = search_event(pevent, id, sys_name, event_name);
+	event = search_event(tep, id, sys_name, event_name);
 	if (event == NULL)
 		goto not_found;
 
@@ -6741,7 +6740,7 @@ int tep_unregister_event_handler(struct tep_handle *pevent, int id,
 	}
 
 not_found:
-	for (next = &pevent->handlers; *next; next = &(*next)->next) {
+	for (next = &tep->handlers; *next; next = &(*next)->next) {
 		handle = *next;
 		if (handle_matches(handle, id, sys_name, event_name,
 				   func, context))
@@ -6758,7 +6757,7 @@ int tep_unregister_event_handler(struct tep_handle *pevent, int id,
 }
 
 /**
- * tep_alloc - create a pevent handle
+ * tep_alloc - create a tep handle
  */
 struct tep_handle *tep_alloc(void)
 {
@@ -6772,9 +6771,9 @@ struct tep_handle *tep_alloc(void)
 	return pevent;
 }
 
-void tep_ref(struct tep_handle *pevent)
+void tep_ref(struct tep_handle *tep)
 {
-	pevent->ref_count++;
+	tep->ref_count++;
 }
 
 int tep_get_ref(struct tep_handle *tep)
@@ -6824,10 +6823,10 @@ void tep_free_event(struct tep_event *event)
 }
 
 /**
- * tep_free - free a pevent handle
- * @pevent: the pevent handle to free
+ * tep_free - free a tep handle
+ * @tep: the tep handle to free
  */
-void tep_free(struct tep_handle *pevent)
+void tep_free(struct tep_handle *tep)
 {
 	struct cmdline_list *cmdlist, *cmdnext;
 	struct func_list *funclist, *funcnext;
@@ -6836,21 +6835,21 @@ void tep_free(struct tep_handle *pevent)
 	struct event_handler *handle;
 	int i;
 
-	if (!pevent)
+	if (!tep)
 		return;
 
-	cmdlist = pevent->cmdlist;
-	funclist = pevent->funclist;
-	printklist = pevent->printklist;
+	cmdlist = tep->cmdlist;
+	funclist = tep->funclist;
+	printklist = tep->printklist;
 
-	pevent->ref_count--;
-	if (pevent->ref_count)
+	tep->ref_count--;
+	if (tep->ref_count)
 		return;
 
-	if (pevent->cmdlines) {
-		for (i = 0; i < pevent->cmdline_count; i++)
-			free(pevent->cmdlines[i].comm);
-		free(pevent->cmdlines);
+	if (tep->cmdlines) {
+		for (i = 0; i < tep->cmdline_count; i++)
+			free(tep->cmdlines[i].comm);
+		free(tep->cmdlines);
 	}
 
 	while (cmdlist) {
@@ -6860,12 +6859,12 @@ void tep_free(struct tep_handle *pevent)
 		cmdlist = cmdnext;
 	}
 
-	if (pevent->func_map) {
-		for (i = 0; i < (int)pevent->func_count; i++) {
-			free(pevent->func_map[i].func);
-			free(pevent->func_map[i].mod);
+	if (tep->func_map) {
+		for (i = 0; i < (int)tep->func_count; i++) {
+			free(tep->func_map[i].func);
+			free(tep->func_map[i].mod);
 		}
-		free(pevent->func_map);
+		free(tep->func_map);
 	}
 
 	while (funclist) {
@@ -6876,16 +6875,16 @@ void tep_free(struct tep_handle *pevent)
 		funclist = funcnext;
 	}
 
-	while (pevent->func_handlers) {
-		func_handler = pevent->func_handlers;
-		pevent->func_handlers = func_handler->next;
+	while (tep->func_handlers) {
+		func_handler = tep->func_handlers;
+		tep->func_handlers = func_handler->next;
 		free_func_handle(func_handler);
 	}
 
-	if (pevent->printk_map) {
-		for (i = 0; i < (int)pevent->printk_count; i++)
-			free(pevent->printk_map[i].printk);
-		free(pevent->printk_map);
+	if (tep->printk_map) {
+		for (i = 0; i < (int)tep->printk_count; i++)
+			free(tep->printk_map[i].printk);
+		free(tep->printk_map);
 	}
 
 	while (printklist) {
@@ -6895,24 +6894,24 @@ void tep_free(struct tep_handle *pevent)
 		printklist = printknext;
 	}
 
-	for (i = 0; i < pevent->nr_events; i++)
-		tep_free_event(pevent->events[i]);
+	for (i = 0; i < tep->nr_events; i++)
+		tep_free_event(tep->events[i]);
 
-	while (pevent->handlers) {
-		handle = pevent->handlers;
-		pevent->handlers = handle->next;
+	while (tep->handlers) {
+		handle = tep->handlers;
+		tep->handlers = handle->next;
 		free_handler(handle);
 	}
 
-	free(pevent->trace_clock);
-	free(pevent->events);
-	free(pevent->sort_events);
-	free(pevent->func_resolver);
+	free(tep->trace_clock);
+	free(tep->events);
+	free(tep->sort_events);
+	free(tep->func_resolver);
 
-	free(pevent);
+	free(tep);
 }
 
-void tep_unref(struct tep_handle *pevent)
+void tep_unref(struct tep_handle *tep)
 {
-	tep_free(pevent);
+	tep_free(tep);
 }
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 02932d3d2632..77f3308274d1 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -64,8 +64,8 @@ typedef int (*tep_event_handler_func)(struct trace_seq *s,
 				      struct tep_event *event,
 				      void *context);
 
-typedef int (*tep_plugin_load_func)(struct tep_handle *pevent);
-typedef int (*tep_plugin_unload_func)(struct tep_handle *pevent);
+typedef int (*tep_plugin_load_func)(struct tep_handle *tep);
+typedef int (*tep_plugin_unload_func)(struct tep_handle *tep);
 
 struct tep_plugin_option {
 	struct tep_plugin_option	*next;
@@ -85,12 +85,12 @@ struct tep_plugin_option {
  * TEP_PLUGIN_LOADER:  (required)
  *   The function name to initialized the plugin.
  *
- *   int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+ *   int TEP_PLUGIN_LOADER(struct tep_handle *tep)
  *
  * TEP_PLUGIN_UNLOADER:  (optional)
  *   The function called just before unloading
  *
- *   int TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+ *   int TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
  *
  * TEP_PLUGIN_OPTIONS:  (optional)
  *   Plugin options that can be set before loading
@@ -393,9 +393,9 @@ struct tep_plugin_list;
 
 #define INVALID_PLUGIN_LIST_OPTION	((char **)((unsigned long)-1))
 
-struct tep_plugin_list *tep_load_plugins(struct tep_handle *pevent);
+struct tep_plugin_list *tep_load_plugins(struct tep_handle *tep);
 void tep_unload_plugins(struct tep_plugin_list *plugin_list,
-			struct tep_handle *pevent);
+			struct tep_handle *tep);
 char **tep_plugin_list_options(void);
 void tep_plugin_free_options_list(char **list);
 int tep_plugin_add_options(const char *name,
@@ -430,37 +430,37 @@ enum trace_flag_type {
 	TRACE_FLAG_SOFTIRQ		= 0x10,
 };
 
-int tep_set_function_resolver(struct tep_handle *pevent,
+int tep_set_function_resolver(struct tep_handle *tep,
 			      tep_func_resolver_t *func, void *priv);
-void tep_reset_function_resolver(struct tep_handle *pevent);
-int tep_register_comm(struct tep_handle *pevent, const char *comm, int pid);
-int tep_override_comm(struct tep_handle *pevent, const char *comm, int pid);
-int tep_register_trace_clock(struct tep_handle *pevent, const char *trace_clock);
-int tep_register_function(struct tep_handle *pevent, char *name,
+void tep_reset_function_resolver(struct tep_handle *tep);
+int tep_register_comm(struct tep_handle *tep, const char *comm, int pid);
+int tep_override_comm(struct tep_handle *tep, const char *comm, int pid);
+int tep_register_trace_clock(struct tep_handle *tep, const char *trace_clock);
+int tep_register_function(struct tep_handle *tep, char *name,
 			  unsigned long long addr, char *mod);
-int tep_register_print_string(struct tep_handle *pevent, const char *fmt,
+int tep_register_print_string(struct tep_handle *tep, const char *fmt,
 			      unsigned long long addr);
-bool tep_is_pid_registered(struct tep_handle *pevent, int pid);
+bool tep_is_pid_registered(struct tep_handle *tep, int pid);
 
-void tep_print_event_task(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_task(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record);
-void tep_print_event_time(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_time(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record,
 			  bool use_trace_clock);
-void tep_print_event_data(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event_data(struct tep_handle *tep, struct trace_seq *s,
 			  struct tep_event *event,
 			  struct tep_record *record);
-void tep_print_event(struct tep_handle *pevent, struct trace_seq *s,
+void tep_print_event(struct tep_handle *tep, struct trace_seq *s,
 		     struct tep_record *record, bool use_trace_clock);
 
-int tep_parse_header_page(struct tep_handle *pevent, char *buf, unsigned long size,
+int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
 			  int long_size);
 
-enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
+enum tep_errno tep_parse_event(struct tep_handle *tep, const char *buf,
 			       unsigned long size, const char *sys);
-enum tep_errno tep_parse_format(struct tep_handle *pevent,
+enum tep_errno tep_parse_format(struct tep_handle *tep,
 				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
@@ -494,51 +494,51 @@ enum tep_reg_handler {
 	TEP_REGISTER_SUCCESS_OVERWRITE,
 };
 
-int tep_register_event_handler(struct tep_handle *pevent, int id,
+int tep_register_event_handler(struct tep_handle *tep, int id,
 			       const char *sys_name, const char *event_name,
 			       tep_event_handler_func func, void *context);
-int tep_unregister_event_handler(struct tep_handle *pevent, int id,
+int tep_unregister_event_handler(struct tep_handle *tep, int id,
 				 const char *sys_name, const char *event_name,
 				 tep_event_handler_func func, void *context);
-int tep_register_print_function(struct tep_handle *pevent,
+int tep_register_print_function(struct tep_handle *tep,
 				tep_func_handler func,
 				enum tep_func_arg_type ret_type,
 				char *name, ...);
-int tep_unregister_print_function(struct tep_handle *pevent,
+int tep_unregister_print_function(struct tep_handle *tep,
 				  tep_func_handler func, char *name);
 
 struct tep_format_field *tep_find_common_field(struct tep_event *event, const char *name);
 struct tep_format_field *tep_find_field(struct tep_event *event, const char *name);
 struct tep_format_field *tep_find_any_field(struct tep_event *event, const char *name);
 
-const char *tep_find_function(struct tep_handle *pevent, unsigned long long addr);
+const char *tep_find_function(struct tep_handle *tep, unsigned long long addr);
 unsigned long long
-tep_find_function_address(struct tep_handle *pevent, unsigned long long addr);
-unsigned long long tep_read_number(struct tep_handle *pevent, const void *ptr, int size);
+tep_find_function_address(struct tep_handle *tep, unsigned long long addr);
+unsigned long long tep_read_number(struct tep_handle *tep, const void *ptr, int size);
 int tep_read_number_field(struct tep_format_field *field, const void *data,
 			  unsigned long long *value);
 
 struct tep_event *tep_get_first_event(struct tep_handle *tep);
 struct tep_event *tep_get_event(struct tep_handle *tep, int index);
 int tep_get_events_count(struct tep_handle *tep);
-struct tep_event *tep_find_event(struct tep_handle *pevent, int id);
+struct tep_event *tep_find_event(struct tep_handle *tep, int id);
 
 struct tep_event *
-tep_find_event_by_name(struct tep_handle *pevent, const char *sys, const char *name);
+tep_find_event_by_name(struct tep_handle *tep, const char *sys, const char *name);
 struct tep_event *
-tep_find_event_by_record(struct tep_handle *pevent, struct tep_record *record);
+tep_find_event_by_record(struct tep_handle *tep, struct tep_record *record);
 
-void tep_data_latency_format(struct tep_handle *pevent,
+void tep_data_latency_format(struct tep_handle *tep,
 			     struct trace_seq *s, struct tep_record *record);
-int tep_data_type(struct tep_handle *pevent, struct tep_record *rec);
-int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
-int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
-int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec);
-const char *tep_data_comm_from_pid(struct tep_handle *pevent, int pid);
+int tep_data_type(struct tep_handle *tep, struct tep_record *rec);
+int tep_data_pid(struct tep_handle *tep, struct tep_record *rec);
+int tep_data_preempt_count(struct tep_handle *tep, struct tep_record *rec);
+int tep_data_flags(struct tep_handle *tep, struct tep_record *rec);
+const char *tep_data_comm_from_pid(struct tep_handle *tep, int pid);
 struct tep_cmdline;
-struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
+struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *tep, const char *comm,
 					   struct tep_cmdline *next);
-int tep_cmdline_pid(struct tep_handle *pevent, struct tep_cmdline *cmdline);
+int tep_cmdline_pid(struct tep_handle *tep, struct tep_cmdline *cmdline);
 
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
@@ -546,10 +546,10 @@ void tep_print_fields(struct trace_seq *s, void *data,
 		      int size __maybe_unused, struct tep_event *event);
 void tep_event_info(struct trace_seq *s, struct tep_event *event,
 		    struct tep_record *record);
-int tep_strerror(struct tep_handle *pevent, enum tep_errno errnum,
+int tep_strerror(struct tep_handle *tep, enum tep_errno errnum,
 		 char *buf, size_t buflen);
 
-struct tep_event **tep_list_events(struct tep_handle *pevent, enum tep_event_sort_type);
+struct tep_event **tep_list_events(struct tep_handle *tep, enum tep_event_sort_type);
 struct tep_format_field **tep_event_common_fields(struct tep_event *event);
 struct tep_format_field **tep_event_fields(struct tep_event *event);
 
@@ -557,28 +557,28 @@ enum tep_endian {
         TEP_LITTLE_ENDIAN = 0,
         TEP_BIG_ENDIAN
 };
-int tep_get_cpus(struct tep_handle *pevent);
-void tep_set_cpus(struct tep_handle *pevent, int cpus);
-int tep_get_long_size(struct tep_handle *pevent);
-void tep_set_long_size(struct tep_handle *pevent, int long_size);
-int tep_get_page_size(struct tep_handle *pevent);
-void tep_set_page_size(struct tep_handle *pevent, int _page_size);
-bool tep_is_file_bigendian(struct tep_handle *pevent);
-void tep_set_file_bigendian(struct tep_handle *pevent, enum tep_endian endian);
-bool tep_is_local_bigendian(struct tep_handle *pevent);
-void tep_set_local_bigendian(struct tep_handle *pevent, enum tep_endian endian);
-bool tep_is_latency_format(struct tep_handle *pevent);
-void tep_set_latency_format(struct tep_handle *pevent, int lat);
-int tep_get_header_page_size(struct tep_handle *pevent);
+int tep_get_cpus(struct tep_handle *tep);
+void tep_set_cpus(struct tep_handle *tep, int cpus);
+int tep_get_long_size(struct tep_handle *tep);
+void tep_set_long_size(struct tep_handle *tep, int long_size);
+int tep_get_page_size(struct tep_handle *tep);
+void tep_set_page_size(struct tep_handle *tep, int _page_size);
+bool tep_is_file_bigendian(struct tep_handle *tep);
+void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian);
+bool tep_is_local_bigendian(struct tep_handle *tep);
+void tep_set_local_bigendian(struct tep_handle *tep, enum tep_endian endian);
+bool tep_is_latency_format(struct tep_handle *tep);
+void tep_set_latency_format(struct tep_handle *tep, int lat);
+int tep_get_header_page_size(struct tep_handle *tep);
 int tep_get_header_timestamp_size(struct tep_handle *tep);
 bool tep_is_old_format(struct tep_handle *tep);
 void tep_set_print_raw(struct tep_handle *tep, int print_raw);
 void tep_set_test_filters(struct tep_handle *tep, int test_filters);
 
 struct tep_handle *tep_alloc(void);
-void tep_free(struct tep_handle *pevent);
-void tep_ref(struct tep_handle *pevent);
-void tep_unref(struct tep_handle *pevent);
+void tep_free(struct tep_handle *tep);
+void tep_ref(struct tep_handle *tep);
+void tep_unref(struct tep_handle *tep);
 int tep_get_ref(struct tep_handle *tep);
 
 /* access to the internal parser */
@@ -590,8 +590,8 @@ const char *tep_get_input_buf(void);
 unsigned long long tep_get_input_buf_ptr(void);
 
 /* for debugging */
-void tep_print_funcs(struct tep_handle *pevent);
-void tep_print_printk(struct tep_handle *pevent);
+void tep_print_funcs(struct tep_handle *tep);
+void tep_print_printk(struct tep_handle *tep);
 
 /* ----------------------- filtering ----------------------- */
 
@@ -724,7 +724,7 @@ struct tep_event_filter {
 	char			error_buffer[TEP_FILTER_ERROR_BUFSZ];
 };
 
-struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent);
+struct tep_event_filter *tep_filter_alloc(struct tep_handle *tep);
 
 /* for backward compatibility */
 #define FILTER_NONE		TEP_ERRNO__NO_FILTER
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index e74f16c88398..d0488de0174a 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -419,16 +419,16 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 }
 
 struct tep_plugin_list*
-tep_load_plugins(struct tep_handle *pevent)
+tep_load_plugins(struct tep_handle *tep)
 {
 	struct tep_plugin_list *list = NULL;
 
-	load_plugins(pevent, ".so", load_plugin, &list);
+	load_plugins(tep, ".so", load_plugin, &list);
 	return list;
 }
 
 void
-tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *pevent)
+tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *tep)
 {
 	tep_plugin_unload_func func;
 	struct tep_plugin_list *list;
@@ -438,7 +438,7 @@ tep_unload_plugins(struct tep_plugin_list *plugin_list, struct tep_handle *peven
 		plugin_list = list->next;
 		func = dlsym(list->handle, TEP_PLUGIN_UNLOADER_NAME);
 		if (func)
-			func(pevent);
+			func(tep);
 		dlclose(list->handle);
 		free(list->name);
 		free(list);
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 4ffd8b25a852..ce437ac286e9 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -164,9 +164,9 @@ add_filter_type(struct tep_event_filter *filter, int id)
 
 /**
  * tep_filter_alloc - create a new event filter
- * @pevent: The pevent that this filter is associated with
+ * @tep: The tep that this filter is associated with
  */
-struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent)
+struct tep_event_filter *tep_filter_alloc(struct tep_handle *tep)
 {
 	struct tep_event_filter *filter;
 
@@ -175,8 +175,8 @@ struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent)
 		return NULL;
 
 	memset(filter, 0, sizeof(*filter));
-	filter->pevent = pevent;
-	tep_ref(pevent);
+	filter->pevent = tep;
+	tep_ref(tep);
 
 	return filter;
 }
diff --git a/tools/lib/traceevent/plugin_cfg80211.c b/tools/lib/traceevent/plugin_cfg80211.c
index a51b366f47da..3d43b56a6c98 100644
--- a/tools/lib/traceevent/plugin_cfg80211.c
+++ b/tools/lib/traceevent/plugin_cfg80211.c
@@ -25,9 +25,9 @@ process___le16_to_cpup(struct trace_seq *s, unsigned long long *args)
 	return val ? (long long) le16toh(*val) : 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process___le16_to_cpup,
 				    TEP_FUNC_ARG_INT,
 				    "__le16_to_cpup",
@@ -36,8 +36,8 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_print_function(pevent, process___le16_to_cpup,
+	tep_unregister_print_function(tep, process___le16_to_cpup,
 				      "__le16_to_cpup");
 }
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index a73eca34a8f9..e93f33bd705f 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -164,9 +164,9 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_event_handler(pevent, -1, "ftrace", "function",
+	tep_register_event_handler(tep, -1, "ftrace", "function",
 				   function_handler, NULL);
 
 	tep_plugin_add_options("ftrace", plugin_options);
@@ -174,11 +174,11 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
 	int i, x;
 
-	tep_unregister_event_handler(pevent, -1, "ftrace", "function",
+	tep_unregister_event_handler(tep, -1, "ftrace", "function",
 				     function_handler, NULL);
 
 	for (i = 0; i <= cpus; i++) {
diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
index 5db5e401275f..bb434e0ed03a 100644
--- a/tools/lib/traceevent/plugin_hrtimer.c
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -67,23 +67,23 @@ static int timer_start_handler(struct trace_seq *s,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_event_handler(pevent, -1,
+	tep_register_event_handler(tep, -1,
 				   "timer", "hrtimer_expire_entry",
 				   timer_expire_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "timer", "hrtimer_start",
+	tep_register_event_handler(tep, -1, "timer", "hrtimer_start",
 				   timer_start_handler, NULL);
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_event_handler(pevent, -1,
+	tep_unregister_event_handler(tep, -1,
 				     "timer", "hrtimer_expire_entry",
 				     timer_expire_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "timer", "hrtimer_start",
+	tep_unregister_event_handler(tep, -1, "timer", "hrtimer_start",
 				     timer_start_handler, NULL);
 }
diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
index a5e34135dd6a..04fc125f38cb 100644
--- a/tools/lib/traceevent/plugin_jbd2.c
+++ b/tools/lib/traceevent/plugin_jbd2.c
@@ -48,16 +48,16 @@ process_jiffies_to_msecs(struct trace_seq *s, unsigned long long *args)
 	return jiffies;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process_jbd2_dev_to_name,
 				    TEP_FUNC_ARG_STRING,
 				    "jbd2_dev_to_name",
 				    TEP_FUNC_ARG_INT,
 				    TEP_FUNC_ARG_VOID);
 
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process_jiffies_to_msecs,
 				    TEP_FUNC_ARG_LONG,
 				    "jiffies_to_msecs",
@@ -66,11 +66,11 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_print_function(pevent, process_jbd2_dev_to_name,
+	tep_unregister_print_function(tep, process_jbd2_dev_to_name,
 				      "jbd2_dev_to_name");
 
-	tep_unregister_print_function(pevent, process_jiffies_to_msecs,
+	tep_unregister_print_function(tep, process_jiffies_to_msecs,
 				      "jiffies_to_msecs");
 }
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
index 0e3c601f9ed1..c09bafdd8377 100644
--- a/tools/lib/traceevent/plugin_kmem.c
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -49,47 +49,47 @@ static int call_site_handler(struct trace_seq *s, struct tep_record *record,
 	return 1;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_event_handler(pevent, -1, "kmem", "kfree",
+	tep_register_event_handler(tep, -1, "kmem", "kfree",
 				   call_site_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kmem", "kmalloc",
+	tep_register_event_handler(tep, -1, "kmem", "kmalloc",
 				   call_site_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kmem", "kmalloc_node",
+	tep_register_event_handler(tep, -1, "kmem", "kmalloc_node",
 				   call_site_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
+	tep_register_event_handler(tep, -1, "kmem", "kmem_cache_alloc",
 				   call_site_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kmem",
+	tep_register_event_handler(tep, -1, "kmem",
 				   "kmem_cache_alloc_node",
 				   call_site_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kmem", "kmem_cache_free",
+	tep_register_event_handler(tep, -1, "kmem", "kmem_cache_free",
 				   call_site_handler, NULL);
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_event_handler(pevent, -1, "kmem", "kfree",
+	tep_unregister_event_handler(tep, -1, "kmem", "kfree",
 				     call_site_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kmem", "kmalloc",
+	tep_unregister_event_handler(tep, -1, "kmem", "kmalloc",
 				     call_site_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kmem", "kmalloc_node",
+	tep_unregister_event_handler(tep, -1, "kmem", "kmalloc_node",
 				     call_site_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
+	tep_unregister_event_handler(tep, -1, "kmem", "kmem_cache_alloc",
 				     call_site_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kmem",
+	tep_unregister_event_handler(tep, -1, "kmem",
 				     "kmem_cache_alloc_node",
 				     call_site_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kmem", "kmem_cache_free",
+	tep_unregister_event_handler(tep, -1, "kmem", "kmem_cache_free",
 				     call_site_handler, NULL);
 }
diff --git a/tools/lib/traceevent/plugin_kvm.c b/tools/lib/traceevent/plugin_kvm.c
index 688e5d97d7a7..472298c2b531 100644
--- a/tools/lib/traceevent/plugin_kvm.c
+++ b/tools/lib/traceevent/plugin_kvm.c
@@ -445,40 +445,40 @@ process_is_writable_pte(struct trace_seq *s, unsigned long long *args)
 	return pte & PT_WRITABLE_MASK;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
 	init_disassembler();
 
-	tep_register_event_handler(pevent, -1, "kvm", "kvm_exit",
+	tep_register_event_handler(tep, -1, "kvm", "kvm_exit",
 				   kvm_exit_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
+	tep_register_event_handler(tep, -1, "kvm", "kvm_emulate_insn",
 				   kvm_emulate_insn_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+	tep_register_event_handler(tep, -1, "kvm", "kvm_nested_vmexit",
 				   kvm_nested_vmexit_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+	tep_register_event_handler(tep, -1, "kvm", "kvm_nested_vmexit_inject",
 				   kvm_nested_vmexit_inject_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
+	tep_register_event_handler(tep, -1, "kvmmmu", "kvm_mmu_get_page",
 				   kvm_mmu_get_page_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
+	tep_register_event_handler(tep, -1, "kvmmmu", "kvm_mmu_sync_page",
 				   kvm_mmu_print_role, NULL);
 
-	tep_register_event_handler(pevent, -1,
+	tep_register_event_handler(tep, -1,
 				   "kvmmmu", "kvm_mmu_unsync_page",
 				   kvm_mmu_print_role, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
+	tep_register_event_handler(tep, -1, "kvmmmu", "kvm_mmu_zap_page",
 				   kvm_mmu_print_role, NULL);
 
-	tep_register_event_handler(pevent, -1, "kvmmmu",
+	tep_register_event_handler(tep, -1, "kvmmmu",
 			"kvm_mmu_prepare_zap_page", kvm_mmu_print_role,
 			NULL);
 
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process_is_writable_pte,
 				    TEP_FUNC_ARG_INT,
 				    "is_writable_pte",
@@ -487,37 +487,37 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_exit",
+	tep_unregister_event_handler(tep, -1, "kvm", "kvm_exit",
 				     kvm_exit_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_emulate_insn",
+	tep_unregister_event_handler(tep, -1, "kvm", "kvm_emulate_insn",
 				     kvm_emulate_insn_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit",
+	tep_unregister_event_handler(tep, -1, "kvm", "kvm_nested_vmexit",
 				     kvm_nested_vmexit_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvm", "kvm_nested_vmexit_inject",
+	tep_unregister_event_handler(tep, -1, "kvm", "kvm_nested_vmexit_inject",
 				     kvm_nested_vmexit_inject_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_get_page",
+	tep_unregister_event_handler(tep, -1, "kvmmmu", "kvm_mmu_get_page",
 				     kvm_mmu_get_page_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_sync_page",
+	tep_unregister_event_handler(tep, -1, "kvmmmu", "kvm_mmu_sync_page",
 				     kvm_mmu_print_role, NULL);
 
-	tep_unregister_event_handler(pevent, -1,
+	tep_unregister_event_handler(tep, -1,
 				     "kvmmmu", "kvm_mmu_unsync_page",
 				     kvm_mmu_print_role, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvmmmu", "kvm_mmu_zap_page",
+	tep_unregister_event_handler(tep, -1, "kvmmmu", "kvm_mmu_zap_page",
 				     kvm_mmu_print_role, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "kvmmmu",
+	tep_unregister_event_handler(tep, -1, "kvmmmu",
 			"kvm_mmu_prepare_zap_page", kvm_mmu_print_role,
 			NULL);
 
-	tep_unregister_print_function(pevent, process_is_writable_pte,
+	tep_unregister_print_function(tep, process_is_writable_pte,
 				      "is_writable_pte");
 }
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
index e38b9477aad2..884303c26b5c 100644
--- a/tools/lib/traceevent/plugin_mac80211.c
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -87,17 +87,17 @@ static int drv_bss_info_changed(struct trace_seq *s,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_event_handler(pevent, -1, "mac80211",
+	tep_register_event_handler(tep, -1, "mac80211",
 				   "drv_bss_info_changed",
 				   drv_bss_info_changed, NULL);
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_event_handler(pevent, -1, "mac80211",
+	tep_unregister_event_handler(tep, -1, "mac80211",
 				     "drv_bss_info_changed",
 				     drv_bss_info_changed, NULL);
 }
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
index 834c9e378ff8..701c22913cf8 100644
--- a/tools/lib/traceevent/plugin_sched_switch.c
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -135,27 +135,27 @@ static int sched_switch_handler(struct trace_seq *s,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_event_handler(pevent, -1, "sched", "sched_switch",
+	tep_register_event_handler(tep, -1, "sched", "sched_switch",
 				   sched_switch_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "sched", "sched_wakeup",
+	tep_register_event_handler(tep, -1, "sched", "sched_wakeup",
 				   sched_wakeup_handler, NULL);
 
-	tep_register_event_handler(pevent, -1, "sched", "sched_wakeup_new",
+	tep_register_event_handler(tep, -1, "sched", "sched_wakeup_new",
 				   sched_wakeup_handler, NULL);
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_event_handler(pevent, -1, "sched", "sched_switch",
+	tep_unregister_event_handler(tep, -1, "sched", "sched_switch",
 				     sched_switch_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "sched", "sched_wakeup",
+	tep_unregister_event_handler(tep, -1, "sched", "sched_wakeup",
 				     sched_wakeup_handler, NULL);
 
-	tep_unregister_event_handler(pevent, -1, "sched", "sched_wakeup_new",
+	tep_unregister_event_handler(tep, -1, "sched", "sched_wakeup_new",
 				     sched_wakeup_handler, NULL);
 }
diff --git a/tools/lib/traceevent/plugin_scsi.c b/tools/lib/traceevent/plugin_scsi.c
index 4eba25cc1431..5d0387a4b65a 100644
--- a/tools/lib/traceevent/plugin_scsi.c
+++ b/tools/lib/traceevent/plugin_scsi.c
@@ -414,9 +414,9 @@ unsigned long long process_scsi_trace_parse_cdb(struct trace_seq *s,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process_scsi_trace_parse_cdb,
 				    TEP_FUNC_ARG_STRING,
 				    "scsi_trace_parse_cdb",
@@ -427,8 +427,8 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_print_function(pevent, process_scsi_trace_parse_cdb,
+	tep_unregister_print_function(tep, process_scsi_trace_parse_cdb,
 				      "scsi_trace_parse_cdb");
 }
diff --git a/tools/lib/traceevent/plugin_xen.c b/tools/lib/traceevent/plugin_xen.c
index bc0496e4c296..993b208d0323 100644
--- a/tools/lib/traceevent/plugin_xen.c
+++ b/tools/lib/traceevent/plugin_xen.c
@@ -120,9 +120,9 @@ unsigned long long process_xen_hypercall_name(struct trace_seq *s,
 	return 0;
 }
 
-int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+int TEP_PLUGIN_LOADER(struct tep_handle *tep)
 {
-	tep_register_print_function(pevent,
+	tep_register_print_function(tep,
 				    process_xen_hypercall_name,
 				    TEP_FUNC_ARG_STRING,
 				    "xen_hypercall_name",
@@ -131,8 +131,8 @@ int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
 	return 0;
 }
 
-void TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+void TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
 {
-	tep_unregister_print_function(pevent, process_xen_hypercall_name,
+	tep_unregister_print_function(tep, process_xen_hypercall_name,
 				      "xen_hypercall_name");
 }
-- 
2.20.1

