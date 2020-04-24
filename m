Return-Path: <SRS0=pvIb=6I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D524C2BA1A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 09:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75B0A20724
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 09:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UKxB/pLv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgDXJ1y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Apr 2020 05:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726347AbgDXJ1x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Apr 2020 05:27:53 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7923CC09B045
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2020 02:27:53 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id g4so9257655ljl.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2020 02:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gYAxOQKkIDCa54Ge0rrWt+vvMIG9IKQAfcWX/gk0B/4=;
        b=UKxB/pLvbwYaVpSPDKTuQCxlrXGK2gxhfiDZdF/5vlJo95kfE9IcxAX2zyASzRmDsj
         MTI/Sug8fG/dsWmxO6Zj0F4MuIqpckPRQ/GjHuTIVajcOpX00bBpFc19t8I8X7/DTr7U
         hEcaYPPnVI6QdwHi21v4wUkZ4GYU0nZETDz3yQgI1b8aW8PWSreo+XYjzVKpxH66z7nh
         pUqhSzEUW2CwoqUgd8rqhlGeMj3Y+yEhlkfhdBVXvfWHDhbCsnWf8h0lNYMSaYXUa3vy
         h5QHKS6S1S3QAV1uC5BGB/tGnwuG+ysMUUC1BB7wP2w8MQc8hqmfca1esIvROvfc065j
         usvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gYAxOQKkIDCa54Ge0rrWt+vvMIG9IKQAfcWX/gk0B/4=;
        b=YLjet0QpKRcMIs+1WTdFz3hGhb/dJj5RDOJjZz4rwbExUYX5vCzBfgPhNXMZn+Cb8p
         +DEIZWfl3KrFfGM5+YEX9PHoZ+VZYP/7k7s7KnKhEH3ZrK+3YHpf4FyqX8FIKoy0naNl
         zGZDYpNGaTqM0a7p0gcoMELIMuvjbywhA8X+96Mpxu0qV1rZS7CkK/avv8qzrdtMLoJO
         8p8n8vU/zbwghyUTd988cwXEUGb1ZWfiTYLve3DfwU5YR9Sfenv2AN5yJKfBbgUPE3Y4
         jCeU5kXUn3eP+U+4GF6tbK1uvtW1DwiQ/iLlEyTZ54vB1kUwssiN49Sn7qT4mGwpw2o9
         by3A==
X-Gm-Message-State: AGi0PuZ2giq/cC1haKxIoc1W+Xdr5m3gteC7ZdPycSmnWW6GZCr+3vOQ
        IhDcWtbxiS4UMZu3AoYNf4BUxdclqPs=
X-Google-Smtp-Source: APiQypLnzj3k+XUkVylRX0HDGX/rwc+Uqp7npzaMi4gJvSSdUwo6j8f+14nZ2mF+2Q+LIUUCE3R+nA==
X-Received: by 2002:a2e:8083:: with SMTP id i3mr5329944ljg.175.1587720471834;
        Fri, 24 Apr 2020 02:27:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s30sm4077841lfc.93.2020.04.24.02.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 02:27:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Do not enable timestamps synchronization by default
Date:   Fri, 24 Apr 2020 12:27:49 +0300
Message-Id: <20200424092749.638101-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a timestamps synchronization data is detected in the trace file options,
and if this data is valid - timestamps correction is enabled by default. This
behavior was for PoC stage of the patches and should not be used in the final
version.
Timestamps synchronization should be enabled only if the file is opened
together with a file from the same tracing session. A new APIs were introduced
and already merged upstream for pairing peers from the same session. There is a
KernelShark patch which uses those new APIs to pair peers from the same session,
when loading the tracing files.
The default behavior, indented to be used for the PoC should be removed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 55c3d80a..25422755 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2191,8 +2191,6 @@ static void tsync_offset_load(struct tracecmd_input *handle, char *buf)
 			host->ts_samples[j++] = host->ts_samples[i];
 	}
 	host->ts_samples_count = j;
-	if (j)
-		host->sync_enable = true;
 }
 
 static void tsync_check_enable(struct tracecmd_input *handle)
-- 
2.25.3

