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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B97C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D91AA61423
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 12:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbhD1M3b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 08:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235833AbhD1M3a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 08:29:30 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B5AC06138A
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:44 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id j28so9960809edy.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 05:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RmxnJl/Q/4nxbDmX0g/m7vKjWl0cphQhiKjiNds0feU=;
        b=jPOdEwT3h7yp1NGCnTjJrxJKXGlihNyCyeeU7Qo+jlxZG5d8CBqr8HOFeyf1t1Q5Nx
         g+hi+aPKNCPMM6nkTCVLwIPFBeSG2kHR0xWFINSloT0LxEAXyWXrhjPhjs7lidG36LYK
         fRAaaJAGLDhbg4bX46UilWdtCmauuIRVY65GNJHMYZg1ztMI4Ku5fZxy9Pggw4VLtNKZ
         61a7aWzH1V/qJBoYOdvH4rZA2ohzQZi5caLyn8IQC/8UfTED0WNJUDPPfDNJ99//C9Ec
         /7JO+26rHV2JQ96vjMC36OaGPY4i1eBYNFSEuQrsmLoBl6A+49CyO7PKi54MvJrA/6t1
         ECiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RmxnJl/Q/4nxbDmX0g/m7vKjWl0cphQhiKjiNds0feU=;
        b=aqNybd0kJTinjio+SmE2yWK2w72lhzDZ5CX10BVeWxDzJ8rBx2dtNwn/OAaJSOO/4M
         o1JPqQQHGTC1OO2F8nDOR4dbv5JpffGGIBSFxXEoY86MkTS8tMCxubkJjImeGrft9OAj
         oblXKNM08gGiQjQPiSXLLSi3o6JLvPdUlA1xyskNydxHx/dIL+FQc2sWTCY7eVUb+ONK
         hFHHoy3wDex7l0PlwmZdz/9vXDWEO+AZYGGrUQRRFAGYnp1xM+yFPau+5GACriIH8ec6
         asMw+eWXokOd70vEVDutPTU8ghM8xu0Js3uHEkfxmCrFbJGUmt6yXVi0JlYYuGT6ypwH
         SlVA==
X-Gm-Message-State: AOAM530LWANUNpiKDnzstQ1k3stS2ss6kJjsDGnoE29piwP+aVFINKy3
        OcdJgGOenP40TvjLbKKfnlI=
X-Google-Smtp-Source: ABdhPJzA+ZMnXdOt2XFUVoaO/QGxIfcQlfQltllpH/BlsDQi5kho/Lq/F6JJT/Genxrip6xuyjnLdA==
X-Received: by 2002:aa7:cc98:: with SMTP id p24mr10780507edt.187.1619612923696;
        Wed, 28 Apr 2021 05:28:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n10sm1846546ejg.124.2021.04.28.05.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 05:28:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/5] trace-cmd library: Remove useless check before applying ts offset
Date:   Wed, 28 Apr 2021 15:28:36 +0300
Message-Id: <20210428122839.805296-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428122839.805296-1-tz.stoyanov@gmail.com>
References: <20210428122839.805296-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Checking if offset is non-zero before adding to the timestamp is useless,
as adding 0 will not change the timestamp.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e8a257db..bacf9ccf 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1323,8 +1323,7 @@ static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
 	}
 
 	/* User specified time offset with --ts-offset or --date options */
-	if (handle->ts_offset)
-		ts += handle->ts_offset;
+	ts += handle->ts_offset;
 
 	return ts;
 }
-- 
2.30.2

