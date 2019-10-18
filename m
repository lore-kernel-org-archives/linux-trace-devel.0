Return-Path: <SRS0=bpiG=YL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175CECA9EAB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 14:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E458F21852
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Oct 2019 14:58:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Er14KFLW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505095AbfJRO6F (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 10:58:05 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43319 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393933AbfJRO6F (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 10:58:05 -0400
Received: by mail-lj1-f195.google.com with SMTP id n14so6524458ljj.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Oct 2019 07:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sfz+dEoVlokTEsS0mqFVUQSYPQprrzzB0BMnVRCuOLU=;
        b=Er14KFLWDHC+rOZdnTkz8B+WvKAOz7kQpUUzFnMXooEmKhDK+sVMS+QpihAjAN2hCn
         3VouxHUFUqbYiaQf1x0wlaX1JohXvC2tm7P10/S8GZArUYdTtg5RRYP10NN22hed5OaJ
         LCmtcw/oM8rmINjsmsvTPNLo9S9+AA1pW/p4DD2ADIevKBJ653OOyUx2wYRp61gcSmBw
         bPmx9f9z+40gV4kVachbNyqwkF/Rb4Puio4poJZ3NHdi6d/GL0mYcwJXupK6VZiZ4eES
         g+qA5x0sNnxnxma60noZ8bLMugzzdmlh4Tgc91DLTHQeYPqydoewBxB2yTeJdH7j04Br
         UGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sfz+dEoVlokTEsS0mqFVUQSYPQprrzzB0BMnVRCuOLU=;
        b=geOAfW2mX1HorTGd2VMe/JvZ5JeJdBWDXf2OC2TYQNzgCjSdUSaDE4tukk29BY3O6D
         8qPA9gKSfucV8OD0vnXQhfux5ha5r/rBYLEk2jN01WHCcLxsoLKiZKkUXZXpwG8GPaUW
         akGZbyoA94YAJVvp2HEi+5BFKTLBjMekN7VWBdZkPjXTq/hVZQqPs7C9zrz+SBRIh6Q6
         AJ+oKz78QC6tIH1HgfiMewQqPSOTh71+yarMcolwvZ0now5HDbtZlUAeEhRfFrIUDd1n
         mCI2B+drEwPev2CwQU515Hftn/+VGeVqXJf+cank8ef5Mcre3F5YLXLCehjPLbMO+3Ci
         azyg==
X-Gm-Message-State: APjAAAUWmWW7zSnee9W/4QJJ4SQNbrYXYmQ3juk5AOKVeGKtlC7bdNxF
        2Cmu/VJOT20Kh0Lk+f8Mjkw/8Y9RuEc=
X-Google-Smtp-Source: APXvYqyEVyTyb8NXoLSZwLiV3NHZoK4pP/FXlJgfq08uW/Les6yJGr/ycrSdM6ov07azi6bdPCumJA==
X-Received: by 2002:a2e:87ca:: with SMTP id v10mr6371767ljj.43.1571410683810;
        Fri, 18 Oct 2019 07:58:03 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id e10sm3008331ljg.38.2019.10.18.07.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 07:58:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Check if ftrace file exists, before writing in it.
Date:   Fri, 18 Oct 2019 17:57:59 +0300
Message-Id: <20191018145759.15335-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191018145759.15335-1-tz.stoyanov@gmail.com>
References: <20191018145759.15335-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Depending of the kernel configuration, some ftrace files are optional
and may not exist. This should not confuse trace-cmd, as it is a valid
case. One such case is tracing_max_latency file, when CONFIG_TRACER_MAX_TRACE
or CONFIG_HWLAT_TRACER are not set.
A check is added in write_instance_file() to ensure the file exist before trying
to write in it.

https://bugzilla.kernel.org/show_bug.cgi?id=205241

Reported-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 81aca1f..c65731f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -813,11 +813,14 @@ static int
 write_instance_file(struct buffer_instance *instance,
 		    const char *file, const char *str, const char *type)
 {
+	struct stat st;
 	char *path;
 	int ret;
 
 	path = get_instance_file(instance, file);
-	ret = write_file(path, str, type);
+	ret = stat(path, &st);
+	if (ret == 0)
+		ret = write_file(path, str, type);
 	tracecmd_put_tracing_file(path);
 
 	return ret;
-- 
2.21.0

