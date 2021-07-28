Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2CFC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 06:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3C7B600EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 06:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232892AbhG1G56 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 02:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbhG1G56 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 02:57:58 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE32C061757;
        Tue, 27 Jul 2021 23:57:56 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l11-20020a7bc34b0000b029021f84fcaf75so3529323wmj.1;
        Tue, 27 Jul 2021 23:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0hPJ2eM108VBPMygJW7FBQ1mhFxbbeIosvraPR0SMy8=;
        b=u3PL8CME/Ym8wcqb5CsJffiCUy61dWeYLtb53B3dJ8ibUJDOpjhQRTcmm4YYCYIV37
         IOBjFB+quHq5lpioniNsO4hVSQU+acgS7CM3Z7GYuxeTw+E8qO5J+fFpMslwIi4XrPZD
         WbT9aLUv8hUCPmMIv0bEmeswzpTHtLaA/2ydXG1WpdFxb4i4s7THI7NdyIUEcFmAlGpq
         QZyMYEZu1pSOD5GfzFQQQo5QUNr7UKHCG+Td8urAYy2uaG3iWHN32vQqd9K5bVhvC16N
         +/1b+ZWrf1hDNW/K02Hw17TVN+mFuAwFjvE/mdO5JD0MvzFXb5iX7iopqdpYenaC+IE3
         jeWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0hPJ2eM108VBPMygJW7FBQ1mhFxbbeIosvraPR0SMy8=;
        b=BkIktg27rXNFegmBZ+fVeUTidTYMXea5BgzJnrPcnE3VSofy6pALUkePxVqR4SgZY+
         NEZr94dpyzVgZEURZWX2T+SmW3d3F6xeLBGN3dwSIL/0SzBdhVL4xIvn8qY7oN55MSEi
         iK3CTzvWx3PAxqLhdup8s30+6p10VxRIplxvFvAO47wezcp87LGHgE3zu7e/y7/BUc6r
         7ui1MRMsS+YliRjHFApmE1dTME9qmWa7RO2DJgj71Es43pX7qYMhUNyuf8Y4ttx9y9/4
         aVB8U4w8O7Q6kVavxYLRNxwdkAWfqKwSPWLGP0axJ/eJzqwquEEGlGY7H39vMrXKG9Go
         q0lg==
X-Gm-Message-State: AOAM532dcq23qR9hQMA4Bwk16U92PCYGwQW3DckBwGt7fMeqhI2+BHED
        gaMo5ssknjjgFOiVsDEajYI=
X-Google-Smtp-Source: ABdhPJw4X84e2qgq83RiEBDq2Js0aP6A3v0mq2u03FLt3NPSkffWZvSDwk6j0c4hL4XKX49f3DW45w==
X-Received: by 2002:a05:600c:414a:: with SMTP id h10mr6097627wmm.139.1627455475383;
        Tue, 27 Jul 2021 23:57:55 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2d7f:fa00:d17c:3332:9759:3d34])
        by smtp.gmail.com with ESMTPSA id s3sm5506678wru.29.2021.07.27.23.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 23:57:54 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH RESEND] MAINTAINERS: add TRACE EVENT LIBRARY section
Date:   Wed, 28 Jul 2021 08:57:48 +0200
Message-Id: <20210728065748.19989-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The git history shows that the files under ./tools/lib/traceevent/ are
being developed and maintained by Tzetomir Stoyanov and Steven Rostedt
and are discussed on linux-trace-devel list.

Add a suitable section in MAINTAINERS for patches to reach them.

This was identified with a small script that finds all files only
belonging to "THE REST" according to the current MAINTAINERS file, and I
acted upon its output.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
applies cleanly on next-20210726

RFC patch (from early 2020) here: https://lore.kernel.org/lkml/20200201161931.29665-1-lukas.bulwahn@gmail.com/

also copied Steven's Acked-by from the RFC patch.

Arnaldo, please pick this quick patch.

 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2eb730101689..5a1863b93a9a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18828,6 +18828,13 @@ Q:	https://patchwork.kernel.org/project/linux-integrity/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git
 F:	drivers/char/tpm/
 
+TRACE EVENT LIBRARY
+M:	Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
+M:	Steven Rostedt <rostedt@goodmis.org>
+L:	linux-trace-devel@vger.kernel.org
+S:	Maintained
+F:	tools/lib/traceevent/
+
 TRACING
 M:	Steven Rostedt <rostedt@goodmis.org>
 M:	Ingo Molnar <mingo@redhat.com>
-- 
2.17.1

