Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDCBC25B0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Aug 2022 03:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbiHODOG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 14 Aug 2022 23:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiHODOF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 14 Aug 2022 23:14:05 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F15913EA1
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Aug 2022 20:14:04 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id mk9so4630980qvb.11
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Aug 2022 20:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=R2/xpT4rU5+vqynDoGmHYITxo+U+UjsijqRaEIpvyKE=;
        b=I/WX1GMI/1U4tqj5ijW9wst7oBrRLKj6ml7vgaaBbPuDrrBgc34dz0l5XUC4PHA53/
         ACR60OxCtM8DiKSVvU7i0SGgXdpmVnjKq/FQG2RE38XLkSnebAuDYccUA+CgicPqZiIV
         GaUguuUgowwM6l0QbQNjE8QSwdvJdHOB2vEvc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=R2/xpT4rU5+vqynDoGmHYITxo+U+UjsijqRaEIpvyKE=;
        b=NSW18zQQ8TRlDAk3L+MAZmcJ5/u3m8wlZBrayM+5XXYG3JR+gR8LMeIcpCDGY/HExV
         HzhFsVlYAUw9YJ6vioZyQrObk+mRygGvvsFqO5x8u5+S79do03ggkn1agqKj9/KmJiVj
         /mIiMEeWFcqfESIM8eBIJUUUYCg3SyXwZLMsvRZgUKg1XWCClzHpLRokRupMi9FVbjev
         miGgmGDaxMEKxN5nLSwRwWIfCYHC+FGGHg2vqrwH1uRFJwuwTc/uYBqdteuk6uz1Jpkd
         WJvR6H//N3uuCSDoUJfjkly1GhQooSETEWMMo57MXnZ4xooAZ5sRP25Zz5B7HVcekgA4
         4Rag==
X-Gm-Message-State: ACgBeo0Hgr60vNvbeSU2Dl4nA0yIIL5BOCrM8ALipoFrpk6zlElk5Ang
        iVmlXxx/71IuQ02ChEPsME6YjhTBa1U2qQ==
X-Google-Smtp-Source: AA6agR66hrRjupCXsGN/eyzWtzB/Ib7nT1vNArN4C2s/nrnQDh1D0R4qkON4Y0KTq0B6peOepwM0SA==
X-Received: by 2002:a05:6214:d62:b0:474:7ceb:247e with SMTP id 2-20020a0562140d6200b004747ceb247emr12124434qvs.61.1660533242993;
        Sun, 14 Aug 2022 20:14:02 -0700 (PDT)
Received: from localhost.localdomain (c-73-148-104-166.hsd1.va.comcast.net. [73.148.104.166])
        by smtp.gmail.com with ESMTPSA id d135-20020ae9ef8d000000b006bb0f9b89cfsm3560743qkg.87.2022.08.14.20.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 20:14:02 -0700 (PDT)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 2/2] trace-cmd: README: Add note on installing libtracecmd
Date:   Sun, 14 Aug 2022 23:13:42 -0400
Message-Id: <20220815031342.775201-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220815031342.775201-1-joel@joelfernandes.org>
References: <20220815031342.775201-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This might be obvious but it still took me some Makefile reading. Add it
to README to make it easier for others.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 README | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/README b/README
index 9d8c127..e823843 100644
--- a/README
+++ b/README
@@ -57,6 +57,9 @@ To install trace-cmd
 To install the gui
     make install_gui
 
+To install libtracecmd libraries
+    make install_libs
+
 Note: The default install is relative to /usr/local
     The default install directory is /usr/local/bin
     The default plugin directory is /usr/local/lib/trace-cmd/plugins
-- 
2.25.1

