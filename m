Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A9EEC4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 23:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhKVXxN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:53:13 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:32620 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231938AbhKVXxN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 18:53:13 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Nov 2021 15:50:03 -0800
Received: from vypre.local.home (unknown [10.21.245.36])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 7670320349;
        Mon, 22 Nov 2021 15:50:05 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 03/11] libtracefs/Documentation: Fix man page examples to include the proper header
Date:   Mon, 22 Nov 2021 18:49:48 -0500
Message-ID: <20211122234956.788401-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122234956.788401-1-rostedt@goodmis.org>
References: <20211122234956.788401-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

It's #include <tracefs.h> not #include <tracefs/tracefs.h> as the
pkg-config will give the full path to the include headers. Anything else
will not build properly.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-dynevents.txt | 2 +-
 Documentation/libtracefs-eprobes.txt   | 2 +-
 Documentation/libtracefs-error.txt     | 2 +-
 Documentation/libtracefs-hist-cont.txt | 2 +-
 Documentation/libtracefs-hist.txt      | 2 +-
 Documentation/libtracefs-kprobes.txt   | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/libtracefs-dynevents.txt b/Documentation/libtracefs-dynevents.txt
index 503bd7e..89b2e92 100644
--- a/Documentation/libtracefs-dynevents.txt
+++ b/Documentation/libtracefs-dynevents.txt
@@ -101,7 +101,7 @@ EXAMPLE
 #include <unistd.h>
 #include <sys/wait.h>
 
-#include <tracefs/tracefs.h>
+#include <tracefs.h>
 
 static struct tep_event *open_event;
 static struct tep_format_field *file_field;
diff --git a/Documentation/libtracefs-eprobes.txt b/Documentation/libtracefs-eprobes.txt
index 3baaea3..65e5b13 100644
--- a/Documentation/libtracefs-eprobes.txt
+++ b/Documentation/libtracefs-eprobes.txt
@@ -41,7 +41,7 @@ EXAMPLE
 #include <unistd.h>
 #include <sys/wait.h>
 
-#include <tracefs/tracefs.h>
+#include <tracefs.h>
 
 static struct tep_event *open_event;
 static struct tep_format_field *file_field;
diff --git a/Documentation/libtracefs-error.txt b/Documentation/libtracefs-error.txt
index 3f6a154..33af074 100644
--- a/Documentation/libtracefs-error.txt
+++ b/Documentation/libtracefs-error.txt
@@ -48,7 +48,7 @@ EXAMPLE
 #include <unistd.h>
 #include <errno.h>
 
-#include <tracefs/tracefs.h>
+#include <tracefs.h>
 
 int main (int argc, char **argv, char **env)
 {
diff --git a/Documentation/libtracefs-hist-cont.txt b/Documentation/libtracefs-hist-cont.txt
index 2ee830d..778b8ee 100644
--- a/Documentation/libtracefs-hist-cont.txt
+++ b/Documentation/libtracefs-hist-cont.txt
@@ -51,7 +51,7 @@ EXAMPLE
 [source,c]
 --
 #include <stdlib.h>
-#include <tracefs/tracefs.h>
+#include <tracefs.h>
 
 enum commands {
 	START,
diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index cc6b859..c07fe6f 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -222,7 +222,7 @@ EXAMPLE
 [source,c]
 --
 #include <stdlib.h>
-#include <tracefs/tracefs.h>
+#include <tracefs.h>
 
 enum commands {
 	START,
diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
index 4a4bf01..e488f9a 100644
--- a/Documentation/libtracefs-kprobes.txt
+++ b/Documentation/libtracefs-kprobes.txt
@@ -89,7 +89,7 @@ EXAMPLE
 #include <unistd.h>
 #include <sys/wait.h>
 
-#include <tracefs/tracefs.h>
+#include <tracefs.h>
 
 static struct tep_event *open_event;
 static struct tep_format_field *file_field;
-- 
2.31.1

