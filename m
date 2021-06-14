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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CCEC48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CB6A61289
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbhFNHxR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbhFNHxQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:16 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FE2C0617AF
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:14 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id u24so45192311edy.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pPf6AJRWjy/8bENp269gum0/POkaKV7VuSt+MbRzz0M=;
        b=Sc/WOEsGbV6RbZkOu0NUwsm62X6uezOjqoq/8kNRJ9PvAX3Q+JooFfcy3Bjmlq4gnP
         kLtZuoNeihouTur29ZNYTQIPbWzHX9Hysm3PJfbV0XofY/6KgnxJRtQEpcTuVP9Iic3t
         GbJ283KLY1IqgJDiKLfLkhnVj+ex75gupP8V+o4B01Zh60BUvOps1NJtwpDdYw72HsVP
         OW1tIG0zM/8quDPGMHiQy9nAsdu1Kf0H5Xa2+4sVlz9XLZLUMAsIrxkcfaRtz/eErLVT
         JjpsfZqzTwYYjX0fBaGJZaI9yo/1QJp/lcK4Z27n1dXGsy8Ve5Y51okVxYpgXlas4BIe
         x+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pPf6AJRWjy/8bENp269gum0/POkaKV7VuSt+MbRzz0M=;
        b=f9obTdxo1vJRC/jADg3HyDx0uIQUOV3IwgrlVpqw4wM7D4oUyVHdXksES3u+50JFa9
         sGjmt8pV4NIjjeI2nYBO18CZ9FEzzjoi0jFwmd7yOBt9e2w0zKm+J94vxkmndMCvUc9x
         nsfSchbTgf/ZuL+gQ2S1tKfdIxv31KS5IBhwNCASc5NemSsdYK0FfWRMsNVygHno64fR
         WhDBOzC7i4hIPNIRuvy7Bd7kdjdbpnMLgD3jS4iyXhVQERkEX0PnRU0SmrY69V1C4oaT
         nGtcDP4yuBfjCJd+nVl6aZuTxARIf1BjoADXCSSdXFMuMS9V7Mm+qJqhaJbHieTE1N0t
         Bj4Q==
X-Gm-Message-State: AOAM532RlFmPjOvW7cE1Ihz3eqXpAo4OgMza3+aK3REjpxFODWaH468Q
        hypwL/f1WlXftGDKpFskDvg=
X-Google-Smtp-Source: ABdhPJxBBwU1BhsKGTJBL57fQFVfsfs5jjUqVyYw/70XS8KTbPCMJCA5WkTIOp/gvwT5IT6Ayb0Ihw==
X-Received: by 2002:a05:6402:26c7:: with SMTP id x7mr15585485edd.383.1623657072615;
        Mon, 14 Jun 2021 00:51:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 43/45] trace-cmd: Update bash completion
Date:   Mon, 14 Jun 2021 10:50:27 +0300
Message-Id: <20210614075029.598048-44-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added support for trace-cmd convert and compression parameters in bash
completion.

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

