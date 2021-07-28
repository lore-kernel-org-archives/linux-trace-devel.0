Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4030C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD2BD60EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhG1Ne0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbhG1Ne0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:26 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88245C061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:24 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id f13so3188983edq.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bDE5H6ouGRCAEZ9YfNrgle8dTCkLnHF61NMoDExWoeY=;
        b=DLLJ7sINsieMyqsKE6C7Y74Rs4RQ6JpITxLyv+CagtDryO2uk1p2BMOQXdpOi5sA4c
         7ww5mQZJdSUMn2OK7aPjZDQtWcyHuw8sgYBUnoX28cXxmEKuRcLd6M0F2ff5Es9WMd1p
         TosD5QDcpXF1Mm50m1IdeYU8yDQX+XCwUSliX20AxHS2wKfPboYAF5rHkxdV4IvMCQ0J
         cOl/3KAfQlxYQ5MYNt535OhVfzuQt7pL0TLfsXG7s0dkxVBpT0RLUN3cOswekJ4xUzRQ
         /S9HRXHqZUEsvWacKcBkR0iGDHx+QvCmEJrGkYwsb/rWonDhbTI+2dxw19zs8lu5sMU3
         yivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bDE5H6ouGRCAEZ9YfNrgle8dTCkLnHF61NMoDExWoeY=;
        b=h2Am4Twm4s1A4nzG5L6gIBpmzFRPBqqwaaehpxfxS7Aj+NtoATWniWDeRLIO9CcpAS
         4EltAWjAbhWNhsV30af9AwVGXwSTjBXnPQTX1SjZgJe4CrN/EQPkdXwn/ORRbTJ8wDAo
         o5mfWOLLZvJKzCsEh6B/ejhb6OzdlBVqewqxO24yn1LGr2irq1EWz68JOPKU8lbuXBdl
         PPVIBY6RTeXFSzZKuBBHWT7TGF3mhltNSDZ5atNcVDxcR8bxlqMWTlQ1XhN0BKygBJs5
         4IhgbdeQwFnXmuYr9Jsh9ZiVvQ7QGMiNdGRG60EuVQqQiVQ3VrzOQc7boEOY0fy/VSfG
         JBDQ==
X-Gm-Message-State: AOAM531KVCjEpEnHZJmCwVou+dlWWxoULkMJE3XpbeE9Ve+qAdIa0VSG
        YKF79Y3tDpSC1jArtZAbKe0=
X-Google-Smtp-Source: ABdhPJwOQcqKtkyOjBusglhlsZy78HNs5Xgox2UZ5FOWyi4n7e0w/wdO+k9PED6MlPyGJHQWbOh4ug==
X-Received: by 2002:aa7:d285:: with SMTP id w5mr6085415edq.132.1627479263149;
        Wed, 28 Jul 2021 06:34:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 84/87] trace-cmd: Update bash completion
Date:   Wed, 28 Jul 2021 16:32:47 +0300
Message-Id: <20210728133250.234140-85-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
2.31.1

