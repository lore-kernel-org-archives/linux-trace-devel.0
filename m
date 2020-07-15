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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB416C433EA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99D7820663
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLRh/8Am"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgGOCaY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 22:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgGOCaY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 22:30:24 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4907C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:23 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id ga4so529187ejb.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rnUiclKVE9nnrJPmPqEOMSR7QLlhP2L9J0AiuKnCakk=;
        b=GLRh/8Amwfm49aNNNuDHBmYw0XAv6tTG5EChtWxIHRExqnnT+jywrDmxQ7JNdzXG2g
         r1sVmOTVI5CJlDzDTfO+nL1IJXDKVcQ1xnksqJbfsXyskiA3I9NpI5QU2YRXbSriItBd
         xKTH9ZTqQph6KlmoTVbol+qw4a5pr9QUF6BpQYYiOkt0nVnDCKbvGBAYTQnTKNLOOFVC
         89zZgFnsdmWCGQYuryDx8Zt2eskS9B5SflKT+TcvlPCQOBH3Z/+g1BDFEnuedrwGWBqy
         1SoXXcELHv8hapgDKrD9WBSpZvBlfh1SWrae8L+QnmyA1ACQeV9UQAsjM7ft6OTOEVAV
         yWiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rnUiclKVE9nnrJPmPqEOMSR7QLlhP2L9J0AiuKnCakk=;
        b=ZCjleRgK4yXaK5AZCDNof80yk1rERUZkzvfyP7/lbquvAsupgk00kYJB4Gqwbst/+c
         AalSEVu2f8UDsEzzPsNVV8fNSO7IFDbUetaelaDKiwFrMIq9E8wYadjVUeagqUda2C4F
         XlwfqFqjRbs82d4XTj3v0KzQi8JMi9qY41fOxTHCJH4VZ+A7GeN19hXyU0V1+ToNUUQx
         M8MDvtjeOXCbj7jh755CjkYaL33fwVEosCdTYQygKU8ThI/zGvJPt0m4oNH31usBIzqH
         oQT1TVsLa8kPPrcfhpLYkSOsATQmK2x0ZTqP3Cg150ky2MbCGGkLiuTl0KVcDnd++uvJ
         dIcg==
X-Gm-Message-State: AOAM533YIWBggzVSShTGiOKXTUIuX0K0CCSgp2rIcSIDMscnndksz4ly
        6NvQOrb5TLOqpiXnfonpSek=
X-Google-Smtp-Source: ABdhPJyerEvINwMaZJH3DDwpObAhVNVhRLk2iq/KQabGnWROpLgM3uP2Ub8R0XyoAzmfKAwXbPsk9w==
X-Received: by 2002:a17:906:4a17:: with SMTP id w23mr7527963eju.360.1594780222556;
        Tue, 14 Jul 2020 19:30:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d24sm576474edp.83.2020.07.14.19.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 19:30:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH v2 8/8] trace-cmd libtraceevent: Handle possible strdup() error in tep_add_plugin_path() API
Date:   Wed, 15 Jul 2020 05:30:09 +0300
Message-Id: <20200715023009.2503879-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
References: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Free allocated resources and return -1 in case strdup() fails in
tep_add_plugin_path() API.

Link: https://lore.kernel.org/linux-trace-devel/CAM9d7cgMgqFDvKhs6xwdBSMsaG=3ZG0RtxwgQDCTLGkML1MY4Q@mail.gmail.com/T/#m60f797c012680cc413a98ffdd9136666efcc4ded
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 841e41c6..4a3f7d3f 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -666,6 +666,10 @@ int tep_add_plugin_path(struct tep_handle *tep, char *path,
 		return -1;
 
 	dir->path = strdup(path);
+	if (!dir->path) {
+		free(dir);
+		return -1;
+	}
 	dir->prio = prio;
 	dir->next = tep->plugins_dir;
 	tep->plugins_dir = dir;
-- 
2.26.2

