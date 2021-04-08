Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67406C43462
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 13:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EDFD61130
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 13:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbhDHNfF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 09:35:05 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:43103 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231255AbhDHNfE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 09:35:04 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 8 Apr 2021 06:34:43 -0700
Received: from vypre.com (unknown [10.21.244.31])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id ECF6C20C0E;
        Thu,  8 Apr 2021 06:34:45 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 2/5] libtracefs: Close the filter file descriptor on exec()
Date:   Thu, 8 Apr 2021 09:34:28 -0400
Message-ID: <20210408133431.2023697-3-rostedt@goodmis.org>
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

There's no reason to keep the function filter file descriptor open if the
application does an exec(). That can end up being a security issue. Best
to set O_CLOEXEC flag when opening such that if the application leaves the
file open and does an exec, it will be closed and the exec code does not
have write permission into that file.

If someone wants to have the file descriptor opened, then they need to
open code the access to the file themselves, and if they want to use the
API for such a use case, then they should submit a bugzilla with an
enhancement request.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index cb07b6f..92e3f72 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -853,7 +853,7 @@ int tracefs_function_filter(struct tracefs_instance *instance, const char *filte
 	open_flags = reset ? O_TRUNC : O_APPEND;
 
 	if (*fd < 0)
-		*fd = open(ftrace_filter_path, O_WRONLY | open_flags);
+		*fd = open(ftrace_filter_path, O_WRONLY | O_CLOEXEC | open_flags);
 	tracefs_put_tracing_file(ftrace_filter_path);
 	if (*fd < 0)
 		goto out_free;
-- 
2.29.2

