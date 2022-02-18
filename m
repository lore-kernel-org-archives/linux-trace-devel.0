Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4063FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Feb 2022 22:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240159AbiBRWvW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Feb 2022 17:51:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240166AbiBRWvV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Feb 2022 17:51:21 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F1EA273753
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 14:51:03 -0800 (PST)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id B74B320C27FD;
        Fri, 18 Feb 2022 14:51:02 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B74B320C27FD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645224662;
        bh=og7F6wNkBt1XhUt7/fU+JrcwQURC3u6/DsVcxqAWLbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnaZuvu3Z8gWxFZMRoWVPcLIZsZBcYrHxCY2/JoLMRDxPke7RLOkY7mTexA19HT40
         +eytgGpD5RXaNP25CepogAPa2qgjGdpwjMdhyG87IUk+DRJjg2LQRhmw1ZL2gYNBR+
         JJh2AEXpeFAqhO7xYqunC5Mgq+YsDx8dAxXCfpxI=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, beaub@linux.microsoft.com
Subject: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs sources
Date:   Fri, 18 Feb 2022 14:50:56 -0800
Message-Id: <20220218225058.12701-2-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220218225058.12701-1-beaub@linux.microsoft.com>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adds the required APIs to libtracefs to create, manage and write out
data to trace events via the user_events kernel mechanism.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 Makefile                 |   8 +
 include/tracefs-local.h  |  24 ++
 include/tracefs.h        |  60 +++++
 src/Makefile             |   4 +
 src/tracefs-userevents.c | 545 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 641 insertions(+)
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
index bf157e1..e768cba 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -119,4 +119,28 @@ int trace_rescan_events(struct tep_handle *tep,
 struct tep_event *get_tep_event(struct tep_handle *tep,
 				const char *system, const char *name);
 
+/* Internal interface for ftrace user events */
+
+struct tracefs_user_event_group;
+
+struct tracefs_user_event
+{
+	int write_index;
+	int status_index;
+	int iovecs;
+	int rels;
+	int len;
+	struct tracefs_user_event_group *group;
+	struct tracefs_user_event *next;
+};
+
+struct tracefs_user_event_group
+{
+	int fd;
+	int mmap_len;
+	char *mmap;
+	pthread_mutex_t lock;
+	struct tracefs_user_event *events;
+};
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index 1848ad0..7871dfe 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -571,4 +571,64 @@ struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
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
+	enum tracefs_uevent_type type;
+
+	/* Length of data, optional during register */
+	int len;
+
+	union {
+		/* Used during write */
+		const void *data;
+
+		/* Used during register */
+		const char *name;
+	};
+};
+
+struct tracefs_user_event;
+struct tracefs_user_event_group;
+
+struct tracefs_user_event_group *tracefs_user_event_group_create(void);
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
+bool tracefs_user_event_test(struct tracefs_user_event *event);
+
+int tracefs_user_event_write(struct tracefs_user_event *event,
+			     struct tracefs_uevent_item *items);
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
index 0000000..4d64fd8
--- /dev/null
+++ b/src/tracefs-userevents.c
@@ -0,0 +1,545 @@
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
+static void free_user_events(struct tracefs_user_event *event)
+{
+	struct tracefs_user_event *next;
+
+	while (event) {
+		next = event->next;
+		free(event);
+		event = next;
+	}
+}
+
+#define LEN_OR_ZERO (len ? len - pos : 0)
+static int append_field(struct tracefs_uevent_item *item, char *buf,
+			int len, int offset, int index)
+{
+	int pos = offset;
+
+	if (index != 0)
+		pos += snprintf(buf + pos, LEN_OR_ZERO, ";");
+
+	switch (item->type) {
+	case TRACEFS_UEVENT_u8:
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" u8 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_s8:
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" s8 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_u16:
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" u16 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_s16:
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" s16 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_u32:
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" u32 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_s32:
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" s32 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_u64:
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" u64 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_s64:
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" s64 %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_string:
+		if (item->len <= 0) {
+			errno = EINVAL;
+			return -1;
+		}
+
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" char[%d] %s", item->len, item->name);
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
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" struct %s %d", item->name, item->len);
+		break;
+
+	case TRACEFS_UEVENT_varray:
+		/* Variable length array */
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" __rel_loc u8[] %s", item->name);
+		break;
+
+	case TRACEFS_UEVENT_vstring:
+		/* Variable length string */
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				" __rel_loc char[] %s", item->name);
+		break;
+
+	default:
+		/* Unknown */
+		errno = ENOENT;
+		return -1;
+	}
+
+	return pos;
+}
+
+static int create_reg_cmd(const char *name, enum tracefs_uevent_flags flags,
+			  struct tracefs_uevent_item *items, char *buf, int len)
+{
+	int pos = 0;
+	int index = 0;
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "%s", name);
+
+	if (flags & TRACEFS_UEVENT_FLAG_bpf_iter)
+		pos += snprintf(buf + pos, LEN_OR_ZERO, ":BPF_ITER");
+
+	while (items->type != TRACEFS_UEVENT_END) {
+		pos = append_field(items, buf, len, pos, index++);
+
+		if (pos < 0)
+			return pos;
+
+		items++;
+	}
+
+	return pos + 1;
+}
+#undef LEN_OR_ZERO
+
+static int get_write_counts(struct tracefs_user_event *event,
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
+ * tracefs_user_event_group_create - Create a new group to use for user events
+ *
+ * Returns a pointer to a group to use for user events. The pointer is valid until
+ * tracefs_user_event_group_close() is called. In case of an error NULL is
+ * returned.
+ */
+struct tracefs_user_event_group *tracefs_user_event_group_create(void)
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
+	struct tracefs_user_event *event = NULL;
+	struct user_reg reg = {0};
+	char *cmd = NULL;
+	int len;
+
+	if (!group || !items) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	/* Determine length of cmd */
+	len = create_reg_cmd(name, flags, items, cmd, 0);
+
+	if (len < 0) {
+		errno = EINVAL;
+		return NULL;
+	}
+
+	/* Allocate and fill cmd */
+	cmd = malloc(len);
+
+	if (!cmd)
+		return NULL;
+
+	create_reg_cmd(name, flags, items, cmd, len);
+
+	event = malloc(sizeof(*event));
+
+	if (!event)
+		goto put_cmd;
+
+	reg.size = sizeof(reg);
+	reg.name_args = (__u64)cmd;
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
+	event->write_index = reg.write_index;
+	event->status_index = reg.status_index;
+	event->group = group;
+
+	/* Add event into the group under lock */
+	pthread_mutex_lock(&group->lock);
+	event->next = group->events;
+	group->events = event->next;
+	pthread_mutex_unlock(&group->lock);
+
+	free(cmd);
+
+	return event;
+put_event:
+	free(event);
+put_cmd:
+	free(cmd);
+
+	return NULL;
+}
+
+/**
+ * tracefs_user_event_test - Tests if an event is currently enabled
+ * @event: User event to test
+ *
+ * Tests if the @event is valid and currently enabled on the system.
+ *
+ * Return true if enabled, false otherwise.
+ */
+bool tracefs_user_event_test(struct tracefs_user_event *event)
+{
+	return event && event->group->mmap[event->status_index] != 0;
+}
+
+/**
+ * tracefs_user_event_write - Writes data out to an event
+ * @event: User event to write data about
+ * @items: Items to write for the event
+ *
+ * Writes out items for the event. Callers should check if the cost of writing
+ * should be performed by calling tracefs_user_event_test(). Items are checked
+ * to ensure they fit within the described items during register. Each item
+ * must specify the length of the item being written.
+ *
+ * Return the number of bytes written or -1 upon error.
+ *
+ * errno will be set to EINVAL if @event or @items is null or @items contains
+ * an item with a length of less than or equal to 0.
+ * errno will be set to E2BIG if @items contains more items than previously
+ * registered for the event.
+ */
+int tracefs_user_event_write(struct tracefs_user_event *event,
+			     struct tracefs_uevent_item *items)
+{
+	struct iovec *head, *io, *relio, *io_end;
+	__u32 *rel, *rel_end;
+	int len, rel_offset, data_offset, used;
+
+	if (!event || !items) {
+		errno = EINVAL;
+		return -1;
+	}
+
+	head = io = alloca(sizeof(*io) * (event->iovecs + event->rels));
+	rel = alloca(sizeof(*rel) * event->rels);
+
+	io_end = head + (event->iovecs + event->rels);
+	rel_end = rel + event->rels;
+
+	/* Relative offset starts at end of static data */
+	relio = io + event->iovecs;
+	rel_offset = event->len;
+	data_offset = 0;
+
+	/* Write index must be first */
+	io->iov_base = &event->write_index;
+	io->iov_len = sizeof(event->write_index);
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
+	return writev(event->group->fd, head, used);
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

