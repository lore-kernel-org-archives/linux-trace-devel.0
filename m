Return-Path: <SRS0=0q7s=A2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C84C433E7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86FBB20663
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gvgCwheB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgGOCaX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 22:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgGOCaW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 22:30:22 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC23C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:22 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id ga4so529148ejb.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mw7NloO9+q/ntZVOIRHwRrmGx/f39MuMbz+oMRpQr5c=;
        b=gvgCwheBIl1Zrh3jQ2fR7DKK4hp/3s/mtkzl4vNleF70QCNKePgpyExwHwy4VcKG+S
         fkRUM82QYSrKnnNTsflD4HvpVxGu187BxLO2CHIRAdGz0qOD+pdcSKEUZ00SZKul7+Wx
         0zZGR3ndfaoJrkq5Rmle+c+O1oz8WbIZlSNeHM1s+7ZbwADY+kBG9EwVeD1XDpc5m+Yy
         eyPqvo5o3O14Z/Zm2ozY+uFoItye0uaPD9z+ZLRl5HKNtwkGKFghdwNnqFzjQe7Hzmwn
         HldLPKQ/4VXijwiggBkQZN3foM0V14MaiyA4vMwQa1Xr/dR6G4+na5YZtU7oMuXofDIT
         /Ung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mw7NloO9+q/ntZVOIRHwRrmGx/f39MuMbz+oMRpQr5c=;
        b=MrmR4zOE7GdoTaOp/YKJ3MHjw3Z3KSf2/DU/YZa9vsmphj0fyNf9kx/GUS0tcIGSqn
         3617mhWz6SDixsCgD9Bjz7jHcKlxznNUxfMnoQQPRWELgoqv0EiMRrQL/5EaRFW2n9BS
         36LZtwfpZ9+gRMxYHvjGVV68qKfxQ0NLTipjafSvKPwx7zWh8ehlCBMRHIz0BjqyxUg8
         nmJeRxMX9tUgTsxWD9MNqMfcyhXZdXnS/+vdgv1eRPmqVLwyVtNM//gxQ6Tw5xX9J1D6
         WUvmbsf3naK/8SLL4KZYvkuyicIpSSsWm5At2bC5Ws5TBLvcg81YOstN+lqVpLPw8nAv
         HuGQ==
X-Gm-Message-State: AOAM533BWlJzQwB0LIqVLno9wpsPYvYOUycCUm8anTOsNb0KMASailAz
        v/qgD+PDzM4PyeH6lyQaalw=
X-Google-Smtp-Source: ABdhPJyMaxiGPbkmnyh1h4NXc8EdMMGjh1sWm3T14mJQPReLO3ZZ/1PDFnHX7yIrJnqqmt/CdVc1kQ==
X-Received: by 2002:a17:906:b16:: with SMTP id u22mr7210819ejg.53.1594780221412;
        Tue, 14 Jul 2020 19:30:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d24sm576474edp.83.2020.07.14.19.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 19:30:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH v2 7/8] trace-cmd libtraceevent: Fix description of tep_add_plugin_path() API
Date:   Wed, 15 Jul 2020 05:30:08 +0300
Message-Id: <20200715023009.2503879-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
References: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changed the description of tep_add_plugin_path() API to reflect the
logic of the function. The suffix of plugin files is not hardcoded
to ".so", it depends on the custom plugin loader callback.

Link: https://lore.kernel.org/linux-trace-devel/CAM9d7cgMgqFDvKhs6xwdBSMsaG=3ZG0RtxwgQDCTLGkML1MY4Q@mail.gmail.com/T/#u
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index aa868133..841e41c6 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -647,8 +647,8 @@ tep_load_plugins(struct tep_handle *tep)
 /**
  * tep_add_plugin_path - Add a new plugin directory.
  * @tep: Trace event handler.
- * @path: Path to a directory. All files with extension .so in that
- *	  directory will be loaded as plugins.
+ * @path: Path to a directory. All plugin files in that
+ *	  directory will be loaded.
  *@prio: Load priority of the plugins in that directory.
  *
  * Returns -1 in case of an error, 0 otherwise.
-- 
2.26.2

