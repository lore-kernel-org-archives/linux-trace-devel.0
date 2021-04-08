Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A6DC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47035610D1
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 21:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhDHVmQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 17:42:16 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:11120 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhDHVmQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 17:42:16 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 8 Apr 2021 14:42:00 -0700
Received: from vypre.com (unknown [10.21.244.31])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id D9865212DB;
        Thu,  8 Apr 2021 14:42:03 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 1/5] libtraceevent: Update gitignore
Date:   Thu, 8 Apr 2021 17:41:56 -0400
Message-ID: <20210408214200.2063946-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210408214200.2063946-1-rostedt@goodmis.org>
References: <20210408214200.2063946-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Update the gitignore files to not pick up files that are created in the
build as well as those auxiliary files used for creating the man pages.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .gitignore               | 5 +++++
 Documentation/.gitignore | 3 +++
 2 files changed, 8 insertions(+)
 create mode 100644 Documentation/.gitignore

diff --git a/.gitignore b/.gitignore
index 7123c70..fde7fe6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -2,3 +2,8 @@
 TRACEEVENT-CFLAGS
 libtraceevent-dynamic-list
 libtraceevent.so.*
+*.o
+build_prefix
+build_uninstall
+*~
+\#*\#
diff --git a/Documentation/.gitignore b/Documentation/.gitignore
new file mode 100644
index 0000000..bdc8252
--- /dev/null
+++ b/Documentation/.gitignore
@@ -0,0 +1,3 @@
+*.m
+*.3
+*.html
-- 
2.29.2

