Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDABC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 13:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F8A261151
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 13:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhDHNfE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 09:35:04 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:43103 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231739AbhDHNfD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 09:35:03 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 8 Apr 2021 06:34:42 -0700
Received: from vypre.com (unknown [10.21.244.31])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id F1F5B20C0C;
        Thu,  8 Apr 2021 06:34:44 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: [PATCH v2 1/5] libtracefs: Close filter file descriptor on freeing of instance
Date:   Thu, 8 Apr 2021 09:34:27 -0400
Message-ID: <20210408133431.2023697-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210408133431.2023697-1-rostedt@goodmis.org>
References: <20210408133431.2023697-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If the instance ftrace_filter_fd is open on freeing of the instance, close
it.

Link: https://lore.kernel.org/linux-trace-devel/20210408085340.5e84064f@gandalf.local.home/

Suggested-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-instance.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index bf2fabf..e222191 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -66,6 +66,10 @@ void tracefs_instance_free(struct tracefs_instance *instance)
 {
 	if (!instance)
 		return;
+
+	if (instance->ftrace_filter_fd >= 0)
+		close(instance->ftrace_filter_fd);
+
 	free(instance->trace_dir);
 	free(instance->name);
 	free(instance);
-- 
2.29.2

