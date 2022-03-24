Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7776AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Mar 2022 02:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346508AbiCXCvw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Mar 2022 22:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238122AbiCXCvv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Mar 2022 22:51:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118FB12774
        for <linux-trace-devel@vger.kernel.org>; Wed, 23 Mar 2022 19:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC33FB8220D
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Mar 2022 02:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FA8C340E8
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Mar 2022 02:50:18 +0000 (UTC)
Date:   Wed, 23 Mar 2022 22:50:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix bash completions for non specified commands
Message-ID: <20220323225016.3a3a7034@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

For trace-cmd commands that are not specifically specified by the bash
completion script, allow to see files after the commands. There's a bug in
the test that returns if there are options, and does not jump to the file
listing if there is any option even if the user does not specify one, and
wants a file instead.

Also make a reference to $cur more consistent with its other references,
which is ${cur}

Fixes: 431f1a03f59cb trace-cmd: Fix bash completion on directory names
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-cmd.bash | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index 6639c1433678..66bd6f4bf2dd 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -52,7 +52,7 @@ cmd_options()
 				 sed -e 's/ *\(-[^ ]*\).*/\1/')
     COMPREPLY=( $(compgen -W "${cmds}" -- "${cur}") )
     if [ ${#COMPREPLY[@]} -eq 0 ]; then
-	__show_files "$cur"
+	__show_files "${cur}"
     fi
 }
 
@@ -276,10 +276,12 @@ __show_command_options()
 		done
 	    fi
 	    COMPREPLY=( $(compgen -W "${opts}" -- "$cur"))
-	    return 0
+	    break
 	fi
     done
-    __show_files "$cur"
+    if [ ${#COMPREPLY[@]} -eq 0 ]; then
+	__show_files "${cur}"
+    fi
 }
 
 _trace_cmd_complete()
-- 
2.35.1

