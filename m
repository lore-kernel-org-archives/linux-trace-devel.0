Return-Path: <SRS0=VUZx=6T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF211C47254
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 May 2020 10:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA1A4206CC
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 May 2020 10:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R95VIguM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgEEKR0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 May 2020 06:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728180AbgEEKRZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 May 2020 06:17:25 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DC8C061A10
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 May 2020 03:17:25 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y4so1010234ljn.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 May 2020 03:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9adEVrZAw7K3sUG1DkL+nxdWMHXWkO6gLXIcJz+ZEzc=;
        b=R95VIguMs+fYz6AF8WTK4Z+LWr8X+2cnnalEFU7ZuGLE/Ou6C6EXSx3sY9Ho8Gkpfl
         9I17MFyrffgZK8but4mg9t31vOc7abkKO0IarPcKlsCWYKzaByqs4MpfJ5WJN3HWFTrj
         B2WQuFr0T5kfvzjsGxcOa1DaclbxEX42fMDtUA3jh/Z/OfmK1BTwhUlLWc0fCPsxaPW/
         RLeV6JbdCDpVdHC0D+lkHgePSBkHb9NOWxTCzcJ36lOOssZtWG8MPhDEsuY40XoHx5z5
         YuKh5Mqu7/WP7p3zWDPA7DkpqbrshV1YM0V7YsPhVcjl5A697/nbkNyLVaFzWDSO/80c
         hI7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9adEVrZAw7K3sUG1DkL+nxdWMHXWkO6gLXIcJz+ZEzc=;
        b=V2N8ploi74sbelcRAQ/VLEBleqOXKRuNgeIA3BAdiGEBGXy9haowrr325jJ1d9kEYE
         X031ibGGoGfvJf6bgOnJqnvlEW+Hshsqa/4t0ZZ41njU2obiuNtfTrSRoAvaCa63r8JI
         7C1rtvxf69gUF6NzToEzPDn5xvA/A8iV/UkOhTerOouteilZ/ezh33Lu7YZcOJA/o6ex
         akf9sWJAXkZWDazaZvWGdZ9nllc6GPVWTDTY5sp9WiUWk7j2l0/5eiyJuCUMKVhZLAL9
         0McEmdZRn6+tc4iX7mL6gMtqiNEY8a9wOzuZFac1DbygJFnLiWZhyEAQVlC82JmnKPyi
         lPvA==
X-Gm-Message-State: AGi0PuaeSG0Y9Lo6n0f1yB/OQItR3no4lEKZklG5qqgmp8ZcY5JMaoK4
        dDAw4tkwanrp510SmPyr0n8yXNtXrD4=
X-Google-Smtp-Source: APiQypKcXgkxdV0F1TQHHR47H0y9r0iZ/eQ+5hVeOj7OJgMzYDZbC4Q8XcOs1QUE/s6e28VObvklNQ==
X-Received: by 2002:a2e:3508:: with SMTP id z8mr1269686ljz.32.1588673844051;
        Tue, 05 May 2020 03:17:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y21sm1334715ljg.66.2020.05.05.03.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 03:17:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] trace-cmd: List ftrace instances at the end of trace-cmd stat
Date:   Tue,  5 May 2020 13:17:19 +0300
Message-Id: <20200505101719.1856601-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200505101719.1856601-1-tz.stoyanov@gmail.com>
References: <20200505101719.1856601-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

By default, "trace-cmd stat" command prints status of the main ftrace
instance. At top of the output there is a listing of all configured
instances abd the user could be confused which status is displayed.
Moved this list at the end of the command output.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
v3: Removed the "main" when top instance is displayed and move instance
    listing at the end of command's output.

 tracecmd/trace-stat.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index c5057978..bd0e647a 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -920,8 +920,7 @@ static void stat_instance(struct buffer_instance *instance)
 			printf("---------------\n");
 		printf("Instance: %s\n",
 			tracefs_instance_get_name(instance->tracefs));
-	} else
-		report_instances();
+	}
 
 	report_plugin(instance);
 	report_events(instance);
@@ -937,6 +936,8 @@ static void stat_instance(struct buffer_instance *instance)
 	report_uprobes(instance);
 	report_traceon(instance);
 	report_errorlog(instance);
+	if (instance == &top_instance)
+		report_instances();
 }
 
 void trace_stat (int argc, char **argv)
-- 
2.26.2

