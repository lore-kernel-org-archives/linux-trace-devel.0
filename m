Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F38AC10F0C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF7B2084D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbfCKIdo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 04:33:44 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38093 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfCKIdo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 04:33:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id a188so3313541wmf.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 01:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B0LSgheigQKYDNu87C/yhSfypvVN6mgElsvHHKqMVDU=;
        b=qrNUmNx8cSilGZ8JQfoTIzSHO47Js8oC/M8cqiyzuP85+2qHMuIzTMordVkCIrMlmj
         zoZVJlJkUbOn6JWfd916XVmSnQwIu7zfKVFUbfem9EZYQsQYC2XIAbwmzy55fI76rIvj
         XZgCZKzX9qeGkgp02Jp058iyTg9NbC97X1mFYjFR5WxTj45lwV+PUs3AGOO36BHDDNnY
         VyHQsKu7Ri4T61fInr2VbqUdBh7KphD3P8ZBRkNyBuTXEu23rOKBzkrkGIW7QMpa8Mc7
         xJP2ubGztxwc1hpGRRmoT8uEvoucZcb4O8NyI2/lV5hHFsEniKa/UB9nEhKAW7EvhhUf
         pZQg==
X-Gm-Message-State: APjAAAUD4lLRHz5iawWlXE3FinqSZdKDMkpemnNJ989JtYN5jQ1RE4Fy
        tsoHNv4hrcqvD0RaC/AjFs1bLKZr
X-Google-Smtp-Source: APXvYqyPjsVAwKE9+CEeCfz6y5XCjffKxCpkPswpLg0GfchLYT6SrFWvCAKMcoLYbwyPxm9cOTMQug==
X-Received: by 2002:a7b:c017:: with SMTP id c23mr16082787wmb.50.1552293222272;
        Mon, 11 Mar 2019 01:33:42 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x17sm19683835wrd.95.2019.03.11.01.33.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 01:33:41 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 1/6] trace-cmd: Fix "trace-cmd reset" command to restore "tracng_on"
Date:   Mon, 11 Mar 2019 10:33:34 +0200
Message-Id: <20190311083339.21581-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190311083339.21581-1-tstoyanov@vmware.com>
References: <20190311083339.21581-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command should restore ftrace to its default state.
By default, "tracing/current_tracer" is "nop" and "tracing/tracing_on" is "1".
This patch sets "tracing/tracing_on" to 1, when the command "trace-cmd reset"
is executed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8beefab..fc658b2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4496,6 +4496,8 @@ void trace_reset(int argc, char **argv)
 	clear_triggers();
 	tracecmd_remove_instances();
 	clear_func_filters();
+	/* restore tracing_on to 1 */
+	tracecmd_enable_tracing();
 	exit(0);
 }
 
-- 
2.20.1

