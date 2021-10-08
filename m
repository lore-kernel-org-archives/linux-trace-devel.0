Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A23C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60F61610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhJHEWL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237470AbhJHEWJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:09 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69ED9C061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:14 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r18so31282184edv.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3gvUNdS2tSOAtgwBR3qg1qW8J0dzWb8S/4v45esPWUk=;
        b=TIOZApjEBzr2RnsIRf+T69BdUYq+uO9L2vbD+U2mcEmnLyg4dAjBepyDrgKrB3E03F
         jWUekBn8mff25eeSrtsD/nEjwA8y1484jh9Pck8F3vvztVKDp8xCmXLN15F/4Ecb8SKv
         jvW3/VF3Z0kox5erTVcJ1rBZDVDrTz3yS1XUhxGP4+f1fvz1enxyufgATnMet24aQx7+
         HNcYyNUUBxi3WHPw8PPhYDH4u3SUmG9z8bHMdNQHpFRQ3GZbRybuHth5XNlh068SGfn1
         Xg/prx2pzum4SG6Xs5lwCdf7V2xoeeI+H9ySNTYpNp/VSg04EkNG1wJCGP7RP+MeXsW7
         b2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3gvUNdS2tSOAtgwBR3qg1qW8J0dzWb8S/4v45esPWUk=;
        b=SHn87bL7K2YOFgf2YR72uRGw0UYZEnHixwGhsnb/mLw65bWSZskfZ4ovBHbuycfWV5
         pvBPVeTP/5P4KvNXCOzpZ7COrt0VSNaXs4YkJPEdcFZWAKbX2ksnMJUAHmhvkYftH2ga
         ejCmhVW6t1wL8k9U/zyN9jXcEoqPd68VMzcwR3R8WD3Jgy+9LlhafvgKWZXZ3zR0aN9q
         3/6zt8PmXdAtdPLw6PoK2vj7/0tTBl70Q1JJPJZAUCbPUJuO8V1eJ/8qesVhgaS3v090
         01tpakHUqvXgbwMX8znoxOi96HYHGCwG7vWWpFWFPyFcBfZHAG7tvSSMCCGKLOnPZQ3T
         323Q==
X-Gm-Message-State: AOAM533lfvr7n66AjzraP5iFLlpjJPC1vL9e0lA27TQGkkAQC930Gkr7
        v3HZxoqC6NE9qB9Cbx+GQGoztJ9R+qS8Xw==
X-Google-Smtp-Source: ABdhPJzOQro0LU5ICezRZaLEuSDzvvHb9CADkOvw+ln0z356wIoFQWD8UFnRpJ0LQmPdv4WCsu/MaA==
X-Received: by 2002:a05:6402:2756:: with SMTP id z22mr11914906edd.264.1633666813081;
        Thu, 07 Oct 2021 21:20:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 12/25] trace-cmd library: Do not write CPUs with empty trace data
Date:   Fri,  8 Oct 2021 07:19:45 +0300
Message-Id: <20211008041958.976309-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index ebe5b179..ffcc62e1 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2076,8 +2076,10 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 	if (i < cpus)
 		ret = -1;
-	else
+	else if (size || !HAS_SECTIONS(handle))
 		ret = out_write_cpu_data(handle, cpus, data, buff_name);
+	else
+		ret = 0;
 
 	for (i--; i >= 0; i--)
 		close(data[i].fd);
-- 
2.31.1

