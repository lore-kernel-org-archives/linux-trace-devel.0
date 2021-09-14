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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85F2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2F9B610E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhINNQN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbhINNQM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:12 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BACFC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:55 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id i23so20176238wrb.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h/pyTwtmdkmQfcEOK48Q4K0PQZdPSwZMcfx+gGOvG+0=;
        b=ePEd97874CBOR5dLnJJoq3dB2GeL+LGetHatpQXBCn9ocYZlbBuaq+Tzj3tut53Udd
         GssSC1EgAUmwyAVJGwKUlgbJ0WRjYlZL4zXz+W2b7huW85Zubcd6Os98pdTdi1rWGtun
         bZcN4h+9kafecuPvrYFsAmyhFu/v6rNFe0eV7+CczlP2F2Y8Z75EOvpVzvgyjsoXz9/L
         3ya7loPbo4Ps8bOj2zlc4RJq/2H4vkxQluXsmpvxLRB5CLxB3oLs9vaHfMg8HsLWPkGq
         s2LHuorLmBICBkXZBMTbUXHX5jqdm/DvPwMCEu9+w75pfHnSPaG0NkWM1LRLUvE3lISx
         18dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h/pyTwtmdkmQfcEOK48Q4K0PQZdPSwZMcfx+gGOvG+0=;
        b=wdg6a3CadtH/ub1w3ZuUzfVRmgqPzAvHgzKztaDD3fUzpSTGFiX9qVZmAeArqwUc8S
         lXQJnERiOryH5byhe3ipitHAJqw63fqTf19QWWo3h/dhfkTPztvzp2Dj0Lh0rznIFQCL
         YRuavxVl609EFBhOLb61irtdS4YgXQvNiJ37ZKcr9m9FbhfCJXxC2q8tPF/UGw4qhXcX
         g7K1VjHTw7RMzhYd5b+W1+YKCnTJ3OZdgO/R8SP34oBmQsUrmIaUkvM+A6fhdw/HOtjY
         WaNEkjKjn2SI0KkZiXgvXaA36OIcA1pBiy01aYxFnvQACaBBLSk1S6p15XFotHnBlAXd
         adZw==
X-Gm-Message-State: AOAM531ZwsRt8F7kvP/9dMzMu5P1IL0+5EdC8EXMskSRBDLqsmaBq4l4
        RzWN+qB87HjC4THuClWn8gmgdr2FMNY=
X-Google-Smtp-Source: ABdhPJxQStRzuHdBRAurSFwGKq2BtcpKUO19K82Ay7oUKl/IsETQWDOPAuO4EQKqqY4Ztd0XX9jRzg==
X-Received: by 2002:a5d:58c9:: with SMTP id o9mr19179727wrf.279.1631625293823;
        Tue, 14 Sep 2021 06:14:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 12/25] trace-cmd library: Do not write CPUs with empty trace data
Date:   Tue, 14 Sep 2021 16:14:25 +0300
Message-Id: <20210914131438.3965484-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has more flexible design, which allows to write only
CPUs with trace data in the file. If a CPU has no recorded trace data,
do not put it in the trace file version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c62fcfca..87b85e0f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2074,8 +2074,10 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 	if (i < cpus)
 		ret = -1;
-	else
+	else if (size || !HAS_SECTIONS(handle))
 		ret = out_write_cpu_data(handle, cpus, data, buff_name);
+	else
+		ret = 0;
 
 	for (i = 0; i < cpus; i++) {
 		if (data[i].fd >= 0)
-- 
2.31.1

