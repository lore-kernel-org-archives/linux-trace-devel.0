Return-Path: <SRS0=fBth=A4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4EDC433E7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 07:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE11C2074B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 07:57:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AX0uXUM+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgGQH5q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 03:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgGQH5p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 03:57:45 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE39EC08C5C0
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 00:57:45 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id y10so9813377eje.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 00:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T6FYqV/YJfd0WvLJsb9hc1HBnq2mOWFV8Ush0sP4TcE=;
        b=AX0uXUM+3+CH6475u6PeISOGmxH6rANrqVosClnRqqoqUki8R/R1rcdaEPcOuGZSQe
         fLyXvAr35PF/La+LC0sHSR+FeG1fs9M60fT+qJZy87U2dRhFA71Df+Bkul+xWq8Scmek
         dGKd3vu1NUIGpnuQl2v4U+fw3yTrsR99c9iCsOInSv7TZzZnzKg6BW+0YE0b/cBxnQ0w
         tgdPMh0UzLTr5v1SzNi01izPgzCJK3KVOvX3W3H5psS6dAw3gBzbCitVFgcTVSAL1Yj7
         VhQW2tjj2brBQz4Zv1ViVLpPV6CMK2Eqch/IaZAvzP+A6Sa2cqKlDRFNS80ivGAvU3i5
         qLkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T6FYqV/YJfd0WvLJsb9hc1HBnq2mOWFV8Ush0sP4TcE=;
        b=qNwIKIsKEpBMF5Cph8bFaKInPF6L3k54Qjhp/zFjxYSvVi1dvHmjfa3QhiJtCCxwzf
         bHDzaWFDUY18TF9ax9tviH2KN66YqIqp2uwEbvj4LxBKuCiLN1vZZhBYPI90jNc5sPm7
         8ZBOFFXUPpGRTmcQCS4bPC1hSQ7IYKCZEuXdUtEPQ7jw58r41ut2ZFk8Q3i/Q+y9bo15
         Zm+jW3cBh64ftqAXwaIqjTdeysx5KIoLFK0NqFvqb0V4TzUGcZYZHX0LbgvoNoqi+HKR
         2tyDHs9yBoXJvvtF94NiKFPN8imczs6VC1gvcLgd9Rj/yH9bIDuZ0knUrco3SVmd0xz1
         n6Nw==
X-Gm-Message-State: AOAM5304HW057ttTXC16kYAQag/h3pj/9YfP+qUmPTPFBL2bC44AaUEG
        DrnbCVXhoZHmMHz4USGNFOQ=
X-Google-Smtp-Source: ABdhPJwmlT766sdACirSKFtVXQs+JsB2ZVISfvYUZIPHYOu0j0m6cJwj9nXY0HqYxfZgMjQYP3QtQA==
X-Received: by 2002:a17:906:f49:: with SMTP id h9mr5434540ejj.155.1594972664473;
        Fri, 17 Jul 2020 00:57:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c15sm7901997edm.47.2020.07.17.00.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 00:57:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Man page of trace-cmd clear subcommand
Date:   Fri, 17 Jul 2020 10:57:40 +0300
Message-Id: <20200717075741.74775-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717075741.74775-1-tz.stoyanov@gmail.com>
References: <20200717075741.74775-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added man page describing trace-cmd clear subcommand.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd-clear.1.txt | 40 +++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/trace-cmd-clear.1.txt

diff --git a/Documentation/trace-cmd-clear.1.txt b/Documentation/trace-cmd-clear.1.txt
new file mode 100644
index 00000000..67e5851a
--- /dev/null
+++ b/Documentation/trace-cmd-clear.1.txt
@@ -0,0 +1,40 @@
+TRACE-CMD-CLEAR(1)
+=================
+
+NAME
+----
+trace-cmd-clear - clear the Ftrace buffer.
+
+SYNOPSIS
+--------
+*trace-cmd clear*
+
+DESCRIPTION
+-----------
+The *trace-cmd(1) clear* clears the content of the Ftrace ring buffer.
+
+SEE ALSO
+--------
+trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
+trace-cmd-extract(1), trace-cmd-reset(1), trace-cmd-split(1),
+trace-cmd-list(1), trace-cmd-listen(1)
+
+AUTHOR
+------
+[verse]
+--
+*Steven Rostedt* <rostedt@goodmis.org>, author of *trace-cmd*.
+*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
+--
+REPORTING BUGS
+--------------
+Report bugs to  <linux-trace-devel@vger.kernel.org>
+
+LICENSE
+-------
+trace-cmd is Free Software licensed under the terms of the
+GNU Public License (GPL).
+
+RESOURCES
+---------
+https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git
\ No newline at end of file
-- 
2.26.2

