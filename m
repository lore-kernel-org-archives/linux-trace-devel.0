Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B88CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 23:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbiBVXXr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 18:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbiBVXXr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 18:23:47 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9DF595A18
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 15:23:20 -0800 (PST)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id A3E9120C31BB;
        Tue, 22 Feb 2022 15:23:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A3E9120C31BB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645572200;
        bh=VylUIfdhAMJuU9a/tsdmGlIJqBBOQxlfD3XRnfI/8gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNp+yZ2hMDVMNs5C1HUcMW/5jeIq8lH0pRUq5yPnpooiWH61f0HBRoa6PaLcJ24Rc
         ysZoijiomqlz6s5tM9YvuPB5Q6/7xCAwl87JMn/7paiqacOAIu664cofV6WDBg0v35
         421J7EuIba34gPIFF1cCnwc/x+TwqffCMbhycj3s=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, beaub@linux.microsoft.com
Subject: [PATCH v2 1/3] libtracefs: Add user_events to libtracefs sources
Date:   Tue, 22 Feb 2022 15:23:14 -0800
Message-Id: <20220222232316.14640-2-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220222232316.14640-1-beaub@linux.microsoft.com>
References: <20220222232316.14640-1-beaub@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The user events are scheduled to be included into Linux 5.18, which
register a special mmapped page to denote when the user event is enabled
(from an external source). This API adds a wrapper to the kernel
interface that makes it easy to register user events and test if they
are enabled and to record the event when it is.

Link:
https://lore.kernel.org/linux-trace-devel/20220121192833.GA3128@kbox/T/#m2bcf53c373fbeaba2c46d1a053b3174171167e4e

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 Makefile                 |   8 +
 include/tracefs-local.h  |  24 ++
 include/tracefs.h        |  67 +++++
 src/Makefile             |   4 +
 src/tracefs-userevents.c | 516 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 619 insertions(+)
 create mode 100644 src/tracefs-userevents.c

diff --git a/Makefile b/Makefile
index 544684c..a4598b4 100644
--- a/Makefile
+++ b/Makefile
@@ -154,6 +154,14 @@ CFLAGS ?= -g -Wall
 CPPFLAGS ?=
 LDFLAGS ?=
 
+USEREVENTS_INSTALLED := $(shell if (echo "$(pound)include <linux/user_events.h>" | $(CC) -E - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
+export USEREVENTS_INSTALLED
+ifeq ($(USEREVENTS_INSTALLED), 1)
+CFLAGS += -DUSEREVENTS
+else
+$(warning user_events.h not installed, skipping)
+endif
+
 CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c - -lcunit -o /dev/null >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
 export CUNIT_INSTALLED
 
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index bf157e1..9491545 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -119,4 +119,28 @@ int trace_rescan_events(struct tep_handle *tep,
 struct tep_event *get_tep_event(struct tep_handle *tep,
 				const char *system, const char *name);
 
+/* Internal interface for ftrace user events */
+
+struct tracefs_user_event_group;
+
+struct tracefs_user_event_internal
+{
+	struct tracefs_user_event		event_external;
+	int					write_index;
+	int					iovecs;
+	int					rels;
+	int					len;
+	struct tracefs_user_event_group		*group;
+	struct tracefs_user_event_internal	*next;
+};
+
+struct tracefs_user_event_group
+{
+	int					fd;
+	int					mmap_len;
+	char					*mmap;
+	pthread_mutex_t				lock;
+	struct tracefs_user_event_internal	*events;
+};
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index 1848ad0..74241a9 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -571,4 +571,71 @@ struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 struct tep_event *
 tracefs_synth_get_event(struct tep_handle *tep, struct tracefs_synth *synth);
 
+/* User events */
+enum tracefs_uevent_type {
+	TRACEFS_UEVENT_END,
+	TRACEFS_UEVENT_u8,
+	TRACEFS_UEVENT_s8,
+	TRACEFS_UEVENT_u16,
+	TRACEFS_UEVENT_s16,
+	TRACEFS_UEVENT_u32,
+	TRACEFS_UEVENT_s32,
+	TRACEFS_UEVENT_u64,
+	TRACEFS_UEVENT_s64,
+	TRACEFS_UEVENT_string,
+	TRACEFS_UEVENT_struct,
+	TRACEFS_UEVENT_varray,
+	TRACEFS_UEVENT_vstring,
+};
+
+enum tracefs_uevent_flags {
+	/* None */
+	TRACEFS_UEVENT_FLAG_NONE = 0,
+
+	/* When BPF is attached, use iterator/no copy */
+	TRACEFS_UEVENT_FLAG_bpf_iter = 1 << 0,
+};
+
+struct tracefs_uevent_item {
+	/* Type of item */
+	enum tracefs_uevent_type	type;
+
+	/* Length of data, optional during register */
+	int len;
+
+	union {
+		/* Used during write */
+		const void		*data;
+
+		/* Used during register */
+		const char		*name;
+	};
+};
+
+struct tracefs_user_event {
+	unsigned int	size;
+	char		*enabled;
+};
+
+struct tracefs_user_event_group;
+
+struct tracefs_user_event_group *tracefs_user_event_group_open(void);
+
+void tracefs_user_event_group_close(struct tracefs_user_event_group *group);
+
+int tracefs_user_event_delete(const char *name);
+
+struct tracefs_user_event *
+tracefs_user_event_register(struct tracefs_user_event_group *group,
+			    const char *name, enum tracefs_uevent_flags flags,
+			    struct tracefs_uevent_item *items);
+
+static inline bool tracefs_user_event_enabled(struct tracefs_user_event *event)
+{
+	return event && ((volatile char *)event->enabled)[0] != 0;
+}
+
+int tracefs_user_event_record(struct tracefs_user_event *event,
+			      struct tracefs_uevent_item *items);
+
 #endif /* _TRACE_FS_H */
diff --git a/src/Makefile b/src/Makefile
index e8afab5..984e8cf 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -14,6 +14,10 @@ OBJS += tracefs-filter.o
 OBJS += tracefs-dynevents.o
 OBJS += tracefs-eprobes.o
 
+ifeq ($(USEREVENTS_INSTALLED), 1)
+OBJS += tracefs-userevents.o
+endif
+
 # Order matters for the the three below
 OBJS += sqlhist-lex.o
 OBJS += sqlhist.tab.o
diff --git a/src/tracefs-userevents.c b/src/tracefs-userevents.c
new file mode 100644
index 0000000..ccd511b
--- /dev/null
+++ b/src/tracefs-userevents.c
@@ -0,0 +1,516 @@
+// SPDX-License-Identifier: LGPL-2.1
+/*
+ * Copyright (C) 2022 Microsoft Corporation.
+ *
+ * Authors:
+ *   Beau Belgrave <beaub@linux.microsoft.com>
+ */
+
+#include <alloca.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <sys/mman.h>
+#include <sys/ioctl.h>
+#include <sys/uio.h>
+#include <linux/user_events.h>
+
+#include "tracefs.h"
+#include "tracefs-local.h"
+
+#define STAT_FILE "user_events_status"
+#define DATA_FILE "user_events_data"
+
+static void free_user_events(struct tracefs_user_event_internal *event)
+{
+	struct tracefs_user_event_internal *next;
+
+	while (event) {
+		next = event->next;
+		free(event);
+		event = next;
+	}
+}
+
+static int append_field(struct tracefs_uevent_item *item, struct trace_seq *seq,
+			int index)
+{
+	if (index != 0)
+		trace_seq_printf(seq, ";");
+
+	switch (item->type) {
+	case TRACEFS_UEVENT_u8:
+		trace_seq_printf(seq, " u8 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_s8:
+		trace_seq_printf(seq, " s8 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_u16:
+		trace_seq_printf(seq, " u16 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_s16:
+		trace_seq_printf(seq, " s16 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_u32:
+		trace_seq_printf(seq, " u32 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_s32:
+		trace_seq_printf(seq, " s32 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_u64:
+		trace_seq_printf(seq, " u64 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_s64:
+		trace_seq_printf(seq, " s64 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_string:
+		if (item->len <= 0) {
+			errno = EINVAL;
+			return -1;
+		}
+
+		trace_seq_printf(seq, " char[%d] %s", item->len, item->name);
+		break;
+
+	case TRACEFS_UEVENT_struct:
+		/*
+		 * struct must have 2 strings, do simple check
+		 * in user, kernel will fully validate
+		 */
+		if (!strchr(item->name, ' ')) {
+			errno = EINVAL;
+			return -1;
+		}
+
+		if (item->len <= 0) {
+			errno = EINVAL;
+			return -1;
+		}
+
+		trace_seq_printf(seq, " struct %s %d", item->name, item->len);
+		break;
+
+	case TRACEFS_UEVENT_varray:
+		/* Variable length array */
+		trace_seq_printf(seq, " __rel_loc u8[] %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_vstring:
+		/* Variable length string */
+		trace_seq_printf(seq, " __rel_loc char[] %s", item->name);
+		break;
+
+	default:
+		/* Unknown */
+		errno = ENOENT;
+		return -1;
+	}
+
+	return 0;
+}
+
+static int create_reg_cmd(const char *name, enum tracefs_uevent_flags flags,
+			  struct tracefs_uevent_item *item, struct trace_seq *seq)
+{
+	int ret, index = 0;
+
+	trace_seq_printf(seq, "%s", name);
+
+	if (flags & TRACEFS_UEVENT_FLAG_bpf_iter)
+		trace_seq_printf(seq, ":BPF_ITER");
+
+	while (item->type != TRACEFS_UEVENT_END) {
+		ret = append_field(item, seq, index++);
+
+		if (ret < 0)
+			return ret;
+
+		item++;
+	}
+
+	trace_seq_terminate(seq);
+
+	if (seq->state) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	return 0;
+}
+
+static int get_write_counts(struct tracefs_user_event_internal *event,
+			    struct tracefs_uevent_item *item)
+{
+	event->rels = 0;
+	event->len = 0;
+
+	/* Start at 1, need iovec for write_index */
+	event->iovecs = 1;
+
+	while (item->type != TRACEFS_UEVENT_END) {
+		switch (item->type) {
+		case TRACEFS_UEVENT_u8:
+		case TRACEFS_UEVENT_s8:
+			event->len += sizeof(__u8);
+			break;
+
+		case TRACEFS_UEVENT_u16:
+		case TRACEFS_UEVENT_s16:
+			event->len += sizeof(__u16);
+			break;
+
+		case TRACEFS_UEVENT_u32:
+		case TRACEFS_UEVENT_s32:
+			event->len += sizeof(__u32);
+			break;
+
+		case TRACEFS_UEVENT_u64:
+		case TRACEFS_UEVENT_s64:
+			event->len += sizeof(__u64);
+			break;
+
+		case TRACEFS_UEVENT_string:
+		case TRACEFS_UEVENT_struct:
+			event->len += item->len;
+			break;
+
+		case TRACEFS_UEVENT_varray:
+		case TRACEFS_UEVENT_vstring:
+			/* Requires a rel loc entry */
+			event->len += sizeof(__u32);
+			event->rels++;
+			break;
+
+		default:
+			/* Unknown */
+			errno = ENOENT;
+			return -1;
+		}
+
+		event->iovecs++;
+		item++;
+	}
+
+	return 0;
+}
+
+/**
+ * tracefs_user_event_group_open - Opens a new group to use for user events
+ *
+ * Returns a pointer to a group to use for user events. The pointer is valid
+ * until tracefs_user_event_group_close() is called. In case of an error NULL
+ * is returned.
+ */
+struct tracefs_user_event_group *tracefs_user_event_group_open(void)
+{
+	int stat, write, page_size, i;
+	struct tracefs_user_event_group *group;
+
+	stat = tracefs_instance_file_open(NULL, STAT_FILE, O_RDWR);
+
+	if (stat < 0)
+		return NULL;
+
+	write = tracefs_instance_file_open(NULL, DATA_FILE, O_RDWR);
+
+	if (write < 0)
+		goto put_stat;
+
+	group = malloc(sizeof(*group));
+
+	if (!group)
+		goto put_write;
+
+	if (pthread_mutex_init(&group->lock, NULL) < 0)
+		goto put_group;
+
+	/* Scale up to 16-bit max user events a page at a time */
+	page_size = sysconf(_SC_PAGESIZE);
+	group->mmap_len = page_size;
+
+	for (i = 0; i < 16; ++i) {
+		group->mmap = mmap(NULL, group->mmap_len,
+				   PROT_READ, MAP_SHARED, stat, 0);
+
+		if (group->mmap == MAP_FAILED && errno == EINVAL) {
+			/* Increase by page size and try again */
+			group->mmap_len += page_size;
+			continue;
+		}
+
+		break;
+	}
+
+	if (group->mmap == MAP_FAILED)
+		goto put_group;
+
+	group->fd = write;
+	group->events = NULL;
+
+	/* Status fd no longer needed */
+	close(stat);
+
+	return group;
+
+put_group:
+	free(group);
+put_write:
+	close(write);
+put_stat:
+	close(stat);
+
+	return NULL;
+}
+
+/**
+ * tracefs_user_event_delete - Deletes a user event from the system
+ * @name: Name of the event to delete
+ *
+ * Deletes the event from the system if it is not used.
+ */
+int tracefs_user_event_delete(const char *name)
+{
+	int ret, write;
+
+	write = tracefs_instance_file_open(NULL, DATA_FILE, O_RDWR);
+
+	if (write < 0)
+		return write;
+
+	ret = ioctl(write, DIAG_IOCSDEL, name);
+
+	close(write);
+
+	return ret;
+}
+
+/**
+ * tracefs_user_event_group_close - Closes a group containing user events
+ * @group: Group to close
+ *
+ * Closes a group and all the user events within it. Any user event that has
+ * been added to the group is no longer valid and cannot be used.
+ */
+void tracefs_user_event_group_close(struct tracefs_user_event_group *group)
+{
+	if (!group)
+		return;
+
+	if (group->mmap != MAP_FAILED)
+		munmap(group->mmap, group->mmap_len);
+
+	if (group->fd != -1)
+		close(group->fd);
+
+	free_user_events(group->events);
+	free(group);
+}
+
+/**
+ * tracefs_user_event_register - Registers a user event with the system
+ * @group: Group to add the user event to
+ * @name: Name of the event to register
+ * @flags: Flags to use
+ * @items: Array of items that the event contains
+ *
+ * Allocates and registers a user event with the system. The user event will be
+ * added to the @group. The lifetime of the event is bound to the @group. When
+ * the @group is closed via tracefs_user_event_group_close() the event will no
+ * longer exist and should not be used.
+ *
+ * The @items are processed in order and the final item type must be set to
+ * TRACEFS_UEVENT_END to mark the last item. Each item must have the type
+ * and name defined. The string and struct type also require the len to be set
+ * for the item.
+ *
+ * Return a pointer to a user event on success, or NULL or error.
+ *
+ * errno will be set to EINVAL if @group is null or unexpected @items.
+ */
+struct tracefs_user_event *
+tracefs_user_event_register(struct tracefs_user_event_group *group,
+			    const char *name, enum tracefs_uevent_flags flags,
+			    struct tracefs_uevent_item *items)
+{
+	struct tracefs_user_event_internal *event = NULL;
+	struct user_reg reg = {0};
+	struct trace_seq seq;
+
+	if (!group || !items) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	trace_seq_init(&seq);
+
+	/* Populate cmd */
+	if (create_reg_cmd(name, flags, items, &seq))
+		return NULL;
+
+	event = malloc(sizeof(*event));
+
+	if (!event)
+		goto put_seq;
+
+	reg.size = sizeof(reg);
+	reg.name_args = (__u64)seq.buffer;
+
+	/* Register event with kernel */
+	if (ioctl(group->fd, DIAG_IOCSREG, &reg) == -1)
+		goto put_event;
+
+	/* Sanity check bounds returned */
+	if (reg.status_index >= group->mmap_len) {
+		errno = EINVAL;
+		goto put_event;
+	}
+
+	if (get_write_counts(event, items))
+		goto put_event;
+
+	/* Keep track of user view at this point in time */
+	event->event_external.size = sizeof(event->event_external);
+	event->event_external.enabled = &group->mmap[reg.status_index];
+
+	event->write_index = reg.write_index;
+	event->group = group;
+
+	/* Add event into the group under lock */
+	pthread_mutex_lock(&group->lock);
+	event->next = group->events;
+	group->events = event->next;
+	pthread_mutex_unlock(&group->lock);
+
+	trace_seq_destroy(&seq);
+
+	return &event->event_external;
+put_event:
+	free(event);
+put_seq:
+	trace_seq_destroy(&seq);
+
+	return NULL;
+}
+
+/**
+ * tracefs_user_event_record - Records an event with data
+ * @event: User event to record data about
+ * @items: Items to write for the event
+ *
+ * Records items for the event. Callers should check if the cost of recording
+ * should be performed by calling tracefs_user_event_enabled(). Items are
+ * checked to ensure they fit within the described items during register. Each
+ * item must specify the length of the item being recorded.
+ *
+ * Return the number of bytes recorded or -1 upon error.
+ *
+ * errno will be set to EINVAL if @event or @items is null or @items contains
+ * an item with a length of less than or equal to 0.
+ * errno will be set to E2BIG if @items contains more items than previously
+ * registered for the event.
+ */
+int tracefs_user_event_record(struct tracefs_user_event *event,
+			      struct tracefs_uevent_item *items)
+{
+	struct tracefs_user_event_internal *e;
+	struct iovec *head, *io, *relio, *io_end;
+	__u32 *rel, *rel_end;
+	int len, rel_offset, data_offset, used;
+
+	if (!event || !items) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	e = (struct tracefs_user_event_internal *)event;
+	head = io = alloca(sizeof(*io) * (e->iovecs + e->rels));
+	rel = alloca(sizeof(*rel) * e->rels);
+
+	io_end = head + (e->iovecs + e->rels);
+	rel_end = rel + e->rels;
+
+	/* Relative offset starts at end of static data */
+	relio = io + e->iovecs;
+	rel_offset = e->len;
+	data_offset = 0;
+
+	/* Write index must be first */
+	io->iov_base = &e->write_index;
+	io->iov_len = sizeof(e->write_index);
+	io++;
+	used = 1;
+
+	while (items->type != TRACEFS_UEVENT_END) {
+		len = items->len;
+
+		if (len <= 0)
+			goto bad_length;
+
+		if (io >= io_end)
+			goto bad_count;
+
+		switch (items->type) {
+		case TRACEFS_UEVENT_varray:
+		case TRACEFS_UEVENT_vstring:
+			/* Dual vectors */
+			used += 2;
+
+			if (rel >= rel_end || relio >= io_end)
+				goto bad_count;
+
+			/* __rel_loc types */
+			relio->iov_base = (void *)items->data;
+			relio->iov_len = len;
+			relio++;
+
+			io->iov_base = (void *)rel;
+			io->iov_len = sizeof(*rel);
+			io++;
+			rel_offset -= sizeof(*rel);
+
+			/* Fill in rel loc data */
+			*rel = DYN_LOC(rel_offset + data_offset, len);
+			data_offset += len;
+			rel++;
+
+			break;
+
+		default:
+			/* Single vector */
+			used++;
+
+			/* Direct types */
+			io->iov_base = (void *)items->data;
+			io->iov_len = len;
+			io++;
+			rel_offset -= len;
+
+			break;
+		}
+
+		items++;
+	}
+
+	return writev(e->group->fd, head, used);
+
+bad_length:
+	fprintf(stderr, "Bad user_event item length at index %d\n",
+		used - 1);
+	errno = EINVAL;
+	return -1;
+
+bad_count:
+	fprintf(stderr, "Too many user_event items passed\n");
+	errno = E2BIG;
+	return -1;
+}
-- 
2.17.1

