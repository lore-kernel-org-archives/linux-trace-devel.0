Return-Path: <SRS0=ZY51=EL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6943FC388F7
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A1452083B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZkJv2Dl4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgKEJeD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730830AbgKEJeD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 04:34:03 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A7FC0613D2
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Nov 2020 01:34:01 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id p93so799600edd.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Nov 2020 01:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xh3onugAZ7keZCUE1WH4BKdAwheCB07wV3sQtrt5Ifc=;
        b=ZkJv2Dl4Mxto+PQgX6VRBHfrfulOCZl7vegqZD774KP90wSnWaBGNUtCo1v08dCMv2
         4x0KFrQnXLRXxctTn0F16QbJSBp2bS3C9mnbA4yWtub2ongJB4eYm31pMcxlWdYsuNor
         hT8+MQ0GuvahL36P9wtJMgs7lntOlkDZdhbyFyNAZb5TTg5pGOHHDlbi63NsJrrzdVFg
         YB5p/NzxX5GfhKCDXDDivwX/vr8I8UMcscOn8Q7T6HQD8OGgQbZhMN7LWBRI54eI2JhU
         l5x27deSc/nKDNFViX7fDZeuty9syCy314/xN0yNnYWjnH+qZKN0EA+xwkiOs1j8fnfi
         kGqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xh3onugAZ7keZCUE1WH4BKdAwheCB07wV3sQtrt5Ifc=;
        b=uTQndaSDgyVct8x5OF9/CsKLRDPdUpIJGZCeXyXGe3H317F2fsZOUmmmUM5bPHpQ2F
         9mdo9n14wMFEuuxiYBacrcyTW5LPuS8/7dljgU1zhUhH6iEi87G8iuET/PgzugO7vEPR
         K1reVvYcXGKm9zvBW9zNvJIZ6Lu0lhxtWa1GJoriRq60WFarR4YUI+dhFEKz5P0rE8qd
         lEQr5xFCx8CLzHDUzRdOCFhe0z0eww5xcms6WiTZ0l5+HSSs0l0yu0vu/LywyQdE+fN9
         SIyJeKOcS6+TN3GyuhGLILe6jcAiP+x3c8zjkId+WoAGZ+4KIs6kGts7Oi4DZTHyEzPP
         IDjw==
X-Gm-Message-State: AOAM531ts3sLNsU6St5+jUKSQtMzDDc1KYq6rDq/PeZD2/BVJXH/RgzE
        KIvZncFjRAvIaGJgTbzO0kU=
X-Google-Smtp-Source: ABdhPJz3WPbTcVCwDZsCZgxj4qoRncQviCpFbmXqIRka4G46UwUL3tOC9vgwyF10vmUD7YpwnAT+Fg==
X-Received: by 2002:a05:6402:43:: with SMTP id f3mr663229edu.373.1604568840549;
        Thu, 05 Nov 2020 01:34:00 -0800 (PST)
Received: from localhost.localdomain ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 1sm586725ejt.107.2020.11.05.01.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 01:33:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/6] trace-cmd: Change tracefs.h include path
Date:   Thu,  5 Nov 2020 11:33:49 +0200
Message-Id: <20201105093354.532742-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201105093354.532742-1-tz.stoyanov@gmail.com>
References: <20201105093354.532742-1-tz.stoyanov@gmail.com>
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

