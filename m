Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 349BCC001E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Aug 2023 15:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjHBPk7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 11:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbjHBPk6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 11:40:58 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE35EE
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 08:40:58 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-577ddda6ab1so52777b3.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Aug 2023 08:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690990857; x=1691595657;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m4jWt/HB9HuLEs3sX6rAFkrz/Q3kJdqSKqG+HgHh2xU=;
        b=R6uXkcSyliZtDyWuRZjwxS/r2oXJbaTfcvaNiYlhO6aNSG21H/VvfwyiHi1KPRK5IP
         CVScaHC/iEz2vIlU0CgsdWE3vkgB3SskyScgpBR95CKtmWGGqYs88VZGQRQhHGH9Vqnh
         zyQd9XUPRtzCdQglrCiG7JmeJTVuAbyctA1gGj9zfhOuOrdVsU6nTf8SmcH2/uv8WKgV
         piqr22hKwcOfSvH29/zEe5IG9UTUgJ3Iqvq+B/huxrymsB5BWtjURev3k7DG1HrDe6ul
         mnKRqgj606myH9kq2CZ+R4K79POGxEY169k2zJYnJOk3W5GWfSidLqo/G6iU8SDh5mwp
         Oacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690990857; x=1691595657;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m4jWt/HB9HuLEs3sX6rAFkrz/Q3kJdqSKqG+HgHh2xU=;
        b=GiGrLXcbySu9A3oaGER88sJdfryx4/O3OLcwm4ag7c/2Iaq5pIwjfq/3MN19sB+xQh
         reXwqjjpoCPQ3lgjvTWGpshm8NRZ3sWsBFHkyrJRaHtBs8052JCtF/OXNNKwQtSj55nh
         /E+8+3tBYjSnroes8uibUqCNwCpVq6+nqUYhNmLV2wPp6tIHJ6Hmk4j4h91awB2AXhR2
         b+e+bfjhTM5QLNxymdGhiaAlVHHyl64IlSfG6ZOmYeKE0BwfpDj/aE7XuJeccDWV0VE8
         MsZvhsYxCF5qQ4/3JQ6iS6ei/dfkJCxdLC8U+uInH7Wy1vAOyqRjqI3/n/z+vjIsN7jT
         qccQ==
X-Gm-Message-State: ABy/qLbURnPe170QyzvQ9F7d7co88rtbtAhO9lzfnSJ7vUqCbFlVyGRW
        azxs4tqbSPynyCmVJJDUVGVOWJZgz/o=
X-Google-Smtp-Source: APBJJlFiEHKzg7rJwWmHahgGEpcLearkvQKR8t8IYoPgUoHDCXgf/p1mKUs+YK4PwTww4SwTezCHAg==
X-Received: by 2002:a81:4f56:0:b0:585:fc5b:8ada with SMTP id d83-20020a814f56000000b00585fc5b8adamr14657787ywb.12.1690990857057;
        Wed, 02 Aug 2023 08:40:57 -0700 (PDT)
Received: from localhost ([162.208.5.36])
        by smtp.gmail.com with ESMTPSA id x84-20020a0dd557000000b005463e45458bsm4701791ywd.123.2023.08.02.08.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 08:40:56 -0700 (PDT)
From:   Matt Turner <mattst88@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Matt Turner <mattst88@gmail.com>
Subject: [PATCH] libtracefs: Pass enum value where expected instead of int
Date:   Wed,  2 Aug 2023 11:40:54 -0400
Message-ID: <20230802154054.1828136-1-mattst88@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Avoids warnings in C++ consumers (such as powertop).

In file included from perf/perf.h:32,
                 from main.cpp:46:
/usr/include/libtracefs/tracefs.h: In function ‘int tracefs_hist_start(tracefs_instance*, tracefs_hist*)’:
/usr/include/libtracefs/tracefs.h:456:53: warning: invalid conversion from ‘int’ to ‘tracefs_hist_command’ [-fpermissive]
  456 |         return tracefs_hist_command(instance, hist, 0);
      |                                                     ^
      |                                                     |
      |                                                     int
/usr/include/libtracefs/tracefs.h:442:79: note:   initializing argument 3 of ‘int tracefs_hist_command(tracefs_instance*, tracefs_hist*, tracefs_hist_command)’
  442 |                          struct tracefs_hist *hist, enum tracefs_hist_command cmd);
      |                                                     ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~

Signed-off-by: Matt Turner <mattst88@gmail.com>
---
 include/tracefs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 269b119..90df00f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -453,7 +453,7 @@ int tracefs_hist_command(struct tracefs_instance *instance,
 static inline int tracefs_hist_start(struct tracefs_instance *instance,
 				     struct tracefs_hist *hist)
 {
-	return tracefs_hist_command(instance, hist, 0);
+	return tracefs_hist_command(instance, hist, TRACEFS_HIST_CMD_START);
 }
 
 /**
-- 
2.41.0

