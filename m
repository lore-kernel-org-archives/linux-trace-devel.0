Return-Path: <SRS0=9gE1=5R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7BE7C2BA17
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76C75208FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sR6rMyfO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389583AbgDAQs7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 12:48:59 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42213 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389799AbgDAQpC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 12:45:02 -0400
Received: by mail-lj1-f193.google.com with SMTP id q19so138044ljp.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 01 Apr 2020 09:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N3w/+XJZl3Qbem/dKRyRDiH3pJIhyPk+ejEKI6aYKJ0=;
        b=sR6rMyfOhG7zg9yFB+NFvB42p0wnmc6oUeY+LjxVtsivI0cyXdvVv9X5rczV90UiFh
         lQfvXE67u4FUorNGdhoqkw6WvYijyRtR2/qLYYfQ+1tfRdwj6LmCTqIh+UcJXkuBEwtu
         4Yz/rb+8DZVqrhpLqftNRWPLPg3QKMUwNeiKinelLh1ns0ssXBNXJ525DtOEHa37ddhg
         kgYDdUKvsAWXge2uNoRGLzopfG9Se9euEZlP8QoQkXV/JxIubqVZiXrv3deO+28rMZDE
         bGaXf/0+JBaKQsrMtHHfEotoageTYAAN920RVLtMngYqshrCWe1+Z3huLSUC26NEKsHk
         LmuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N3w/+XJZl3Qbem/dKRyRDiH3pJIhyPk+ejEKI6aYKJ0=;
        b=Jg3PN/RAbt3L7Vo/cEZBjx4uQdilikDMAKVzIOKn1GrMfAB1AB70BuaKtaPuIxYwH7
         uAAfQtV+j0jLkYithaesXqFgH4265b2WGVFhoTiCcrANOBfqgNFPXiK9brawG/WPCb2G
         0sSvgUrnPTE6cphLV90TFfYVXJEHLc11dsrycQ7NnFi3sEtRraIxLiYaZ5geWXBBgdU4
         0b+uxGcAfBEUaVZZJ+OTiIBzcza5cguxyFuImwB2ZNCGQq7ydsnmRjW5SHZVt3pmgUcn
         wMg5Cmnn2ojTAAsM0uBHt4p/1CZx6C694J7dbgblAPb7BIhH5TsQ+JCRZKXwhXtpfB3U
         QzAw==
X-Gm-Message-State: AGi0PuYwVF0pMpISa+WEW6RezMnQ6wuMVf6TsnIQbC+sSCP98VTW4wGB
        DKV8DcW+/upMR0TrE5Rcaqk=
X-Google-Smtp-Source: APiQypK4ajhFuQ1288eAVUVuYLHPk4rs9EHMjEUjrozSxTKRgBd4rRB6TRv4g0EVr5zs7WxIhcg4Lg==
X-Received: by 2002:a2e:9757:: with SMTP id f23mr13234005ljj.269.1585759498424;
        Wed, 01 Apr 2020 09:44:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e4sm1982499lfn.80.2020.04.01.09.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 09:44:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/5] trace-cmd: Fix reading of the traceid option from trace.dat file
Date:   Wed,  1 Apr 2020 19:44:48 +0300
Message-Id: <20200401164451.191425-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401164451.191425-1-tz.stoyanov@gmail.com>
References: <20200401164451.191425-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Due to a copy / paste error, the reading of traceid option from
trace.dat file is broken. There is no impact to the user, as this
option is not used yet.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0726b364..347a595f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2640,8 +2640,10 @@ static int handle_options(struct tracecmd_input *handle)
 				trace_pid_map_load(handle, buf);
 			break;
 		case TRACECMD_OPTION_TRACEID:
+			if (size != 8)
+				break;
 			handle->trace_id = tep_read_number(handle->pevent,
-							   &cpus, 8);
+							   buf, 8);
 			break;
 		case TRACECMD_OPTION_GUEST:
 			trace_guest_load(handle, buf, size);
-- 
2.25.1

