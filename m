Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D896C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4608360FDA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhIMMyn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbhIMMym (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:54:42 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C894DC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:53:26 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id v20-20020a1cf714000000b002e71f4d2026so5177482wmh.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bDE5H6ouGRCAEZ9YfNrgle8dTCkLnHF61NMoDExWoeY=;
        b=fOXb4FseN2UxHacml94//MNoB4E2N/eDKrC0p72xUMUjWaV5rmxO9uuMNHe/JH+M69
         dKqo1tox2cT7L2slF7KHC+l0dFO1sIMZymodbCESRFWiU/Va+Vn3gu7ZhpCXf5vxrwri
         Q5plRmLVLDIQrA/opZtLdk4/R6woeHQToNMIowL4r/sCxPLHXUNZ/nQgMv0F+M8YQ7Lz
         YbiBXU528YFjDXjqdfdx9oHPR5gBejYZ/UKPkvI/LM0FxZMHPOMcGfPYJNhQXdtcqq6E
         egCooc4LL2FLSd2LFRP2MveY72DEfqM6HqCeBx/hDZDqeQEQOBo+1KGtOwdSgnptGwTV
         2nqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bDE5H6ouGRCAEZ9YfNrgle8dTCkLnHF61NMoDExWoeY=;
        b=KShW6Sk4ux3midZewbfH9B+p/2NW81hA4MlCX0/mva8zN367Jiq26HeaAvGNW94j2J
         u5mNOkq7ueSduiUJrPCqIb/VASfkEQmrScR7Hh0KgLGUlbnhG1bBFaKeJg/tnkGUYEn0
         vC/QjESSEswndss7nmBTIJl1c7q9HwgAHXCa1AZJKPnfavIt3YpdoG6om3xcNBltUhkm
         WcuqRsjQtuL3tF31D4gdACnO3LlGp5ujVpjKsb8mPiHvD5Z27JNXQk7B3rbNRnO2SnRr
         UWTHx6iHcBDgBTFKS7lZnkgPVgCq5u+jta2spUqHeEfJZ83GBEcV21kTzfsmIufG4fwM
         ja8Q==
X-Gm-Message-State: AOAM531V657xFC2bQh1iUR5qhtKM8Z4u8h6jIw0yJoTXcIV/PUm0MYFU
        FOwSreUZHFMNWhnyiSFWrMEj1NrfDkQ=
X-Google-Smtp-Source: ABdhPJxk6ReQW/gTt5cuA7V1bLz9HiqYbEKAB5NeXr8RQ2Ugw6AT80ZWtikRX/dBIuVLSE6bgwO/XA==
X-Received: by 2002:a7b:c947:: with SMTP id i7mr912141wml.136.1631537605436;
        Mon, 13 Sep 2021 05:53:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u8sm7280552wmq.45.2021.09.13.05.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:53:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/4] trace-cmd: Update bash completion
Date:   Mon, 13 Sep 2021 15:53:19 +0300
Message-Id: <20210913125322.3682097-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913125322.3682097-1-tz.stoyanov@gmail.com>
References: <20210913125322.3682097-1-tz.stoyanov@gmail.com>
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

