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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEF8C6379D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 856B124655
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0Fv4zA0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgKQHqC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKQHqC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 02:46:02 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D427CC0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:01 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 23so22109204wrc.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xh3onugAZ7keZCUE1WH4BKdAwheCB07wV3sQtrt5Ifc=;
        b=K0Fv4zA0wIFJ5l+spgGsmhPlrMi0cAn1pxdZ9GUXRFm6hlQ0P0/KhPb5ffJ63RHSVi
         go9g1d/s9xRGm/bP50pg5EB+y9Xx6Qpi+3cs5lydGDj6XSj/27PoRQvrv74PKAny85zD
         oInSlGL2ZCAo0TI4TBLTN6T9sDJEGlSYWZfju52uO0yXTv3Fbh5tQj7RLJY8Genbm4+G
         xgKd54+NBFoKep/7Q5cUZRZ2V4FkjTMp5hIUOmLV1W6dA7cQNw7UJsf3A5o98maXgvFs
         nll1wowfVKlYZdKfx0oYPgsjh9PmUexSqT9mnFtviSdhJ5++8yVZuhU4EJO5lPygIkqx
         Vp/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xh3onugAZ7keZCUE1WH4BKdAwheCB07wV3sQtrt5Ifc=;
        b=Vb6iEI6h19Yr3K/EtMnxTxaScbHzOGNg8gkxfia8+k0ciftYOx6YzvbR34r5LvOmFx
         Y6MjRiJoMvQGp+0OVUOXDX1sxnyp/Iw+b0N6BxvDXQrkEgwSVfL7jc0IiHQp2Hj8y6Og
         sqJG3OxMng2GVlIhPahIXj0i1WOgjUorlqqBoDu0Rc9C2hGkuOtE3h6PEc0/kYT23jiR
         6X8Za2hopqxpjGs5kRSwOFVAIHAqG/fi78u4SCBeLn2dDxsLMO4K/+frqHNl9cZayP9g
         q1I4V78FwW3hERyu+marZLl0I4wYtJdqNdbm7n6vgwa7ygbogfUtgWr4jYRgkxcLHrMX
         hmLg==
X-Gm-Message-State: AOAM530s0n23+VAk/gkIDrVc4QWzUj73z0W2WhPksHAOrEhrQq0fsjIW
        gaDoBaz8ok7uZjhu0sSQT2f4dewfI4czWFoJ
X-Google-Smtp-Source: ABdhPJyGyR1siYoFrUGb/q7d2mBgUNa9aBPvpvModm/oSIy3BnX1zeW1DcmUNZO1LnG9Y4r20m7EJQ==
X-Received: by 2002:adf:f04b:: with SMTP id t11mr22259384wro.147.1605599160661;
        Mon, 16 Nov 2020 23:46:00 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d3sm25752046wre.91.2020.11.16.23.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:46:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 1/8] trace-cmd: Change tracefs.h include path
Date:   Tue, 17 Nov 2020 09:45:50 +0200
Message-Id: <20201117074557.180602-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117074557.180602-1-tz.stoyanov@gmail.com>
References: <20201117074557.180602-1-tz.stoyanov@gmail.com>
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

