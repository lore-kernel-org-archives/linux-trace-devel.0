Return-Path: <SRS0=rM3Y=3Q=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F57C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jan 2020 15:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B306622522
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jan 2020 15:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbgA0PmG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Jan 2020 10:42:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:37584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729473AbgA0PmG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Jan 2020 10:42:06 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C435521739;
        Mon, 27 Jan 2020 15:42:04 +0000 (UTC)
Date:   Mon, 27 Jan 2020 10:42:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Qu Wenruo <wqu@suse.com>, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] tools/lib/traceevent, perf tools: Handle %pU format
 correctly
Message-ID: <20200127104203.7ae4c35f@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: Qu Wenruo <wqu@suse.com>

[BUG]
For btrfs related events, there is a field for fsid, but perf never
parse it correctly.

 # perf trace -e btrfs:qgroup_meta_convert xfs_io -f -c "pwrite 0 4k" \
   /mnt/btrfs/file1
     0.000 xfs_io/77915 btrfs:qgroup_meta_reserve:(nil)U: refroot=5(FS_TREE) type=0x0 diff=2
                                                  ^^^^^^ Not a correct UUID
     ...

[CAUSE]
The pretty_print() function doesn't handle the %pU format correctly.
In fact it doesn't handle %pU as uuid at all.

[FIX]
Add a new function, print_uuid_arg(), to handle %pU correctly.

Now perf trace can at least print fsid correctly:
     0.000 xfs_io/79619 btrfs:qgroup_meta_reserve:23ad1511-dd83-47d4-a79c-e96625a15a6e refroot=5(FS_TREE) type=0x0 diff=2

Link: http://lkml.kernel.org/r/20191021094730.57332-1-wqu@suse.com

Signed-off-by: Qu Wenruo <wqu@suse.com>
[ Change if statement from (1 <= i && i >= 4) to (i >= 1 && i >= 4) ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---

Arnaldo,

This patch was stuck on a completion that never happened. My comment on
the if statement never was addressed, so I just made the change myself.

-- Steve


 tools/lib/traceevent/event-parse.c | 51 ++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index beaa8b8c08ff..a3b87a12bef2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -18,6 +18,7 @@
 #include <errno.h>
 #include <stdint.h>
 #include <limits.h>
+#include <linux/uuid.h>
 #include <linux/time64.h>
 
 #include <netinet/in.h>
@@ -4510,6 +4511,40 @@ get_bprint_format(void *data, int size __maybe_unused,
 	return format;
 }
 
+static void print_uuid_arg(struct trace_seq *s, void *data, int size,
+			   struct tep_event *event, struct tep_print_arg *arg)
+{
+	unsigned char *buf;
+	int i;
+
+	if (arg->type != TEP_PRINT_FIELD) {
+		trace_seq_printf(s, "ARG TYPE NOT FIELID but %d", arg->type);
+		return;
+	}
+
+	if (!arg->field.field) {
+		arg->field.field = tep_find_any_field(event, arg->field.name);
+		if (!arg->field.field) {
+			do_warning("%s: field %s not found",
+				   __func__, arg->field.name);
+			return;
+		}
+	}
+	if (arg->field.field->size < 16) {
+		trace_seq_printf(s, "INVALID UUID: size have %u expect 16",
+				arg->field.field->size);
+		return;
+	}
+	buf = data + arg->field.field->offset;
+
+	for (i = 0; i < 8; i++) {
+		trace_seq_printf(s, "%02x", buf[2 * i]);
+		trace_seq_printf(s, "%02x", buf[2 * i + 1]);
+		if (i >= 1 && i <= 4)
+			trace_seq_putc(s, '-');
+	}
+}
+
 static void print_mac_arg(struct trace_seq *s, int mac, void *data, int size,
 			  struct tep_event *event, struct tep_print_arg *arg)
 {
@@ -5076,6 +5111,22 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct tep_e
 						arg = arg->next;
 						break;
 					}
+				} else if (*ptr == 'U') {
+					/*
+					 * %pU has several finetunings variants
+					 * like %pUb and %pUL.
+					 * Here we ignore them, default to
+					 * byte-order no endian, lower case
+					 * letters.
+					 */
+					if (isalpha(ptr[1]))
+						ptr += 2;
+					else
+						ptr++;
+
+					print_uuid_arg(s, data, size, event, arg);
+					arg = arg->next;
+					break;
 				}
 
 				/* fall through */
-- 
2.20.1

