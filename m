Return-Path: <SRS0=0q7s=A2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 502BDC433DF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D3D420663
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="menyrLxx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgGOCaS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 22:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgGOCaQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 22:30:16 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4D2C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:16 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id y10so580712eje.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XUKjAVCtp2w11gmss2/AQYK+a1PPGsN90lgxfra62y4=;
        b=menyrLxxzGcGNuyXenVRMi+EVmF7W10CMBoYZGuAcCrNsZlrmEOoqQnBNBc3StBVLI
         XuaO7n9zlvAzfAuiUYYM4OVCilxUAgIz3c/VbXXXeN0qW1r5eeXmfpnu70LALDLDFdzF
         uqinGUSwKeHG8h9IRIGgGqtVS21Njv2ExeoyuA/nQm9QLVurQvvtDHd/NiZLa96A8aOQ
         5wJy/+R+I9lUa22RsXWvuTvzR+slqlqj5xaK9QBRaczzBKdaEoIOlRSSxIjD0tfxZc4H
         GVlT+xwYUHgOhzNq0E3YM/yl0z8P9wA89bUBbOAzHlFgLwLv+5+CIu/gxInMfxlG90F4
         7vVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XUKjAVCtp2w11gmss2/AQYK+a1PPGsN90lgxfra62y4=;
        b=cbsBVcCrAtWGyeBpAHb3K4ww6rKgza0XV332vwSUi151vZlq3J43aDjaDodjFWUxh0
         41Xs0YzCiHaAqPBZnrZjiLLKj9BWEf/3VDhiLav3CPftN1ciWzaSGJDm5F+gOmLm/7FE
         u3Dt4QDF8ch6vMu1qv2Yl2ew0AxgAkEi+wXdn2bNwHbPAz5/fMx5p30ZTGKEBGBXCrGQ
         zn2USPylkbHN7pN96+JR/GByLsz+9PUz1cVvxLS71E/OtNuZ61WW/17pSj6gAcgpZ6yg
         +wJxP3UZjpVHrXbwh1LoBdgFXFZeNzsACKiG3TjlADNrRCOjTZqnCZmvu6u0Mrc7LMEF
         HA4w==
X-Gm-Message-State: AOAM530aWLRDH+V/2A161Wyb9Zue9KKkmjtJ4IvrNLYWN7OFKrQQsA7A
        SFyeq6t4wawwFV6cuAYAgW0=
X-Google-Smtp-Source: ABdhPJycnb2HQOrLQr8FFVBYwSs3N3aIsLCUOW282+ao4AFhsoSgqKP6WF1FgHkNbCJITS/FaQwCJw==
X-Received: by 2002:a17:906:abc9:: with SMTP id kq9mr7337728ejb.493.1594780215381;
        Tue, 14 Jul 2020 19:30:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d24sm576474edp.83.2020.07.14.19.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 19:30:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH v2 2/8] trace-cmd libtraceevent: Handle strdup() error in parse_option_name()
Date:   Wed, 15 Jul 2020 05:30:03 +0300
Message-Id: <20200715023009.2503879-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
References: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Modified internal function parse_option_name() to return error and handle
that error in function callers in case strdup() fails.

Link: https://lore.kernel.org/linux-trace-devel/CAM9d7cizjF+fbK7YzmsBDgrx__4YAOsmEq67D3sWET8FF+YdFA@mail.gmail.com/T/#u
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index c11636ce..b97d0c7e 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -254,7 +254,7 @@ void tep_plugin_remove_options(struct tep_plugin_option *options)
 	}
 }
 
-static void parse_option_name(char **option, char **plugin)
+static int parse_option_name(char **option, char **plugin)
 {
 	char *p;
 
@@ -265,8 +265,9 @@ static void parse_option_name(char **option, char **plugin)
 		*p = '\0';
 		*option = strdup(p + 1);
 		if (!*option)
-			return;
+			return -1;
 	}
+	return 0;
 }
 
 static struct tep_plugin_option *
@@ -325,7 +326,8 @@ int tep_plugin_add_option(const char *name, const char *val)
 	if (!option_str)
 		return -ENOMEM;
 
-	parse_option_name(&option_str, &plugin);
+	if (parse_option_name(&option_str, &plugin) < 0)
+		return -ENOMEM;
 
 	/* If the option exists, update the val */
 	for (op = trace_plugin_options; op; op = op->next) {
-- 
2.26.2

