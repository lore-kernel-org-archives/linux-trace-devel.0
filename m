Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01ADCC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbhLJLGh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhLJLGg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:06:36 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DBFC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:03:01 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id e3so29104912edu.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ksy0xrSPVuAQw6eKnrIq2YqyARmo9alOxGtiAGfbEkI=;
        b=KFQbRnafStJOAuofoNpCN3y8o20Z98HA8fDNlcOTBPr4W8FA5bkmC2kS1Yg8/OUswr
         Un91SOlmd4aARbmdMf4LhmQ1QthiTohKHsvT1zwtMls7oN/urwb8Dcexyt+ui4t/Zho3
         yZgPH0ux9T2EsB3IcoMfNNWZansqIHMQ3xZwIUHsxehNckz2NQVdpRi+PVrgdTH0mEeM
         WprO4e3CrUHDoKmmKrBuowDm4THvnPT1GyGwJm5E/5V2wJwNZxlUjyV/OH6rSemqv8LY
         HvfSw4o3sMy0+2bKVsAWSCEv5eZk24nNn3qbfPbjC5b2jNnqd+PM7vJi3uvofDtF8mXy
         lgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ksy0xrSPVuAQw6eKnrIq2YqyARmo9alOxGtiAGfbEkI=;
        b=PkAWFQLqxlfOqFUUxNoE36DYGHXY1tlVcztTPgxnYV7v3i+sJJc+QrqI/Q43gZtVoM
         2VdA/BD2mc9IGagaJin+QTUbZN+Ot5xtl9mhZit4sbOFhxnxMWq/Vt4B429DTL+CxSf1
         APkG8CDQZ80ACx6Zp3MgLGyLHPUHDiazA5+7IJ+6TAVc6C5poUzVmXCqWqDk0L3BIBsr
         0g6saruCgdBaIIZROq7M9pqfVR+SM0aVqJP8Ncc9XuzSyG5bo+zaj49Dotrs1EQ++iC8
         8AykJwDdICfPr9Zyl0FARbVwg7m3l3LqUPlAViizkkKeC5pP0M2iYYmtpBj/pyrb8C9J
         FJzg==
X-Gm-Message-State: AOAM533hMa6vcUWLU98Kf+Ka6C8r18xZ5b15JWjMPrDLj/6yNgHHM/w2
        /ffq1Dg37DkjYA8oUTI62eZj4YDA1yw=
X-Google-Smtp-Source: ABdhPJyx4HRAlX0u8GeHD3kyKhPpgT8Bd/t+Sspxr9meHlfl32idueJZt+L+m41CkRUno6iUdasdvQ==
X-Received: by 2002:a17:906:5653:: with SMTP id v19mr23115745ejr.360.1639134180372;
        Fri, 10 Dec 2021 03:03:00 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id sg39sm1275269ejc.66.2021.12.10.03.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:02:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 7/9] trace-cmd library: Avoid memory leak when setting trace clock
Date:   Fri, 10 Dec 2021 13:02:47 +0200
Message-Id: <20211210110249.98583-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110249.98583-1-tz.stoyanov@gmail.com>
References: <20211210110249.98583-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The API for setting a trace clock to a input handle did not check if the
clock is already set:
 tracecmd_set_out_clock()
This could cause a memory leak, if the clock is alredy set - the old
clock string is overwritten. The old clock should be freed before
setting the new one.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index cc27c245..4f31f58b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -211,8 +211,10 @@ void tracecmd_set_quiet(struct tracecmd_output *handle, bool set_quiet)
 
 void tracecmd_set_out_clock(struct tracecmd_output *handle, const char *clock)
 {
-	if (handle && clock)
+	if (handle && clock) {
+		free(handle->trace_clock);
 		handle->trace_clock = strdup(clock);
+	}
 }
 
 /**
-- 
2.33.1

