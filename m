Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A44C433B4
	for <linux-trace-devel@archiver.kernel.org>; Sat, 17 Apr 2021 00:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47995611AB
	for <linux-trace-devel@archiver.kernel.org>; Sat, 17 Apr 2021 00:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbhDQArG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 20:47:06 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:2067 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229719AbhDQArF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 20:47:05 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Apr 2021 17:46:35 -0700
Received: from vypre.com (unknown [10.21.244.206])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id B34EC2045F;
        Fri, 16 Apr 2021 17:46:39 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] trace-cmd record: Add bash tab completion for -A
Date:   Fri, 16 Apr 2021 20:46:35 -0400
Message-ID: <20210417004637.3899514-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210417004637.3899514-1-rostedt@goodmis.org>
References: <20210417004637.3899514-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a virsh lookup of guest names when -A is the option for trace-cmd
record and tab is done.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-cmd.bash | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index 85f6743b..e89c1a55 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -9,6 +9,17 @@ show_instances()
    return 0
 }
 
+show_virt()
+{
+    local cur="$1"
+    if ! which virsh &>/dev/null; then
+	return 1
+    fi
+    local virt=`virsh list | awk '/^ *[0-9]/ { print $2 }'`
+    COMPREPLY=( $(compgen -W "${virt}" -- "${cur}") )
+    return 0
+}
+
 show_options()
 {
    local cur="$1"
@@ -159,6 +170,11 @@ __trace_cmd_record_complete()
 	-O)
 	    show_options "$cur"
 	    ;;
+	-A)
+	    if ! show_virt "$cur"; then
+		cmd_options record "$cur"
+	    fi
+	    ;;
         *)
 	    # stream start and profile do not show all options
 	    cmd_options record "$cur"
-- 
2.29.2

