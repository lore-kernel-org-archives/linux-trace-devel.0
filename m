Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB966C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239614AbhLBMee (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346947AbhLBMed (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:34:33 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC5AC06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:31:10 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x15so115206662edv.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VbZnL0lpdI+vGNQrRjSgtZTvcxT/t2MeibgH9TMT8kA=;
        b=EPPoIj68Gd55ju6GYgh2ngZxiRGb3GDD7KQ/9kq3uhiK1/tfsXUTK7tkB/IYkmoh3F
         6T5VOXCxWFN/yklZvjQ583j6rzPipKqp1UFCC5uXnOI7SU9sEjuxTK/rnMT0WP83S2/O
         DK2F4TBf5OvlKGdsYE1Ax2rUJw4s3sR8bKP20FsezW45q+0t+ANzIjFxehg5fUaeI055
         LbXi8A2HFZFULP18J3gCNiOsfaSeRRBEgFJV+wye8U1XQYXoTGmSMVFMm59Q1AZzYmH4
         heASm81983PRLxQYAVrBFQwOt/xkvF1aksXNLDeaQ0/Enm3Ge+hvP0RJ1ckhBv7swI75
         XjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VbZnL0lpdI+vGNQrRjSgtZTvcxT/t2MeibgH9TMT8kA=;
        b=amom4mVZmv8EPRzi2odZDTTr0TJ/ij+59iMoyF7UDMepOSmjKVVbJK7ckFF7B20YhO
         kHSLtwf2XACWJMqgZwfTF4/Id8jsTEHyekyV/z0ERXjuBTM3fiZuMI6FaaZvuKmIwK8I
         yzg6GZ2Yqy1H7v1SOdk/ESMavOp+PB0frFMfI8CUiBupszCnwtVJQqSgvfTV6yT57Kli
         7nzCHevU86Lygk9f5T3J48dsLyw9VeXMRAJ/a5WvBcCTW+mIpp/CxBX3rgZ7Zo861FO2
         eppgvwIJGOnVCsSvNGONYMhEtB7DvbwFBwayvVFQfocuWjQuxHUIzyTlrCLE8+u/LHMu
         IB8Q==
X-Gm-Message-State: AOAM5314c3IXDFLv/KF3f8uWKWhriUc1gscSFpH+q/ScQGXUdzPGbUOJ
        N8WyMMHzlHYz+4nrgFvKz3sCefJX19EICw==
X-Google-Smtp-Source: ABdhPJyngZVp6pQ6IIkTux/OsWG6T413uXEkDF0m50X7mTZX6okV+u/rjsDQ6suj45lubFhF7xPDjA==
X-Received: by 2002:a17:906:2788:: with SMTP id j8mr14640890ejc.203.1638448269570;
        Thu, 02 Dec 2021 04:31:09 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b14sm2120394edw.6.2021.12.02.04.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:31:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 1/4] trace-cmd: Update bash completion
Date:   Thu,  2 Dec 2021 14:31:03 +0200
Message-Id: <20211202123106.44245-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202123106.44245-1-tz.stoyanov@gmail.com>
References: <20211202123106.44245-1-tz.stoyanov@gmail.com>
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
2.33.1

