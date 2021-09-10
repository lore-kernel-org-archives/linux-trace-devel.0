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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6883C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBE4C611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbhIJNtc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbhIJNta (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:30 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E09DC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:19 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ho42so4352476ejc.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vFXaQI/G0HHdHdRSAHOmVE4YjkrR1Z9WT14pKr2Ncd0=;
        b=KpOPyNn3Z4QB7SZ6kMdu/8vcgrgVHX8ywYiSN4Nj7QFRc3wu9n0MunVAtd85aUzqpr
         qHDnQy5L0JMM9mTXaxL4OgozRjC4SG6NLPwEnT4ZQAHY53hT+Gu5ZcJpTLWKTsbKS8N/
         H5nBVhrIdSpQahLmKKZPHX4rrcHzdPp1IEoTFHDAsM3mHTQADUyIETS/VxZCMcY/HeTa
         FfFpLJ19q9oRx9dn3TIa2f661z29r1dp8vUO2YNIL1zNVUsReBJYMvGm4gTQEnYjGcC+
         8JdS2fKpu7HEK5emH7ciQ5htXggrxNruT82OCXMNtd6RpmDLo8f0xel5NAFN/5WxHrRq
         e3zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vFXaQI/G0HHdHdRSAHOmVE4YjkrR1Z9WT14pKr2Ncd0=;
        b=Ga3Tuc/DKkZulfXDxP/AUEdcJAehfGxlx61sqWGlD4r7/6NLrfMy1IY7Wz/U1ohjNN
         oJ7S43CF3+bGE7po88/i0k13pU1w04bGjUuJ8byMU+A4zvPvTN4AJ6E5fdk+vn2G1HdH
         XQyvwCgUCvtq++V/kl+rhlEUidbUi6MUWwo+u1HAZpBBlBi7m8QKyue0LuFH7zkF3yAV
         wOyGbshhhOIG5Nn9q0bJO1H/SJgD0pGwppaGshIbLKW6MURuD5q8PibrCW6S/CEzG9su
         1kpr7Up6+L3JXHyVTgk8wG/80615eO//LXwDVtKI2GHiQ6qz2A3AVNJ5S6VgpNOsi2x8
         l2jg==
X-Gm-Message-State: AOAM530xwyeHi7H5hEtsmLqW289oqnqklfxF8CwY70lqNKNXMsmpLk3B
        DANms8zCN2Txqj9CygKrddRUjFOJ6zU=
X-Google-Smtp-Source: ABdhPJyXVN2mpcYma3d2gITGH8J2xhTyD4Ico/RmiZptLhoaXKt93szNi3TKmxuL1eD3UyxRLQq1rA==
X-Received: by 2002:a17:906:3854:: with SMTP id w20mr9184860ejc.537.1631281697843;
        Fri, 10 Sep 2021 06:48:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 17/21] trace-cmd report: Do not print empty buffer name
Date:   Fri, 10 Sep 2021 16:47:53 +0300
Message-Id: <20210910134757.2863982-18-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This clean up is needed for the design of the next version of the trace
file, where the top buffer is saved with its empty file name, string "".

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 4261088d..02f75cb9 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1173,7 +1173,7 @@ static void print_handle_file(struct handle_list *handles)
 	/* Only print file names if more than one file is read */
 	if (!multi_inputs && !instances)
 		return;
-	if (handles->file)
+	if (handles->file && *handles->file != '\0')
 		printf("%*s: ", max_file_size, handles->file);
 	else
 		printf("%*s  ", max_file_size, "");
-- 
2.31.1

