Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643B7C10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35C7F2085A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfCHObf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:31:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34647 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfCHObe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 09:31:34 -0500
Received: by mail-wm1-f66.google.com with SMTP id o10so9078311wmc.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 06:31:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hx45oLWm3cO7y7qj3wq6+r7jPLgvW5RIhXHj5w/9PtQ=;
        b=uPwElAqNrKJ92KSIdzijZnAjsZVQxRNv5mINqalhjuWq9Jfhf62pbG39cgx5gish8z
         LGAiVci+sA1tntUZyw9e8KeKK55fgrRcD96jdTcW0J5xZWjdPE9VTVSrkPPH5vcTNDwE
         uYNHcrOQ2Wzt0c4OQhcTmDcvdBBrwI1LSfOsujAT1PnoYalTucM6qRXQRHcGpZHAisyt
         RORiXrjqxcxXm8uaH9g2lNV/3MvEvjy4evelwKxxKLGqY29ukzL7fVsU2QJZ89W70RVD
         BXfrH22RjClJGvRrsq5LqrxlDAoY2VEP63KKMWWOmnUWQ9ZYU36/DgiiZRZxfjZh/T1z
         myTQ==
X-Gm-Message-State: APjAAAUvJK+dD5hR6yCegUGHUkOAJEq4Gjy5Ga08Vk5M2umEQSnGIvw9
        f/Jq+0XnqecYqsrQ/iszb5o=
X-Google-Smtp-Source: APXvYqwqjToiTE6DxiUPOhvdbIKkJhblEkiBGb5LIKWP1LczdQxBqJ9NaHoNMXgzU5KE/86lkf1ddg==
X-Received: by 2002:a1c:4c08:: with SMTP id z8mr8513287wmf.99.1552055492983;
        Fri, 08 Mar 2019 06:31:32 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t3sm13495654wmc.20.2019.03.08.06.31.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 06:31:32 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 6/7] trace-cmd: Fix "trace-cmd reset" command to restore the default value of set_event_pid
Date:   Fri,  8 Mar 2019 16:31:24 +0200
Message-Id: <20190308143125.31168-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308143125.31168-1-tstoyanov@vmware.com>
References: <20190308143125.31168-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command should restore ftrace to its default state.
This patch sets "tracing/set_event_pid" to an empty string,
when the "trace-cmd reset" command is executed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a398723..bdf0c02 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3796,6 +3796,12 @@ static void reset_clock(void)
 		write_instance_file(instance, "trace_clock", "local", "clock");
 }
 
+static void reset_event_pid(void)
+{
+	add_event_pid("");
+}
+
+
 static void clear_triggers(void)
 {
 	struct buffer_instance *instance;
@@ -4499,6 +4505,7 @@ void trace_reset(int argc, char **argv)
 	clear_triggers();
 	/* set clock to "local" */
 	reset_clock();
+	reset_event_pid();
 	tracecmd_remove_instances();
 	clear_func_filters();
 	/* restore tracing_on to 1 */
-- 
2.20.1

