Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94F9C433E2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88CFB6192A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCVJ75 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 05:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhCVJ7x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 05:59:53 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424FBC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:53 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id jy13so20164752ejc.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qum7V/CX9vs6Frbtqh58iT4ZdrrYTiakqaue6dbnQtw=;
        b=encznjyLHc0JOV7wpvlUoLkG4dC2SuLNEzzBBok03Lr6Gubs0xhcRaCqizQVP6nYJq
         f4JSEA2OdFlrXFWLcBWVzuxJEfwEKH06YW+1qEtuGLrIuAOVR0nxFRrN6paf+kvWg8L0
         fQeT1UUnSwvAZn7GXDKu///lZGOeq17w+7X/P33aDt4dO4Y4cO6fmaArFdtHk+mcT1+8
         5TbcW0TdsavapadMzhg2Ljy+fCV+w2t1OZJPqDjHe0FQDQiG3l7jJ+pDXyz2PUto/Uvo
         DJ6LpoEndkOvpk9twUIlfX0e4N5pLPNIOP7xbWrrj2yEVKqf1VnMJjNnuSNsLedP9jI0
         OuVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qum7V/CX9vs6Frbtqh58iT4ZdrrYTiakqaue6dbnQtw=;
        b=mGKH5UKNBnYiWLXiKnf9708LX4DilueRUvwEaTusraop6ePgBKz5n7o2XKIAAJf/x/
         TEU2bA/sH2YJxF6dpJBM/Snqi7VEC8unUDhClsqYocBtUnSgWpqhma3Qnn1VdYg7WaOY
         /nrkhCJHLJTWtcajM40qoS+CtY1Xz0FXODsgjMXvZ8+ugRHE61FQnQShdF41qWghOAAy
         pc8YeakoAnRXQeMAss8Rj8bBv+UZ8i2M7BxA5VpCgN+/aYNAptiMDuaCFf8M3mX0lTai
         c216Z1AJD+vtXm7oGrmca+xtZqT0YnU/ZHfrmnS1uo1ZFDGgEAZYAUDBOZL4z17rq1a0
         30mA==
X-Gm-Message-State: AOAM5335EmhsJUAe4riQ2Xp8hxYbBTsdCE5rUQEjZpBAXmzudT1sY9QT
        4l/wQ8VWMyj/tDecLI/9LKb2jij2tERcEg==
X-Google-Smtp-Source: ABdhPJxvPNmjwYBpBDW59IxlX37AzkbbqBKIqB3oUuHJ+fF+SDvOWuliVf7ocSjNsI9EE57DV3S1Qw==
X-Received: by 2002:a17:906:a049:: with SMTP id bg9mr18378491ejb.186.1616407192026;
        Mon, 22 Mar 2021 02:59:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 05/18] trace-cmd: Add a new option in trace file metadata for tsc2nsec conversion
Date:   Mon, 22 Mar 2021 11:59:32 +0200
Message-Id: <20210322095945.259300-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new option is added in the trace.dat file for holding the multiplier
and shift, used for converting TSC trace clock to nanoseconds.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 tracecmd/trace-dump.c                         | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index a4637046..ce3d8dc0 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -125,6 +125,7 @@ enum {
 	TRACECMD_OPTION_TRACEID,
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
+	TRACECMD_OPTION_TSC2NSEC,
 };
 
 enum {
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 4bdfd53f..31b9d201 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -483,6 +483,22 @@ out:
 	free(buf);
 }
 
+void dump_option_tsc2nsec(int fd, int size)
+{
+	int mult, shift;
+	unsigned long long offset;
+
+	do_print(OPTIONS, "\n\t\t[Option TSC2NSEC, %d bytes]\n", size);
+
+	if (read_file_number(fd, &mult, 4))
+		die("cannot read tsc2nsec multiplier");
+	if (read_file_number(fd, &shift, 4))
+		die("cannot read tsc2nsec shift");
+	if (read_file_number(fd, &offset, 8))
+		die("cannot read tsc2nsec offset");
+	do_print(OPTIONS, "%d %d %llu [multiplier, shift, offset]\n", mult, shift, offset);
+}
+
 static void dump_options(int fd)
 {
 	unsigned short option;
@@ -543,6 +559,9 @@ static void dump_options(int fd)
 		case TRACECMD_OPTION_GUEST:
 			dump_option_guest(fd, size);
 			break;
+		case TRACECMD_OPTION_TSC2NSEC:
+			dump_option_tsc2nsec(fd, size);
+			break;
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
-- 
2.30.2

