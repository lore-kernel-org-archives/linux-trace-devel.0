Return-Path: <SRS0=rfvd=6A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BA7C352BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 07:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F46206D5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 07:22:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2KF8Trx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438826AbgDPHW4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Apr 2020 03:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439175AbgDPHWu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 03:22:50 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB48C061A10
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 00:22:49 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id m19so4747291lfq.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 00:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fV3jv5/vvpj8C2k/WUdKZx7FxPEy1PNBFXGhFEDZzbc=;
        b=H2KF8Trx6c+IDC+zckCpid6I4ydEbFzCq+mjogX84EKKLj8pEIGSGrnF22WpemN7sN
         9O45cX0peoyoKWC+zisMnjByyk4PqZuEHrRRi6+4hSakcSukyC+JZbC99kYQtoVG6PsN
         keyM29f41yhq3QOtNEHb/5w23rUOydHJw7tOEJUKgdlM/0iCNlbJ0851jlYJ9hHfteQb
         X4jUk8aSWdNxmMs5JBM4Ehj47lmO7xreK4ujN2UFr+1f5k/hms4RZc3Q+pCYtkEk2WG4
         430iWvMG3Y40u5tX/R9GC23IoeF2Ep2P8biQKJeNa3HujGOU2DWbon4ItcxuC6o7wucx
         SqQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fV3jv5/vvpj8C2k/WUdKZx7FxPEy1PNBFXGhFEDZzbc=;
        b=K25kxD/0q6AMcQSGIM6XEC9wlzmgKnXi2+JrpcYJ0hc0cFQKKF9w9UILZLVBkviMdL
         dVgLuuiL5FdGNPz6R9+vcvC/E0y2SqDUT1j2OvLFUhxGzoNCElmie0oEScKsqBEtxAYz
         AOJhjPdQY3Mu/e8GLhp8rEzklxDTpDUH/dKzSE4++GqE0YrfSkFi+7M2rCy2L0zAYQ1M
         5zmgz4r55cBU9bz8w2OtE4UuxQq9SL1oGdws6ZohaIHXu7ATp0Z6a9X6yl6HZptRQz4T
         keysVWnYbMWQjHvrn6eDCWrPinBRsTDOsOZct/QcgAHX7xS+SxQQR/b7lv1wZNUbzu2P
         QWow==
X-Gm-Message-State: AGi0PuZa6wVXSsTOeETXDePU6PSRQoWTHFo/6BFnDWqrK/yKsYSLxjf9
        4CSsRtxMbH2PzLe4biOLI7A=
X-Google-Smtp-Source: APiQypLiT3JpUeJvp30JjG3xIZ9fz//Y+OrdPsLwo8HtJGdtjp+sQVRMP49HuI6GCpE0MlO0HQu0Hw==
X-Received: by 2002:a19:f614:: with SMTP id x20mr5221576lfe.84.1587021768374;
        Thu, 16 Apr 2020 00:22:48 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o3sm9914077lfl.78.2020.04.16.00.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 00:22:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Update tarce-cmd stat man page with instances list
Date:   Thu, 16 Apr 2020 10:22:43 +0300
Message-Id: <20200416072244.50239-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200416072244.50239-1-tz.stoyanov@gmail.com>
References: <20200416072244.50239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Recently, the "tarce-cmd stat" command was enhanced to list all
configured ftrace instances. However, the man page was not updated
with this new output.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-stat.1.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/trace-cmd-stat.1.txt b/Documentation/trace-cmd-stat.1.txt
index 4a29b143..004fbaa5 100644
--- a/Documentation/trace-cmd-stat.1.txt
+++ b/Documentation/trace-cmd-stat.1.txt
@@ -14,6 +14,8 @@ DESCRIPTION
 The trace-cmd(1) stat displays the various status of the tracing (ftrace)
 system. The status that it shows is:
 
+*Instances:* List all configured ftrace instances.
+
 *Tracer:* if one of the tracers (like function_graph) is active. Otherwise
   nothing is displayed.
 
-- 
2.25.1

