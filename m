Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120D4C43217
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 23:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhKVXxQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:53:16 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:32630 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231953AbhKVXxP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 18:53:15 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Nov 2021 15:50:06 -0800
Received: from vypre.local.home (unknown [10.21.245.36])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 4B37B20364;
        Mon, 22 Nov 2021 15:50:08 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 07/11] libtracefs/Documentation: Fix example in libtracefs-error.txt
Date:   Mon, 22 Nov 2021 18:49:52 -0500
Message-ID: <20211122234956.788401-8-rostedt@goodmis.org>
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

The example code in libtracefs-error.txt man page referenced the old
tracefs_kprobe_clear_probe() API that no longer exists. Update it to use
the new tracefs_dynevent_get() and the tracefs_dynevent_destroy() API to
do the same thing.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-error.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-error.txt b/Documentation/libtracefs-error.txt
index 33af074..8dd5b42 100644
--- a/Documentation/libtracefs-error.txt
+++ b/Documentation/libtracefs-error.txt
@@ -52,6 +52,7 @@ EXAMPLE
 
 int main (int argc, char **argv, char **env)
 {
+	struct tracefs_dynevent *kevent;
 	char *system = NULL;
 	char *kprobe;
 	char *format;
@@ -72,7 +73,11 @@ int main (int argc, char **argv, char **env)
 	format = argv[arg++];
 
 	tracefs_error_clear(NULL);
-	tracefs_kprobe_clear_probe(system, kprobe, true);
+	kevent = tracefs_dynevent_get(TRACEFS_DYNEVENT_KPROBE, system, kprobe);
+	if (kevent) {
+		tracefs_dynevent_destroy(kevent, true);
+		tracefs_dynevent_free(kevent);
+	}
 
 	ret = tracefs_kprobe_raw(system, kprobe, addr, format);
 	if (ret < 0) {
-- 
2.31.1

