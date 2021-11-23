Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1633C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbhKWWDO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 17:03:14 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:29860 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233876AbhKWWDN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 17:03:13 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 23 Nov 2021 14:00:01 -0800
Received: from vypre.local.home (unknown [10.21.245.90])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 8A98920256;
        Tue, 23 Nov 2021 14:00:04 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtracefs/Documentation: Clean up libtracefs-hist man pages
Date:   Tue, 23 Nov 2021 16:59:57 -0500
Message-ID: <20211123215958.1091307-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123215958.1091307-1-rostedt@goodmis.org>
References: <20211123215958.1091307-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Include the tracefs_hist_key_type enum and the structure of
tracefs_hist_axis in the man page as that is expected to be useful. It
should not be expected that people must read the actual header for this
information.

Also add spaces between some of the functions to separate out
functionality a little to make it easier to read.

Also fix the missing "pass:" before "[*]axes".

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-hist.txt | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index 31ea712..ab802cf 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -12,6 +12,23 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
+enum tracefs_hist_key_type {
+	TRACEFS_HIST_KEY_NORMAL = 0,
+	TRACEFS_HIST_KEY_HEX,
+	TRACEFS_HIST_KEY_SYM,
+	TRACEFS_HIST_KEY_SYM_OFFSET,
+	TRACEFS_HIST_KEY_SYSCALL,
+	TRACEFS_HIST_KEY_EXECNAME,
+	TRACEFS_HIST_KEY_LOG,
+	TRACEFS_HIST_KEY_USECS,
+	TRACEFS_HIST_KEY_MAX
+};
+
+struct tracefs_hist_axis {
+	const char *key;
+	enum tracefs_hist_key_type type;
+};
+
 struct tracefs_hist pass:[*]tracefs_hist1d_alloc(struct tracefs_tep pass:[*] tep,
 			const char pass:[*]system, const char pass:[*]event,
 			const char pass:[*]key, enum tracefs_hist_key_type type);
@@ -21,27 +38,33 @@ struct tracefs_hist pass:[*]tracefs_hist2d_alloc(struct tracefs_tep pass:[*] tep
 			const char pass:[*]key2, enum tracefs_hist_key_type type2));
 struct tracefs_hist pass:[*]tracefs_hist_alloc(struct tracefs_tep pass:[*] tep,
 			const char pass:[*]system, const char pass:[*]event,
-			struct tracefs_hist_axis [*]axes);
+			struct tracefs_hist_axis pass:[*]axes);
 void tracefs_hist_free(struct tracefs_hist pass:[*]hist);
+
 int tracefs_hist_add_key(struct tracefs_hist pass:[*]hist, const char pass:[*]key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist pass:[*]hist, const char pass:[*]value);
 int tracefs_hist_add_sort_key(struct tracefs_hist pass:[*]hist,
 			      const char pass:[*]sort_key);
+
 int tracefs_hist_set_sort_key(struct tracefs_hist pass:[*]hist,
 			      const char pass:[*]sort_key, ...);
 int tracefs_hist_sort_key_direction(struct tracefs_hist pass:[*]hist,
 				    const char pass:[*]sort_key,
 				    enum tracefs_hist_sort_direction dir);
+
 int tracefs_hist_add_name(struct tracefs_hist pass:[*]hist, const char pass:[*]name);
+
 int tracefs_hist_append_filter(struct tracefs_hist pass:[*]hist,
 			       enum tracefs_filter type,
 			       const char pass:[*]field,
 			       enum tracefs_compare compare,
 			       const char pass:[*]val);
+
 int tracefs_hist_echo_cmd(struct trace_seq pass:[*]s, struct tracefs_instance pass:[*]instance,
 			  struct tracefs_hist pass:[*]hist,
 			  enum tracefs_hist_command command);
+
 int tracefs_hist_command(struct tracefs_instance pass:[*]instance,
 			 struct tracefs_hist pass:[*]hist,
 			 enum tracefs_hist_command command);
-- 
2.31.1

