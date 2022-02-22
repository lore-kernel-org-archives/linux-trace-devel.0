Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F473C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 23:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbiBVXXt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 18:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiBVXXs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 18:23:48 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2189E95A1C
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 15:23:21 -0800 (PST)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id D52EE20C31BE;
        Tue, 22 Feb 2022 15:23:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D52EE20C31BE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645572200;
        bh=YfgrnOC9I1+1wsswUYjRW5aa9lI3t9PUb7bSGYmefnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d3PhHzbi3vIBk9hVlWlu9WxzUShgeXtI80CPtts1/gYlv9vafeh5pK7skx4TqSruW
         Myi7eyxqMkwkO59F9Hua1d91sZ6gnkyELntwvb5f2V3b7yKA3tbWgR/f6dSjDrozXE
         cYkmi5XuczcXN4KhNqxPbfcBe2Ai4UtDAxPLS3/Q=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, beaub@linux.microsoft.com
Subject: [PATCH v2 2/3] libtracefs: Add documentation and sample code for user_events
Date:   Tue, 22 Feb 2022 15:23:15 -0800
Message-Id: <20220222232316.14640-3-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220222232316.14640-1-beaub@linux.microsoft.com>
References: <20220222232316.14640-1-beaub@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adds the initial documentation file for user_event APIs within
libtracefs. Adds sample code on how to use these new APIs.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 Documentation/libtracefs-userevents.txt | 260 ++++++++++++++++++++++++
 samples/Makefile                        |   4 +
 2 files changed, 264 insertions(+)
 create mode 100644 Documentation/libtracefs-userevents.txt

diff --git a/Documentation/libtracefs-userevents.txt b/Documentation/libtracefs-userevents.txt
new file mode 100644
index 0000000..1d32d81
--- /dev/null
+++ b/Documentation/libtracefs-userevents.txt
@@ -0,0 +1,260 @@
+libtracefs(3)
+=============
+
+NAME
+----
+tracefs_user_event_group_open, tracefs_user_event_group_close, tracefs_user_event_register,
+tracefs_user_event_enabled, tracefs_user_event_record, tracefs_user_event_delete,
+- Creation and management of a user event group, event, and data
+
+SYNOPSIS
+--------
+[verse]
+--
+*#include <tracefs.h>*
+
+struct tracefs_user_event_group pass:[*]*tracefs_user_event_group_open*(void);
+void *tracefs_user_event_group_close*(struct tracefs_user_event_group pass:[*]_group_);
+int *tracefs_user_event_delete*(const char pass:[*]_name_);
+struct tracefs_user_event pass:[*]*tracefs_user_event_register*(struct tracefs_user_event_group pass:[*]_group_,
+				const char pass:[*]_name_,
+				enum tracefs_uevent_flags _flags_,
+				struct tracefs_uevent_item pass:[*]_items_);
+bool *tracefs_user_event_enabled*(struct tracefs_user_event pass:[*]_event_);
+int *tracefs_user_event_record*(struct tracefs_user_event pass:[*]_event_,
+				struct tracefs_uevent_item pass:[*]_items_);
+--
+
+DESCRIPTION
+-----------
+User events allow user applications to create trace events from their process.
+The status of each event that is created is exposed to the application, which
+enables quick checking if the event is being traced out or not. This enables
+a way to always have the events on with minimal impact to the performance of
+the process. The *tracefs_user_event_enabled*() function should be used for this.
+When the event is to be traced out with data the *tracefs_user_event_record*()
+function is to be used. Processes should delay any work related to the write
+calls until after *tracefs_user_event_enabled*() returns true. This ensures
+minimal performance impacts until tracing is enabled on the system for each event.
+
+To reduce the number of resources, and to manage lifetimes of the events, the
+concept of a group exists within this implementation. Groups keep track of all
+the events that have been registered within it and ensure that once the group
+is closed that all the events are cleaned up properly. All events in a group
+share system resources used for writing. Groups and events are thread safe and
+do not require additional locking when operating in a multi-threaded process.
+Once a group has been closed the events within it are no longer valid to use.
+When groups are closed their resources go away, callers need to ensure that a
+group is closed only once it's no longer needed by any of the events.
+
+*tracefs_user_event_group_open*() opens and initializes a group to be used.
+Group opening can fail if user_events are not installed, the user doesn't have
+permissions to access tracefs or memory allocation errors. The returned group is
+then used to register events.
+
+*tracefs_user_event_group_close*() closes a group and any events that have been
+registered within the group. Events within the group are no longer valid.
+
+*tracefs_user_event_register*() registers an event within the group and the system.
+The name and items passed are translated to show up in tracefs format file.
+The last item passed to this function must have the type of *TRACEFS_UEVENT_END*.
+While events do not require any items, it's expected that each item that will
+be written out should have a matching item during registration.
+
+Flags passed during registration affect the behavior of the event:
+
+*TRACEFS_UEVENT_FLAG_NONE* - No affect
+
+*TRACEFS_UEVENT_FLAG_bpf_iter* - Force BPF programs to receive iovecs instead
+of a copy of the data. Enables higher performance under some conditions for
+events that plan to use BPF programs and require very little overhead when writing.
+
+Types of items passed during the registration:
+
+*TRACEFS_UEVENT_END* - Indicates the last item.
+
+*TRACEFS_UEVENT_u8* - u8 item.
+
+*TRACEFS_UEVENT_s8* - s8 item.
+
+*TRACEFS_UEVENT_u16* - u16 item.
+
+*TRACEFS_UEVENT_s16* - s16 item.
+
+*TRACEFS_UEVENT_u32* - u32 item.
+
+*TRACEFS_UEVENT_s32* - s32 item.
+
+*TRACEFS_UEVENT_u64* - u64 item.
+
+*TRACEFS_UEVENT_s64* - s64 item.
+
+*TRACEFS_UEVENT_string* - Specific length array of char data.
+
+*TRACEFS_UEVENT_struct* - Specific sized struct by name and type (When used the
+name of the item must include both the type and name of the struct).
+
+*TRACEFS_UEVENT_varray* - Variable length array of u8 data.
+
+*TRACEFS_UEVENT_vstring* - Variable length array of char data.
+
+Each item has a type, length, and name during registration. When items are being
+used for writing each item has a type, length, and the data to write.
+
+When items are being registered, length is required for theses types:
+
+*TRACEFS_UEVENT_string*
+
+*TRACEFS_UEVENT_struct*
+
+If lengths are not set for the above types the register will fail. All other
+types have the length determined automatically.
+
+When items are being written, all items must indicate their length. If lengths
+are not set the write will fail. Automatic length sets are not performed.
+
+*tracefs_user_event_enabled*() checks if an event is being traced at that
+moment. This check is quick and should always be used before writing or
+calculating data required for writing out the event data.
+
+*tracefs_user_event_record*() records data for the event. This causes an entry
+to be made in the tracing system that has been attached (perf, ftrace, BPF,
+etc.).
+
+All items passed must set their length, even for common data types (u8, u16,
+etc.). If required, callers may mix types from what has been registered as long
+as it fits within the allocated resources. A common scenario for this is having
+an internal struct that is packed and contains several consecutive registered
+types. Passing the struct directly instead of each individual item might be
+beneficial. While mixing types is allowed, it's a bug to pass more items than
+have been registered. If this occurs the write will fail.
+
+When the type *TRACEFS_UEVENT_vstring* is being used, the length of the data
+must include the null character of a string. If the length does not include the
+null character the write will fail.
+
+*tracefs_user_event_delete*() deletes the event from the system. Delete only
+works if the event is not being used by anything, include the calling program.
+
+RETURN VALUE
+------------
+*tracefs_user_event_group_open*() returns an allocated struct
+tracefs_user_event_group on success or NULL on error.
+
+*tracefs_user_event_register*() returns an allocated struct tracefs_user_event
+on success or NULL on error.
+
+*tracefs_user_event_enabled*() returns true if the event is currently being
+traced.
+
+*tracefs_user_event_record*() returns the number of bytes recorded out on
+success or -1 on error.
+
+*tracefs_user_event_delete*() returns 0 on success or -1 on error.
+
+ERRORS
+------
+The following errors are for all the above calls:
+
+*EPERM* Not run as root user when required.
+
+*EINVAL* Either a parameter is not valid (NULL when it should not be)
+  or a item that is missing an attribute.
+
+*E2BIG* Too many items passed.
+
+*ENOMEM* not enough memory is available.
+
+And more errors may have happened from the system calls to the system.
+
+EXAMPLE
+-------
+[source,c]
+--
+#include <stdlib.h>
+#include <tracefs.h>
+
+static struct tracefs_user_event_group *group;
+static struct tracefs_user_event *event;
+
+static void make_event(void)
+{
+	struct tracefs_uevent_item items[] = {
+		{ TRACEFS_UEVENT_vstring, .name = "message" },
+		{ TRACEFS_UEVENT_END },
+	};
+
+	group = tracefs_user_event_group_open();
+
+	event = tracefs_user_event_register(group, "example",
+					    TRACEFS_UEVENT_FLAG_NONE, items);
+}
+
+int main (int argc, char **argv)
+{
+	make_event();
+
+	if (argc != 2) {
+		printf("Usage: %s <message>\n", argv[0]);
+		return 1;
+	}
+
+	if (tracefs_user_event_enabled(event)) {
+		const char *msg = argv[1];
+
+		struct tracefs_uevent_item items[] = {
+			{ TRACEFS_UEVENT_vstring, strlen(msg)+1, .data = msg },
+			{ TRACEFS_UEVENT_END },
+		};
+
+		tracefs_user_event_record(event, items);
+
+		printf("Event enabled, recorded '%s'\n", msg);
+	} else {
+		printf("Event user_events/example not enabled, enable via tracefs\n");
+	}
+
+	tracefs_user_event_group_close(group);
+
+	return 0;
+}
+--
+
+FILES
+-----
+[verse]
+--
+*tracefs.h*
+	Header file to include in order to have access to the library APIs.
+*-ltracefs*
+	Linker switch to add when building a program that uses the library.
+--
+
+SEE ALSO
+--------
+*libtracefs*(3),
+*libtraceevent*(3),
+*trace-cmd*(1)
+
+AUTHOR
+------
+[verse]
+--
+*Beau Belgrave* <beaub@linux.microsoft.com>
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+libtracefs is Free Software licensed under the GNU LGPL 2.1
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+
+COPYING
+-------
+Copyright \(C) 2022 Microsoft Corporation. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
diff --git a/samples/Makefile b/samples/Makefile
index f03aff6..169c106 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -21,6 +21,10 @@ EXAMPLES += tracer
 EXAMPLES += stream
 EXAMPLES += instances-affinity
 
+ifeq ($(USEREVENTS_INSTALLED), 1)
+EXAMPLES += userevents
+endif
+
 TARGETS :=
 TARGETS += sqlhist
 TARGETS += $(EXAMPLES)
-- 
2.17.1

