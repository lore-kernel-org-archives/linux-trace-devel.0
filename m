Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D899C3A5A4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03A5F2189D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rrcJdT7L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfH1I5y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 04:57:54 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45472 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfH1I5y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 04:57:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id q12so1608613wrj.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 01:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cvAw5cqGWJQCaxLK4o1tvUof4SkcEdE+z/wwuzAqZTM=;
        b=rrcJdT7LwBYT+tX8E0w8pBT29XRCFmIHxIMTymw/R/16lChpuoCAnbdLsg98tRMOwO
         ZdgHemeJsxcc8pyX+8k7lSHVb/4oDiZkeso365zRw/nZu7Mvk9Qqesor+zvrOEVfuQ8y
         eH4QHXufGR4v3pQsriszZODMINZcTwNyv5FZ2WfK1pIQ7gUuF9cIxY1PlWawleqTsfIF
         kYknupdiNLAqSfz5cC0xlqfbJKEcqYVIAbKE3559NqqnSyLsbSOVAxGzV6AAB9FeR030
         Zl2EiP8xL3XRvoYIMSdXR+U6dvUC+b+jwtb53Y7yNCFDGvVR9WTzq+1N4arPpTwv9kgn
         sDjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cvAw5cqGWJQCaxLK4o1tvUof4SkcEdE+z/wwuzAqZTM=;
        b=bBtDJ1Jm/utYqLfY1SzryECzSjwlH5Ufi7P5o0IY9ZHF4qM/wjYQyZHdNY6awsgBlg
         VqdKQXZT4C3Da+z4EV4mDXVVYV51tkfH+UO3nVaaJBJNJkso5nTXkCmAh1iZEIV+Hl+g
         v5AqCZuIXT0iVe98Vyc4AXvNKWSWa+Zvf/lkhFRW4lj6rU5FhvigHRazW/A8yEePxhwM
         u6zoBNLEPbGHuh3v5pPKh2gPZStm4uEHxyyYS6PRiqRBW20Scut/ieht4kN8dgZs4QFt
         t2ejCkqoDfWPt4fwoNe/ktleOh96s+HxuN4jdHlFtjw537qL+lBxQLhVXh0J05zV8t1J
         hZXA==
X-Gm-Message-State: APjAAAUDtbQNmSH0Mu8dYTe/1p811G7TVn3EZgJ8j27W8SQozah7Wg+3
        GxZ6E6F2r+svy51hqbTOpMw=
X-Google-Smtp-Source: APXvYqwxbznHPG48Zljyf5HZffAtrsY3/Ut7dyjWfo46WBwXoIOaiEOd5CaDuBJ9hPHl08JfXdTUcA==
X-Received: by 2002:a5d:564f:: with SMTP id j15mr3111877wrw.326.1566982672568;
        Wed, 28 Aug 2019 01:57:52 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u186sm2579433wmu.26.2019.08.28.01.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 01:57:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 4/9] trace-cmd: Added implementation of htonll() and ntohll()
Date:   Wed, 28 Aug 2019 11:57:41 +0300
Message-Id: <20190828085746.26231-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828085746.26231-1-tz.stoyanov@gmail.com>
References: <20190828085746.26231-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Added implementation of htonll() and ntohll() as
macros, if they are not already defined.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/include/trace-msg.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tracecmd/include/trace-msg.h b/tracecmd/include/trace-msg.h
index b7fe10b..445f799 100644
--- a/tracecmd/include/trace-msg.h
+++ b/tracecmd/include/trace-msg.h
@@ -15,4 +15,14 @@ extern unsigned int page_size;
 void plog(const char *fmt, ...);
 void pdie(const char *fmt, ...);
 
+#ifndef htonll
+# if __BYTE_ORDER == __LITTLE_ENDIAN
+#define htonll(x) __bswap_64(x)
+#define ntohll(x) __bswap_64(x)
+#else
+#define htonll(x) (x)
+#define ntohll(x) (x)
+#endif
+#endif
+
 #endif /* _TRACE_MSG_H_ */
-- 
2.21.0

