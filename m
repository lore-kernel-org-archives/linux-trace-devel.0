Return-Path: <SRS0=ULQB=4F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F145C34022
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 17:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01E9220725
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 17:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tbKu3sNf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgBQRkP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 12:40:15 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40373 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgBQRkP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 12:40:15 -0500
Received: by mail-lf1-f68.google.com with SMTP id c23so12473728lfi.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Feb 2020 09:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lHEhdxGh6yyx/7gr+zMvJM3a8/AXJTsE1hi5ltFOxiM=;
        b=tbKu3sNfixEPRvWrQHId7hLx9Se3xNOinmEzLW5VSxndC3Tdvhjbo1gATT1MS8Yh8F
         eF0HxV2mYyu5Bv5z3jOP7oJD4vKsNXgZ55FKp6/PJVHK5tvfJ2U0C6NmfqV1JXsdLzui
         KQaKJrte+dikbYlZiHbSNQyYPTou/n8qaxmSNKlHlV9AGJ2RkfkXbJpHKb/hCZQHVU1V
         buvFFED7PfVMR0JNIAFcM3buouufMXeIHUsptM4jkMmHpYtLznXEe6c3WRZ0M8EIqBZE
         /8qLtOs+zSXRngS7Zqc6u3H/o3qSHBmTJGMZbIpLgKKK/KracB4lM0FDMHXUnSHPqWDf
         fPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lHEhdxGh6yyx/7gr+zMvJM3a8/AXJTsE1hi5ltFOxiM=;
        b=hhbGEXjfkiIbt54KF73aU3zA4EUvA6H6jRc/vYM4RmVbDT+YCELNnCQWt4xbR1F2z+
         +4fYtC/HLaqnMloO+kzatBOXGuuCb1e0csQZXN7R90KtDKwVbrgAkmJPfLNzXKpjc4Q3
         2F3AXwzDfMKKJ9rF/FYvpBtWgE/BH9gYBHrfq5MIqcTwLg0K3sfcpkvMFBEKJZbsnDRd
         Rj6DBubbZWxzhqazpA4en/rhgeRonMRQGniwwXHevx8X1rsEckuTFlT3E6uV/adNqb+m
         e3ZYrj6qgE7K3zey3T6EQ/pghMqs3dPNfPdyVS/va16ZMfFnfp9A8in247p1a//RGgfJ
         VNOg==
X-Gm-Message-State: APjAAAVJtF4tLHJE7b6O4HeRKTBwo5R2VvXj66ndUkD7kS19CBy0iCzX
        JHjH9je7ZYywdAumeX0PcRgBnW+u1fc=
X-Google-Smtp-Source: APXvYqyuSnbxJP+ACISP2x4QIAG1eYxaMNBLNMEXSW38ZJxI9MCD+3mPXvfomevgucY9h4gWBy0OnQ==
X-Received: by 2002:ac2:57cc:: with SMTP id k12mr8500004lfo.36.1581961209141;
        Mon, 17 Feb 2020 09:40:09 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e8sm933508ljb.45.2020.02.17.09.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 09:40:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/4] trace-cmd: Add "--sql" option to trace-cmd start and record sub commands
Date:   Mon, 17 Feb 2020 19:39:59 +0200
Message-Id: <20200217173959.385278-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217173959.385278-1-tz.stoyanov@gmail.com>
References: <20200217173959.385278-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Configuration of complex ftrace histograms could be hard, using the existing ftrace interface.
The "--sql" option is implemented to simplify this task. It uses a sql-like syntax to define
the histograms and generates necessary ftrace syntetic events and triggers. Each ftrace event
represents a sql tible, while the fields of this event are rows in the table.
Additional option "-V" is added to trace-cmd start and report sub commands, which can be used
to dump the auto generated ftrace synthetic events and triggers configuration.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-record.1.txt |   37 +
 Makefile                             |    1 +
 tracecmd/Makefile                    |   12 +-
 tracecmd/include/trace-local.h       |    4 +
 tracecmd/sqlparser/Makefile          |   52 +
 tracecmd/sqlparser/sqlhist-api.h     |   29 +
 tracecmd/sqlparser/sqlhist-parse.c   | 1454 ++++++++++++++++++++++++++
 tracecmd/sqlparser/sqlhist.h         |   34 +
 tracecmd/sqlparser/sqlhist.l         |   59 ++
 tracecmd/sqlparser/sqlhist.y         |  175 ++++
 tracecmd/trace-record.c              |  114 +-
 tracecmd/trace-usage.c               |    2 +
 12 files changed, 1970 insertions(+), 3 deletions(-)
 create mode 100644 tracecmd/sqlparser/Makefile
 create mode 100644 tracecmd/sqlparser/sqlhist-api.h
 create mode 100644 tracecmd/sqlparser/sqlhist-parse.c
 create mode 100644 tracecmd/sqlparser/sqlhist.h
 create mode 100644 tracecmd/sqlparser/sqlhist.l
 create mode 100644 tracecmd/sqlparser/sqlhist.y

diff --git a/Documentation/trace-cmd-record.1.txt b/Documentation/trace-cmd-record.1.txt
index 0d75e43..fd482e1 100644
--- a/Documentation/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd-record.1.txt
@@ -343,6 +343,43 @@ OPTIONS
     executed will not be changed. This is useful if you want to monitor the
     output of the command being executed, but not see the output from trace-cmd.
 
+*--sql*::
+    Generate necessary ftrace syntetic events and triggers, based on the given
+    sql query. A simplified sql syntax can be used to describe ftrace histograms.
+    Each ftrace event represents a sql tible, while the fields of this event are
+    rows in the table. A sql aliases can be used to define synthetic events and
+    simplify the sql statement.
+
+    Example 1:
+	--sql 'select pid as key1, common_pid from sched_waking'
+    Configures a histogram, where the key is the pid from sched/sched_waking
+    event and the value is the common_pid filed from the same event.
+    The auto generated ftrace config, written in sched/sched_waking/trigger file
+    is:
+	hist:keys=pid:values=common_pid
+
+    Example 2:
+	--sql '(select start.common_timestamp as start_time, end.common_timestamp
+		as end_time, start.pid, (end_time - start_time) as delta
+		from sched_waking as start join sched_switch as end on
+		start.pid = end.next_pid) as first'
+    A more complex histogram example, using a synthetic event. The synthetic
+    event "first" is configured in synthetic_events file:
+	first u64 start_time u64 end_time pid_t pid u64 delta
+    After that, a histogram trigger is configured in sched/sched_waking/trigger
+    file:
+	hist:keys=pid:start_time=common_timestamp,__arg0__=pid
+    A second histogram trigger is configured in sched/sched_switch/trigger file:
+	hist:keys=next_pid:__arg1__=$start_time,__arg2__=$__arg0__,
+	    delta=common_timestamp-$__arg1__:
+	    onmatch(sched.sched_waking).trace(first,$__arg1__,common_timestamp,$__arg2__,$delta)
+    The "onmatch" histogram action is used to trigger the synthetic event "first"
+    with interested parameters, when there is a match between next_pid and pid
+    fields from both events.
+
+*-V*::
+    Dump ftrace configuration, auto generated by the *--sql* option.
+
 EXAMPLES
 --------
 
diff --git a/Makefile b/Makefile
index d75f143..8ca87cf 100644
--- a/Makefile
+++ b/Makefile
@@ -225,6 +225,7 @@ INCLUDES += -I$(src)/lib/traceevent/include
 INCLUDES += -I$(src)/lib/trace-cmd/include
 INCLUDES += -I$(src)/lib/tracefs/include
 INCLUDES += -I$(src)/tracecmd/include
+INCLUDES += -I$(src)/tracecmd/sqlparser
 INCLUDES += -I$(obj)/tracecmd/include
 
 include $(src)/features.mk
diff --git a/tracecmd/Makefile b/tracecmd/Makefile
index 0976341..678dab3 100644
--- a/tracecmd/Makefile
+++ b/tracecmd/Makefile
@@ -5,6 +5,9 @@ EXTRAVERSION := $(TC_EXTRAVERSION)
 
 bdir:=$(obj)/tracecmd
 
+sqldir:=$(bdir)/sqlparser
+LIBSQLPARSE = $(sqldir)/libsqlparse.a
+
 TC_VERSION := $(bdir)/include/tc_version.h
 TARGETS = $(bdir)/trace-cmd $(TC_VERSION)
 
@@ -42,6 +45,8 @@ ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
 all_objs := $(sort $(ALL_OBJS))
 all_deps := $(all_objs:$(bdir)/%.o=$(bdir)/.%.d)
 
+CFLAGS += -I$(sqldir)
+
 CONFIG_INCLUDES =
 CONFIG_LIBS	= -lrt
 CONFIG_FLAGS	=
@@ -63,7 +68,8 @@ $(all_objs): | $(bdir)
 $(bdir)/trace-cmd: $(ALL_OBJS)
 	$(Q)$(do_app_build)
 
-$(bdir)/trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC) $(LIBTRACEFS_STATIC)
+$(bdir)/trace-cmd: $(LIBTRACECMD_STATIC) $(LIBTRACEEVENT_STATIC)\
+		   $(LIBTRACEFS_STATIC)  $(LIBSQLPARSE)
 
 $(bdir)/%.o: %.c
 	$(Q)$(call do_compile)
@@ -81,8 +87,12 @@ ifneq ($(dep_includes),)
   include $(dep_includes)
 endif
 
+$(LIBSQLPARSE): force
+	$(Q)$(MAKE) -C $(sqldir) $@
+
 clean:
 	$(RM) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d $(TARGETS)
+	$(Q)$(MAKE) -C $(sqldir) $@
 
 force:
 .PHONY: clean
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 7a0804e..108b9a0 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -11,6 +11,7 @@
 
 #include "trace-cmd.h"
 #include "event-utils.h"
+#include "sqlhist-api.h"
 
 #define TRACE_AGENT_DEFAULT_PORT	823
 
@@ -213,6 +214,9 @@ struct buffer_instance {
 
 	char			*max_graph_depth;
 
+	struct sqlhist_trigger	*auto_triggers;
+	struct sqlhist_synth_event *synth_events;
+
 	int			flags;
 	int			tracing_on_init_val;
 	int			tracing_on_fd;
diff --git a/tracecmd/sqlparser/Makefile b/tracecmd/sqlparser/Makefile
new file mode 100644
index 0000000..f648b18
--- /dev/null
+++ b/tracecmd/sqlparser/Makefile
@@ -0,0 +1,52 @@
+
+include $(src)/scripts/utils.mk
+
+bdir:=$(obj)/tracecmd/sqlparser
+
+TARGET = $(bdir)/libsqlparse.a
+
+all: $(TARGET)
+
+FLEX ?= flex
+BISON ?= bison
+
+OBJS =
+OBJS += sqlhist-parse.o
+OBJS += lex.yy.o
+OBJS += sqlhist.tab.o
+
+OBJS := $(OBJS:%.o=$(bdir)/%.o)
+DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
+
+$(bdir):
+	@mkdir -p $(bdir)
+
+$(OBJS): | $(bdir)
+$(DEPS): | $(bdir)
+
+$(TARGET): $(OBJS)
+	$(call do_build_static_lib)
+
+sqlhist-parse.c: lex.yy.c sqlhist.tab.c
+
+$(bdir)/%.o: %.c
+	$(Q)$(call do_compile)
+
+$(DEPS): $(bdir)/.%.d: %.c
+	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
+
+$(OBJS): $(bdir)/%.o : $(bdir)/.%.d
+
+
+lex.yy.c: sqlhist.l
+	$(Q)$(FLEX) $^
+
+sqlhist.tab.c: sqlhist.y
+	$(Q)$(BISON) -d -o $@ $^
+
+clean:
+	$(RM) $(bdir)/*.o $(bdir)/*.a $(bdir)/.*.d
+	$(RM) lex.yy.c *~ sqlhist.output sqlhist.tab.[ch]
+
+PHONY += force
+force:
\ No newline at end of file
diff --git a/tracecmd/sqlparser/sqlhist-api.h b/tracecmd/sqlparser/sqlhist-api.h
new file mode 100644
index 0000000..a92cbb1
--- /dev/null
+++ b/tracecmd/sqlparser/sqlhist-api.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: LGPL-2.0 */
+/*
+ * Copyright (C) 2020 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+#ifndef __SQLHIST_API_H
+#define __SQLHIST_API_H
+
+struct sqlhist_trigger {
+	struct sqlhist_trigger	*next;
+	char			*system;
+	char			*event;
+	char			*config;
+};
+
+struct sqlhist_synth_event {
+	struct sqlhist_synth_event	*next;
+	char				*name;
+	char				*config;
+};
+
+int sqlhist_parse(char *buff, size_t buff_size,
+		  struct sqlhist_trigger **triggers,
+		  struct sqlhist_synth_event **synt_events);
+
+void sqlhist_trigger_free(struct sqlhist_trigger *list);
+void sqlhist_synth_event_free(struct sqlhist_synth_event *list);
+
+#endif /* __SQLHIST_API_H */
diff --git a/tracecmd/sqlparser/sqlhist-parse.c b/tracecmd/sqlparser/sqlhist-parse.c
new file mode 100644
index 0000000..72e148d
--- /dev/null
+++ b/tracecmd/sqlparser/sqlhist-parse.c
@@ -0,0 +1,1454 @@
+// SPDX-License-Identifier: LGPL-2.0
+/*
+ * Copyright (C) 2020 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <unistd.h>
+
+#include "trace-seq.h"
+#include "trace-local.h"
+#include "sqlhist.h"
+
+#define SQL_PARSE_DEBUG	0
+
+/*
+ *  Ideally, we will conevert:
+ *
+ * trace-cmd start						\
+ *    --sql '(select start.common_timestamp as start_time,
+ *                    end.common_timestamp as end_time, start.pid,
+ *                   (start_time - end_time) as delta
+ *            from sched_waking as start
+ *            join sched_switch as end
+ *              on start.pid = end.next_pid) as first'
+ *
+ * to this:
+ *
+ * # echo 'first u64 start_time u64 end_time pid_t pid u64 delta' >> synthetic_events
+ * # echo 'hist:keys=pid:start=common_timestamp' >
+ *                      events/sched/sched_waking/trigger
+ * # echo 'hist:keys=next_pid:start2=$start,delta=common_timestamp-$start:onmatch(sched.sched_waking).trace(first,$start2,common_timestamp,next_pid,$delta)' >
+ *                       events/sched/sched_switch/trigger
+ */
+
+#define HASH_BITS 10
+
+struct str_hash {
+	struct str_hash		*next;
+	char			*str;
+};
+
+static struct str_hash *str_hash[1 << HASH_BITS];
+
+enum label_type {
+	LABEL_STRING,
+	LABEL_EXPR,
+};
+
+struct label_map {
+	struct label_map	*next;
+	enum label_type		type;
+	char			*label;
+	void			*value;
+};
+
+struct match_map {
+	struct match_map	*next;
+	const char		*A;
+	const char		*B;
+};
+
+struct selection {
+	struct selection	*next;
+	const char		*name;
+	void			*item;
+};
+
+enum expr_type {
+	EXPR_FIELD,
+	EXPR_PLUS,
+	EXPR_MINUS,
+	EXPR_MULT,
+	EXPR_DIVID,
+};
+
+struct sql_table;
+
+struct expression {
+	enum expr_type		type;
+	void			*A;
+	void			*B;
+	const char		*name;
+	struct sql_table	*table;
+};
+
+struct table_map {
+	struct table_map	*next;
+	char			*name;
+	struct sql_table	*table;
+};
+
+struct sql_table {
+	char			*name;
+	struct sql_table	*parent;
+	struct sql_table	*child;
+	struct label_map	*labels;
+	struct match_map	*matches;
+	struct table_map	*tables;
+	struct selection	*selections;
+	struct selection	**next_selection;
+	const char		*from;
+	const char		*to;
+};
+
+static struct sql_table *curr_table;
+static struct sql_table *top_table;
+static struct table_map *table_list;
+
+static int parse_error;
+
+static struct tep_handle *tep;
+
+static int print_type(struct trace_seq *s, struct expression *e);
+
+static int no_table(void)
+{
+	if (curr_table)
+		return 0;
+#if SQL_PARSE_DEBUG
+	{
+		static int once;
+
+		if (!once++)
+			printf("No table?\n");
+	}
+#endif
+	return 1;
+}
+
+void table_start(void)
+{
+	struct sql_table *table;
+
+	table = calloc(1, sizeof(*table));
+	if (!table) {
+		parse_error++;
+		return;
+	}
+
+	table->next_selection = &table->selections;
+
+	table->parent = curr_table;
+	if (curr_table)
+		curr_table->child = table;
+	else
+		top_table = table;
+
+	curr_table = table;
+}
+
+void add_from(void *item)
+{
+	curr_table->from = show_expr(item);
+}
+
+void add_to(void *item)
+{
+	curr_table->to = show_expr(item);
+}
+
+static void add_table(const char *label)
+{
+	struct table_map *tmap;
+
+	if (no_table())
+		return;
+
+	tmap = malloc(sizeof(*tmap));
+	if (!tmap) {
+		parse_error++;
+		return;
+	}
+
+	tmap->table = curr_table;
+	tmap->name = store_str(label);
+
+	tmap->next = table_list;
+	table_list = tmap;
+}
+
+static struct sql_table *find_table(const char *name)
+{
+	struct table_map *tmap;
+
+	for (tmap = table_list; tmap; tmap = tmap->next)
+		if (strcmp(tmap->name, name) == 0)
+			return tmap->table;
+	return NULL;
+}
+
+void table_end(const char *name)
+{
+	static int anony_cnt;
+	char *tname;
+
+	if (!name)
+		tname = store_printf("Anonymous%d", anony_cnt++);
+	else
+		tname = store_str(name);
+
+	add_table(tname);
+
+	curr_table->name = tname;
+	curr_table = curr_table->parent;
+
+}
+
+void from_table_end(const char *name)
+{
+	if (curr_table->parent)
+		curr_table->parent->from = store_str(name);
+	table_end(name);
+}
+
+/* Just a histogram table */
+void simple_table_end(void)
+{
+}
+
+static void insert_label(const char *label, void *val, enum label_type type)
+{
+	struct label_map *lmap;
+	struct sql_table *table = curr_table;
+
+	if (!table)
+		table = top_table;
+
+	if (!table) {
+		no_table();
+		return;
+	}
+
+	lmap = malloc(sizeof(*lmap));
+	if (!lmap) {
+		parse_error++;
+		return;
+	}
+	lmap->label = store_str(label);
+	lmap->value = val;
+	lmap->type = type;
+
+	lmap->next = table->labels;
+	table->labels = lmap;
+}
+
+void add_label(const char *label, const char *val)
+{
+	insert_label(label, store_str(val), LABEL_STRING);
+}
+
+void add_match(const char *A, const char *B)
+{
+	struct match_map *map;
+
+	if (no_table())
+		return;
+
+	map = malloc(sizeof(*map));
+	if (!map) {
+		parse_error++;
+		return;
+	}
+	map->A = store_str(A);
+	map->B = store_str(B);
+
+	map->next = curr_table->matches;
+	curr_table->matches = map;
+}
+
+void add_selection(void *item)
+{
+	struct selection *selection;
+	struct expression *e = item;
+
+	if (no_table())
+		return;
+
+	selection = malloc(sizeof(*selection));
+	if (!selection) {
+		parse_error++;
+		return;
+	}
+	selection->item = e;
+	selection->name = e->name;
+	selection->next = NULL;
+	*curr_table->next_selection = selection;
+	curr_table->next_selection = &selection->next;
+}
+
+static char *expr_op_connect(void *A, void *B, char *op,
+			     const char *(*show)(void *A))
+{
+	struct expression *eA = A;
+	struct expression *eB = B;
+	char *a = NULL, *b = NULL;
+	char *str = NULL;
+	char *ret = NULL;
+	int r;
+
+	if (eA->name) {
+		r = asprintf(&a, "%s AS %s", show(A), eA->name);
+		if (r < 0)
+			goto out;
+	}
+
+	if (eB->name) {
+		r = asprintf(&b, "%s AS %s", show(B), eB->name);
+		if (r < 0)
+			goto out;
+	}
+
+	r = asprintf(&str, "(%s %s %s)",
+		     a ? a : show(A), op, b ? b : show(B));
+	if (r < 0)
+		goto out;
+
+	ret = store_str(str);
+out:
+	free(a);
+	free(b);
+	free(str);
+
+	if (!ret)
+		parse_error++;
+
+	return ret;
+}
+
+static const char *show_raw_expr(void *e);
+static const char *resolve(struct sql_table *table, const char *label);
+
+static const char *expand(const char *str)
+{
+	char *exp = strdup(str);
+	const char *label;
+	const char *ret;
+	char *p;
+
+	if (!exp) {
+		parse_error++;
+		return NULL;
+	}
+
+	p = strstr(exp, ".");
+	if (p) {
+		*p = 0;
+		label = resolve(curr_table, exp);
+		ret = store_printf("%s.%s", label, p+1);
+		*p = '.';
+	} else {
+		ret = resolve(curr_table, str);
+	}
+	free(exp);
+	return ret;
+}
+
+static const char *__show_expr(struct expression *e, bool eval)
+{
+	const char *(*show)(void *e);
+	char *ret;
+
+	if (eval)
+		show = show_raw_expr;
+	else
+		show = show_expr;
+
+	switch (e->type) {
+	case EXPR_FIELD:
+		ret = e->A;
+		if (eval)
+			return expand(e->A);
+		break;
+	case EXPR_PLUS:
+		ret = expr_op_connect(e->A, e->B, "+", show);
+		break;
+	case EXPR_MINUS:
+		ret = expr_op_connect(e->A, e->B, "-", show);
+		break;
+	case EXPR_MULT:
+		ret = expr_op_connect(e->A, e->B, "*", show);
+		break;
+	case EXPR_DIVID:
+		ret = expr_op_connect(e->A, e->B, "/", show);
+		break;
+	}
+	return ret;
+}
+
+static const char *show_raw_expr(void *e)
+{
+	return __show_expr(e, true);
+}
+
+const char *show_expr(void *expr)
+{
+	struct expression *e = expr;
+
+	if (e->name)
+		return e->name;
+
+	return __show_expr(expr, false);
+}
+
+static struct expression *create_expression(void *A, void *B, enum expr_type type)
+{
+	struct expression *e;
+
+	e = calloc(sizeof(*e), 1);
+	if (!e) {
+		parse_error++;
+		return NULL;
+	}
+	e->A = A;
+	e->B = B;
+	e->type = type;
+	e->table = curr_table;
+
+	return e;
+}
+
+void *add_plus(void *A, void *B)
+{
+	return create_expression(A, B, EXPR_PLUS);
+}
+
+void *add_minus(void *A, void *B)
+{
+	return create_expression(A, B, EXPR_MINUS);
+}
+
+void *add_mult(void *A, void *B)
+{
+	return create_expression(A, B, EXPR_MULT);
+}
+
+void *add_divid(void *A, void *B)
+{
+	return create_expression(A, B, EXPR_DIVID);
+}
+
+void add_expr(const char *label, void *A)
+{
+	struct expression *e = A;
+
+	insert_label(label, A, LABEL_EXPR);
+	e->name = store_str(label);
+}
+
+void *add_field(const char *field, const char *label)
+{
+	struct expression *e;
+
+	e = create_expression(store_str(field), NULL, EXPR_FIELD);
+	if (label)
+		add_expr(label, e);
+
+	return e;
+}
+
+static inline unsigned int quick_hash(const char *str)
+{
+	unsigned int val = 0;
+	int len = strlen(str);
+
+	for (; len >= 4; str += 4, len -= 4) {
+		val += str[0];
+		val += str[1] << 8;
+		val += str[2] << 16;
+		val += str[3] << 24;
+	}
+	for (; len > 0; str++, len--)
+		val += str[0] << (len * 8);
+
+	val *= 2654435761;
+
+	return val & ((1 << HASH_BITS) - 1);
+}
+
+
+static struct str_hash *find_string(const char *str)
+{
+	unsigned int key = quick_hash(str);
+	struct str_hash *hash;
+
+	for (hash = str_hash[key]; hash; hash = hash->next) {
+		if (!strcmp(hash->str, str))
+			return hash;
+	}
+	return NULL;
+}
+
+/*
+ * If @str is found, then return the hash string.
+ * This lets store_str() know to free str.
+ */
+static char **add_hash(const char *str)
+{
+	struct str_hash *hash;
+	unsigned int key;
+
+	hash = find_string(str);
+	if (hash)
+		return &hash->str;
+
+	hash = malloc(sizeof(*hash));
+	if (!hash) {
+		parse_error++;
+		return NULL;
+	}
+	key = quick_hash(str);
+	hash->next = str_hash[key];
+	str_hash[key] = hash;
+	hash->str = NULL;
+	return &hash->str;
+}
+
+char *store_str(const char *str)
+{
+	char **pstr = add_hash(str);
+
+	if (!(*pstr))
+		*pstr = strdup(str);
+
+	return *pstr;
+}
+
+char *store_printf(const char *fmt, ...)
+{
+	va_list ap;
+	char **pstr;
+	char *str;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = vasprintf(&str, fmt, ap);
+	va_end(ap);
+
+	if (!ret) {
+		parse_error++;
+		return NULL;
+	}
+
+	pstr = add_hash(str);
+	if (*pstr)
+		free(str);
+	else
+		*pstr = str;
+
+	return *pstr;
+}
+
+#if SQL_PARSE_DEBUG
+static void dump_label_map(struct sql_table *table)
+{
+	struct label_map *lmap;
+	struct table_map *tmap;
+
+	if (table->labels)
+		printf("%s Labels:\n", table->name);
+	for (lmap = table->labels; lmap; lmap = lmap->next) {
+		switch (lmap->type) {
+		case LABEL_STRING:
+			printf("  %s = %s\n",
+			       lmap->label, (char *)lmap->value);
+			break;
+		case LABEL_EXPR:
+			printf("  %s = (%s)\n", lmap->label,
+			       show_raw_expr(lmap->value));
+			break;
+		}
+	}
+	if (table->tables)
+		printf("%s Tables:\n", table->name);
+	for (tmap = table->tables; tmap; tmap = tmap->next)
+		printf("  %s = Table %s\n", tmap->name, tmap->table->name);
+}
+
+static void dump_match_map(struct sql_table *table)
+{
+	struct match_map *map;
+
+	if (table->matches)
+		printf("%s Matches:\n", table->name);
+	for (map = table->matches; map; map = map->next)
+		printf("  %s = %s\n", map->A, map->B);
+
+}
+
+static void dump_selections(struct sql_table *table)
+{
+	struct selection *sel;
+	struct trace_seq s;
+
+	trace_seq_init(&s);
+	if (table->selections)
+		trace_seq_printf(&s, "%s Selections:\n", table->name);
+	for (sel = table->selections; sel; sel = sel->next) {
+		trace_seq_printf(&s, "  %s::\n\t", sel->name);
+		show_raw_expr(sel->item);
+		print_type(&s, sel->item);
+		trace_seq_printf(&s, "\n  --\n");
+	}
+	trace_seq_do_printf(&s);
+	trace_seq_destroy(&s);
+}
+
+static void dump_table(struct sql_table *table)
+{
+	struct sql_table *save_curr = curr_table;
+
+	if (!table)
+		return;
+
+	printf("\nTable: %s\n\tFrom: %s\n", table->name, table->from);
+
+	dump_table(find_table(table->from));
+
+	curr_table = table;
+
+	dump_label_map(table);
+	dump_match_map(table);
+	dump_selections(table);
+
+	curr_table = save_curr;
+
+	printf("\n\tTo: %s\n", table->to);
+	dump_table(find_table(table->to));
+}
+
+
+static void dump_tables(void)
+{
+	static int debug = 1;
+
+	if (!debug)
+		return;
+
+	dump_table(top_table);
+}
+#endif
+
+static const char *event_match(const char *event, const char *val, int len)
+{
+	if (strncmp(event, val, len) == 0 && val[len] == '.')
+		return val + len + 1;
+
+	return NULL;
+}
+
+static char *make_dynamic_arg(void)
+{
+	static int arg_cnt;
+
+	return store_printf("__arg%d__", arg_cnt++);
+}
+
+static struct tep_event *find_event(struct tep_handle *tep, const char *name)
+{
+	static struct tep_event stub_event = {
+		.system			= "(system)",
+	};
+
+	if (tep)
+		return tep_find_event_by_name(tep, NULL, name);
+
+	return &stub_event;
+}
+
+static struct tep_format_field *find_field(struct tep_event *event, char *name)
+{
+	static struct tep_format_field stub_field = {
+		.type = "(unknown)",
+	};
+
+	if (tep)
+		return tep_find_any_field(event, name);
+
+	return &stub_field;
+}
+
+static int print_type(struct trace_seq *s, struct expression *e)
+{
+	struct tep_format_field *field;
+	struct tep_event *event;
+	char *name = NULL;
+	char *tok;
+	int ret = -1;
+
+	while (e && e->type != EXPR_FIELD)
+		e = e->A;
+
+	if (!e)
+		return -1;
+
+	name = strdup(show_raw_expr(e));
+	if (!name)
+		return -1;
+
+	tok = strtok(name, ".");
+
+	event = find_event(tep, tok);
+	if (!event) {
+		tok = strtok(NULL, ".");
+		if (!tok)
+			goto out;
+		event = find_event(tep, tok);
+	}
+
+	tok = strtok(NULL, ".");
+	if (!tok || !event)
+		goto out;
+
+	if (strcmp(tok, "common_timestamp") == 0) {
+		trace_seq_printf(s, " u64 ");
+	} else {
+		field = find_field(event, tok);
+		if (field)
+			trace_seq_printf(s, " %s ", field->type);
+		else
+			goto out;
+	}
+
+	ret = 0;
+
+out:
+	free(name);
+	return ret;
+}
+
+static int print_synthetic_field(struct trace_seq *s, struct sql_table *table,
+				  struct selection *selection)
+{
+	struct expression *e = selection->item;
+	const char *name;
+	const char *actual;
+	const char *field;
+	const char *to;
+	int len;
+	int ret;
+
+	ret = print_type(s, e);
+	if (ret < 0)
+		return ret;
+
+	name = selection->name;
+	if (!name)
+		name = e->name;
+	if (name) {
+		trace_seq_printf(s, "%s", name);
+		return 0;
+	}
+
+	to = resolve(table, table->to);
+	len = strlen(to);
+
+	actual = show_raw_expr(e);
+	field = event_match(to, actual, len);
+	if (field) {
+		trace_seq_printf(s, "%s", field);
+		return 0;
+	}
+
+	selection->name = make_dynamic_arg();
+	e->name = selection->name;
+
+	field = strstr(actual, ".");
+	if (field) {
+		/* Need to check for common_timestamp */
+		trace_seq_printf(s, "%s", field + 1);
+	} else {
+		trace_seq_printf(s, "%s", e->name);
+	}
+
+	return 0;
+}
+
+static int make_synthetic_events(struct sql_table *table,
+				  struct sqlhist_synth_event **synt_events)
+{
+	int ret;
+	struct trace_seq str;
+	struct selection *selection;
+	struct sqlhist_synth_event *synt_event = NULL;
+	struct sql_table *save_curr = curr_table;
+
+	if (!table || !table->to)
+		return 0;
+
+	ret = make_synthetic_events(find_table(table->from), synt_events);
+	if (ret < 0)
+		return ret;
+
+	trace_seq_init(&str);
+	synt_event = calloc(1, sizeof(struct sqlhist_synth_event));
+	if (!synt_event)
+		goto error;
+	synt_event->name = strdup(table->name);
+	if (!synt_event->name)
+		goto error;
+
+	curr_table = table;
+	trace_seq_printf(&str, "%s ", table->name);
+	for (selection = table->selections; selection; selection = selection->next) {
+		if (print_synthetic_field(&str, table, selection) < 0)
+			goto error;
+	}
+
+	synt_event->config = strdup(str.buffer);
+	if (!synt_event->config)
+		goto error;
+
+	curr_table = save_curr;
+	trace_seq_destroy(&str);
+
+	if (*synt_events)
+		(*synt_events)->next = synt_event;
+	else
+		*synt_events = synt_event;
+
+	return make_synthetic_events(find_table(table->to), synt_events);
+
+error:
+	trace_seq_destroy(&str);
+	if (synt_event) {
+		free(synt_event->name);
+		free(synt_event->config);
+		free(synt_event);
+	}
+
+	return -1;
+}
+
+static const char *resolve(struct sql_table *table, const char *label)
+{
+	struct sql_table *save_curr = curr_table;
+	struct label_map *lmap;
+	struct expression *e;
+
+	curr_table = table;
+
+	for (lmap = table->labels; lmap; lmap = lmap->next)
+		if (strcmp(lmap->label, label) == 0)
+			break;
+
+	if (lmap) {
+		switch (lmap->type) {
+		case LABEL_STRING:
+			label = (char *)lmap->value;
+			break;
+		case LABEL_EXPR:
+			e = lmap->value;
+			label = show_raw_expr(e);
+			break;
+		}
+	}
+
+	curr_table = save_curr;
+
+	return label;
+}
+
+static int print_key(struct trace_seq *s, struct sql_table *table,
+		     const char *event, const char *key1, const char *key2)
+{
+	int len = strlen(event);
+	const char *field;
+
+	field = event_match(event, key1, len);
+	if (field)
+		trace_seq_printf(s, "%s", field);
+
+	field = event_match(event, key2, len);
+	if (field)
+		trace_seq_printf(s, "%s", field);
+
+	return 0;
+}
+
+static int print_keys(struct trace_seq *s,
+		      struct sql_table *table, const char *event)
+{
+	int ret = 0;
+	struct selection *selection;
+	struct match_map *map;
+	struct expression *e;
+	char *f, *p;
+	int start = 0;
+
+	if (event) {
+		f = strdup(event);
+		if (!f)
+			return -1;
+		p = strstr(f, ".");
+		if (p)
+			*p = '\0';
+
+		for (map = table->matches; map; map = map->next) {
+			if (start++)
+				trace_seq_printf(s, ",");
+			ret = print_key(s, table, f,
+					expand(map->A), expand(map->B));
+			if (ret < 0)
+				break;
+		}
+
+		free(f);
+	} else {
+		for (selection = table->selections; selection; selection = selection->next) {
+			e = selection->item;
+			if (!e->name || strncmp(e->name, "key", 3) != 0)
+				continue;
+			if (start++)
+				trace_seq_printf(s, ",");
+			trace_seq_printf(s, "%s", show_raw_expr(e));
+		}
+	}
+
+	return ret;
+}
+
+enum value_type {
+	VALUE_TO,
+	VALUE_FROM,
+};
+
+static void print_val_delim(struct trace_seq *s, bool *start)
+{
+	if (*start) {
+		trace_seq_printf(s, ":");
+		*start = false;
+	} else
+		trace_seq_printf(s, ",");
+}
+
+struct var_list {
+	struct var_list		*next;
+	const char		*var;
+	const char		*val;
+};
+
+static const char *find_var(struct var_list **vars, const char *val)
+{
+	struct var_list *v;
+
+	for (v = *vars; v; v = v->next) {
+		if (strcmp(v->val, val) == 0)
+			return v->var;
+	}
+
+	return NULL;
+}
+
+static int add_var(struct var_list **vars, const char *var, const char *val)
+{
+	struct var_list *v;
+
+	v = malloc(sizeof(*v));
+	if (!v)
+		return -1;
+
+	v->var = var;
+	v->val = val;
+	v->next = *vars;
+	*vars = v;
+
+	return 0;
+}
+
+static int print_to_expr(struct trace_seq *s,
+			 struct sql_table *table, const char *event,
+			 struct expression *e, struct var_list **vars)
+{
+	int ret = 0;
+	const char *actual;
+	const char *field;
+	const char *var;
+	int len = strlen(event);
+
+	switch (e->type) {
+	case EXPR_FIELD:
+		actual = show_raw_expr(e);
+		field = event_match(event, actual, len);
+		if (field) {
+			trace_seq_printf(s, "%s", field);
+			break;
+		}
+
+		field = strstr(actual, ".");
+		if (!field) {
+			trace_seq_printf(s, "%s", field);
+			break;
+		}
+		var = find_var(vars, actual);
+		if (!var)
+			return -1;
+		trace_seq_printf(s, "$%s", var);
+		break;
+	default:
+		ret = print_to_expr(s, table, event, e->A, vars);
+		if (ret < 0)
+			break;
+		switch (e->type) {
+		case EXPR_PLUS:
+			trace_seq_printf(s, "+");
+			break;
+		case EXPR_MINUS:
+			trace_seq_printf(s, "-");
+			break;
+		case EXPR_MULT:
+			trace_seq_printf(s, "*");
+			break;
+		case EXPR_DIVID:
+			trace_seq_printf(s, "/");
+			break;
+		default:
+			break;
+		}
+		ret = print_to_expr(s, table, event, e->B, vars);
+	}
+
+	return ret;
+}
+
+static int print_from_expr(struct trace_seq *s, struct sql_table *table,
+			    const char *event, struct expression *e,
+			    bool *start, struct var_list **vars)
+{
+	int ret = 0;
+	const char *actual;
+	const char *field;
+	int len = strlen(event);
+
+	switch (e->type) {
+	case EXPR_FIELD:
+		actual = show_raw_expr(e);
+		field = event_match(event, actual, len);
+		if (field && !find_var(vars, actual)) {
+			print_val_delim(s, start);
+			if (!e->name)
+				e->name = make_dynamic_arg();
+			trace_seq_printf(s, "%s=%s", e->name, field);
+			ret = add_var(vars, e->name, actual);
+			break;
+		}
+		break;
+	default:
+		ret = print_from_expr(s, table, event, e->A, start, vars);
+		if (ret < 0)
+			break;
+		ret = print_from_expr(s, table, event, e->B, start, vars);
+	}
+	return ret;
+}
+
+static int print_value(struct trace_seq *s, struct sql_table *table,
+		       const char *event, struct selection *selection,
+		       enum value_type type, bool *start,
+		       struct var_list **vars)
+{
+	int ret = 0;
+	struct expression *e = selection->item;
+	const char *name = selection->name;
+	int len = strlen(event);
+	const char *actual;
+	const char *field;
+
+	switch (e->type) {
+	case EXPR_FIELD:
+		if (!selection->name || !e->name)
+			break;
+		actual = show_raw_expr(e);
+		field = event_match(event, actual, len);
+		if (field) {
+			if (type != VALUE_TO) {
+				print_val_delim(s, start);
+				trace_seq_printf(s, "%s=%s", e->name, field);
+				ret = add_var(vars, e->name, actual);
+			}
+		} else if (type == VALUE_TO) {
+			const char *arg;
+			/*
+			 * The selection wants to show the from,
+			 * We need to save the from field in a variable
+			 */
+			print_val_delim(s, start);
+			arg = make_dynamic_arg();
+			trace_seq_printf(s, "%s=$%s", arg, e->name);
+			ret = add_var(vars, arg, actual);
+			if (ret < 0)
+				break;
+			/* Now use the this arg for the parameters */
+			selection->name = arg;
+		}
+		break;
+	default:
+		if (type == VALUE_TO) {
+			print_val_delim(s, start);
+			trace_seq_printf(s, "%s=", name);
+			ret = print_to_expr(s, table, event, e, vars);
+		} else {
+			ret = print_from_expr(s, table, event, e, start, vars);
+		}
+		break;
+	}
+
+	return ret;
+}
+
+static int print_values(struct trace_seq *s, struct sql_table *table,
+			 const char *event, enum value_type type,
+			 struct var_list **vars)
+{
+	int ret = -1;
+	struct selection *selection;
+	struct expression *e;
+	char *f = NULL, *p;
+	bool start = true;
+
+	if (event) {
+		f = strdup(event);
+		if (!f)
+			goto out;
+		p = strstr(f, ".");
+		if (p)
+			*p = '\0';
+
+		for (selection = table->selections; selection; selection = selection->next) {
+			ret = print_value(s, table, f, selection, type, &start, vars);
+			if (ret < 0)
+				goto out;
+		}
+		ret = 0;
+	} else {
+		for (selection = table->selections; selection; selection = selection->next) {
+			e = selection->item;
+			if (e->name && strncmp(e->name, "key", 3) == 0)
+				continue;
+			if (start) {
+				trace_seq_printf(s, ":values=");
+				start = false;
+			} else {
+				trace_seq_printf(s, ",");
+			}
+			trace_seq_printf(s, "%s", show_raw_expr(e));
+		}
+		ret = 0;
+	}
+out:
+	free(f);
+	return ret;
+}
+
+static int print_trace_field(struct trace_seq *s, struct sql_table *table,
+			      struct selection *selection)
+{
+	struct expression *e = selection->item;
+	const char *name;
+	const char *actual;
+	const char *field;
+	const char *to;
+	int len;
+
+	to = resolve(table, table->to);
+	len = strlen(to);
+
+	actual = show_raw_expr(e);
+	field = event_match(to, actual, len);
+	if (field) {
+		trace_seq_printf(s, ",%s", field);
+		return 0;
+	}
+
+	name = selection->name;
+	if (!name)
+		name = e->name;
+	if (name) {
+		trace_seq_printf(s, ",$%s", name);
+		return 0;
+	}
+
+	return -1;
+}
+
+static int print_trace(struct trace_seq *s, struct sql_table *table)
+{
+	struct selection *selection;
+	int ret;
+
+	trace_seq_printf(s, ".trace(%s", table->name);
+
+	for (selection = table->selections; selection; selection = selection->next) {
+		ret = print_trace_field(s, table, selection);
+		if (ret < 0)
+			return ret;
+	}
+	trace_seq_printf(s, ")");
+	return 0;
+}
+
+static int print_system_event(const char *text,
+			     char **sys_name, char **event_name)
+{
+	struct tep_event *event;
+	char *name = strdup(text);
+	char *tok;
+
+	*sys_name = NULL;
+	*event_name = NULL;
+
+	strtok(name, ".");
+	tok = strtok(NULL, ".");
+	if (tok) {
+		*sys_name = strdup(tok);
+		*event_name = strdup(name);
+		goto out;
+	}
+
+	event = find_event(tep, name);
+	if (!event)
+		goto out;
+
+	*sys_name = strdup(event->system);
+	*event_name = strdup(name);
+
+ out:
+	free(name);
+	if (!*sys_name || !*event_name) {
+		free(*sys_name);
+		free(*event_name);
+		*sys_name = NULL;
+		*event_name = NULL;
+		return -1;
+	}
+	return 0;
+}
+
+static int make_histograms(struct sql_table *table,
+			    struct sqlhist_trigger **triggers)
+{
+	int ret;
+	struct sqlhist_trigger *trigger = NULL;
+	struct trace_seq str;
+	struct sql_table *save_curr = curr_table;
+	struct var_list *vars = NULL;
+	const char *from = NULL;
+	const char *to;
+	char *sys_name = NULL, *event_name = NULL;
+
+	if (!table)
+		return 0;
+
+	/* Need to do children and younger siblings first */
+	ret = make_histograms(find_table(table->from), triggers);
+	if (ret < 0)
+		return ret;
+	trace_seq_init(&str);
+	curr_table = table;
+	trigger = calloc(1, sizeof(struct sqlhist_trigger));
+	if (!trigger)
+		goto error;
+
+	if (table->to)
+		from = resolve(table, table->from);
+
+	trace_seq_printf(&str, "hist:keys=");
+	ret = print_keys(&str, table, from);
+	if (ret < 0)
+		goto error;
+	ret = print_values(&str, table, from, VALUE_FROM, &vars);
+	if (ret < 0)
+		goto error;
+
+	trigger->config = strdup(str.buffer);
+	if (!trigger->config)
+		goto error;
+
+	if (!table->to)
+		from = resolve(table, table->from);
+	ret = print_system_event(from, &trigger->system, &trigger->event);
+	if (ret < 0)
+		goto error;
+
+	if (*triggers)
+		(*triggers)->next = trigger;
+	else
+		*triggers = trigger;
+
+	if (!table->to)
+		goto out;
+
+	trigger = calloc(1, sizeof(struct sqlhist_trigger));
+	if (!trigger)
+		goto error;
+
+	trace_seq_reset(&str);
+	trace_seq_printf(&str, "hist:keys=");
+	to = resolve(table, table->to);
+	ret = print_keys(&str, table, to);
+	if (ret < 0)
+		goto error;
+	ret = print_values(&str, table, to, VALUE_TO, &vars);
+	if (ret < 0)
+		goto error;
+	trace_seq_printf(&str, ":onmatch(");
+	print_system_event(from, &sys_name, &event_name);
+	if (!sys_name || !event_name)
+		goto error;
+	trace_seq_printf(&str, "%s.%s", sys_name, event_name);
+	trace_seq_printf(&str, ")");
+
+	ret = print_trace(&str, table);
+	if (ret < 0)
+		goto error;
+
+	print_system_event(to, &trigger->system, &trigger->event);
+	if (ret < 0)
+		goto error;
+
+	trigger->config = strdup(str.buffer);
+	if (!trigger->config)
+		goto error;
+
+	if (*triggers)
+		(*triggers)->next = trigger;
+	else
+		*triggers = trigger;
+
+	while (vars) {
+		struct var_list *v = vars;
+
+		vars = v->next;
+		free(v);
+	}
+	free(sys_name);
+	free(event_name);
+ out:
+	curr_table = save_curr;
+	trace_seq_destroy(&str);
+	return make_histograms(find_table(table->to), triggers);
+
+error:
+	free(sys_name);
+	free(event_name);
+	trace_seq_destroy(&str);
+	if (trigger) {
+		free(trigger->config);
+		free(trigger->event);
+		free(trigger->system);
+		free(trigger);
+	}
+	return -1;
+}
+
+static char *buffer;
+static size_t buffer_size;
+static size_t buffer_idx;
+
+int my_yyinput(char *buf, int max)
+{
+	if (!buffer)
+		return read(0, buf, max);
+
+	if (buffer_idx + max > buffer_size)
+		max = buffer_size - buffer_idx;
+
+	if (max)
+		memcpy(buf, buffer + buffer_idx, max);
+
+	buffer_idx += max;
+
+	return max;
+}
+
+void sqlhist_cleanup(void)
+{
+	parse_error = 0;
+	buffer_idx = 0;
+
+}
+
+void sqlhist_destroy(void)
+{
+	sqlhist_cleanup();
+	tep_free(tep);
+}
+
+void sqlhist_trigger_free(struct sqlhist_trigger *list)
+{
+	struct sqlhist_trigger *del, *trigger = list;
+
+	while (trigger) {
+		del = trigger;
+		trigger = trigger->next;
+		free(del->config);
+		free(del->event);
+		free(del->system);
+		free(del);
+	}
+}
+
+void sqlhist_synth_event_free(struct sqlhist_synth_event *list)
+{
+	struct sqlhist_synth_event *del, *event = list;
+
+	while (event) {
+		del = event;
+		event = event->next;
+		free(del->config);
+		free(del->name);
+		free(del);
+	}
+}
+
+int sqlhist_parse(char *buff, size_t buff_size,
+		  struct sqlhist_trigger **triggers,
+		  struct sqlhist_synth_event **synt_events)
+{
+	int ret;
+
+	sqlhist_cleanup();
+	buffer = buff;
+	buffer_size = buff_size;
+
+	if (!tep)
+		tep = tracefs_local_events(NULL);
+	if (!tep)
+		return -1;
+
+	ret = yyparse();
+	if (ret < 0)
+		return ret;
+
+#if SQL_PARSE_DEBUG
+	dump_tables();
+#endif
+
+	if (parse_error)
+		return -1;
+
+	ret = make_synthetic_events(top_table, synt_events);
+	if (ret < 0)
+		return ret;
+
+	ret = make_histograms(top_table, triggers);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
diff --git a/tracecmd/sqlparser/sqlhist.h b/tracecmd/sqlparser/sqlhist.h
new file mode 100644
index 0000000..68ff196
--- /dev/null
+++ b/tracecmd/sqlparser/sqlhist.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: LGPL-2.0 */
+/*
+ * Copyright (C) 2020 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+#ifndef __SQLHIST_H
+#define __SQLHIST_H
+
+#include <tracefs.h>
+#include "sqlhist.tab.h"
+
+char *store_str(const char *str);
+char *store_printf(const char *fmt, ...);
+void add_label(const char *label, const char *val);
+void add_match(const char *A, const char *B);
+void table_start(void);
+void table_end(const char *name);
+void from_table_end(const char *name);
+void simple_table_end(void);
+
+const char *show_expr(void *expr);
+void *add_plus(void *A, void *B);
+void *add_minus(void *A, void *B);
+void *add_mult(void *A, void *B);
+void *add_divid(void *A, void *B);
+void *add_field(const char *field, const char *label);
+
+void add_expr(const char *name, void *expr);
+
+void add_selection(void *item);
+void add_from(void *item);
+void add_to(void *item);
+
+#endif /* __SQLHIST_H */
diff --git a/tracecmd/sqlparser/sqlhist.l b/tracecmd/sqlparser/sqlhist.l
new file mode 100644
index 0000000..99dddcc
--- /dev/null
+++ b/tracecmd/sqlparser/sqlhist.l
@@ -0,0 +1,59 @@
+%{
+/* SPDX-License-Identifier: LGPL-2.0
+ *
+ * Copyright (C) 2020 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+
+#include <stdarg.h>
+#include "sqlhist.h"
+
+extern int my_yyinput(char *buf, int max);
+
+#undef YY_INPUT
+#define YY_INPUT(b, r, m) (r = my_yyinput(b, m))
+
+#define YY_NO_INPUT
+#define YY_NO_UNPUT
+
+static int line_no = 1;
+
+%}
+
+%option caseless
+
+%%
+
+select { return SELECT; }
+as { return AS; }
+from { return FROM; }
+join { return JOIN; }
+on { return ON; }
+
+\$[a-z][a-z0-9_]* { yylval.string = store_str(yytext); return VARIABLE; }
+
+[a-z0-9_\.]+ {  yylval.string = store_str(yytext); return STRING; }
+
+[()\-\+\*/,=] { return yytext[0]; }
+
+[ \t]
+\n { line_no++; }
+
+%%
+
+int yywrap(void)
+{
+	return 1;
+}
+
+void yyerror(const char *fmt, ...)
+{
+	va_list ap;
+
+	printf("\n");
+	va_start(ap, fmt);
+	printf("ERROR: (%s) at line %d\n", yytext, line_no);
+	vprintf(fmt, ap);
+	printf("\n");
+	va_end(ap);
+}
diff --git a/tracecmd/sqlparser/sqlhist.y b/tracecmd/sqlparser/sqlhist.y
new file mode 100644
index 0000000..8a0004a
--- /dev/null
+++ b/tracecmd/sqlparser/sqlhist.y
@@ -0,0 +1,175 @@
+%{
+/* SPDX-License-Identifier: LGPL-2.0
+ *
+ * Copyright (C) 2020 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "sqlhist.h"
+
+extern int yylex(void);
+extern void yyerror(char *fmt, ...);
+
+%}
+
+%union {
+	int	s32;
+	char	*string;
+	void	*expr;
+}
+
+%token AS SELECT FROM JOIN ON WHERE
+%token <string> STRING VARIABLE
+
+%left '+' '-'
+%left '*' '/'
+
+%type <string> name field label
+%type <string> selection_list table_exp selection_item
+%type <string> from_clause select_statement event_map
+%type <string> where_clause
+
+%type <expr>  selection_expr item named_field join_clause
+
+%%
+
+start:
+   select_statement { table_end(NULL); }
+ | select_name
+ | simple_select { simple_table_end(); }
+ ;
+
+select_name :
+   '(' select_statement ')' label
+			{ table_end($4); add_label($4, "SELECT"); }
+ ;
+
+label : AS name { $$ = store_printf("%s", $2); }
+ | name
+ ;
+
+select : SELECT  { table_start(); }
+  ;
+
+simple_select :
+     select selection_list from_clause
+  |  select selection_list from_clause where_clause
+  ;
+
+select_statement :
+    select selection_list table_exp
+				{
+					$$ = store_printf("SELECT %s %s", $2, $3);
+				}
+  ;
+
+selection_list :
+   selection_item
+ | selection_list ',' selection_item
+   				{
+					$$ = store_printf("%s, %s", $1, $3);
+				}
+ ;
+
+selection_item : selection_expr { $$ = store_str(show_expr($1)); add_selection($1); }
+  ;
+
+selection_expr :
+   selection_expr '+' selection_expr
+   				{
+					$$ = add_plus($1, $3);
+				}
+ | selection_expr '-' selection_expr
+   				{
+					$$ = add_minus($1, $3);
+				}
+ | selection_expr '*' selection_expr
+   				{
+					$$ = add_mult($1, $3);
+				}
+ | selection_expr '/' selection_expr
+   				{
+					$$ = add_divid($1, $3);
+				}
+ | item
+ | '(' selection_expr ')' { $$ = $2; }
+ | '(' selection_expr ')' label
+			{
+				add_expr($4, $2);
+				$$ = $2;
+			}
+ ;
+
+item :
+   named_field
+ | field		{ $$ = add_field($1, NULL); }
+ ;
+
+field :
+   STRING
+ | VARIABLE
+ ;
+
+named_field :
+   field label { $$ = add_field($1, $2); }
+ ;
+
+name :
+   STRING
+ ;
+
+event_map :
+   from_clause join_clause on_clause { $$ = store_printf("%s TO %s", $1, show_expr($2)); }
+ ;
+
+where_clause :
+   WHERE item { $$ = store_printf(" WHERE %s", show_expr($2)); }
+ ;
+
+table_exp :
+   event_map
+ | event_map where_clause
+ ;
+
+from_clause :
+   FROM item
+				{
+					add_from($2);
+					$$ = store_printf("FROM %s", show_expr($2));
+				}
+/*
+ * Select from a from clause confuses the variable parsing.
+ * disable it for now.
+
+   | FROM '(' select_statement ')' label
+				{
+					from_table_end($5);
+					$$ = store_printf("FROM (%s) AS %s", $3, $5);
+				}
+*/
+ ;
+
+join_clause :
+  JOIN item	{ add_to($2); $$ = $2; }
+ ;
+
+on_clause :
+  ON match_clause
+ ;
+
+match :
+   item '=' item { add_match(show_expr($1), show_expr($3)); }
+ ;
+
+match_clause :
+   match
+ | match_clause ',' match
+ ;
+
+%%
+
+
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3e0d066..28daf41 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -43,6 +43,7 @@
 #include "version.h"
 #include "trace-local.h"
 #include "trace-msg.h"
+#include "sqlhist-api.h"
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
@@ -223,6 +224,7 @@ struct common_record_context {
 	int total_disable;
 	int disable;
 	int events;
+	int auto_triggers;
 	int global;
 	int filtered;
 	int date;
@@ -2069,6 +2071,51 @@ static int clear_trigger(const char *file)
 	return ret;
 }
 
+static void clear_synthetic_events(void)
+{
+	struct sqlhist_synth_event *sevent;
+	struct buffer_instance *instance;
+	char *config;
+
+	for_all_instances(instance) {
+		if (is_guest(instance) || !instance->synth_events)
+			continue;
+		for (sevent = instance->synth_events; sevent; sevent = sevent->next) {
+			if (asprintf(&config, "!%s", sevent->config) < 0)
+				continue;
+			tracefs_instance_file_append(NULL,
+						     "synthetic_events",
+						     config);
+			free(config);
+		}
+		sqlhist_synth_event_free(instance->synth_events);
+		instance->synth_events = NULL;
+	}
+}
+
+static void clear_auto_triggers(void)
+{
+	struct buffer_instance *instance;
+	struct sqlhist_trigger *trigger;
+	char file[PATH_MAX];
+	char *config;
+
+	for_all_instances(instance) {
+		if (is_guest(instance) || !instance->auto_triggers)
+			continue;
+		for (trigger = instance->auto_triggers; trigger; trigger = trigger->next) {
+			if (asprintf(&config, "!%s", trigger->config) < 0)
+				continue;
+			snprintf(file, PATH_MAX, "events/%s/%s/trigger",
+				 trigger->system, trigger->event);
+			tracefs_instance_file_append(instance->tracefs, file, config);
+			free(config);
+		}
+		sqlhist_trigger_free(instance->auto_triggers);
+		instance->auto_triggers = NULL;
+	}
+}
+
 static void clear_func_filter(const char *file)
 {
 	char filter[BUFSIZ];
@@ -2568,6 +2615,45 @@ static void set_mask(struct buffer_instance *instance)
 	instance->cpumask = NULL;
 }
 
+static void set_synth_events(struct buffer_instance *instance)
+{
+	struct sqlhist_synth_event *sevent;
+
+	if (is_guest(instance))
+		return;
+
+	for (sevent = instance->synth_events; sevent; sevent = sevent->next) {
+		pr_stat("Synthetic event %s: %s\n", sevent->name, sevent->config);
+		if (tracefs_instance_file_append(NULL, "synthetic_events", sevent->config) < 0)
+			die("Failed to set synthetic event %s", sevent->config);
+	}
+}
+
+static void set_auto_triggers(struct buffer_instance *instance)
+{
+	struct sqlhist_trigger *trigger;
+	char file[PATH_MAX];
+
+	if (is_guest(instance))
+		return;
+
+	for (trigger = instance->auto_triggers; trigger; trigger = trigger->next) {
+		pr_stat("Trigger %s/%s: %s\n", trigger->system,
+					       trigger->event, trigger->config);
+		snprintf(file, PATH_MAX, "events/%s/%s/trigger",
+			 trigger->system, trigger->event);
+		if (tracefs_instance_file_write(instance->tracefs, file, trigger->config) < 0) {
+			char *err_log = NULL;
+
+			err_log = tracefs_instance_file_read(instance->tracefs,
+							     "error_log", NULL);
+			die("Failed to set trigger %s:\n\t%s\nerror:\n\t%s",
+					file, trigger->config,
+					err_log ? err_log : "N/A");
+		}
+	}
+}
+
 static void enable_events(struct buffer_instance *instance)
 {
 	struct event_list *event;
@@ -4813,7 +4899,7 @@ static void check_function_plugin(void)
 static int __check_doing_something(struct buffer_instance *instance)
 {
 	return is_guest(instance) || (instance->flags & BUFFER_FL_PROFILE) ||
-		instance->plugin || instance->events;
+		instance->plugin || instance->events || instance->synth_events;
 }
 
 static void check_doing_something(void)
@@ -5227,6 +5313,7 @@ void init_top_instance(void)
 }
 
 enum {
+	OPT_sql			= 242,
 	OPT_user		= 243,
 	OPT_procmap		= 244,
 	OPT_quiet		= 245,
@@ -5529,13 +5616,14 @@ static void parse_record_options(int argc,
 			{"proc-map", no_argument, NULL, OPT_procmap},
 			{"user", required_argument, NULL, OPT_user},
 			{"module", required_argument, NULL, OPT_module},
+			{"sql", required_argument, NULL, OPT_sql},
 			{NULL, 0, NULL, 0}
 		};
 
 		if (IS_EXTRACT(ctx))
 			opts = "+haf:Fp:co:O:sr:g:l:n:P:N:tb:B:ksiT";
 		else
-			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:q";
+			opts = "+hae:f:FA:p:cC:dDGo:O:s:r:vg:l:n:P:N:tb:R:B:ksSiTm:M:H:qV";
 		c = getopt_long (argc-1, argv+1, opts, long_options, &option_index);
 		if (c == -1)
 			break;
@@ -5799,6 +5887,9 @@ static void parse_record_options(int argc,
 		case 'i':
 			ignore_event_not_found = 1;
 			break;
+		case 'V':
+			show_status = 1;
+			break;
 		case OPT_user:
 			ctx->user = strdup(optarg);
 			if (!ctx->user)
@@ -5870,6 +5961,14 @@ static void parse_record_options(int argc,
 		case 'q':
 			quiet = true;
 			break;
+		case OPT_sql:
+			ctx->auto_triggers = 1;
+			ret = sqlhist_parse(optarg, strlen(optarg) + 1,
+					    &ctx->instance->auto_triggers,
+					    &ctx->instance->synth_events);
+			if (ret < 0)
+				die("Failed to parse sql argument");
+			break;
 		default:
 			usage(argv);
 		}
@@ -5947,6 +6046,8 @@ static void finalize_record_trace(struct common_record_context *ctx)
 	update_reset_triggers();
 	if (clear_function_filters)
 		clear_func_filters();
+	clear_auto_triggers();
+	clear_synthetic_events();
 
 	set_plugin("nop");
 
@@ -6021,6 +6122,11 @@ static void record_trace(int argc, char **argv,
 
 	make_instances();
 
+	if (ctx->auto_triggers) {
+		for_all_instances(instance)
+			set_synth_events(instance);
+	}
+
 	if (ctx->events)
 		expand_event_list();
 
@@ -6048,6 +6154,10 @@ static void record_trace(int argc, char **argv,
 			enable_events(instance);
 	}
 
+	if (ctx->auto_triggers) {
+		for_all_instances(instance)
+			set_auto_triggers(instance);
+	}
 	set_saved_cmdlines_size(ctx);
 	set_buffer_size();
 	update_plugins(type);
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 502a410..ba196ec 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -60,6 +60,8 @@ static struct usage_help usage_help[] = {
 		"          --no-filter include trace-cmd threads in the trace\n"
 		"          --proc-map save the traced processes address map into the trace.dat file\n"
 		"          --user execute the specified [command ...] as given user\n"
+		"          --sql generate necessary ftrace syntetic events and triggers, based on the given sql query\n"
+		"          -V dump ftrace configuration, auto generated by the --sql option"
 	},
 	{
 		"start",
-- 
2.24.1

