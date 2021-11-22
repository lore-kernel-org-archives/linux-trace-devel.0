Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD413C43217
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 23:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhKVXxO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:53:14 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:32625 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231894AbhKVXxN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 18:53:13 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Nov 2021 15:50:04 -0800
Received: from vypre.local.home (unknown [10.21.245.36])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 2B72420348;
        Mon, 22 Nov 2021 15:50:06 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 04/11] tracefs/Documentation: Fix example in libtracefs-eprobes.txt to compile
Date:   Mon, 22 Nov 2021 18:49:49 -0500
Message-ID: <20211122234956.788401-5-rostedt@goodmis.org>
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

The example program in libtracefs-eprobes.txt man page did not compile,
and had a warning. Fix the mykprobe string, and remove the unused label.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-eprobes.txt | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Documentation/libtracefs-eprobes.txt b/Documentation/libtracefs-eprobes.txt
index 65e5b13..4155544 100644
--- a/Documentation/libtracefs-eprobes.txt
+++ b/Documentation/libtracefs-eprobes.txt
@@ -62,8 +62,6 @@ static int callback(struct tep_event *event, struct tep_record *record,
 
 	trace_seq_terminate(&seq);
 	trace_seq_do_printf(&seq);
-
-out:
 	trace_seq_destroy(&seq);
 
 	return 0;
@@ -89,7 +87,7 @@ int main (int argc, char **argv, char **env)
 	struct tracefs_dynevent *eprobe;
 	struct tracefs_instance *instance;
 	struct tep_handle *tep;
-	const char *sysnames[] = { mykprobe, NULL };
+	const char *sysnames[] = { myprobe, NULL };
 	pid_t pid;
 
 	if (argc < 2) {
-- 
2.31.1

