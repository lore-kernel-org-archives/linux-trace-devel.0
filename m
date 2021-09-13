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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A16C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C77C60555
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240002AbhIMM3g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240004AbhIMM3e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:34 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11CFC061762
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:18 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id w29so13642456wra.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RL9NU2QU3eQCBHNiwR5XAbT/oZdzMq72Opi9smJDKmw=;
        b=HZcYUjWjC1oF1IweZeAFzFbHBP+6UMX9Qk+L7N2buzTdazO+Sf0/QIuVWAEL8MUQJ8
         9ykz5LOtrOoprOUUmikobi1rAAdN92WIfQ0GgPPsYQvsccNIs0LLMxHZSoMbBMr3aO3A
         d64m3d0GuO0xr9XhuegEpzbLCy9ZrsrGr9KK5YievDrqt0ba+DMqEYK+3lu7TPAZa21d
         hmUro3ipl4qhMDZwGeV1rGgAazuta0V5icdvNrbUThgyMFKnfRCA38S8ehhXatOevRQE
         XMtKJ3Ii2VZiAEuDuJlixDJURM5F22BKdKFwBpDbjMMUyE/VKCs0ODf3yg0X/pvwaUCG
         ssSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RL9NU2QU3eQCBHNiwR5XAbT/oZdzMq72Opi9smJDKmw=;
        b=HCAWhANGnN10KOIW7kdD9jKcxjcsb6x1ecxrVmtvDTC1f2C/F0WCvPdnEwIhOkBThC
         6f1o5WZX7vDfVDJPbx8jumwMy+/kd6Up73U+uZj7FVqY8MXiCRM8nUF+E5IHUWkOBL9o
         p0rhhuOPfZGvFiClp19O1AK9mz9mG9Ke8vTmbKF5PXkmgrpBmCaxKfvS5MXXSkNQSMdw
         zLnSFPEIU7x8K4bz1spNOC1A7E+TTyuSHwFI+DxkvnkDJ5CQhSi+YXw8JDbqXQC/lKvW
         +2wHyvb1N6wUl0RsYOaTIsuIKI8RAqkpgqtjE6/GlL2kjhG9Ij61Df1DZ2D7miDjgvGa
         yrkA==
X-Gm-Message-State: AOAM532tsd80XSLnigfdfodlsnKISiZN7WJW1H2oKlKW+D6/Ly9L3h2u
        NsbO5OW0pWXW2D2R5W/fIUgQSOTdu1c=
X-Google-Smtp-Source: ABdhPJyt01J0M6dgheowZchimRyq3d7bwO8PPoCa8pXezhysrcZJ14Br5gZ9YvE3pfBSoJHN3OfiGw==
X-Received: by 2002:adf:cc82:: with SMTP id p2mr12562438wrj.5.1631536097311;
        Mon, 13 Sep 2021 05:28:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 16/21] trace-cmd report: Close input file handlers on exit
Date:   Mon, 13 Sep 2021 15:27:54 +0300
Message-Id: <20210913122759.3672494-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When "trace-cmd report" is interrupted with "ctrl-c", close the input
handlers to opened trace files, to delete any temporary files used when
reading the trace data. This clean up is needed for the design of the
next version of the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 31724b09..4261088d 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1363,7 +1363,14 @@ struct tracecmd_input *read_trace_header(const char *file, int flags)
 
 static void sig_end(int sig)
 {
+	struct handle_list *handles;
+
 	fprintf(stderr, "trace-cmd: Received SIGINT\n");
+
+	list_for_each_entry(handles, &handle_list, list) {
+		tracecmd_close(handles->handle);
+	}
+
 	exit(0);
 }
 
-- 
2.31.1

