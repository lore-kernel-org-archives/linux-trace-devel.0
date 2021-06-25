Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD8FC2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 20:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 393B561973
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 20:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhFYUck (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 16:32:40 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:55896 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229573AbhFYUck (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 16:32:40 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 25 Jun 2021 13:15:11 -0700
Received: from oasis.vmware.com (unknown [10.84.232.102])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 6278120318;
        Fri, 25 Jun 2021 13:15:15 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] trace-cmd: Do not enforce upper limit of verbose id
Date:   Fri, 25 Jun 2021 16:15:11 -0400
Message-ID: <20210625201511.1206465-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210625201511.1206465-1-rostedt@goodmis.org>
References: <20210625201511.1206465-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Applications that have a "verbose" option, do not usually set an upper
limit of what can be passed in. If the max is -V6, trace-cmd should not
error if someone passes in -V7. The way this is handled, is just set the
verbosity to the highest level if the number supplied is above the highest
level.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-cmd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 7f5d1ffd..9fc126e4 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -68,7 +68,9 @@ int trace_set_verbose(char *level)
 
 	if (isdigit(level[0])) {
 		id = atoi(level);
-		if (id >= TEP_LOG_NONE && id <= TEP_LOG_ALL) {
+		if (id >= TEP_LOG_NONE) {
+			if (id > TEP_LOG_ALL)
+				id = TEP_LOG_ALL;
 			tracecmd_set_loglevel(id);
 			return 0;
 		}
-- 
2.30.2

