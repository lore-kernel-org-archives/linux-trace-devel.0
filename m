Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BFF1C4649B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 14:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CEB420828
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 14:11:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kfqqqEdz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfGEOLH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 10:11:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51477 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEOLH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 10:11:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so9026157wma.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Jul 2019 07:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YES+gq8/faaNeT0qDLicw5Zrqz5fEZVeWY10rDhUJJU=;
        b=kfqqqEdzYzcsKenJ9NlxahUYSqdjtDYogKhK+jyRFU/OOdvfOBxYg+0QqDwCSgM/5A
         DrqWgBxXdWP38QaBrTwWe/qb6EgqLJ7xwCj6ocWWsFgyQ7b054po/zhx2EDvNq9Y53Jj
         KpZfc4vntn18ucGk5VBPoeOE16Pj1rgXKYMyWMTB8lE6P2JWH2mONbLJ6fssUn1ynHGQ
         pg+w1P2wTuASg6Y0CCdcsA6SiuU+ot/9xYrMKkYqukwzBr6Vsu4uvqZlp9fzx1dWm7M4
         8ehC8uzOlbTv0yMovOdW4qRKfUISviEPwRRtCK76ngxrWMbnYU46Oz9OEFsWZRjzbqrN
         Tuiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YES+gq8/faaNeT0qDLicw5Zrqz5fEZVeWY10rDhUJJU=;
        b=DrKfeOnX8LiOaAiM+Y03a80BJLREwyFJa9qTVTDzdp9j3mU2uhNy2aaY5KSqAk54Q1
         jozcud5s3AiK2h8c0kDKcW9ubMtPGwV2iakurH8aiXZuBhlA2juAHxNZi4jauWIyH6YJ
         JtUOw1VvhumeUySAOEVqSKl+4lXXwu6KKlujUXhDt1rNa8A/IURRUNjH+VhKd4Jd65Eb
         OqpHf2yyLcRo3tPQwE3e+ZDosC9FMzeoQQ0TqrfBU2X+kNL032TmvWuy6+ImgDIT53T8
         AO1EvW6EtcdxF6CJisPw/WvmujNZluXAoxuSbcIVuCYrQMH27HlTUB0mxTPL1vGEl0/k
         MWYg==
X-Gm-Message-State: APjAAAUm9zBIxR5v1UXcpoKH08A6MKtHeyyxsf/B1M+doW7aQt3AbBOQ
        pgQvB9xZfnaN256HSQS8dp8=
X-Google-Smtp-Source: APXvYqw+Vbzb4Bocj7iap9I3FeIL96KUv8ga5rg7KX/gyRv3+RkEQ/FBnPfzfns/Q+w6V9ZH9y7Aqg==
X-Received: by 2002:a1c:cfc5:: with SMTP id f188mr3450576wmg.24.1562335866300;
        Fri, 05 Jul 2019 07:11:06 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f192sm1893715wmg.30.2019.07.05.07.11.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 07:11:06 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark: Line up the table of the loaded Advanced filters
Date:   Fri,  5 Jul 2019 17:10:30 +0300
Message-Id: <20190705141031.20239-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190705141031.20239-1-y.karadz@gmail.com>
References: <20190705141031.20239-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The Advanced filtering dialog shows a table of the already loaded filters.
The new line that is added at the end of the string breaks the alignment
of the last column of this tables.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsAdvFilteringDialog.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsAdvFilteringDialog.cpp b/kernel-shark/src/KsAdvFilteringDialog.cpp
index 1edf68b..6af1aea 100644
--- a/kernel-shark/src/KsAdvFilteringDialog.cpp
+++ b/kernel-shark/src/KsAdvFilteringDialog.cpp
@@ -216,7 +216,7 @@ void KsAdvFilteringDialog::_getFilters(struct kshark_context *kshark_ctx)
 			continue;
 
 		_filters.insert(events[i]->id,
-				QString("%1/%2:%3\n").arg(events[i]->system,
+				QString("%1/%2:%3").arg(events[i]->system,
 							  events[i]->name, str));
 
 		free(str);
-- 
2.20.1

