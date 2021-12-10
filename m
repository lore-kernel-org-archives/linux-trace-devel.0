Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87106C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhLJLKy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbhLJLKx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:10:53 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD4CC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:07:18 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id t5so28394175edd.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VbZnL0lpdI+vGNQrRjSgtZTvcxT/t2MeibgH9TMT8kA=;
        b=igSmt4EG0TaBt31joOJ6AT026e0rlR19n567juQzFYm9rgTWstDt2W38BYiVh877dx
         /uv9GkCTNkRq1SMLcsO0orqa9VGDeSuIrkBXe2j1FM+OGnVGVWuIlQaEJYDW73HMawlT
         NnSHpNL7oQ1uwMSJynS5KEjG+CqNRAmZ3eyz6GCxGDmkLkpi1+uQDh1dVOtJ7fuzXsMx
         /IedhGfoI+3T3pFfWmzhZ+An6lRLL2da0YnwKwgfFBLfXeMvs2qbBPenEPhA3XnO1ij7
         bHDgi6Fsj9iK26KX1+RIEqCb5dgbrtZn26vywysuwv+YQKzV8tvCExmVM56qF+clfQ6D
         2zCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VbZnL0lpdI+vGNQrRjSgtZTvcxT/t2MeibgH9TMT8kA=;
        b=7FKAaroxRRHe4wF8KVhY1lxLyTa+TXhpgOsq2ZnfW240+AX+MCDzIS1CAbQmjJ1bZN
         4gcFvPyLbqXKS196twN+DlBEk9yaEoIYw9Tjr8isE9CHbUDIsLLZmTFbYTcJzqGjOaBM
         1Hh8fBZbmwHor5uiF8UtoCfVt5cFuklF9SWJ7ct5n+jRiaOQQHtELVamfqi3k4ACarp5
         f3zZSwmCVlhVFS/aIV+t6iv/+3MXDF4yqasLKr+fTE3nKJ1rQl/XHH1l3tIoFJTVGSwf
         QMCNRlnnsFCf+bFbMpor/yzH4LQAXadIkgcpi9MW3QAkaGzbKPCs6xCeI85fd9/h/j21
         GaGw==
X-Gm-Message-State: AOAM531xL791Vk9xiMPZZrqjXDclc2ddveWEI1Hf+BJgHo6eKD9upiNb
        pYpn8FT+45TbK+dhIS+E2FOhcSNIdKs=
X-Google-Smtp-Source: ABdhPJwjFE9a4dbUTlrbwvH+qnvPtmBSVnAusXp+oWhXIfZnak/pU0IBi5WXvvwbR3BKHiEac4NI5g==
X-Received: by 2002:a17:906:49d6:: with SMTP id w22mr22384423ejv.222.1639134436796;
        Fri, 10 Dec 2021 03:07:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w5sm1299236edc.58.2021.12.10.03.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:07:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 1/4] trace-cmd: Update bash completion
Date:   Fri, 10 Dec 2021 13:07:11 +0200
Message-Id: <20211210110714.99067-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110714.99067-1-tz.stoyanov@gmail.com>
References: <20211210110714.99067-1-tz.stoyanov@gmail.com>
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

