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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665DBC433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3462023137
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbhAGIeO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGIeO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 03:34:14 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C4DC0612F6
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 00:33:31 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c133so4425595wme.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 00:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IxgwmrWBHTI3Ao7awMI69aKUri97nJbVPpMGpnKG7FM=;
        b=cfOzv6SFzywmq7uXhH3doyhk+thjjYLZRpCu5kMfPFtrtcpeSGwwR/du48zA0Q262O
         OF7K3KVg0zgjawiybIrL0c2pZELRDf8f7oYU9M8DrQS4h+O50KcfVFzJ7hJgtXuWsqiT
         zbavvJm6k69UF9jf7U0eAK5WLCCFiGKTNT7U68rcnK4Wb3nZnn5Oo4yyCbFlzBJJAmzH
         lgaG7NtucDi/YX6h0NV9pmOKu8MVzvcrlfUMsCOQcSkczEcXj62lOVLff5K0FB1MUM6U
         5jauSLez6DHxdCTjU1N3DwzzRAgigjBa/tbnKf7d8QJVRaszaaeyhaHI8cMHuwkjAHg5
         AI6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IxgwmrWBHTI3Ao7awMI69aKUri97nJbVPpMGpnKG7FM=;
        b=XX2uMj/PQwm1Bp9Arg6qbhNiIUACMQJQjAs+tOx05Av+SzhFFUtA9UlpLWwV9fdfeA
         +F2rlpkBPs/587hr3q+BTrdXX+GDtSk3NkEarDraqBBqv7oOV37QMNGQbiut214XSE/x
         9QSDb46ZlDHqFayxS459qCF1DsU5EZ7FhBHZEgVoiBvDZ9T7YD3v09Q+Jdn7W6DUklKD
         Qwpp4fetFqPbYLdbIUkYfNmd04Azet6Hzl0WERyswtbef/fnWZt1JGXgVU4lfvwatpH3
         untkeZhj6Dva53rZCbR3QRFlxz2O8I9C+Cv7UiuP3g3E3uu2NXm7+4lGlwIcj4iYYse7
         MGMQ==
X-Gm-Message-State: AOAM532jAH71OGeMGp0DlUXJORxK09UxVRi1442Jn0xVo4+W8w/gGN5V
        NR0bXxREpiJbwXnYjG+m3FU=
X-Google-Smtp-Source: ABdhPJxj2bTFF3tomyKLl0E/nt7giGyAha8/eyXIVWXmZjP2zLnwbIukQ4C5k5vCeUeEEMMCTb5gig==
X-Received: by 2002:a1c:a9c8:: with SMTP id s191mr7026773wme.89.1610008410258;
        Thu, 07 Jan 2021 00:33:30 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s1sm6725182wrv.97.2021.01.07.00.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 00:33:29 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtraceevent: Set correct libtraceevent version in the HTML documentation
Date:   Thu,  7 Jan 2021 10:33:28 +0200
Message-Id: <20210107083328.16492-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtraceevent documentation building structure was gotten from perf.
The variable, used when generating HTML documentation, was not updated
and the libtraceevent version is not passed correctly.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 2dba73c..21bcd5e 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -213,5 +213,5 @@ $(OUTPUT)%.xml : %.txt
 $(MAN_HTML): $(OUTPUT)%.html : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
 	$(ASCIIDOC) -b $(ASCIIDOC_HTML) -d manpage \
-		$(ASCIIDOC_EXTRA) -aperf_version=$(EVENT_PARSE_VERSION) -o $@+ $< && \
+		$(ASCIIDOC_EXTRA) -alibtraceevent_version=$(EVENT_PARSE_VERSION) -o $@+ $< && \
 	mv $@+ $@
-- 
2.29.2

