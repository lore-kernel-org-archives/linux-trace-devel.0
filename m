Return-Path: <SRS0=JQUT=5S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434B5C43331
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 10:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16A0920658
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Apr 2020 10:58:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uWF3FZCi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387931AbgDBK6j (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Apr 2020 06:58:39 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38925 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgDBK6j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Apr 2020 06:58:39 -0400
Received: by mail-lj1-f194.google.com with SMTP id i20so2730097ljn.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Apr 2020 03:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N3w/+XJZl3Qbem/dKRyRDiH3pJIhyPk+ejEKI6aYKJ0=;
        b=uWF3FZCi4o7nol2A9ZdwtATh8CwHDn8M9Ploi7Bm9iZF+6vRSE7LIJVXqTm9AsPJZe
         yJfQCe7wSbpgs9mOoo/tTKkabuCEaxjSHDd/jWspziYWk9kpMpiHou4VH/jNAxcLjoU5
         fX/v5ydzUdhRR/iuNXrutPfXKhsjsxn8OrfW9fFFd+Ffw/gzeJa/olNyMNKxm3+C2Vzh
         8vM1b2cMr+N2LEm9EaCheVmLyZjaztW94FDDqlfTX8vCTbREOO4pFg8sFyVNq2p/ytt/
         HbiG9X8YbIdoahA4zo6ZcDoAvuz8ZP91zvQVdbVALJ0oYvOQLOGgrTS+7GiKIrDGvE50
         Ln+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N3w/+XJZl3Qbem/dKRyRDiH3pJIhyPk+ejEKI6aYKJ0=;
        b=lYkorke2QxUlCajUoK3jpKdrh2+15C2Bs0XRpq9uOtZ1M09mhUTUYuMMfwdvHj5Jmu
         IuSjTT93sLdZ1nZC2e25xYPJgUbPbwTaKU22J1X3sP1kzwGvhR23gxwIyrM/Sa44WJ0g
         o5gNHC4sKn5h96g1CV8juO+xthZA1pu5Y7uhLz1wGy/xiEYvdiQ0U19i0ywgzA1WByoM
         8WSR1NhLU0XOv2DS4ZJYZxlQETdIcSIeRu8tWNt1nl7FScmRilXX+9109U4wYpEZpD3c
         1LELkKZEM1xP4gazi1eZ42j7Vgwt2xlmFzXu/XvF+vRPwZ+CjVFuepkUVtzzEPpFAnpi
         OzbA==
X-Gm-Message-State: AGi0PuY7FbFFX27EkEEnlY2sbwFz5/ODNNyoJVImEUptlx2NcWLnX6mk
        vQgq8DM4JAsGf4QDnB4dgAQ=
X-Google-Smtp-Source: APiQypIgIlqfZ4OwXTVwswg8kwDOXZNUG0ciR7BEOslN1YwyDzRAEsHEFrOUKWrRNoPopPMqT+Z4rQ==
X-Received: by 2002:a2e:91da:: with SMTP id u26mr1716147ljg.232.1585825117289;
        Thu, 02 Apr 2020 03:58:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c2sm3779803lfb.43.2020.04.02.03.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 03:58:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/5] trace-cmd: Fix reading of the traceid option from trace.dat file
Date:   Thu,  2 Apr 2020 13:58:28 +0300
Message-Id: <20200402105831.263753-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402105831.263753-1-tz.stoyanov@gmail.com>
References: <20200402105831.263753-1-tz.stoyanov@gmail.com>
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

