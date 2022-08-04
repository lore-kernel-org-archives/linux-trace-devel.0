Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73FAC19F2A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Aug 2022 17:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbiHDRhx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Aug 2022 13:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbiHDRhw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Aug 2022 13:37:52 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EB1BF56
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Aug 2022 10:37:50 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id 17so460800plj.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Aug 2022 10:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=XaM7pibYCkuBxa6jN4Rtz515v0ZZbQzxMDBJdqLtbLg=;
        b=C876QRNGIpacmus+8o4Dc43MbfxBTdF1br8iaa1IvA9QhGN3LOfs/FBTeX8A/i7/7e
         sPuLitOmfqdBy3AKWjD6haI6UbIH+00WvJexJjXyi9dCT/sene/TbdRPZMMBjbKTVp4P
         ZI+4Wy0AAz+nQTTaDzz9TtHnOf+jnGRqqDbD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=XaM7pibYCkuBxa6jN4Rtz515v0ZZbQzxMDBJdqLtbLg=;
        b=PCfvCS8Inusw9hU+4Q/G1OOUp7wjYUbzdTqvwm8bFaPf+zMpsSB6qc42fKrZ2jsxAX
         PGvGls359KSxuS5bHeL4naAic9cYoV5wI3V/lqRd/vBbLSGid5tJrEud38FGL9RcczJc
         wcjUVOKkVHMrbp/y50Nwk+0eAhR8GObLKPMNBNkd/yfyhDh0QkipprOaSuEZECCGjFa2
         45Jfwa9NV/iA25uLQk9VWWjG9B+WFrt20I/aydQcndTNHdNpSUwDdWFnL8j8Y3/81cnl
         RZF8lmZNiBl6Ipq9NNDKmVxrBvKSByJ6krj23BK5pwZALjOK5/raVvN6fprMfteSibtH
         3hOw==
X-Gm-Message-State: ACgBeo1Qv5i5F7JIolQnfS6BWQjfxFkm5GJs4XneFRFfjIuuOdbiHPKB
        ahAuckeWEQmIxzlKZFVKU4U8QtGCAPUa+Q==
X-Google-Smtp-Source: AA6agR7TKqiRjK9jdlE3emZI+sGyHWRkNvd4rI9kpulQlkfSlnwsn2qMIds5ZaXoRCIYn1GbKAh3xQ==
X-Received: by 2002:a17:90b:4d91:b0:1f5:24a:ff90 with SMTP id oj17-20020a17090b4d9100b001f5024aff90mr11996961pjb.152.1659634669699;
        Thu, 04 Aug 2022 10:37:49 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:1db:10a2:5dcf:ea66])
        by smtp.gmail.com with UTF8SMTPSA id o10-20020a655bca000000b0040d1eb90d67sm135199pgr.93.2022.08.04.10.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 10:37:49 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] trace-cmd: Document new proxy args for {agent,record}
Date:   Thu,  4 Aug 2022 10:37:43 -0700
Message-Id: <20220804103729.1.Ia9701619f867f6acbec9e20bf89ed41979fcce87@changeid>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Largely cribbed off the commit message introducing these:

4f9d216ee312 trace-cmd: Add agent proxy communications between record and agent

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
NB: I may not have all the vsock/VM/proxy lingo quite right, so feel
free to correct!

 Documentation/trace-cmd/trace-cmd-agent.1.txt  | 5 +++++
 Documentation/trace-cmd/trace-cmd-record.1.txt | 6 ++++++
 tracecmd/trace-usage.c                         | 9 +++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace-cmd/trace-cmd-agent.1.txt b/Documentation/trace-cmd/trace-cmd-agent.1.txt
index f247d41dcdb8..8c1721d023e6 100644
--- a/Documentation/trace-cmd/trace-cmd-agent.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-agent.1.txt
@@ -32,6 +32,11 @@ OPTIONS
     This options causes trace-cmd agent to go into a daemon mode and run in
     the background.
 
+*-P* 'cid'::
+    Allow an agent to also act as a proxy server, where it can be run on a host
+    and connect with a guest. 'cid' is the context ID (see *vsock*(7)) of the
+    client (e.g., guest VM) it will allow to connect.
+
 *--verbose*[='level']::
      Set the log level. Supported log levels are "none", "critical", "error", "warning",
      "info", "debug", "all" or their identifiers "0", "1", "2", "3", "4", "5", "6". Setting the log
diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index af3e776b1dce..b709e483ebe2 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -412,6 +412,12 @@ OPTIONS
     'name' - the name of the desired compression algorithms. Available algorithms can be listed with
     trace-cmd list -c
 
+*--proxy* 'vsocket'::
+    Use a vsocket proxy to reach the agent. Acts the same as *-A* (for an
+    agent) but will send the proxy connection to the agent. It is expected to
+    run on a privileged guest that the host is aware of (as denoted by the
+    'cid' in the *-P* option for the agent).
+
 EXAMPLES
 --------
 
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index f809c1845cfa..42a8e7d1107d 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -19,7 +19,8 @@ static struct usage_help usage_help[] = {
 		"record a trace into a trace.dat file",
 		" %s record [-v][-e event [-f filter]][-p plugin][-F][-d][-D][-o file] \\\n"
 		"           [-q][-s usecs][-O option ][-l func][-g func][-n func] \\\n"
-		"           [-P pid][-N host:port][-t][-r prio][-b size][-B buf][command ...]\n"
+		"           [-P pid][-N host:port][-t][-r prio][-b size][-B buf] \\\n"
+		"           [--proxy vsock][command ...]\n"
 		"           [-m max][-C clock]\n"
 		"          -e run command with event enabled\n"
 		"          -f filter for previous -e event\n"
@@ -78,6 +79,8 @@ static struct usage_help usage_help[] = {
 		"                            none - do not compress the trace file\n"
 		"                            name - the name of the desired compression algorithms\n"
 		"                        available algorithms can be listed with trace-cmd list -c\n"
+		"          --proxy vsocket to reach the agent. Acts the same as -A (for an agent)\n"
+		"              but will send the proxy connection to the agent.\n"
 	},
 	{
 		"set",
@@ -331,13 +334,15 @@ static struct usage_help usage_help[] = {
 	{
 		"agent",
 		"listen on a vsocket for trace clients",
-		" %s agent -p port[-D]\n"
+		" %s agent -p port[-D][-N][-P cid]\n"
 		"          Creates a vsocket to listen for clients.\n"
 		"          -N Connect to IP via TCP instead of vsockets\n"
 		"             *** Insecure setting, only use on a trusted network ***\n"
 		"             ***   Only use if the client is totally trusted.    ***\n"
 		"          -p port number to listen on.\n"
 		"          -D run in daemon mode.\n"
+		"          -P Also act as a proxy server, with a single client denoted\n"
+		"             by a context ID (cid).\n"
 		"          --verbose 'level' Set the desired log level\n"
 	},
 	{
-- 
2.37.1.559.g78731f0fdb-goog

