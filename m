Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769CCC433E9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 06:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 360C264E56
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Feb 2021 06:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhBHGSe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 01:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhBHGSd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 01:18:33 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F461C06178A
        for <linux-trace-devel@vger.kernel.org>; Sun,  7 Feb 2021 22:17:51 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id lg21so22785766ejb.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 07 Feb 2021 22:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7iY9PnC49nVteWuU9AGuFKEUQ/4IeU3tgqIpRqkEY4A=;
        b=B5H8/3bTIJ8WXk0x56sI2TrqgGFaNY6KaTuSAVIyAO8dDPvOJjPtD039RWY+ov+P4Y
         F1AEgizlmOozYEOTuUivNhms3cOxfP4lxfK0TSDo0m98Vu0BkDikviSSTMq+9kPGFTrU
         lpqkWTOMMc2Lw+otRrmaSR0yDETKNlMufLPQkO+yhgtTINyfFj/n+Kv10tk146EPym8y
         0nUXI4NFpbJh4E5so25RjnuFJCMBX06nKycHvNPrlWI/p1rcXDIYOM2m07gdMOAF4Tpr
         ACaRBiXAsaB5v4ngbcKuz/7T0FGr2+/dOoe6YNgPyxPPUX24LE68ltECIR/MLDFU31eL
         801A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7iY9PnC49nVteWuU9AGuFKEUQ/4IeU3tgqIpRqkEY4A=;
        b=RHsp7MJWOOIk1hm0Av++RmgCkOEWizUaipFyfBF0ppGhRIl14z6pUBv0GTAN0DEY5Y
         kk4FfseGNZLpzlOoGy4ys3xR7xDyCP8Rx9q73o29SzNDGOW8pXRglIyRX4m6OaMOKMvJ
         sxUuxuNbPwtnO1rToQcx7PkH2qdn+UFGT6xoTWQ5Y2wo+Z7HV/jho0+JB+BS8Qubnr/w
         8ISh/5dph5D1ZEB3V+WQ3332f/BrmgJWubIsNIFqSjDYepkLx+bzIOQWZg43arPx83Df
         Go/bGGu4kpu2tunl7Cnw+qwuUS8/5RLofhjsDKeLd9OP4GtR5oFa3/KCexKODgft8zZ2
         LrjQ==
X-Gm-Message-State: AOAM533netC2Rw2NgcXsRA8UAs3MMHfZBNisJys1PAnB4g+2l74EBwD+
        DwGGG2BZsSX9b+zOYjqk5K+VbKosjnMdVA==
X-Google-Smtp-Source: ABdhPJwwEDayLSNGH3JTloDPtkHjP60qqglDsAlSKL6ClAvrU2YIA//cVOSsmh5FiQc3+hRdvraVjg==
X-Received: by 2002:a17:907:7252:: with SMTP id ds18mr15474764ejc.239.1612765069933;
        Sun, 07 Feb 2021 22:17:49 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 35sm135618edp.85.2021.02.07.22.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 22:17:48 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v28 2/8] trace-cmd: Fix bug in getting tracing dir in trace-cmd agent
Date:   Mon,  8 Feb 2021 08:17:37 +0200
Message-Id: <20210208061743.510964-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208061743.510964-1-tz.stoyanov@gmail.com>
References: <20210208061743.510964-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace-cmd agent context, when getting the tracing directory, a bug
using srtcpy() was instroduced by that commit:
 https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/commit/?id=b8498696e0e8d7b7cce8f50f92e1fa94d9127e6e

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a0a0b8b5..efd96d27 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3341,7 +3341,7 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 			const char *dir = tracefs_tracing_dir();
 
 			if (dir)
-				path = strdup(path);
+				path = strdup(dir);
 		}
 		if (!path)
 			die("can't get the tracing directory");
-- 
2.29.2

