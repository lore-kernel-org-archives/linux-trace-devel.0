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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754C6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 08:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432EB61130
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 08:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhIQJAJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 05:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbhIQJAJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 05:00:09 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F28EC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Sep 2021 01:58:47 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id v22so23089133edd.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Sep 2021 01:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ix4O4K4IM0jzifucnV2zm1pIpWvpwumkEC189y4IAI=;
        b=hpfwbo7w4i6GrsRUfV8DREomxo5VLSKg7CombRb2lhZ4GwhlDqzU63D5YBLN5gDCxf
         BJDBIawx0lf5BLVBn389NUWHsQa7Vogy9erCDJ4WvdJTn18xjihoreNWMXct7DW6Fqzz
         vqV5bQHXqIWHZrfvmOoHrEO8omYLMCDBKYRuXS1eo53sPLmqUPwuCBnBT4/yZenmlrf7
         tMxU3aXjudVs2NJ8b88PI5EDHUydJSBwsZjU1zvTS7SGzgIc2a8FiCl0jpZlhZEwR8JP
         oAmYSj/Vvv2FRYaHTIj8UtkrckqAe7G5i0eKNC8cG3a2PiF49QHRxD6Fr33YK12GUR+u
         +2Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ix4O4K4IM0jzifucnV2zm1pIpWvpwumkEC189y4IAI=;
        b=P1I9mdB7f5nW3voGloWH1XzhHG41siJOqZLct5+s5A3nfcyCZgY65QdpsXFG9A82MZ
         jvF81YaL7BrlhoKaCbshY5J+aeS3ltr225tTRA5niXNX4aTDqnz5mmf/P1NjPUWw3Oao
         e7ciRXOvj0Nu7+KkKxLxYkSyCO7EZJNIrYF4TE55IoOab2+J8/6Ngi7zZCrwNqHnM4R/
         R8zI1EJsmjhtucQZ0VT9nqXTPvaCQ2P4Yh1xGqb4YFtOHZp83psmV9d63smvY/U568s5
         942RXQvoPYq+1jx3XbZi+n0+sfONjGLUx8ffmq7AHljMcbc8bn5uq66nwetW4TcWwnZ7
         ExhA==
X-Gm-Message-State: AOAM532CqLM9hdUr9nwNsZ6oiFRW9Uu7Y+MbxTzSJN/DQ9xMcRdmACTu
        Vm07Og0VDE54Y93cPFC0q7ElnJgqiMk=
X-Google-Smtp-Source: ABdhPJyMT+fS8jv7xffJW8xBBHgpbh6Rd+rLVfe+Wp48dwIs3c6+XsiBCquMJCH76NBByJ5JHmM8YQ==
X-Received: by 2002:a05:6402:1a2f:: with SMTP id be15mr11371778edb.246.1631869125481;
        Fri, 17 Sep 2021 01:58:45 -0700 (PDT)
Received: from crow.. ([95.87.199.246])
        by smtp.gmail.com with ESMTPSA id fx4sm2026639ejb.113.2021.09.17.01.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 01:58:45 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2] trace-cruncher: Fix PyFtrace_set_event_filter()
Date:   Fri, 17 Sep 2021 11:58:33 +0300
Message-Id: <20210917085833.554521-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The current arguments format descriptor is a mess. The Python method
requires 4 arguments, however the format descriptor of the arguments
describes only 3 and includes ')', which is meaningless.

Fixes: 38bdaec (trace-cruncher: Refactor the way libtracefs instances are handled)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index bddc4fc..58f543a 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1316,7 +1316,7 @@ PyObject *PyFtrace_set_event_filter(PyObject *self, PyObject *args,
 	static char *kwlist[] = {"system", "event", "filter", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "ssO|)",
+					 "sss|O",
 					 kwlist,
 					 &system,
 					 &event,
-- 
2.30.2

