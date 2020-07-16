Return-Path: <SRS0=576e=A3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F03C433E3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95BCA206C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VT+enB+h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgGPJUY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgGPJUX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:20:23 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0921DC061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:22 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id w6so5811874ejq.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YuEEjolJbRPDpv8irdFKFzEge/lWCtPeCNl55tP0drA=;
        b=VT+enB+hOsdPAtNIYmXTnxHOoxzwML75BqP//Fnomfl7Q4hVZlYSbWVlhmV42NuxNI
         RgDwAY8pfdfneWFFwAaXu3gTctfpxLm31gwqwg9pXSLVlY7Dznej4V8k7DyzHA0MABbd
         DB8Gt1J6VsITyrTnW31tyDi3whmpOP+Uqs1fJzZiRH8jwX2q51yd1rF6RbOJaiACefVD
         xQat/hvx8FElC8smgU4Et95AHGCHM4ydBGZcb5y8caMkMCqLZvIyf2c+6mYoqhH/pkm6
         1ZU2Xa9m9QQX/XQwpVF+tXB/tRigGIn+8vOxOQFXhthzG7QKTKrcclGv4CNaEzAxtQeg
         t0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YuEEjolJbRPDpv8irdFKFzEge/lWCtPeCNl55tP0drA=;
        b=ReU5bOK80pWYqZfW9khmLMhhRu3Q7TC9IAXzTGbyqon9rR02rA7kklHvln2TpPFCYc
         FJRs4UEDZlWZiV4cBo8R9DV83Jmr+3s070ziTttBu9vU0OmSK04UeeQSgLxSCJLoqojI
         cxbFi+S3eMy0uuV+p8E+aWd2L01Z4l7+RAi7zHCdnLBJCcf8LcW5+qHfrQluX01tIc8Q
         H0katiJISroV8tjQ+cwOohIRF4zRyWnJe8pQA9mXhvuwadNhlpie7tV3lSuxeLONzxwg
         PtzjEvdT8tSPiDDbgA5PCYLIhvjPYiy7YRL78Pqw42duIj+LOx9gfF8tAZMpxx8hpaXj
         49YA==
X-Gm-Message-State: AOAM530pEOmcfbNYIdF1/GN5CSL0D/+QjCuyenAx6Et3kKJPXQaBfYV7
        ihloJGPovx2biJGm+iHEDuursAnpt0I=
X-Google-Smtp-Source: ABdhPJyoJcD42Pd6UJS5ZQxgcVb6VJsMc5ydDpw+0WaDrd/ESyAkN6BC9qKWnCVIuSX2hYW7dQumTA==
X-Received: by 2002:a17:906:cd19:: with SMTP id oz25mr2823171ejb.36.1594891220801;
        Thu, 16 Jul 2020 02:20:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y1sm5129117ede.7.2020.07.16.02.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:20:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 3/8] tools lib traceevent: Fix typo in tep_plugin_add_option() description
Date:   Thu, 16 Jul 2020 12:20:09 +0300
Message-Id: <20200716092014.2613403-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
References: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A typo "optiona" -> "optional" is fixed in description of
tep_plugin_add_option() API.

Link: https://lore.kernel.org/r/CAM9d7cizjF+fbK7YzmsBDgrx__4YAOsmEq67D3sWET8FF+YdFA@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-4-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index a39eeb6ef1f2..f8d253a61970 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -310,7 +310,7 @@ static int process_option(const char *plugin, const char *option, const char *va
 /**
  * tep_plugin_add_option - add an option/val pair to set plugin options
  * @name: The name of the option (format: <plugin>:<option> or just <option>)
- * @val: (optiona) the value for the option
+ * @val: (optional) the value for the option
  *
  * Modify a plugin option. If @val is given than the value of the option
  * is set (note, some options just take a boolean, so @val must be either
-- 
2.26.2

