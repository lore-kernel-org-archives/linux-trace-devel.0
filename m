Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2404C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Mar 2022 04:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiCIEjV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Mar 2022 23:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiCIEjU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Mar 2022 23:39:20 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3155D5BE46
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Mar 2022 20:38:22 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b12-20020a056902030c00b0061d720e274aso851564ybs.20
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Mar 2022 20:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AtYLFpeYhlr6PLHdeuki8GuKCXU1QN4himAbnAJwBms=;
        b=nbIBABAB3T/nmIUcCOqqI6ziGV6cZPoKY/kfZUOTxtzTofO7Sb4d4b7zibqwBnBlM0
         Pdle2tcytIBooxz0lNHzBVocYntu9KuPJz90MgZxBseFur7RRAVIlVaYgAlom4ahfk1I
         lyX1j1DvsEpCu1ukhYE4R7O24tyzZ9i/mgp0EHFNBHH/bm51OyfkUpZer3NWjsfFkB0G
         3llY9MTr+I1XJoHtaTKi29sEim9Bd3xPDKRlmCEBSfwz5BUv0x8N0A0SqSntL+TctevH
         puz9lyN9bbDCOVu+OEIhDLPMXOMSuwyPeeNooKlFKjPMIjwAyDIQgFNWOpJ/ZUuUehK0
         5Cng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AtYLFpeYhlr6PLHdeuki8GuKCXU1QN4himAbnAJwBms=;
        b=TdkGbfgoVzgFgnsy50SCAUfh8zXC+xlU1GQoI6NQbybzs9CAbly4SeafGbj2mLcKsR
         bPn8rsKd+pkN8EjAoZ30efAvbwP8ynPpB8bgTKEqFkATDskXeSaLis4a8kVxOgkdC1kL
         xG4h71L/RkyY27TOyWvT3PuWX2vdelE7IO9T3V0/YGTmVGTqxVOzWOaveBGHmclDEkbv
         Tv8BKPNbijEwPlOUh7sb+8BoyZ9ATOodJl3ktdKFNO0bvmn5ZtzMbEoTd2Km/JZJMY8p
         nXUG8F1YDU0DJ7zoYFL8w/q96nPt8b95/TTb6sB1m6AinofbSMI9RYnC9ihrdkagK9Uq
         gRXg==
X-Gm-Message-State: AOAM5332DYFGvI0IdG0HCvN1T4cl/fHwo+Yng45hpEUElFu52OxmpwfY
        Tav+5v/MBmGMX03NgLK7fPNU9v824p2WZ0QbZh5NOXd4tiKbTb7tV3vboqcFW+Z+wOQT9pVmYq9
        LHkuDyeBBP1ekoB2+A5eOe+13rd1hi6ZwirlVgkOHftnF0jIk+znFrd6N2eVQ6AlVOe9K9Xju+K
        2nuxc=
X-Google-Smtp-Source: ABdhPJwcUdpgFjXVBZ8bPc+FQsDSHP/2QifvSg/9NtR0DxKoTKteeceztWjkDh+MMkBf6/pnYD9Qihp96t5M
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:1e8f:9091:7fd1:b274])
 (user=irogers job=sendgmr) by 2002:a0d:e88d:0:b0:2dc:108e:b184 with SMTP id
 r135-20020a0de88d000000b002dc108eb184mr15698390ywe.240.1646800701225; Tue, 08
 Mar 2022 20:38:21 -0800 (PST)
Date:   Tue,  8 Mar 2022 20:38:15 -0800
Message-Id: <20220309043815.1301991-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH] trace-cmd: Use builtin for offset_of
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Arithmetic on null pointers is undefined behavior, spotted by C compiler
sanitizers such as with clang. The builtin offset of is available in all
recent compilers, so unconditionally use it as discussed for libbpf in:
https://lore.kernel.org/all/a0a26308-a1d7-a57c-727c-000652a5d246@fb.com/

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tracecmd/include/list.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/include/list.h b/tracecmd/include/list.h
index cf9dd47e..fa0de6df 100644
--- a/tracecmd/include/list.h
+++ b/tracecmd/include/list.h
@@ -6,7 +6,7 @@
 #ifndef __LIST_H
 #define __LIST_H
 
-#define offset_of(type, field)		(long)(&((type *)0)->field)
+#define offset_of(type, field)		__builtin_offsetof(type, field)
 #define container_of(p, type, field)	(type *)((long)p - offset_of(type, field))
 
 struct list_head {
-- 
2.35.1.616.g0bdcbb4464-goog

