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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9619DC48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DBBA61370
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhFNHyE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:54:04 -0400
Received: from mail-ej1-f54.google.com ([209.85.218.54]:40725 "EHLO
        mail-ej1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbhFNHyD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:54:03 -0400
Received: by mail-ej1-f54.google.com with SMTP id my49so15064348ejc.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BTU1iFO2V4ZzMjExOiVLwCGbuFnGNHp5D2Mj4ZKntEk=;
        b=NreabNewJTGKscnzf0f5kMwvJafThH3qICR8jVHDlBW4rFW5bZpCrU77BVvxhwwdkW
         qWUMs5QYct0zXuSjuyVr19maFZHjbto/0BuwGWnkPXOexPHzjJhNbsaw2cm5icLJP3BM
         2BDB/zaqAZcRuCoXRlWagByrw9AheLZC45uIp8qczel3ErmkF1OVpiR4FBAUF3E8AtqL
         A51oraHX3l1AYMFl6Ey1Sk2oN2+Lhk05oYIcmfDvfOla9Cd5HRng9HTpExw+USoM1i8t
         PNxg2O1MoS12i2wKknovA1soAXeNoWqnjEKfccDBfeFvhJZMTdrvbZ5KqQXgG8MJYmy6
         WTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BTU1iFO2V4ZzMjExOiVLwCGbuFnGNHp5D2Mj4ZKntEk=;
        b=SaoDnzX2a7r5jROdfdrScytSWzr20hhlDazVGvzEqA0fqUhtQpukPagtwTT2NifNnQ
         3wvqMuPuMS8GT9xzLIG+dtXAgQlNSAF4hQoc7OCtwfe16246MEEmj33JoJsTLeociPAC
         RMvc73W+auQMXbRJxEcJG/mrqJc854HRYKkf49clYpKpasiwWI2RwvMNanQkRrHb5eXy
         7/jIskGyjRAyrywCDFUIOrwUJ6x9BPtT/Q8hvwurm4XfyuoK8y6/S+gDtJ4kOkCj8GJm
         GGOnL104XupKi00KhaVZNY960JVdyXsRqi3XIwu/lCmhIebVctUT3z+mhs3q9QWwzQA0
         bbIA==
X-Gm-Message-State: AOAM530AgzXfhUriqzZeOjBquHMAFZth5OrK3ACFQzMqF4uYAUPclJOk
        aTp+rnR6sMah7fctWGwvYJo=
X-Google-Smtp-Source: ABdhPJwunKu6zIBxTD6LF32GIVZRH3FDLBkzhIMcB+kztf6mhsReR4KU2zhuuAh9Hp0Qvn4tbr+lFA==
X-Received: by 2002:a17:906:d8cf:: with SMTP id re15mr14157964ejb.278.1623657060470;
        Mon, 14 Jun 2021 00:51:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 30/45] trace-cmd: Do not use trace file compression with streams
Date:   Mon, 14 Jun 2021 10:50:14 +0300
Message-Id: <20210614075029.598048-31-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When creating a temporary output handler for use with a stream, force it
not not use trace file compression. As no data are saved in this file,
there is no need to have a compression overhead.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index 317de1b2..1ca3a79d 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -43,7 +43,7 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 		tfd = fileno(fp);
 
 		ofd = dup(tfd);
-		trace_output = tracecmd_create_init_fd(ofd, NULL);
+		trace_output = tracecmd_create_init_fd(ofd, "none");
 		if (!trace_output) {
 			fclose(fp);
 			return NULL;
-- 
2.31.1

