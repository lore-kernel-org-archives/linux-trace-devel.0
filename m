Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73498C43461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DB3061007
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236448AbhD1HrX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbhD1HrV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:47:21 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964FBC06138B
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:35 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u3so14496767eja.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fEY6azDhSHEkA5JF2UCVmiNnDGP7VpSjU9sOlCrATlQ=;
        b=vYQsVbhSspW9HGfcTkOihdTDbgW/v8BraoVTr4orGqDoBrHGxn1UkqUqKhtJBDp3Oi
         xfUqfQ06QrsrE/ZRa3I7afQfGtPJ9GHVYTkgSQ4/9EzvORI+Vmey/RGWTK6CnyNTe5De
         e50i7PbIaNI75Qb75giQn8GhAMgnbdKxBfJO/B+5KaTxybzpEe8p7DxkJY1ZmINjejRw
         lxFC7i369rijDOqsQS7w2uokNguo4uiNKeW9GGeermdUj7PQTXjP6TA4GTLaemLRYtxm
         o636xe24O2hQFvbHKLhgjig6x60FA8YDLHyi9fJCi5GHTNDTOqg5/FE3y3eYVz9ENBG3
         km4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fEY6azDhSHEkA5JF2UCVmiNnDGP7VpSjU9sOlCrATlQ=;
        b=TGW0gDEr0DBBsssqZx7jUIrKz5IW62fEeZ2Jli83sbyDYgKnLOWKNOX7o+ZwdOLBcj
         7xpja6dfrC7GuA1/bB9FdCUNMotnJc6ASjV5FfSL2NKXtf1VtdVFLi4nupwmlskVTXyT
         /QJEg2zC/5QoJsh1Q3PfGLK7uNEYDlHgmYlIIX9V4NUCZKjzU3cm+YOmLsMW3uungD3w
         sWNI5uJ1fy7dfIYMeRWY7167aJjtuMGuCoJhR+c1+rnGxNekqO/o8tdfqcssdVmI8nXZ
         E6qbdrIDbn9JAABXCV4F7wsTOzbk+NJukx0Yh2eqmzANfx2Te7ZG2f5GkMN4bsj75nY5
         YDiQ==
X-Gm-Message-State: AOAM532zKeEhGOejYTBXVo7kn9S3Ptf9pI6VRmlP299l4t693zQVB8DF
        E5Fg7syiZxce+r3cCdoTOthSLUSr4sTAUA==
X-Google-Smtp-Source: ABdhPJyqBrmxOb6al3OIu9CeF/91HzaaiAbhiO0jiSGR2gmmhbKuiZr07ChLJoKpkpxuyguP9Yjw1A==
X-Received: by 2002:a17:906:4d02:: with SMTP id r2mr15764455eju.464.1619595994428;
        Wed, 28 Apr 2021 00:46:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lc1sm1412556ejb.39.2021.04.28.00.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:46:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/7] trace-cmd agent: Add --verbose
Date:   Wed, 28 Apr 2021 10:46:25 +0300
Message-Id: <20210428074630.757694-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210428074630.757694-1-tz.stoyanov@gmail.com>
References: <20210428074630.757694-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add new "trace-cmd agent --verbose" argument for setting the desired
log level.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-agent.c | 6 ++++++
 tracecmd/trace-usage.c | 1 +
 2 files changed, 7 insertions(+)

diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 1f7d9461..0dc339b4 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -281,6 +281,7 @@ busy:
 }
 
 enum {
+	OPT_verbose	= 254,
 	DO_DEBUG	= 255
 };
 
@@ -301,6 +302,7 @@ void trace_agent(int argc, char **argv)
 			{"port", required_argument, NULL, 'p'},
 			{"help", no_argument, NULL, '?'},
 			{"debug", no_argument, NULL, DO_DEBUG},
+			{"verbose", required_argument, NULL, OPT_verbose},
 			{NULL, 0, NULL, 0}
 		};
 
@@ -321,6 +323,10 @@ void trace_agent(int argc, char **argv)
 		case DO_DEBUG:
 			tracecmd_set_debug(true);
 			break;
+		case OPT_verbose:
+			if (trace_set_verbose(optarg) < 0)
+				die("invalid verbose level %s", optarg);
+			break;
 		default:
 			usage(argv);
 		}
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index edc43ba9..7019ab97 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -303,6 +303,7 @@ static struct usage_help usage_help[] = {
 		"          Creates a vsocket to listen for clients.\n"
 		"          -p port number to listen on.\n"
 		"          -D run in daemon mode.\n"
+		"          --verbose 'level' Set the desired log level\n"
 	},
 	{
 		"setup-guest",
-- 
2.30.2

