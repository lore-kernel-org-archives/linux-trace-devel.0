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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5CCC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F3864FB3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhCKItr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhCKItS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 03:49:18 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832B9C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:18 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id e19so44592226ejt.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cGItAm0KdBmyA0uZhimYLjv3a/cNK6WQJH0OOStbyAU=;
        b=n1a/WjRv2pBS4WBOdCVMbVck0YUcrpJaGhZ/n3yLgSOoSLSmsV2nA/ZpQf4z0307Ir
         NCp8k9CfDGf6N/vzUs3NQ3LXLvLev0VCFjoDrDesB18MdG56KeihMEZMkKPlal0TofIZ
         yS75Eaf1Z+qfAyHKjb+XRUXMlGE9+FobTHnKYEI2dgOhqWLQbvVqBOuGvxySt49t53ia
         VlpqGhc33DMX5fI5Tb6KXWorhqyyz5dSsXcJOlzcj5S2I/tQlTQS+gz4E4mAetjeRauJ
         qQJ446Onk6mWO39x6kpMCwyXzkiAB3hNh/Kq6qVH5IF5STTO5GcnAhv/wT1eUZk5gwkr
         yOsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGItAm0KdBmyA0uZhimYLjv3a/cNK6WQJH0OOStbyAU=;
        b=rSlp0dfvj4Ou5ybQR91jp94Nxq8HT6UR8X5wqNYogK8mFKsdZrvpQm6udLRiDOXYaF
         H/+f8BD+6QKuEglrJ4ahOrH8igTI2yLAoX5QM2OBZ0uApka8yQGlCtfxO51cYvPUL5kA
         xg0AuyAqzKjfXmR6uChnLXZ7tsAxfvk7zBtrKaSnr2fHyx77mu/cpU1cuqRY77WeI3iU
         sBk0zG6n5N4Ob8J7XCs9Ce1Pg5Iwt/rlSpCJTedbMRGH2QRh5jJfNzPFXgna+15xNivJ
         92taA8a0AOOYPhze/eo3x2gAnd3hCalHooGHjEcB6ZSl///KPzvIPZXlSUTfS6wL94gN
         JT9w==
X-Gm-Message-State: AOAM530qjFGN/DNKj6eTsnezd19vHi/c5WfpGtm96YkLWfAQJ9uLnLcK
        DzgIeWZE75X1uFaeUTW/yyJaapwUDw3owQ==
X-Google-Smtp-Source: ABdhPJznOpC8PTLz/x93VIY5WGR5C1KbTg+Jr+8btRc5U5Q2o9gFSdocezDYViIEb0Hnf7joEJUv/g==
X-Received: by 2002:a17:907:76b6:: with SMTP id jw22mr2042671ejc.11.1615452557355;
        Thu, 11 Mar 2021 00:49:17 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id fi11sm901647ejb.73.2021.03.11.00.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:49:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v31 11/16] trace-cmd: Add a new option in trace file metadata for tsc2nsec conversion
Date:   Thu, 11 Mar 2021 10:48:52 +0200
Message-Id: <20210311084857.1919805-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
References: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new option is added in the trace.dat file for holding the multiplier
and shift, used for converting TSC trace clock to nanoseconds.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h        |  1 +
 tracecmd/trace-dump.c                          | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 0f682c18..49e0bb42 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -125,6 +125,7 @@ enum {
 	TRACECMD_OPTION_TRACEID,
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
+	TRACECMD_OPTION_TSC2NSEC,
 };
 
 enum {
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index c1143eba..31b13af4 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -487,6 +487,21 @@ out:
 	free(buf);
 }
 
+void dump_option_tsc2nsec(int fd, int size)
+{
+	int mult, shift, offset;
+
+	do_print(OPTIONS, "\n\t\t[Option TSC2NSEC, %d bytes]\n", size);
+
+	if (read_file_number(fd, &mult, 4))
+		die("cannot read tsc2nsec multiplier");
+	if (read_file_number(fd, &shift, 4))
+		die("cannot read tsc2nsec shift");
+	if (read_file_number(fd, &offset, 4))
+		die("cannot read tsc2nsec offset");
+	do_print(OPTIONS, "%d %d %d [multiplier, shift, offset]\n", mult, shift, offset);
+}
+
 static void dump_options(int fd)
 {
 	unsigned short option;
@@ -546,6 +561,9 @@ static void dump_options(int fd)
 		case TRACECMD_OPTION_GUEST:
 			dump_option_guest(fd, size);
 			break;
+		case TRACECMD_OPTION_TSC2NSEC:
+			dump_option_tsc2nsec(fd, size);
+			break;
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
-- 
2.29.2

