Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A20AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1179630EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhKOKtb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237593AbhKOKtK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 05:49:10 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF6FC061767
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:14 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id e3so33401846edu.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=epkCq6AT/wz6cMxL6AMlkBwN3glIlU5bcaUvAqf1PeE=;
        b=XGB5f4tQYL3Bdy/IsEQ5Xl6Tuo6SQ54YKKs/MSl4/wMq44o+vTNyfwvbZ1yrWRiTWF
         0bNSnmkDoFPw55cdTKFaTVL092P2uYyRk3o8Bujp8TxZiC+VVXPNWCZqaIFWVAZr73TI
         x5U7W9UC1BKB+clY16iKzvHoNHDhR2v8duAO20ccMTS8TcH8iA9PWWqa2eYI4gem8XXO
         gNh6tVUH9Tf6Md/OwnkruP4RgEwR+IQ/zYpTOpMw5iVAfBNa9KjjqSIhL9uWDJSELTIi
         7TrfYkyfySoSIRMKSaDGdv9tw/nlhbjGrFdYeTOT6qXFMJxmSMQa4f/O6E6riWngxaPF
         prXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=epkCq6AT/wz6cMxL6AMlkBwN3glIlU5bcaUvAqf1PeE=;
        b=SEj9SA/M0ajK+Y17W3AqkMJk23X2GhlZ/5RFxuSlGcPQmE3NxQnWcaf16BJTXsEX+P
         4VvwQztmv943fbShE28H1MPu8AooATw0BST1Tz0hBU5pxn77WDz3VvIihXrm3ENBb0EN
         Ro6yO5QoSt97LbD0gMANGfnXqONoKJNCYAD7e8MDkMyaYZ+qlh89VTB7NKHFlrhCXhFv
         /mJv68KXoLzWHvR+gS+gVC6DZWhcZRabZ8w1wJ1oFwqRz3fNB0SWDvH6i6kC+cEn6DI5
         VYP4I19qf4NCgTDHG6MDhuQYJJMnGq4+/eEtu6bfJahCFdlYbwuWbrO4ZAAingS4X5Xo
         nFdg==
X-Gm-Message-State: AOAM533Cw7A4VLGifWSepWpvbUDU1YL/e/SbKHfxPjnlGUYJKPkqswqy
        1h2pAOaAIFdslBSKG1pfyPDVbHsdzzgP1w==
X-Google-Smtp-Source: ABdhPJzb5E07mSJTg7cDKQj6/omO+FR5sp9empLblaQVPd4vE+z8NEtjkSN65Df+Weu5TIBUNRvGUQ==
X-Received: by 2002:a50:d6d9:: with SMTP id l25mr44398561edj.41.1636973173648;
        Mon, 15 Nov 2021 02:46:13 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm6315509ejs.86.2021.11.15.02.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:46:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 12/15] libtracefs: Do not clean sqlhist man page source
Date:   Mon, 15 Nov 2021 12:45:53 +0200
Message-Id: <20211115104556.121359-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115104556.121359-1-tz.stoyanov@gmail.com>
References: <20211115104556.121359-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "make doc_clean" command assumes that all *.1 files are being
generated with "make doc" command and removes all of them. This
assumption is wrong, as the sources of man pages from section one
have prefix "*.txt.1" and must not be removed. A more precise filtering
is added, so only files generated during "make doc" are removed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 0c00505..92a67aa 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -197,7 +197,8 @@ endif
 CLEAN_FILES =					\
 	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
 	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
-	$(DOC_MAN3) *.3 *.1 *.m
+	$(filter-out $(MAN1_TEXT),$(wildcard *.1)) \
+	$(DOC_MAN3) *.3 *.m
 
 clean:
 	$(Q) $(RM) $(CLEAN_FILES)
-- 
2.33.1

