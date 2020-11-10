Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A6E5C388F7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A792206B6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Nov 2020 12:22:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XMLocNRY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbgKJMWy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Nov 2020 07:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbgKJMWy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 07:22:54 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D168C0613CF
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Nov 2020 04:22:54 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id v22so2130227edt.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 10 Nov 2020 04:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xh3onugAZ7keZCUE1WH4BKdAwheCB07wV3sQtrt5Ifc=;
        b=XMLocNRYA/lwWae4S0IQpwgkeZUXbYmMyUnF+KGnW+V4OuuCZ0r+5zs8co1ZQG0Ngi
         lUAWcheM3UA7cVohEJXbq0xikNjHBXTp8WaBaloSF2tsNXj1/UXFeMS+fBWaWg8vtHv/
         1UOnPVlzkbhv+Xd4LsRSfllXVJMTGknLVmvn40Pzndi+RVhBgVL5d7UTxlnAy2+UdrqL
         pJdPrwlA9/iju3f9iC9vx03zqqVoFbGlW+QD4ZhOMk2giWm5UaF1/5GaR7jTtzC4cH6t
         asK9CnZvvymmQgOr0IbqeK5eKP8RbQsAlXzCK8zinrzV6077EQq5pvlKO7J66hcCgD33
         dOKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xh3onugAZ7keZCUE1WH4BKdAwheCB07wV3sQtrt5Ifc=;
        b=mLwx9NoWJaW+V73j7ImCBnw/LjlZJqzeP9ayCspur0LKnhD7ay4VjbXTPOx0mIRjz2
         IFdHOtanpy6a9hlYj43ygDM2SNn6Acr+fgH2abdnMygH68mlIgwSFECX3T7lkA4tmbBE
         Qzjt+5/4acLKRwRQHAXmkYLZdmA//5fCefgBy/aus8Rk8elQOBkvvZNBBkyU+c+eVLZl
         9AqkWgVfiOfjaZePFBU6MwvnGBe2gbGGB8ouOJq2oXP/enaywx4wi7wao5hD9xK82kkC
         70F8H8A/oOSJr/92MFcFwTnFnugvr22UBHPV9Fj8NSF6vZ6iSHxj+gmF1mKRKOFeg05C
         +Mkw==
X-Gm-Message-State: AOAM532/eHzBzkMj1yLtkjW9pvuEUjbDqHqe8qvg0hPFwlkHz6Aj0THt
        ppXaCNCUYqEDyQm9tHJdLso=
X-Google-Smtp-Source: ABdhPJz6kZVslE8YhtDbejbuFSAYgUnEA/UyBMzKwbqPuNUDhvg73DzhPuWS4cUJ6753qruDM/mRAQ==
X-Received: by 2002:a05:6402:150:: with SMTP id s16mr19952357edu.304.1605010973245;
        Tue, 10 Nov 2020 04:22:53 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h9sm10204156ejk.118.2020.11.10.04.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 04:22:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/6] trace-cmd: Change tracefs.h include path
Date:   Tue, 10 Nov 2020 14:22:44 +0200
Message-Id: <20201110122249.911664-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110122249.911664-1-tz.stoyanov@gmail.com>
References: <20201110122249.911664-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracefs.h file is installed in
	<install_prefix>/include/tracefs/tracefs.h.
However, in trace-cmd.h it is inluded just as "tracefs.h".
When trace-cmd.h is used in trace-cmd build context that include is not
a problem, as all local header paths are described in the Makefiles. But
when other application uses trace-cmd.h and tracefs.h, installed in the
system, the compilation fails due to this broken include.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f3c95f30..3c2b4745 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -7,6 +7,7 @@
 #define _TRACE_CMD_H
 
 #include "traceevent/event-parse.h"
+#include "tracefs/tracefs.h"
 
 #define TRACECMD_MAGIC { 23, 8, 68 }
 
-- 
2.28.0

