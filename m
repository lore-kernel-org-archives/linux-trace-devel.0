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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0EDC2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C54206FB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 09:11:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p/cUkqHQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgKLJLP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 04:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbgKLJLO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 04:11:14 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E1CC0613D4
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 01:11:13 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id 23so5154471wrc.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 01:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xh3onugAZ7keZCUE1WH4BKdAwheCB07wV3sQtrt5Ifc=;
        b=p/cUkqHQtnN/S2UEyzv0X2YGiQ0jfZL5bvYwJhdajJa2ZFKUxp3vJvBRbd/yg1Mdx9
         ijvOZhQyLvh/pbT8ivMcL6eNYpqXvtksG487cRHzvtSnUv0+/XCjK4+F1/lIFaY5kBOm
         f8wbX2NNN0H9JFwKSSgGqJHZ2GQRLONVh16/tFJIgNhqmqBeUg1P2xla64pf+w2RhWpq
         hoyNshvAkAkugGUJ1z8eQtxzEk69108Npu4yEBHf29sTLHjPqYOdY0e6MRL/cDPmIWmG
         HRbYW47AVQ0pNAS38FZu5+MoDv+6VCyCU5Ov/wJqiew5HvfJ4Gtsieq9Ly+37PIQNoWv
         dC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xh3onugAZ7keZCUE1WH4BKdAwheCB07wV3sQtrt5Ifc=;
        b=dmERvzX1grKcHt+Yuriyr3EiWaNfaqHUpJ9ZGZHPtLsBjb7vYr4POmb9pH7szQEF2W
         i4TSw3uIBenSDSFSMML5qZHQgb9L0HlkN/Y4AhMF2yJIpr1E8Yhhl3dY8Eb2rlMz4Fdb
         GrgLPkeOo1k8LBiThAe8eTmxjwEahPA+zFoaaCDGekMcfaGBcaQtC0NKUTDeiyy+epvf
         /wfJYpaXcY9C/W+AlqbDkgsaAfIEVJG0BiB4/ngGG2p7aL4nK80BQGOLTqdM/DtgAU9p
         ByJ3eMbQ6DlUqZMQlvcDCY5EreKeTemAyUyjM2ETIA0gGEdtoADIay4VH0DcibbxKhno
         jZdA==
X-Gm-Message-State: AOAM532zCuyT8KUBz+5Ujd3AC/9KJ3wcNy40KiVJvQJqvfZfwtH6VI/Z
        RkgRu+yG0bKwKFkkcb6MOEY=
X-Google-Smtp-Source: ABdhPJwEXsxJI+0b3b+S9+6waMTYceaPPKl6rGMlYBPUwtJe9qddWWK0jBNzbt4tkIUccJkFsgZXzQ==
X-Received: by 2002:adf:ebcb:: with SMTP id v11mr33912896wrn.408.1605172272622;
        Thu, 12 Nov 2020 01:11:12 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r18sm6705718wrj.50.2020.11.12.01.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 01:11:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/6] trace-cmd: Change tracefs.h include path
Date:   Thu, 12 Nov 2020 11:11:04 +0200
Message-Id: <20201112091109.1239169-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
References: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
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

