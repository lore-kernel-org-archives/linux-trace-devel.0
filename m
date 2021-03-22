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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EC2C433E4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F99E6198E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCVKA3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbhCVJ76 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 05:59:58 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EFEC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:57 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w18so18568246edc.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oMjD439qNlAB7PqKNkhqf7Z0VI4YUDEnQeZeV/0WHzA=;
        b=b8PH62CyLIIr2Udgg2r/QsoREOO4sXdJcORlgEmC3QyduMBlYXJH8z39oMm7TgS6Rg
         CDzJjE/b5z0MPnG+bxDJBLuZLY0wRI/KS0+WtBsM33zphFqJ63FVrqHfhGlJCC4v/j49
         tn5TrS28Oc1kJsts4Cv7SdU1HkLkfdwKtRsbJR5SDIxbe4iDg+STv10BBmjuYJevcnVF
         jQeReaiNMVoZ8vXaXra+owGZga2Ipvcdb3H0Qgt6MrKek01DvLhSE4RK5QP34eCenuVo
         c4pE7fe1EYEYYdx3sz/1Zzhu6UvzY1aO1Zz5OR8uS/BQ0DwxHfEdipLnmjfIkjopPfk2
         dkgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oMjD439qNlAB7PqKNkhqf7Z0VI4YUDEnQeZeV/0WHzA=;
        b=mQe/mM/0msMw9efCc/ZLYstLsxZeEYQFevIicWgCPDbfAT9fguPnJK9pBhP7EpwTbl
         h9gguXqLCgXhtPEi4HHWJftoguHOiIXXWSf0Wd4avHFLuS4Cl/5oVEO3n6X6Zqh6ncc/
         tVGDuaFcwJ3yllKklUW3CIQvsAM5cwuigI8+lBhE57ZQYahW5N9vhfwM5QsHm85tdk4n
         Fad4wYLV0LeU6Tmj/1mGVFZbKe4BK2Y+HCQW1VSKAkc/d0EKJTnUTV4D3KhCjVuqAgvi
         hE0Qfhxqyyo0F5ewRaPPAum4EB4rZPOtUmbSaMWPS1quAN0EPIqFFF/8vMlh1fxT/EnA
         o4ZA==
X-Gm-Message-State: AOAM5321oY45es4k9JFtFKMWc6nKMT82g77WrWLWzPk0Sghtn5jZYo08
        OI2tdKHEfzlfE1uQHGtNQd/1EUlI/BDGrA==
X-Google-Smtp-Source: ABdhPJw5TNPZHvfT4SGWcbZTPk0/dbhZ2Kekdtw0NP/7nI3Vffeu61jpnHWxwv8GL+7HR/bvhsVYYw==
X-Received: by 2002:aa7:c907:: with SMTP id b7mr25000180edt.37.1616407196743;
        Mon, 22 Mar 2021 02:59:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 10/18] trace-cmd: Remove unneeded multiply in events timestamp reading
Date:   Mon, 22 Mar 2021 11:59:37 +0200
Message-Id: <20210322095945.259300-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When the event timestamp is converted to seconds, the local variable
that holds this timestamp is converted to seconds also. As this
variable is not used in the function later, this conversion in not
needed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 67915f25..be8a7919 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1932,10 +1932,8 @@ read_again:
 
 	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
 
-	if (handle->ts2secs) {
+	if (handle->ts2secs)
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
-		ts *= handle->ts2secs;
-	}
 
 	index = kbuffer_curr_offset(kbuf);
 
-- 
2.30.2

