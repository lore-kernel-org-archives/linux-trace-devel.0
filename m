Return-Path: <SRS0=5Z96=UG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F162BC2BCA1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jun 2019 18:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C19E7208C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jun 2019 18:37:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XQiOgaHq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbfFGShL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 14:37:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34501 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729047AbfFGShL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 14:37:11 -0400
Received: by mail-pf1-f195.google.com with SMTP id c85so1675429pfc.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 Jun 2019 11:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AXz6xJuRtQNVNa3/Hyq0orP8MP4eCjbkOFFWL4FhcKY=;
        b=XQiOgaHqOKGqlAKv/WdBXlrDr6na79hfF0t3RpVAwXB99I2vkg9tr8sG8Hs0/xcBAr
         +e0joQQbSL7o+DsIeljNLjpLHPQ3uyqJKVFtqZknfR+V3sJT2SfztjkdYtwkJiXS2L3m
         2i0KM8ZPqAcIq8LQUOaxmQVRkZ36ceoWEJ4qRpfkSWxN8Bas0EpM+hNNGS+86UqlbigJ
         f7YpD0iXrVMtupvYNT+aWzUi+bRxxxi2cLbx+nX3JiaA5xikxgEoV7KqqYjWBCvNpz1Z
         QEG24KaU5C2TTcRRstME8K0mSCMvJjo97Lpas471bBD6i7LboLWwAFtyEUNbwYwLDtLw
         ihaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AXz6xJuRtQNVNa3/Hyq0orP8MP4eCjbkOFFWL4FhcKY=;
        b=YZqwK1RO+jHXOV8pF0Xa9M/bwoTuWOMgNs6PgGACV0tDOhM09xY+nHPJrFiCkgY1EG
         EUfQLEItTN2iNubnBAOa+HkslaEnZxvzHIW5LsDVeVM5PYIZlqGhkWUpqXXAWkvOhYY3
         Z2v79VZz6t46kjlOcaIYp2gEYOhoIq5rJ4VeSUmt6YW64FM1T/e5tnRm7Jqr8l31f1rB
         rT0cUqjweyeKOqvdAPMYhatR2L7fyc6x1eB04XGotTWPXm4oZMGBdidtGXqQ/+zJjDI6
         an3qclhZqHRda1Ys+ntrXFfoS45rtSjqoCsGGs2xM5nrm7oMXb3LeqyuZZ/IWfjgubLg
         SOrg==
X-Gm-Message-State: APjAAAVnztCSMW/4zQl3blgRWFFbzXNZifK3FBWGw1hEqygCFjEIYYHG
        Gv06+h2T9fflG/k+DUppS65e9DOqPKM=
X-Google-Smtp-Source: APXvYqzvFDLQtquuWSc5Bsp9NXQtobP/Hnx3tag0XbKy/SOxSJTSCj37CimmwQM+T5KdjFUWfD17sw==
X-Received: by 2002:a62:5306:: with SMTP id h6mr61279970pfb.29.1559932630476;
        Fri, 07 Jun 2019 11:37:10 -0700 (PDT)
Received: from localhost.localdomain ([152.179.67.70])
        by smtp.gmail.com with ESMTPSA id s4sm2764185pgg.55.2019.06.07.11.37.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 11:37:09 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH] Fix the description of check-events
Date:   Fri,  7 Jun 2019 11:36:58 -0700
Message-Id: <20190607183658.5605-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 tracecmd/trace-usage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index d2a1089..8db4241 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -283,7 +283,7 @@ static struct usage_help usage_help[] = {
 	{
 		"check-events",
 		"parse trace event formats",
-		" %s check-format [-N]\n"
+		" %s check-events [-N]\n"
 		"          -N do not load any plugins\n"
 	},
 	{
-- 
2.11.0

