Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095EFC2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A389020857
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:28:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PqcgyFrx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390661AbgKXR2g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 Nov 2020 12:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbgKXR2f (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 12:28:35 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C502BC0613D6
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 Nov 2020 09:28:35 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id l7so10347353qtp.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 Nov 2020 09:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pFK6deoUBmBHKQo+x2nhJIAB75wIkXDZ7TMs47dfyUA=;
        b=PqcgyFrxs54/saXZFZHAOApEQrU7wzZwGtxOLXDefm9IIE40yXxGsnRf/Lg7UClA0o
         5fshy1xFqlJYkERNZIhtBE9WJiD1jh+dZb4hnukFoGXF4E/mJFlukOtGDsWzQfQ2I078
         pk5FU3onZw5cpzFaV8TFVXKCVIYxL8cDpLFaNq78hiEDCIW2IMENYSjVbJNDPD00Z/bt
         vSuS0BKzfD4Q0GJmaDaMQXthfLh25xVrcBhEkUUguVu0y3Eln0Tqm5dGJ3x1KHLJm3wW
         yqFrwvmsYIgD6CJHbq4P0z/iUvHOvR2RNfXN+PZLtfru6XUmjpPJ9/sCegu4OT0fnxB6
         huqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pFK6deoUBmBHKQo+x2nhJIAB75wIkXDZ7TMs47dfyUA=;
        b=LrVbPJzL7MbE94hxPgKCoDlK0vIZNXQ0l2JLLmfvpb1/GCQCiQXZmbVAaS1dFSF6we
         vgaD6fLskdQ7A7dXk06WIbViBsvGFlnOEUTef6z82S13O9LxMm1gM+F3ahDjPg63rogl
         zPBn9Db4F1bYqNkpHSjOXim5b5rIP7/1xHQ/q3VbQ2bF3ZB51kpnIEEv704JVp/lm9TO
         6nWJujUzIRP+UWekmxawBNaJscDdsFpZFOVfVbJXLy5LUY0+lQvFLM2LcSOEry8APyX9
         g4ISiQ00Eb7iVLrPlR9D9EmZNlonHCRllyaFPRjnGKKA4ArNBmkEaAsEGlqoPGP36z5S
         n1PA==
X-Gm-Message-State: AOAM533Er/bHfbYC5Ehsrq6Nmv9jNq/Fr/m1kp0+dNWPF6YNQTIgOenQ
        OQe6Rlicxe5ZoVhgYoiPnbtNfytJekA=
X-Google-Smtp-Source: ABdhPJz6lrd6wjiGPJaAWsaNgjPjyf/4leahPt0elk+9s//uPbHtjqqxGT5n5M3cteeoSUKV02NG4A==
X-Received: by 2002:ac8:bc7:: with SMTP id p7mr3182795qti.91.1606238915079;
        Tue, 24 Nov 2020 09:28:35 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id m62sm6903195qkb.91.2020.11.24.09.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 09:28:34 -0800 (PST)
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Subject: [PATCH] libtraceevent: Install kbuffer.h from the install_lib make target
Date:   Tue, 24 Nov 2020 12:27:55 -0500
Message-Id: <20201124172755.31795-1-marcelo827@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This file is included in the list of installed headers in
./tools/lib/traceevent in the kernel tree, but was left out here.

Signed-off-by: Marcelo Diop-Gonzalez <marcelo827@gmail.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 8626b91..72ec2d0 100644
--- a/Makefile
+++ b/Makefile
@@ -418,6 +418,7 @@ install_libs: libs
 	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ)/traceevent)
 	$(Q)$(call do_install,$(LIBTRACEFS_SHARED),$(libdir_SQ)/tracefs)
 	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ)/traceevent)
+	$(Q)$(call do_install,$(src)/include/traceevent/kbuffer.h,$(includedir_SQ)/traceevent)
 	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(includedir_SQ)/traceevent)
 	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
 	$(Q)$(call do_install,$(src)/include/tracefs/tracefs.h,$(includedir_SQ)/tracefs)
-- 
2.20.1

