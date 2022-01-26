Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7677C2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbiAZJzh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJzg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:55:36 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99A1C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:55:35 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id j23so63041598edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MGXHuQX5vwaqYPPtMcMPtJdnP+a4bN96V7nhqFeCZ9w=;
        b=ZI0yeNtS3qxuBuv3JMtK9zI9vO6kBLA5ZN/dlz9/R5gh5UJz5sBl8hPA36M+0pSctp
         b0EhaNHbZB+QpKAW7gs4PEKNr1SUDa9jabHKzeQSj2PnIdWTxScgqTifuIZuqHoKcIxG
         njMH7p9lgJ0TYEC99/w0QzCT0Q1nteXm7PDadTSRDqnwbuWX5Z5lxKhCcHUdHR7+R/3T
         Nu2M1LAcdIKuM6yhD0RUd9ooJ+ObstnXmkwpEcf37EgpN6sAOsTFx2n+hDwvijdmEHDi
         EEpNRtgN5ZDmQudBXSUp8Rp/f0cxMhQ2FFu+S27TmFYS1di/JmK7q1LAn00teOwRvR7g
         o8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MGXHuQX5vwaqYPPtMcMPtJdnP+a4bN96V7nhqFeCZ9w=;
        b=MjgldQPT5X8wYoc+p7tDmMTTFt7QWEzyJXkEWYSukdCvC1RORKM9855sxWHU458rW5
         XBut/9BoGeHpYdUSEjWGYt+Fl+htaGLq9ABDLmDC8XEzH2sEs0DCWTwUG75RgnIF84rT
         umAcRaXGmwKTwuLPL5pVaeqkBx53DnrUUmkabcB0aPw0rjCH6bS8a8/CmlcS5tjfuZpE
         6DX1gz44qHC/4Jfr2/EQEOsnwSKant4XowQvyfu9Q/CMMNmVHAI/0JqmG47V7rQ9u0dI
         bCVGkFGIK2sZDSwQaPCRaoxZGefeZJTYTzD6J641SmEC+LrugSg9P0aACp4nQJpMK2f7
         J9bQ==
X-Gm-Message-State: AOAM531DQjmPsrOu8UeWRWSmd5cHkqAMw0WTmZMVrOUO0lS+YfNqXhbv
        4/nv66Klxjb+z0FhLw8DszHWtBq2JuQ=
X-Google-Smtp-Source: ABdhPJwhxOq3j70gk3WQM6vAUqiWfnHcEErlMbY/luuhFwcMPYqBWhIIbdlbeaQRK78hoH7fVUReXg==
X-Received: by 2002:a05:6402:5109:: with SMTP id m9mr10580561edd.337.1643190934423;
        Wed, 26 Jan 2022 01:55:34 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id z25sm9563070edm.60.2022.01.26.01.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:55:33 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 1/4] trace-cmd: Update bash completion
Date:   Wed, 26 Jan 2022 11:55:27 +0200
Message-Id: <20220126095530.571035-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095530.571035-1-tz.stoyanov@gmail.com>
References: <20220126095530.571035-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added convert subcommand and its arguments to bash completion logic.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-cmd.bash | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index b01c7a07..6639c143 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -64,6 +64,13 @@ plugin_options()
     COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
 }
 
+compression_param()
+{
+    local opts=$(trace-cmd list -c | grep -v 'Supported' | cut -d "," -f1)
+    opts+=" any none "
+    COMPREPLY=( $(compgen -W "${opts}") )
+}
+
 __trace_cmd_list_complete()
 {
     local prev=$1
@@ -181,6 +188,9 @@ __trace_cmd_record_complete()
 		cmd_options record "$cur"
 	    fi
 	    ;;
+	--compression)
+	    compression_param
+	    ;;
         *)
 	    # stream start and profile do not show all options
 	    cmd_options record "$cur"
@@ -222,6 +232,29 @@ __trace_cmd_dump_complete()
     esac
 }
 
+__trace_cmd_convert_complete()
+{
+    local prev=$1
+    local cur=$2
+    shift 2
+    local words=("$@")
+
+    case "$prev" in
+	-i)
+	    __show_files
+	    ;;
+	-o)
+	    __show_files
+	    ;;
+	--compression)
+	    compression_param
+	    ;;
+	*)
+	    cmd_options convert "$cur"
+	    ;;
+    esac
+}
+
 __show_command_options()
 {
     local command="$1"
@@ -298,6 +331,10 @@ _trace_cmd_complete()
 	    __trace_cmd_dump_complete "${prev}" "${cur}" ${words[@]}
 	    return 0
 	    ;;
+	convert)
+	    __trace_cmd_convert_complete "${prev}" "${cur}" ${words[@]}
+	    return 0
+	    ;;
         *)
 	    __show_command_options "$w" "${prev}" "${cur}"
             ;;
-- 
2.34.1

