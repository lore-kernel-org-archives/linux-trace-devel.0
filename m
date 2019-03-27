Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E93C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 14:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A62122147C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 14:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfC0OUH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:20:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52823 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbfC0OT5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 10:19:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id a184so224034wma.2;
        Wed, 27 Mar 2019 07:19:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b6URzg13Yrjtbuoibfd+2+25u3pYGPKUtYG7LlZYHWo=;
        b=KSStZzBmaOkgut8BKJ3suEH/tPE2BZ1a+FA6Eak0+OGdIDyDgmhPucfu/M3fT6vWyq
         494qG4VboEoO9ISc6Jr2cvj9gRW70BllnKj3DofJhckT9OJKBSlVXrZeNra+Jji4liA3
         Mp69/ldJGYrKCzLxKScbbnr9JZt+nU4k26QaCE7ZwITKmlQ9c87jVuuiS6AC/pRWP2x6
         FjUH0UH6+9pi9MxqxFGqnyB1d86SkkNU5QEoxS11yQNCVofFLW6RXJmaKsRqt1hNqsrj
         MchcMzrLIQ9zhMeBVT3QcmBN0dx3OklY2joxxa7Ne5JFjkEPZ6UhMsSaqnf+xytu1WCJ
         cNHA==
X-Gm-Message-State: APjAAAX6HFT2/A/lP2GoN7cTfGN6qeLpjznm+1YlyMBmmZ5w/rAMEw7V
        epaZ1tTSbhe9CTF2+kEmPOA=
X-Google-Smtp-Source: APXvYqwvbQS8pvBcNtVICG3Q2xYZikPN8pfcHACATiHpWL7E4uTlC4eVWxZKOPbH8uSAXLuExrWpRg==
X-Received: by 2002:a1c:a9cb:: with SMTP id s194mr16827993wme.62.1553696394225;
        Wed, 27 Mar 2019 07:19:54 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t69sm205022wmt.16.2019.03.27.07.19.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 Mar 2019 07:19:53 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] tools/lib/traceevent: Rename input arguments and local variables of libtraceevent from pevent to tep
Date:   Wed, 27 Mar 2019 16:19:46 +0200
Message-Id: <20190327141946.4353-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190327141946.4353-1-tstoyanov@vmware.com>
References: <20190327141946.4353-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch renames from "pevent" to "tep":
 - all "pevent" input arguments of libtraceevent internal functions.
 - all local "pevent" variables of libtraceevent.
This makes the implementation consistent with the chosen naming convention,
tep (trace event parser), and will avoid any confusion with the old pevent name

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse.c     | 306 ++++++++++++-------------
 tools/lib/traceevent/event-plugin.c    |  24 +-
 tools/lib/traceevent/parse-filter.c    |  26 +--
 tools/lib/traceevent/plugin_function.c |   6 +-
 4 files changed, 181 insertions(+), 181 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 18fb22a89ef2..a6a7c9f561a5 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -148,14 +148,14 @@ struct cmdline_list {
 	int			pid;
 };
 
-static int cmdline_init(struct tep_handle *pevent)
+static int cmdline_init(struct tep_handle *tep)
 {
-	struct cmdline_list *cmdlist = pevent->cmdlist;
+	struct cmdline_list *cmdlist = tep->cmdlist;
 	struct cmdline_list *item;
 	struct tep_cmdline *cmdlines;
 	int i;
 
-	cmdlines = malloc(sizeof(*cmdlines) * pevent->cmdline_count);
+	cmdlines = malloc(sizeof(*cmdlines) * tep->cmdline_count);
 	if (!cmdlines)
 		return -1;
 
@@ -169,15 +169,15 @@ static int cmdline_init(struct tep_handle *pevent)
 		free(item);
 	}
 
-	qsort(cmdlines, pevent->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
+	qsort(cmdlines, tep->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
 
-	pevent->cmdlines = cmdlines;
-	pevent->cmdlist = NULL;
+	tep->cmdlines = cmdlines;
+	tep->cmdlist = NULL;
 
 	return 0;
 }
 
-static const char *find_cmdline(struct tep_handle *pevent, int pid)
+static const char *find_cmdline(struct tep_handle *tep, int pid)
 {
 	const struct tep_cmdline *comm;
 	struct tep_cmdline key;
@@ -185,13 +185,13 @@ static const char *find_cmdline(struct tep_handle *pevent, int pid)
 	if (!pid)
 		return "<idle>";
 
-	if (!pevent->cmdlines && cmdline_init(pevent))
+	if (!tep->cmdlines && cmdline_init(tep))
 		return "<not enough memory for cmdlines!>";
 
 	key.pid = pid;
 
-	comm = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
-		       sizeof(*pevent->cmdlines), cmdline_cmp);
+	comm = bsearch(&key, tep->cmdlines, tep->cmdline_count,
+		       sizeof(*tep->cmdlines), cmdline_cmp);
 
 	if (comm)
 		return comm->comm;
@@ -232,10 +232,10 @@ bool tep_is_pid_registered(struct tep_handle *tep, int pid)
  * we must add this pid. This is much slower than when cmdlines
  * are added before the array is initialized.
  */
-static int add_new_comm(struct tep_handle *pevent,
+static int add_new_comm(struct tep_handle *tep,
 			const char *comm, int pid, bool override)
 {
-	struct tep_cmdline *cmdlines = pevent->cmdlines;
+	struct tep_cmdline *cmdlines = tep->cmdlines;
 	struct tep_cmdline *cmdline;
 	struct tep_cmdline key;
 	char *new_comm;
@@ -246,8 +246,8 @@ static int add_new_comm(struct tep_handle *pevent,
 	/* avoid duplicates */
 	key.pid = pid;
 
-	cmdline = bsearch(&key, pevent->cmdlines, pevent->cmdline_count,
-		       sizeof(*pevent->cmdlines), cmdline_cmp);
+	cmdline = bsearch(&key, tep->cmdlines, tep->cmdline_count,
+			  sizeof(*tep->cmdlines), cmdline_cmp);
 	if (cmdline) {
 		if (!override) {
 			errno = EEXIST;
@@ -264,26 +264,26 @@ static int add_new_comm(struct tep_handle *pevent,
 		return 0;
 	}
 
-	cmdlines = realloc(cmdlines, sizeof(*cmdlines) * (pevent->cmdline_count + 1));
+	cmdlines = realloc(cmdlines, sizeof(*cmdlines) * (tep->cmdline_count + 1));
 	if (!cmdlines) {
 		errno = ENOMEM;
 		return -1;
 	}
 
-	cmdlines[pevent->cmdline_count].comm = strdup(comm);
-	if (!cmdlines[pevent->cmdline_count].comm) {
+	cmdlines[tep->cmdline_count].comm = strdup(comm);
+	if (!cmdlines[tep->cmdline_count].comm) {
 		free(cmdlines);
 		errno = ENOMEM;
 		return -1;
 	}
 
-	cmdlines[pevent->cmdline_count].pid = pid;
+	cmdlines[tep->cmdline_count].pid = pid;
 		
-	if (cmdlines[pevent->cmdline_count].comm)
-		pevent->cmdline_count++;
+	if (cmdlines[tep->cmdline_count].comm)
+		tep->cmdline_count++;
 
-	qsort(cmdlines, pevent->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
-	pevent->cmdlines = cmdlines;
+	qsort(cmdlines, tep->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
+	tep->cmdlines = cmdlines;
 
 	return 0;
 }
@@ -408,18 +408,18 @@ static int func_bcmp(const void *a, const void *b)
 	return 1;
 }
 
-static int func_map_init(struct tep_handle *pevent)
+static int func_map_init(struct tep_handle *tep)
 {
 	struct func_list *funclist;
 	struct func_list *item;
 	struct func_map *func_map;
 	int i;
 
-	func_map = malloc(sizeof(*func_map) * (pevent->func_count + 1));
+	func_map = malloc(sizeof(*func_map) * (tep->func_count + 1));
 	if (!func_map)
 		return -1;
 
-	funclist = pevent->funclist;
+	funclist = tep->funclist;
 
 	i = 0;
 	while (funclist) {
@@ -432,34 +432,34 @@ static int func_map_init(struct tep_handle *pevent)
 		free(item);
 	}
 
-	qsort(func_map, pevent->func_count, sizeof(*func_map), func_cmp);
+	qsort(func_map, tep->func_count, sizeof(*func_map), func_cmp);
 
 	/*
 	 * Add a special record at the end.
 	 */
-	func_map[pevent->func_count].func = NULL;
-	func_map[pevent->func_count].addr = 0;
-	func_map[pevent->func_count].mod = NULL;
+	func_map[tep->func_count].func = NULL;
+	func_map[tep->func_count].addr = 0;
+	func_map[tep->func_count].mod = NULL;
 
-	pevent->func_map = func_map;
-	pevent->funclist = NULL;
+	tep->func_map = func_map;
+	tep->funclist = NULL;
 
 	return 0;
 }
 
 static struct func_map *
-__find_func(struct tep_handle *pevent, unsigned long long addr)
+__find_func(struct tep_handle *tep, unsigned long long addr)
 {
 	struct func_map *func;
 	struct func_map key;
 
-	if (!pevent->func_map)
-		func_map_init(pevent);
+	if (!tep->func_map)
+		func_map_init(tep);
 
 	key.addr = addr;
 
-	func = bsearch(&key, pevent->func_map, pevent->func_count,
-		       sizeof(*pevent->func_map), func_bcmp);
+	func = bsearch(&key, tep->func_map, tep->func_count,
+		       sizeof(*tep->func_map), func_bcmp);
 
 	return func;
 }
@@ -510,18 +510,18 @@ void tep_reset_function_resolver(struct tep_handle *tep)
 }
 
 static struct func_map *
-find_func(struct tep_handle *pevent, unsigned long long addr)
+find_func(struct tep_handle *tep, unsigned long long addr)
 {
 	struct func_map *map;
 
-	if (!pevent->func_resolver)
-		return __find_func(pevent, addr);
+	if (!tep->func_resolver)
+		return __find_func(tep, addr);
 
-	map = &pevent->func_resolver->map;
+	map = &tep->func_resolver->map;
 	map->mod  = NULL;
 	map->addr = addr;
-	map->func = pevent->func_resolver->func(pevent->func_resolver->priv,
-						&map->addr, &map->mod);
+	map->func = tep->func_resolver->func(tep->func_resolver->priv,
+					     &map->addr, &map->mod);
 	if (map->func == NULL)
 		return NULL;
 
@@ -662,18 +662,18 @@ static int printk_cmp(const void *a, const void *b)
 	return 0;
 }
 
-static int printk_map_init(struct tep_handle *pevent)
+static int printk_map_init(struct tep_handle *tep)
 {
 	struct printk_list *printklist;
 	struct printk_list *item;
 	struct printk_map *printk_map;
 	int i;
 
-	printk_map = malloc(sizeof(*printk_map) * (pevent->printk_count + 1));
+	printk_map = malloc(sizeof(*printk_map) * (tep->printk_count + 1));
 	if (!printk_map)
 		return -1;
 
-	printklist = pevent->printklist;
+	printklist = tep->printklist;
 
 	i = 0;
 	while (printklist) {
@@ -685,27 +685,27 @@ static int printk_map_init(struct tep_handle *pevent)
 		free(item);
 	}
 
-	qsort(printk_map, pevent->printk_count, sizeof(*printk_map), printk_cmp);
+	qsort(printk_map, tep->printk_count, sizeof(*printk_map), printk_cmp);
 
-	pevent->printk_map = printk_map;
-	pevent->printklist = NULL;
+	tep->printk_map = printk_map;
+	tep->printklist = NULL;
 
 	return 0;
 }
 
 static struct printk_map *
-find_printk(struct tep_handle *pevent, unsigned long long addr)
+find_printk(struct tep_handle *tep, unsigned long long addr)
 {
 	struct printk_map *printk;
 	struct printk_map key;
 
-	if (!pevent->printk_map && printk_map_init(pevent))
+	if (!tep->printk_map && printk_map_init(tep))
 		return NULL;
 
 	key.addr = addr;
 
-	printk = bsearch(&key, pevent->printk_map, pevent->printk_count,
-			 sizeof(*pevent->printk_map), printk_cmp);
+	printk = bsearch(&key, tep->printk_map, tep->printk_count,
+			 sizeof(*tep->printk_map), printk_cmp);
 
 	return printk;
 }
@@ -782,29 +782,29 @@ static struct tep_event *alloc_event(void)
 	return calloc(1, sizeof(struct tep_event));
 }
 
-static int add_event(struct tep_handle *pevent, struct tep_event *event)
+static int add_event(struct tep_handle *tep, struct tep_event *event)
 {
 	int i;
-	struct tep_event **events = realloc(pevent->events, sizeof(event) *
-					    (pevent->nr_events + 1));
+	struct tep_event **events = realloc(tep->events, sizeof(event) *
+					    (tep->nr_events + 1));
 	if (!events)
 		return -1;
 
-	pevent->events = events;
+	tep->events = events;
 
-	for (i = 0; i < pevent->nr_events; i++) {
-		if (pevent->events[i]->id > event->id)
+	for (i = 0; i < tep->nr_events; i++) {
+		if (tep->events[i]->id > event->id)
 			break;
 	}
-	if (i < pevent->nr_events)
-		memmove(&pevent->events[i + 1],
-			&pevent->events[i],
-			sizeof(event) * (pevent->nr_events - i));
+	if (i < tep->nr_events)
+		memmove(&tep->events[i + 1],
+			&tep->events[i],
+			sizeof(event) * (tep->nr_events - i));
 
-	pevent->events[i] = event;
-	pevent->nr_events++;
+	tep->events[i] = event;
+	tep->nr_events++;
 
-	event->tep = pevent;
+	event->tep = tep;
 
 	return 0;
 }
@@ -2941,14 +2941,14 @@ process_bitmask(struct tep_event *event __maybe_unused, struct tep_print_arg *ar
 }
 
 static struct tep_function_handler *
-find_func_handler(struct tep_handle *pevent, char *func_name)
+find_func_handler(struct tep_handle *tep, char *func_name)
 {
 	struct tep_function_handler *func;
 
-	if (!pevent)
+	if (!tep)
 		return NULL;
 
-	for (func = pevent->func_handlers; func; func = func->next) {
+	for (func = tep->func_handlers; func; func = func->next) {
 		if (strcmp(func->name, func_name) == 0)
 			break;
 	}
@@ -2956,12 +2956,12 @@ find_func_handler(struct tep_handle *pevent, char *func_name)
 	return func;
 }
 
-static void remove_func_handler(struct tep_handle *pevent, char *func_name)
+static void remove_func_handler(struct tep_handle *tep, char *func_name)
 {
 	struct tep_function_handler *func;
 	struct tep_function_handler **next;
 
-	next = &pevent->func_handlers;
+	next = &tep->func_handlers;
 	while ((func = *next)) {
 		if (strcmp(func->name, func_name) == 0) {
 			*next = func->next;
@@ -3413,7 +3413,7 @@ int tep_read_number_field(struct tep_format_field *field, const void *data,
 	}
 }
 
-static int get_common_info(struct tep_handle *pevent,
+static int get_common_info(struct tep_handle *tep,
 			   const char *type, int *offset, int *size)
 {
 	struct tep_event *event;
@@ -3423,12 +3423,12 @@ static int get_common_info(struct tep_handle *pevent,
 	 * All events should have the same common elements.
 	 * Pick any event to find where the type is;
 	 */
-	if (!pevent->events) {
+	if (!tep->events) {
 		do_warning("no event_list!");
 		return -1;
 	}
 
-	event = pevent->events[0];
+	event = tep->events[0];
 	field = tep_find_common_field(event, type);
 	if (!field)
 		return -1;
@@ -3439,58 +3439,58 @@ static int get_common_info(struct tep_handle *pevent,
 	return 0;
 }
 
-static int __parse_common(struct tep_handle *pevent, void *data,
+static int __parse_common(struct tep_handle *tep, void *data,
 			  int *size, int *offset, const char *name)
 {
 	int ret;
 
 	if (!*size) {
-		ret = get_common_info(pevent, name, offset, size);
+		ret = get_common_info(tep, name, offset, size);
 		if (ret < 0)
 			return ret;
 	}
-	return tep_read_number(pevent, data + *offset, *size);
+	return tep_read_number(tep, data + *offset, *size);
 }
 
-static int trace_parse_common_type(struct tep_handle *pevent, void *data)
+static int trace_parse_common_type(struct tep_handle *tep, void *data)
 {
-	return __parse_common(pevent, data,
-			      &pevent->type_size, &pevent->type_offset,
+	return __parse_common(tep, data,
+			      &tep->type_size, &tep->type_offset,
 			      "common_type");
 }
 
-static int parse_common_pid(struct tep_handle *pevent, void *data)
+static int parse_common_pid(struct tep_handle *tep, void *data)
 {
-	return __parse_common(pevent, data,
-			      &pevent->pid_size, &pevent->pid_offset,
+	return __parse_common(tep, data,
+			      &tep->pid_size, &tep->pid_offset,
 			      "common_pid");
 }
 
-static int parse_common_pc(struct tep_handle *pevent, void *data)
+static int parse_common_pc(struct tep_handle *tep, void *data)
 {
-	return __parse_common(pevent, data,
-			      &pevent->pc_size, &pevent->pc_offset,
+	return __parse_common(tep, data,
+			      &tep->pc_size, &tep->pc_offset,
 			      "common_preempt_count");
 }
 
-static int parse_common_flags(struct tep_handle *pevent, void *data)
+static int parse_common_flags(struct tep_handle *tep, void *data)
 {
-	return __parse_common(pevent, data,
-			      &pevent->flags_size, &pevent->flags_offset,
+	return __parse_common(tep, data,
+			      &tep->flags_size, &tep->flags_offset,
 			      "common_flags");
 }
 
-static int parse_common_lock_depth(struct tep_handle *pevent, void *data)
+static int parse_common_lock_depth(struct tep_handle *tep, void *data)
 {
-	return __parse_common(pevent, data,
-			      &pevent->ld_size, &pevent->ld_offset,
+	return __parse_common(tep, data,
+			      &tep->ld_size, &tep->ld_offset,
 			      "common_lock_depth");
 }
 
-static int parse_common_migrate_disable(struct tep_handle *pevent, void *data)
+static int parse_common_migrate_disable(struct tep_handle *tep, void *data)
 {
-	return __parse_common(pevent, data,
-			      &pevent->ld_size, &pevent->ld_offset,
+	return __parse_common(tep, data,
+			      &tep->ld_size, &tep->ld_offset,
 			      "common_migrate_disable");
 }
 
@@ -3566,7 +3566,7 @@ tep_find_event_by_name(struct tep_handle *tep,
 static unsigned long long
 eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg *arg)
 {
-	struct tep_handle *pevent = event->tep;
+	struct tep_handle *tep = event->tep;
 	unsigned long long val = 0;
 	unsigned long long left, right;
 	struct tep_print_arg *typearg = NULL;
@@ -3588,7 +3588,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			
 		}
 		/* must be a number */
-		val = tep_read_number(pevent, data + arg->field.field->offset,
+		val = tep_read_number(tep, data + arg->field.field->offset,
 				      arg->field.field->size);
 		break;
 	case TEP_PRINT_FLAGS:
@@ -3628,11 +3628,11 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			}
 
 			/* Default to long size */
-			field_size = pevent->long_size;
+			field_size = tep->long_size;
 
 			switch (larg->type) {
 			case TEP_PRINT_DYNAMIC_ARRAY:
-				offset = tep_read_number(pevent,
+				offset = tep_read_number(tep,
 						   data + larg->dynarray.field->offset,
 						   larg->dynarray.field->size);
 				if (larg->dynarray.field->elementsize)
@@ -3661,7 +3661,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 			default:
 				goto default_op; /* oops, all bets off */
 			}
-			val = tep_read_number(pevent,
+			val = tep_read_number(tep,
 					      data + offset, field_size);
 			if (typearg)
 				val = eval_type(val, typearg, 1);
@@ -3762,7 +3762,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 		}
 		break;
 	case TEP_PRINT_DYNAMIC_ARRAY_LEN:
-		offset = tep_read_number(pevent,
+		offset = tep_read_number(tep,
 					 data + arg->dynarray.field->offset,
 					 arg->dynarray.field->size);
 		/*
@@ -3774,7 +3774,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 		break;
 	case TEP_PRINT_DYNAMIC_ARRAY:
 		/* Without [], we pass the address to the dynamic data */
-		offset = tep_read_number(pevent,
+		offset = tep_read_number(tep,
 					 data + arg->dynarray.field->offset,
 					 arg->dynarray.field->size);
 		/*
@@ -3849,7 +3849,7 @@ static void print_str_to_seq(struct trace_seq *s, const char *format,
 		trace_seq_printf(s, format, str);
 }
 
-static void print_bitmask_to_seq(struct tep_handle *pevent,
+static void print_bitmask_to_seq(struct tep_handle *tep,
 				 struct trace_seq *s, const char *format,
 				 int len_arg, const void *data, int size)
 {
@@ -3881,7 +3881,7 @@ static void print_bitmask_to_seq(struct tep_handle *pevent,
 		 * In the kernel, this is an array of long words, thus
 		 * endianness is very important.
 		 */
-		if (pevent->file_bigendian)
+		if (tep->file_bigendian)
 			index = size - (len + 1);
 		else
 			index = len;
@@ -3907,7 +3907,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			  struct tep_event *event, const char *format,
 			  int len_arg, struct tep_print_arg *arg)
 {
-	struct tep_handle *pevent = event->tep;
+	struct tep_handle *tep = event->tep;
 	struct tep_print_flag_sym *flag;
 	struct tep_format_field *field;
 	struct printk_map *printk;
@@ -3944,7 +3944,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 		 * is a pointer.
 		 */
 		if (!(field->flags & TEP_FIELD_IS_ARRAY) &&
-		    field->size == pevent->long_size) {
+		    field->size == tep->long_size) {
 
 			/* Handle heterogeneous recording and processing
 			 * architectures
@@ -3959,12 +3959,12 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			 * on 32-bit devices:
 			 * In this case, 64 bits must be read.
 			 */
-			addr = (pevent->long_size == 8) ?
+			addr = (tep->long_size == 8) ?
 				*(unsigned long long *)(data + field->offset) :
 				(unsigned long long)*(unsigned int *)(data + field->offset);
 
 			/* Check if it matches a print format */
-			printk = find_printk(pevent, addr);
+			printk = find_printk(tep, addr);
 			if (printk)
 				trace_seq_puts(s, printk->printk);
 			else
@@ -4021,7 +4021,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 	case TEP_PRINT_HEX_STR:
 		if (arg->hex.field->type == TEP_PRINT_DYNAMIC_ARRAY) {
 			unsigned long offset;
-			offset = tep_read_number(pevent,
+			offset = tep_read_number(tep,
 				data + arg->hex.field->dynarray.field->offset,
 				arg->hex.field->dynarray.field->size);
 			hex = data + (offset & 0xffff);
@@ -4052,7 +4052,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			unsigned long offset;
 			struct tep_format_field *field =
 				arg->int_array.field->dynarray.field;
-			offset = tep_read_number(pevent,
+			offset = tep_read_number(tep,
 						 data + field->offset,
 						 field->size);
 			num = data + (offset & 0xffff);
@@ -4103,7 +4103,7 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			f = tep_find_any_field(event, arg->string.string);
 			arg->string.offset = f->offset;
 		}
-		str_offset = tep_data2host4(pevent, *(unsigned int *)(data + arg->string.offset));
+		str_offset = tep_data2host4(tep, *(unsigned int *)(data + arg->string.offset));
 		str_offset &= 0xffff;
 		print_str_to_seq(s, format, len_arg, ((char *)data) + str_offset);
 		break;
@@ -4121,10 +4121,10 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
 			f = tep_find_any_field(event, arg->bitmask.bitmask);
 			arg->bitmask.offset = f->offset;
 		}
-		bitmask_offset = tep_data2host4(pevent, *(unsigned int *)(data + arg->bitmask.offset));
+		bitmask_offset = tep_data2host4(tep, *(unsigned int *)(data + arg->bitmask.offset));
 		bitmask_size = bitmask_offset >> 16;
 		bitmask_offset &= 0xffff;
-		print_bitmask_to_seq(pevent, s, format, len_arg,
+		print_bitmask_to_seq(tep, s, format, len_arg,
 				     data + bitmask_offset, bitmask_size);
 		break;
 	}
@@ -4256,7 +4256,7 @@ static void free_args(struct tep_print_arg *args)
 
 static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, struct tep_event *event)
 {
-	struct tep_handle *pevent = event->tep;
+	struct tep_handle *tep = event->tep;
 	struct tep_format_field *field, *ip_field;
 	struct tep_print_arg *args, *arg, **next;
 	unsigned long long ip, val;
@@ -4264,8 +4264,8 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
 	void *bptr;
 	int vsize = 0;
 
-	field = pevent->bprint_buf_field;
-	ip_field = pevent->bprint_ip_field;
+	field = tep->bprint_buf_field;
+	ip_field = tep->bprint_ip_field;
 
 	if (!field) {
 		field = tep_find_field(event, "buf");
@@ -4278,11 +4278,11 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
 			do_warning_event(event, "can't find ip field for binary printk");
 			return NULL;
 		}
-		pevent->bprint_buf_field = field;
-		pevent->bprint_ip_field = ip_field;
+		tep->bprint_buf_field = field;
+		tep->bprint_ip_field = ip_field;
 	}
 
-	ip = tep_read_number(pevent, data + ip_field->offset, ip_field->size);
+	ip = tep_read_number(tep, data + ip_field->offset, ip_field->size);
 
 	/*
 	 * The first arg is the IP pointer.
@@ -4359,7 +4359,7 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
 					vsize = 4;
 					break;
 				case 1:
-					vsize = pevent->long_size;
+					vsize = tep->long_size;
 					break;
 				case 2:
 					vsize = 8;
@@ -4376,7 +4376,7 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
 				/* the pointers are always 4 bytes aligned */
 				bptr = (void *)(((unsigned long)bptr + 3) &
 						~3);
-				val = tep_read_number(pevent, bptr, vsize);
+				val = tep_read_number(tep, bptr, vsize);
 				bptr += vsize;
 				arg = alloc_arg();
 				if (!arg) {
@@ -4433,13 +4433,13 @@ static char *
 get_bprint_format(void *data, int size __maybe_unused,
 		  struct tep_event *event)
 {
-	struct tep_handle *pevent = event->tep;
+	struct tep_handle *tep = event->tep;
 	unsigned long long addr;
 	struct tep_format_field *field;
 	struct printk_map *printk;
 	char *format;
 
-	field = pevent->bprint_fmt_field;
+	field = tep->bprint_fmt_field;
 
 	if (!field) {
 		field = tep_find_field(event, "fmt");
@@ -4447,12 +4447,12 @@ get_bprint_format(void *data, int size __maybe_unused,
 			do_warning_event(event, "can't find format field for binary printk");
 			return NULL;
 		}
-		pevent->bprint_fmt_field = field;
+		tep->bprint_fmt_field = field;
 	}
 
-	addr = tep_read_number(pevent, data + field->offset, field->size);
+	addr = tep_read_number(tep, data + field->offset, field->size);
 
-	printk = find_printk(pevent, addr);
+	printk = find_printk(tep, addr);
 	if (!printk) {
 		if (asprintf(&format, "%%pf: (NO FORMAT FOUND at %llx)\n", addr) < 0)
 			return NULL;
@@ -4834,13 +4834,13 @@ void tep_print_field(struct trace_seq *s, void *data,
 {
 	unsigned long long val;
 	unsigned int offset, len, i;
-	struct tep_handle *pevent = field->event->tep;
+	struct tep_handle *tep = field->event->tep;
 
 	if (field->flags & TEP_FIELD_IS_ARRAY) {
 		offset = field->offset;
 		len = field->size;
 		if (field->flags & TEP_FIELD_IS_DYNAMIC) {
-			val = tep_read_number(pevent, data + offset, len);
+			val = tep_read_number(tep, data + offset, len);
 			offset = val;
 			len = offset >> 16;
 			offset &= 0xffff;
@@ -4860,7 +4860,7 @@ void tep_print_field(struct trace_seq *s, void *data,
 			field->flags &= ~TEP_FIELD_IS_STRING;
 		}
 	} else {
-		val = tep_read_number(pevent, data + field->offset,
+		val = tep_read_number(tep, data + field->offset,
 				      field->size);
 		if (field->flags & TEP_FIELD_IS_POINTER) {
 			trace_seq_printf(s, "0x%llx", val);
@@ -4909,7 +4909,7 @@ void tep_print_fields(struct trace_seq *s, void *data,
 
 static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_event *event)
 {
-	struct tep_handle *pevent = event->tep;
+	struct tep_handle *tep = event->tep;
 	struct tep_print_fmt *print_fmt = &event->print_fmt;
 	struct tep_print_arg *arg = print_fmt->args;
 	struct tep_print_arg *args = NULL;
@@ -5001,7 +5001,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 			case '-':
 				goto cont_process;
 			case 'p':
-				if (pevent->long_size == 4)
+				if (tep->long_size == 4)
 					ls = 1;
 				else
 					ls = 2;
@@ -5062,7 +5062,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 				arg = arg->next;
 
 				if (show_func) {
-					func = find_func(pevent, val);
+					func = find_func(tep, val);
 					if (func) {
 						trace_seq_puts(s, func->func);
 						if (show_func == 'F')
@@ -5072,7 +5072,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 						break;
 					}
 				}
-				if (pevent->long_size == 8 && ls == 1 &&
+				if (tep->long_size == 8 && ls == 1 &&
 				    sizeof(long) != 8) {
 					char *p;
 
@@ -5319,14 +5319,14 @@ const char *tep_data_comm_from_pid(struct tep_handle *tep, int pid)
 }
 
 static struct tep_cmdline *
-pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct tep_cmdline *next)
+pid_from_cmdlist(struct tep_handle *tep, const char *comm, struct tep_cmdline *next)
 {
 	struct cmdline_list *cmdlist = (struct cmdline_list *)next;
 
 	if (cmdlist)
 		cmdlist = cmdlist->next;
 	else
-		cmdlist = pevent->cmdlist;
+		cmdlist = tep->cmdlist;
 
 	while (cmdlist && strcmp(cmdlist->comm, comm) != 0)
 		cmdlist = cmdlist->next;
@@ -6012,11 +6012,11 @@ static void free_handler(struct event_handler *handle)
 	free(handle);
 }
 
-static int find_event_handle(struct tep_handle *pevent, struct tep_event *event)
+static int find_event_handle(struct tep_handle *tep, struct tep_event *event)
 {
 	struct event_handler *handle, **next;
 
-	for (next = &pevent->handlers; *next;
+	for (next = &tep->handlers; *next;
 	     next = &(*next)->next) {
 		handle = *next;
 		if (event_matches(event, handle->id,
@@ -6054,7 +6054,7 @@ static int find_event_handle(struct tep_handle *pevent, struct tep_event *event)
  * /sys/kernel/debug/tracing/events/.../.../format
  */
 enum tep_errno __tep_parse_format(struct tep_event **eventp,
-				  struct tep_handle *pevent, const char *buf,
+				  struct tep_handle *tep, const char *buf,
 				  unsigned long size, const char *sys)
 {
 	struct tep_event *event;
@@ -6096,8 +6096,8 @@ enum tep_errno __tep_parse_format(struct tep_event **eventp,
 		goto event_alloc_failed;
 	}
 
-	/* Add pevent to event so that it can be referenced */
-	event->tep = pevent;
+	/* Add tep to event so that it can be referenced */
+	event->tep = tep;
 
 	ret = event_read_format(event);
 	if (ret < 0) {
@@ -6109,7 +6109,7 @@ enum tep_errno __tep_parse_format(struct tep_event **eventp,
 	 * If the event has an override, don't print warnings if the event
 	 * print format fails to parse.
 	 */
-	if (pevent && find_event_handle(pevent, event))
+	if (tep && find_event_handle(tep, event))
 		show_warning = 0;
 
 	ret = event_read_print(event);
@@ -6161,18 +6161,18 @@ enum tep_errno __tep_parse_format(struct tep_event **eventp,
 }
 
 static enum tep_errno
-__parse_event(struct tep_handle *pevent,
+__parse_event(struct tep_handle *tep,
 	      struct tep_event **eventp,
 	      const char *buf, unsigned long size,
 	      const char *sys)
 {
-	int ret = __tep_parse_format(eventp, pevent, buf, size, sys);
+	int ret = __tep_parse_format(eventp, tep, buf, size, sys);
 	struct tep_event *event = *eventp;
 
 	if (event == NULL)
 		return ret;
 
-	if (pevent && add_event(pevent, event)) {
+	if (tep && add_event(tep, event)) {
 		ret = TEP_ERRNO__MEM_ALLOC_FAILED;
 		goto event_add_failed;
 	}
@@ -6426,7 +6426,7 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			 struct tep_record *record, int err)
 {
 	struct tep_format_field *field = tep_find_field(event, name);
-	struct tep_handle *pevent = event->tep;
+	struct tep_handle *tep = event->tep;
 	unsigned long long val;
 	struct func_map *func;
 	char tmp[128];
@@ -6437,7 +6437,7 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 	if (tep_read_number_field(field, record->data, &val))
 		goto failed;
 
-	func = find_func(pevent, val);
+	func = find_func(tep, val);
 
 	if (func)
 		snprintf(tmp, 128, "%s/0x%llx", func->func, func->addr - val);
@@ -6582,7 +6582,7 @@ int tep_unregister_print_function(struct tep_handle *tep,
 	return -1;
 }
 
-static struct tep_event *search_event(struct tep_handle *pevent, int id,
+static struct tep_event *search_event(struct tep_handle *tep, int id,
 				      const char *sys_name,
 				      const char *event_name)
 {
@@ -6590,7 +6590,7 @@ static struct tep_event *search_event(struct tep_handle *pevent, int id,
 
 	if (id >= 0) {
 		/* search by id */
-		event = tep_find_event(pevent, id);
+		event = tep_find_event(tep, id);
 		if (!event)
 			return NULL;
 		if (event_name && (strcmp(event_name, event->name) != 0))
@@ -6598,7 +6598,7 @@ static struct tep_event *search_event(struct tep_handle *pevent, int id,
 		if (sys_name && (strcmp(sys_name, event->system) != 0))
 			return NULL;
 	} else {
-		event = tep_find_event_by_name(pevent, sys_name, event_name);
+		event = tep_find_event_by_name(tep, sys_name, event_name);
 		if (!event)
 			return NULL;
 	}
@@ -6755,14 +6755,14 @@ int tep_unregister_event_handler(struct tep_handle *tep, int id,
  */
 struct tep_handle *tep_alloc(void)
 {
-	struct tep_handle *pevent = calloc(1, sizeof(*pevent));
+	struct tep_handle *tep = calloc(1, sizeof(*tep));
 
-	if (pevent) {
-		pevent->ref_count = 1;
-		pevent->host_bigendian = tep_is_bigendian();
+	if (tep) {
+		tep->ref_count = 1;
+		tep->host_bigendian = tep_is_bigendian();
 	}
 
-	return pevent;
+	return tep;
 }
 
 void tep_ref(struct tep_handle *tep)
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index d0488de0174a..8ca28de9337a 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -269,7 +269,7 @@ void tep_print_plugins(struct trace_seq *s,
 }
 
 static void
-load_plugin(struct tep_handle *pevent, const char *path,
+load_plugin(struct tep_handle *tep, const char *path,
 	    const char *file, void *data)
 {
 	struct tep_plugin_list **plugin_list = data;
@@ -316,7 +316,7 @@ load_plugin(struct tep_handle *pevent, const char *path,
 	*plugin_list = list;
 
 	pr_stat("registering plugin: %s", plugin);
-	func(pevent);
+	func(tep);
 	return;
 
  out_free:
@@ -324,9 +324,9 @@ load_plugin(struct tep_handle *pevent, const char *path,
 }
 
 static void
-load_plugins_dir(struct tep_handle *pevent, const char *suffix,
+load_plugins_dir(struct tep_handle *tep, const char *suffix,
 		 const char *path,
-		 void (*load_plugin)(struct tep_handle *pevent,
+		 void (*load_plugin)(struct tep_handle *tep,
 				     const char *path,
 				     const char *name,
 				     void *data),
@@ -359,15 +359,15 @@ load_plugins_dir(struct tep_handle *pevent, const char *suffix,
 		if (strcmp(name + (strlen(name) - strlen(suffix)), suffix) != 0)
 			continue;
 
-		load_plugin(pevent, path, name, data);
+		load_plugin(tep, path, name, data);
 	}
 
 	closedir(dir);
 }
 
 static void
-load_plugins(struct tep_handle *pevent, const char *suffix,
-	     void (*load_plugin)(struct tep_handle *pevent,
+load_plugins(struct tep_handle *tep, const char *suffix,
+	     void (*load_plugin)(struct tep_handle *tep,
 				 const char *path,
 				 const char *name,
 				 void *data),
@@ -378,7 +378,7 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 	char *envdir;
 	int ret;
 
-	if (pevent->flags & TEP_DISABLE_PLUGINS)
+	if (tep->flags & TEP_DISABLE_PLUGINS)
 		return;
 
 	/*
@@ -386,8 +386,8 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 	 * check that first.
 	 */
 #ifdef PLUGIN_DIR
-	if (!(pevent->flags & TEP_DISABLE_SYS_PLUGINS))
-		load_plugins_dir(pevent, suffix, PLUGIN_DIR,
+	if (!(tep->flags & TEP_DISABLE_SYS_PLUGINS))
+		load_plugins_dir(tep, suffix, PLUGIN_DIR,
 				 load_plugin, data);
 #endif
 
@@ -397,7 +397,7 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 	 */
 	envdir = getenv("TRACEEVENT_PLUGIN_DIR");
 	if (envdir)
-		load_plugins_dir(pevent, suffix, envdir, load_plugin, data);
+		load_plugins_dir(tep, suffix, envdir, load_plugin, data);
 
 	/*
 	 * Now let the home directory override the environment
@@ -413,7 +413,7 @@ load_plugins(struct tep_handle *pevent, const char *suffix,
 		return;
 	}
 
-	load_plugins_dir(pevent, suffix, path, load_plugin, data);
+	load_plugins_dir(tep, suffix, path, load_plugin, data);
 
 	free(path);
 }
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 1d2f1343090d..298694356277 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -256,7 +256,7 @@ static int event_match(struct tep_event *event,
 }
 
 static enum tep_errno
-find_event(struct tep_handle *pevent, struct event_list **events,
+find_event(struct tep_handle *tep, struct event_list **events,
 	   char *sys_name, char *event_name)
 {
 	struct tep_event *event;
@@ -299,8 +299,8 @@ find_event(struct tep_handle *pevent, struct event_list **events,
 		}
 	}
 
-	for (i = 0; i < pevent->nr_events; i++) {
-		event = pevent->events[i];
+	for (i = 0; i < tep->nr_events; i++) {
+		event = tep->events[i];
 		if (event_match(event, sys_name ? &sreg : NULL, &ereg)) {
 			match = 1;
 			if (add_event(events, event) < 0) {
@@ -1257,7 +1257,7 @@ static void filter_init_error_buf(struct tep_event_filter *filter)
 enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 					 const char *filter_str)
 {
-	struct tep_handle *pevent = filter->tep;
+	struct tep_handle *tep = filter->tep;
 	struct event_list *event;
 	struct event_list *events = NULL;
 	const char *filter_start;
@@ -1313,7 +1313,7 @@ enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 		}
 
 		/* Find this event */
-		ret = find_event(pevent, &events, strim(sys_name), strim(event_name));
+		ret = find_event(tep, &events, strim(sys_name), strim(event_name));
 		if (ret < 0) {
 			free_events(events);
 			free(this_event);
@@ -1334,7 +1334,7 @@ enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 		if (ret < 0)
 			rtn = ret;
 
-		if (ret >= 0 && pevent->test_filters) {
+		if (ret >= 0 && tep->test_filters) {
 			char *test;
 			test = tep_filter_make_string(filter, event->event->id);
 			if (test) {
@@ -1346,7 +1346,7 @@ enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 
 	free_events(events);
 
-	if (rtn >= 0 && pevent->test_filters)
+	if (rtn >= 0 && tep->test_filters)
 		exit(0);
 
 	return rtn;
@@ -1462,7 +1462,7 @@ static int copy_filter_type(struct tep_event_filter *filter,
 	const char *name;
 	char *str;
 
-	/* Can't assume that the pevent's are the same */
+	/* Can't assume that the tep's are the same */
 	sys = filter_type->event->system;
 	name = filter_type->event->name;
 	event = tep_find_event_by_name(filter->tep, sys, name);
@@ -1700,7 +1700,7 @@ static int test_num(struct tep_event *event, struct tep_filter_arg *arg,
 static const char *get_field_str(struct tep_filter_arg *arg, struct tep_record *record)
 {
 	struct tep_event *event;
-	struct tep_handle *pevent;
+	struct tep_handle *tep;
 	unsigned long long addr;
 	const char *val = NULL;
 	unsigned int size;
@@ -1730,12 +1730,12 @@ static const char *get_field_str(struct tep_filter_arg *arg, struct tep_record *
 
 	} else {
 		event = arg->str.field->event;
-		pevent = event->tep;
+		tep = event->tep;
 		addr = get_value(event, arg->str.field, record);
 
 		if (arg->str.field->flags & (TEP_FIELD_IS_POINTER | TEP_FIELD_IS_LONG))
 			/* convert to a kernel symbol */
-			val = tep_find_function(pevent, addr);
+			val = tep_find_function(tep, addr);
 
 		if (val == NULL) {
 			/* just use the hex of the string name */
@@ -1875,7 +1875,7 @@ int tep_event_filtered(struct tep_event_filter *filter, int event_id)
 enum tep_errno tep_filter_match(struct tep_event_filter *filter,
 				struct tep_record *record)
 {
-	struct tep_handle *pevent = filter->tep;
+	struct tep_handle *tep = filter->tep;
 	struct tep_filter_type *filter_type;
 	int event_id;
 	int ret;
@@ -1886,7 +1886,7 @@ enum tep_errno tep_filter_match(struct tep_event_filter *filter,
 	if (!filter->filters)
 		return TEP_ERRNO__NO_FILTER;
 
-	event_id = tep_data_type(pevent, record);
+	event_id = tep_data_type(tep, record);
 
 	filter_type = find_filter_type(filter, event_id);
 	if (!filter_type)
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
index d6a8df060614..7770fcb78e0f 100644
--- a/tools/lib/traceevent/plugin_function.c
+++ b/tools/lib/traceevent/plugin_function.c
@@ -126,7 +126,7 @@ static int add_and_get_index(const char *parent, const char *child, int cpu)
 static int function_handler(struct trace_seq *s, struct tep_record *record,
 			    struct tep_event *event, void *context)
 {
-	struct tep_handle *pevent = event->tep;
+	struct tep_handle *tep = event->tep;
 	unsigned long long function;
 	unsigned long long pfunction;
 	const char *func;
@@ -136,12 +136,12 @@ static int function_handler(struct trace_seq *s, struct tep_record *record,
 	if (tep_get_field_val(s, event, "ip", record, &function, 1))
 		return trace_seq_putc(s, '!');
 
-	func = tep_find_function(pevent, function);
+	func = tep_find_function(tep, function);
 
 	if (tep_get_field_val(s, event, "parent_ip", record, &pfunction, 1))
 		return trace_seq_putc(s, '!');
 
-	parent = tep_find_function(pevent, pfunction);
+	parent = tep_find_function(tep, pfunction);
 
 	if (parent && ftrace_indent->set)
 		index = add_and_get_index(parent, func, record->cpu);
-- 
2.20.1

