Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2DD2C43460
	for <linux-trace-devel@archiver.kernel.org>; Sat, 17 Apr 2021 00:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1BA66101E
	for <linux-trace-devel@archiver.kernel.org>; Sat, 17 Apr 2021 00:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbhDQArG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 20:47:06 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:40218 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229719AbhDQArG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 20:47:06 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Apr 2021 17:46:36 -0700
Received: from vypre.com (unknown [10.21.244.206])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 6C9412045F;
        Fri, 16 Apr 2021 17:46:40 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] trace-cmd record: Update -e event bash tab completion
Date:   Fri, 16 Apr 2021 20:46:36 -0400
Message-ID: <20210417004637.3899514-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210417004637.3899514-1-rostedt@goodmis.org>
References: <20210417004637.3899514-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Update the tab completion to find events instead of needing to know the
systems.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-cmd.bash | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index e89c1a55..9b0703b7 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -142,10 +142,16 @@ __trace_cmd_record_complete()
 
     case "$prev" in
         -e)
-            local events=$(trace-cmd list -e)
+	    local list=$(trace-cmd list -e "$cur")
             local prefix=${cur%%:*}
+	    if [ -z "$cur" -o  "$cur" != "$prefix" ]; then
+		COMPREPLY=( $(compgen -W "all ${list}" -- "${cur}") )
+	    else
+		local events=$(for e in $list; do echo ${e/*:/}; done | sort -u)
+	        local systems=$(for s in $list; do echo ${s/:*/:}; done | sort -u)
 
-            COMPREPLY=( $(compgen -W "${events}" -- "${cur}") )
+		COMPREPLY=( $(compgen -W "all ${events} ${systems}" -- "${cur}") )
+	    fi
 
             # This is still to handle the "*:*" special case
             if [[ -n "$prefix" ]]; then
-- 
2.29.2

