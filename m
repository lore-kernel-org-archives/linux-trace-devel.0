Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6E3C63682
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbiAZJwJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbiAZJwI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:52:08 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF9CC061744
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:52:08 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ka4so37706609ejc.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FtkvWDntvaQsbS0VyHeLi1rv+YVJUzbhCKEwMcOq4Ao=;
        b=avn7EnilLdBB9B4bTV44i2SeTu0+Td6cn+AcsasGjQorgawxHFcsLUWsY3wViItokg
         Bp4U7DXdAnr//DpZVNyRleEpDkpCl3wTN95GrLZsVNX9EIZSAGsNpy7NMIkiB2ZH3fl8
         7/VojKjOGnRYKh3HGnheVzzVHQy4buf3eETHT+PYatOI9hpSutu0kJmIuLRgYObkQdM1
         CZfRXxI4zqV1JsIefCJWkJQvXpCP/Yp7TgJsgnGfPgMoobu3+0sXhKGMqeigXRLzPwkZ
         6nl+D+xlckm79jCDp/GqsI1s78MERRpBSkA1XrAC8U0amczzhZTElGtwKYl42XtcKPrn
         2hHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FtkvWDntvaQsbS0VyHeLi1rv+YVJUzbhCKEwMcOq4Ao=;
        b=0pDwLlnnVtWvErWgNBIxDa/0oFAJTunjRwrbavVYhtPi5SyPZzqgYeTV+d/uFKVRcb
         Aj1DNQNYp56kZCs5yLaoDFuKbj1s6OVfaar5+SQ9h4E9oN/NZgJY8S6a8iaApEj9GLvj
         YtZJSTqAbZHDk5huwcrozNnhLgrETG/MdroXMAz/0cvtp3S9hvvBlX6FLtO1XNzlfx6J
         KW4ax0ZhJbfZhWkD8mfd2kiVCdmAghB0L0vFMv3Vm8og3muognl+uRLdKCKn8lIfVLbi
         C80MSu4r7O91ZYDP28kgT3Us6BLs0GmU0vvW6ePmoC/2dqzAvEiOIeYxbNwB4vOOHeUb
         aa4A==
X-Gm-Message-State: AOAM5338g1lIzCBKczEi1+9UZlYReH4frNgwoIj9ePFbdsgt2DVWMyAK
        ukd3XmqAmb2Hcj+S5HRZwnI=
X-Google-Smtp-Source: ABdhPJwgm/7ltU0w00OyZKPkxS9BiHBnaMUjT3bsQzqxLh0bjjJmV5ZF4Bw3VAHJnKaHwj5cPLyNsg==
X-Received: by 2002:a17:907:3ea4:: with SMTP id hs36mr1252202ejc.507.1643190726802;
        Wed, 26 Jan 2022 01:52:06 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id v15sm9529823edq.35.2022.01.26.01.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:52:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 7/9] trace-cmd library: Avoid memory leak when setting trace clock
Date:   Wed, 26 Jan 2022 11:51:52 +0200
Message-Id: <20220126095154.570700-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095154.570700-1-tz.stoyanov@gmail.com>
References: <20220126095154.570700-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The API for setting a trace clock to a input handle did not check if the
clock is already set:
 tracecmd_set_out_clock()
This could cause a memory leak, if the clock is already set - the old
clock string is overwritten. The old clock should be freed before
setting the new one.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index b54c68fe..c1ba8a52 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -227,8 +227,10 @@ void tracecmd_set_quiet(struct tracecmd_output *handle, bool set_quiet)
 
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
2.34.1

