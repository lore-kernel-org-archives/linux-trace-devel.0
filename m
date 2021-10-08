Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A3CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34D9860F35
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbhJHEbJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhJHEbI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:31:08 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A0EC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:29:13 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id p13so31835336edw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bDE5H6ouGRCAEZ9YfNrgle8dTCkLnHF61NMoDExWoeY=;
        b=moDivMnL3rmdccFyMY5KgnSya2r55Ig/8iCM+IZ7yszhnVQorlIfc3PikbgWe4inF3
         k+0rVohgpbwZdFeCQCTvnK5VQPuyEP0EXJRGlCnBxLc716LkBzRW79DuN/UXs36QMY8I
         KhKSceytIioIVC/Nv6JvrcUtoq5WSeq287CCieTjDUuzejQR3oRhef3Rs0QLJVI4gDya
         VXD2VxD/p09V2bbvjxzrwU1QG+OdVQBQpjJf9C3MqideaaCqkaCs7GTAWKJbETclVY8n
         +wcsHAIoMoFbxUi1Z5GCwOhPZgjdjGfFPVmflDRGixbKS1ob/7wT/3dKg+bA7Lu3mXKk
         0SSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bDE5H6ouGRCAEZ9YfNrgle8dTCkLnHF61NMoDExWoeY=;
        b=BGFVAaWzv+WlrRY2vvA4Qx5cXlQo7FQe9iR7VR4OaKk98kMAH41aKZRN/oSMeF9qLr
         n2xkU8d46imj1fnOnx20pnglyn/l3+RQhVHN0wUP0szwxoHM74uU8Bitkrlvd/PfBJFm
         30+V29TSjzMBRtYHXD+UsZpcxMAlvDzo+sBSYZ9J1ALg96aPjpEViI/X4yycgRcB3UF9
         cYNqXC7Axj4k+J8tGBMCAdiy+jgrWCJ3cYNmlSKVYsmw1tf5ne99vcpH19qmoQZNsSfF
         3JlN8TH/W6ua9D/4+/AV5+TogQNHrVvDtveAf+g4mY9L5/xtIyRhWMCGSO5AJQPSlJzH
         B5oQ==
X-Gm-Message-State: AOAM530MPWoRNlV5HfgWGnXnQpNIN9vTVoYIj5eRQl7e5T7526SLCkuO
        ZEOrR+Lb0T3OVrRip37u39GFgZGdRsa2eA==
X-Google-Smtp-Source: ABdhPJzj0MIs6Ir15Glt63JmBsowDl8dcRTvQLPgUEJalWZ4zoO6lRwHOt5DxPlGCcX6dvnFx0C2/w==
X-Received: by 2002:a17:906:369a:: with SMTP id a26mr1240754ejc.539.1633667352551;
        Thu, 07 Oct 2021 21:29:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j11sm456662ejt.114.2021.10.07.21.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:29:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/4] trace-cmd: Update bash completion
Date:   Fri,  8 Oct 2021 07:29:06 +0300
Message-Id: <20211008042909.979877-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042909.979877-1-tz.stoyanov@gmail.com>
References: <20211008042909.979877-1-tz.stoyanov@gmail.com>
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

