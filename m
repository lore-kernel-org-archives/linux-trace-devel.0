Return-Path: <SRS0=Bo3z=VA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D956C0650E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45FF2218A0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IAMQ17s8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfGCMQs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 08:16:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39206 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfGCMQs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:16:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so2537529wrt.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Jul 2019 05:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RogkDYnm1ncuO7Svv1mErHrEW2982ytOI6SdOjhNfrs=;
        b=IAMQ17s88q0ysq3ksePgVd4i0AgNl6+tgE4GB2OAhUyn4USIAB/UZEbk54fdw+hB/5
         Iinfn14/5P+i4hT1Iu8y8BV5+RDSAA+/C9m9XQNaFBDBUDSZnc8tHA3u4PoAgnK0UCEB
         vDKdkqu1xP5qp+7k9QWa/1HPTFJE2WDXJX+0c9rx9xxyA4U5MxFTKPErCw6RatUFevpf
         WjFf+2pajhNATKAq/oQBCW6QROU+jdEv6u9DOTq3ldlorbC6IaW6OYdn1k/kW5XV6m61
         BE7tvk5swu1wN5NByGoSIMHwhvqqFf5agmwQU0fPhBDq8/Zwn8F4dDkcngGUfsHg7Cqe
         1cwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RogkDYnm1ncuO7Svv1mErHrEW2982ytOI6SdOjhNfrs=;
        b=QJ0yPpCckLBfvItwZWyAPt9xlAN3V/j3u723RZimbbyHxxRkadZ+48ABvvb+5Ra4AG
         09uuMrIr7sIFOE5kE7ex7hBAhOk2BbuFgsbGMKKLsNpHnaXtMPpS3Y8bP8dTOHQXByCc
         g5SndajEE46JXx92HGgkYrNmCXGhQBRU3EiGIOAon61SS1BxQyBkCe+DVLMBSoyV/rVX
         wZYCxdEgK0w786Q/c4jEqyGA5p0EpBOyhduES+7A18xZVUfzn0pVuZehuDMfQrqfB7Bj
         eb5REAv4xd0mXvr+ozeiuwH3wnavM0nYc613geolRbnYWin9eucyure7ym/dcVVrbQlK
         pOzg==
X-Gm-Message-State: APjAAAWSTB/8esopguE7wyrTg1G5absLV6V3CfL2M6i+FdHDtfCgPF0p
        k8I7D7xa8ap/YnwTDnECB9g=
X-Google-Smtp-Source: APXvYqy/v07bETbVWHacOPc2KqesG3syuaoYgBiGPijSbCRwl5K0aBxrg056qfxmSTiF4EVou34Ncw==
X-Received: by 2002:a5d:5706:: with SMTP id a6mr26977925wrv.224.1562156205969;
        Wed, 03 Jul 2019 05:16:45 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s10sm2136244wrt.49.2019.07.03.05.16.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 05:16:45 -0700 (PDT)
From:   tz.stoyanov@gmail.com
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Fixed a potential problem with non-terminated string, returned by readlink()
Date:   Wed,  3 Jul 2019 15:16:44 +0300
Message-Id: <20190703121644.18680-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

The buffer, returned by readlink() API, is not guaranteed to be a null terminated string.
Explicitly adding '\0' at the end of the buffer is recommended, to ensure the string is
null terminated and to avoid possible buffer overruns.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 190cf74..7c74bae 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1373,6 +1373,7 @@ static char *trace_util_get_source_plugins_dir(void)
 	ret = readlink("/proc/self/exe", path, PATH_MAX);
 	if (ret > PATH_MAX || ret < 0)
 		return NULL;
+	path[ret] = 0;
 
 	dirname(path);
 	p = strrchr(path, '/');
-- 
2.21.0

