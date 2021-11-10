Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 478D9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C3AB6121F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhKJOlA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 09:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbhKJOk7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 09:40:59 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99693C061766
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:38:11 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id c8so11193238ede.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W2ebLlhHxVhhVL8MbhAGySkyrDECmVtwrd8UGJwQoGM=;
        b=IvZf/NFyAwPx0nwrgdwDnqaSh0n+p1kwFKgfEj/vpbMg/h1tyqAC7Ji8J6NrG9YZTl
         q9DPDvOxdH6NPjjEY0eLdLhOcRz/MwuB3Hc2a9rIzLKVXRjEQkgSmULxlnNWkXchbU9Y
         bpXNQfCv/jN0YqbYnz0sKPbJ5dwHQXHe9kwgKv5TyiWLlnh0xp+dN0ts/l3b8wN2FLVk
         1X+tyOxBX6jzOTqkq0ugKpicBf9UgOqbiUpPj2SuGLDA+jhn7zjSqDarlxa8HpKehLiq
         1GihZlMPGnOmiFumAIK3Nbl8Ne7zjBVYjmp/CvV0heMV5BNqD8lIuNHqmWyfJdk/NVRt
         Uj0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W2ebLlhHxVhhVL8MbhAGySkyrDECmVtwrd8UGJwQoGM=;
        b=ZYuJAbinGPazEp8c3DZVnFpOQeGsFspjlnmd34o05KZb1it9/N857tNfSptj6Ovkix
         kbGTWB7h9KpYW28TAjiWoMQZivwbm4BrWRdjcLija8HpFHRnRj/Z6+l2EIz2ZFaoKc9I
         SJ7+GRnhnx7of94XE4IDzu43wASWf+8FnfJzndJeDVzu5UKIvBcUYFYQVyW46aQ8BMWh
         U3v6OupREvHUJtpnC/8ZHDDBzKuY0nL9vpWdfz9i3Hxl6zxfdvycntSXZT66igPNPlnf
         JrYIYFS75GUHKIbbJ922gD+I5rCsdx5m1mgc+QTEZi7Nx+Uk4luCLR6PIRL1v/pnaq5P
         zteA==
X-Gm-Message-State: AOAM53282tzgzcsbEZL5eOOxhueuchhUNrHd5vCZ+3et/wdf57IlpmG6
        tqrZmZYUrnnfPUif60LoZ9SL07MRO9M=
X-Google-Smtp-Source: ABdhPJwZCFmdJWAcuv+OAyY6QUgFq042Ct5FthSg53K0puBQUxva5jCOmt3XPC4JSLcGu0Mun3t9Fg==
X-Received: by 2002:a05:6402:51cc:: with SMTP id r12mr147825edd.64.1636555090056;
        Wed, 10 Nov 2021 06:38:10 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id hc10sm11477039ejc.99.2021.11.10.06.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:38:09 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/5] kernel-shark: Fix a warning from 'KsUtils.cpp'
Date:   Wed, 10 Nov 2021 16:37:44 +0200
Message-Id: <20211110143747.32833-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110143747.32833-1-y.karadz@gmail.com>
References: <20211110143747.32833-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

gcc 11.2.1 prints the following warning:

KsUtils.cpp:573:41: warning: loop variable 'task' creates a copy from
type 'const QString' [-Wrange-loop-construct]

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsUtils.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index 364c25d..a22c445 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -570,7 +570,7 @@ QMap<int, QVector<int>> parseTaskList(QString v_str)
 			if (name.isEmpty())
 				continue;
 
-			for (auto const task: taskList) {
+			for (auto const &task: taskList) {
 				if(name == task)
 					ret[sd].append(pid);
 			}
-- 
2.33.1

