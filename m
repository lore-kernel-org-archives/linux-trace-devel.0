Return-Path: <SRS0=s3Jp=26=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C98CC33CA1
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 12:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EED862082E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Jan 2020 12:21:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TTHe2Ggq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbgAIMVE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Jan 2020 07:21:04 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:41463 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730345AbgAIMVE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 07:21:04 -0500
Received: by mail-lj1-f181.google.com with SMTP id h23so6978901ljc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Jan 2020 04:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sOz3/zYzIQwAO/2tT9D7Pe7X58OroiWuc4JhTK3Kw6I=;
        b=TTHe2Ggqxi7FIFLaaczgilafQn5R7IMTz9QUPdN9NgiXMzxZOankkhF9tE6EU+7nlj
         b3dOSJwsZvgoUt7ZMj3zNPJrhm/AmOVYBr4rA3pu15SGxp3wCrbDqYCFLLjJC15CnY0T
         dU9MrMMwVxqaL3T+ITdN8Fz8eCoUrtLaIIKJu240GNReAawwIngAZCf5Ft8SxruIaGGD
         TbGX/JfmWH4uAT2niki5n6R3A6bnFHL/eNZQX6MbdLXwC0GAHv8assXhv+Hni3PPtEjr
         pu60Ul64tkTCJhqQiKX1xcYYuoVOqk/k41ZIoMhqmhgbj7zJQey1Ui3ErJL3A5RLTx3u
         8/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sOz3/zYzIQwAO/2tT9D7Pe7X58OroiWuc4JhTK3Kw6I=;
        b=FEP+e/MT+WFZU2nV/H7YuVumxtAC4NvxZ8lnNC9BRCSTKOy3wRAiMoXxYG95JzZMmA
         PbPPzwJcdIEG0jcp7XO9PbnFtxOFzojNhg56pdgeig9RxveZPYiD62Y6ABxavDmHW3wQ
         ym4+i0cQ1C5U19jPLDq5cGP7MTHzgnUCqaJ4CQ1AdTy5JKwKiJli/cvzv7gEqAa97Qw0
         c+ccZWTv0dX4vhP0KUj4XQTbmXt8sLcQHthn5L/dVtnpTpPxzOZMSECQwAsKrDNBMxGc
         Ld9mYnzDi3BqGmojcl6v4yt1lEGIWx29TJXUjGb8pb5hgBZDABpcygRVKDqmGskL8k0d
         T+2g==
X-Gm-Message-State: APjAAAUpHjsqHt5IXUXIGuDGRc0KxZPPtcQpcpJC80QQ/0sfvWVs0Yxc
        faMq5xiuhUrsgxyh3CeMVYWozSEs0nI=
X-Google-Smtp-Source: APXvYqx0BMKWZ1sfyRdI//PztfGUirZZPU9ZqAcFkP+BrOsxD39N+91LCpB/LE7V5wLqxTNzjvn6Iw==
X-Received: by 2002:a2e:87ca:: with SMTP id v10mr6351769ljj.253.1578572462595;
        Thu, 09 Jan 2020 04:21:02 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f16sm2877251ljn.17.2020.01.09.04.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 04:21:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd: bash completion of "trace-cmd dump" sub-command
Date:   Thu,  9 Jan 2020 14:20:55 +0200
Message-Id: <20200109122055.286290-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109122055.286290-1-tz.stoyanov@gmail.com>
References: <20200109122055.286290-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Update trace-cmd bash completion logic to support "trace-cmd dump" sub-command

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-cmd.bash | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index bdc1410..85f6743 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -183,6 +183,23 @@ __trace_cmd_report_complete()
     esac
 }
 
+__trace_cmd_dump_complete()
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
+	*)
+	    cmd_options dump "$cur"
+	    ;;
+    esac
+}
+
 __show_command_options()
 {
     local command="$1"
@@ -246,6 +263,10 @@ _trace_cmd_complete()
 	    __trace_cmd_report_complete "${prev}" "${cur}" ${words[@]}
 	    return 0
 	    ;;
+	dump)
+	    __trace_cmd_dump_complete "${prev}" "${cur}" ${words[@]}
+	    return 0
+	    ;;
         *)
 	    __show_command_options "$w" "${cur}"
             ;;
-- 
2.24.1

