Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACBFC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 02:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9124723715
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 02:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732263AbhALCCb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Jan 2021 21:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbhALCCb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Jan 2021 21:02:31 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8829C061575
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jan 2021 18:01:50 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id o11so865552ote.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Jan 2021 18:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sSu7K3T+Is+tDF9RKxNFrnM5Ps7pns1eb1u7wrpDKkI=;
        b=mi/pDa/fkh7mIIoZT/JmDRC085wBfveTkskhoaKed/apGQ6FAQIYoEjo7JO2L/1GCy
         0cfq8hngp4HSp55WqjGGt5YuiBXHPotdRm26nFPV9o91HpYbXsUzYmRf5++5JtKCJgoX
         muuc7i024XipusGACsC+3jh5uBxzpj9ESdP8IJUB/K2UwPYZSIQfEqhESdQgOut7ziw9
         bYsg0LPQ6xl4zVHXgWkBkBpKL1QeqD2FwL/GtbV/xwNecnDYzo4zdQ3L8Cy44fszarPA
         DjvVg355Ng3LU/nwK4xu3d1/IWiKrUyINZ2fi/j7H1RhbegA7UUu/VOpTfpeaDNa80qL
         7EgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sSu7K3T+Is+tDF9RKxNFrnM5Ps7pns1eb1u7wrpDKkI=;
        b=L9VFjYQMakeesEzFbRQRQi6SZWF6HSIZ9NN0wCbsJq+0lwS3vBDL7auPsU7Wuntb27
         WLk77UUFQiR3rDoBxlDu4B/NqbjH04Ar+AEXGkPzcKhKZs8EoXXJ09jNSe9j6v36035a
         X2XWoo8eHC2dli5NQesOszXYn55W97qn2gwizgUSi2qbo9J1rfO0aACEucqyPrhpSicx
         rTL7+fUS3uOHtl/wqURtHj3TzQJlYQStWydT4joXHi0+HjL44uEOjak27cuM5ALV3thy
         OPAAbPblXizc+dSUbHLk8f//Wm3H6GgXjoYomN+eEa9nLcNC+cCZno1TvynW4z37opVh
         Kmlg==
X-Gm-Message-State: AOAM531JxQpJpkvb3PsZ7eQsLK3FnN994SzbaQvoiJFl24PH7ysr44vm
        DUP5tuuBkQzgCfPXLuAKUtjV+XbMiU/1be/LlS92NI2chnA=
X-Google-Smtp-Source: ABdhPJzeMZY/fP3CMvQ1fl46DOJ6H0uUbgi6Bn2tdkYP7TRNozIp4t3NPTqqrR3CqKwZsG0/H31w6lHE0aQzB1G7Jgs=
X-Received: by 2002:a05:6830:b:: with SMTP id c11mr1375316otp.138.1610416909964;
 Mon, 11 Jan 2021 18:01:49 -0800 (PST)
MIME-Version: 1.0
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Tue, 12 Jan 2021 13:01:20 +0530
Message-ID: <CAK7tX=bWn89VxofeyK0hfb4_dQz3tKG2Y2+_47WnaYiWN5UN2w@mail.gmail.com>
Subject: [PATCH] trace-cmd: Fix lib audit warning message
To:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

statically updated the warning message which we will get, when
compiling trace-cmd without the libaudit library.

Following are the the messages which will pop out when compiling

Before:
-------
trace-profile.c:23:3: warning: #warning "lib audit not found, using
raw syscalls " "(install libaudit-devel and try again)"

After:
-------
trace-profile.c:23:3: warning: #warning "lib audit not found, using
raw syscalls " "(install libaudit-devel(for fedora) or
libaudit-dev(for debian/ubuntu) and try again)"

Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
---
 tracecmd/trace-profile.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-profile.c b/tracecmd/trace-profile.c
index cfae2a2..4e5d68d 100644
--- a/tracecmd/trace-profile.c
+++ b/tracecmd/trace-profile.c
@@ -21,7 +21,8 @@

 #ifdef WARN_NO_AUDIT
 # warning "lib audit not found, using raw syscalls "    \
-    "(install libaudit-devel and try again)"
+    "(install libaudit-devel(for fedora) or libaudit-dev(for \
+debian/ubuntu) and try again)"
 #endif

 #define TASK_STATE_TO_CHAR_STR "RSDTtXZxKWP"
-- 
2.7.4
