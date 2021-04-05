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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FB2C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 09:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D045F61241
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 09:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhDEJeH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 05:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbhDEJeG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 05:34:06 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF31C061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 02:34:00 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j20-20020a05600c1914b029010f31e15a7fso7318567wmq.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 02:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q4T3I5enlJvgka96b9AQQceMhsvmmZTnNV8ZvAn2zyg=;
        b=cA6Kv2cHGF3U+b7lEXHyhDkLeRpHYsBJs6lRlN30hgJD/MlPHLA/yevCOhrEjfnhPZ
         SOrTDCcSaXJk5CDB9r5kFS3ima6eT6vg7gcxL7pXMle2Qxlng0GefghaLOahRPN2FYMB
         vm4Bwe5duAejFuHuJL7wZjQ/xcyNsReDkRrjfWqlmjyind/qnc91Pv1msjzIyz7BCf4m
         wp17pH0pglWflPhko6pSrF2GFb+45hPUnwFQSJrPH3qAQwYGViVRqY7aQk2e1NZUgC9y
         oT9gRRqyYKixKAnvhV7iByRlFz1qg+V4KBhduQtzQI0QIBik4WtOgMlu6G8Y3G+7DT49
         Kakg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q4T3I5enlJvgka96b9AQQceMhsvmmZTnNV8ZvAn2zyg=;
        b=YypTBzZfdvN6AC0Msm5tsZ7lpMD2lZjfCE3V4l3wOymGrsk5ETYALmGk5MbegxhdW5
         6F3nGB23fa1WL4922mnerk/J7J5L8TMfKNBGvHuV0YIBxeb/X0iArScwPV/Ww5w2Px36
         cV2vNa37crYBRY/OXnPidM+dEhqln2rGDNp3vkUlZuSHko3Q7eLdqQbVEwbEK73kMYSO
         0eaSf+VIhiRdDtMpbSVZ0TI1a/Zoau5d+p5fxItJiy/I9bjUMx8h3bG/QaFkMF/tPDDu
         3sGPZ1G6hWyhzHxkfoKAP+yOVkG8V3Wv6GhwRGVq0qK25MQUDuMUkJQRIB3gj8IuPg0r
         USrw==
X-Gm-Message-State: AOAM532rOwG8K5FwPZgx7Zlj5oo/JBvDrPm5fXU+7mcqskBEZPMULmTD
        M8GOxDzvBk3yu8d8s5mfG3O3FPf7p92JHQ==
X-Google-Smtp-Source: ABdhPJzGu1gLvj12MT1qAQyusVs2ISVMn78RyGrrLkWBcnxJZ0JZeI5OAneE7xWDo6tpqwAJE5TnTw==
X-Received: by 2002:a7b:c4c5:: with SMTP id g5mr13947728wmk.150.1617615239387;
        Mon, 05 Apr 2021 02:33:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s8sm26660712wrn.97.2021.04.05.02.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 02:33:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Implement warning() in the library
Date:   Mon,  5 Apr 2021 12:33:57 +0300
Message-Id: <20210405093357.870395-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The warning() function is used in a lot of places in the trace-cmd
library, but there is no implementation. The function is implemented in
the trace-cmd application. Added a weak implementation in the library, in
case the function in not implemented in the application, using that
library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Depends on "[v4] trace-cmd: Remove all die()s from trace-cmd library"
 https://patchwork.kernel.org/project/linux-trace-devel/patch/20210405092100.869572-1-tz.stoyanov@gmail.com/

 lib/trace-cmd/trace-util.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index db7bead6..0ee842e5 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -368,6 +368,16 @@ static int __vlib_warning(const char *fmt, va_list ap)
 	return ret;
 }
 
+void __weak warning(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__vlib_warning(fmt, ap);
+	va_end(ap);
+}
+
+
 void __weak tracecmd_lib_fatal(const char *fmt, ...)
 {
 	int ret;
-- 
2.30.2

