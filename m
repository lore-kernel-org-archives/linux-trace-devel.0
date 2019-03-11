Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D1EC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D74E20643
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbfCKIdn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 04:33:43 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54498 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfCKIdn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 04:33:43 -0400
Received: by mail-wm1-f68.google.com with SMTP id f3so3423011wmj.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 01:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XWB1wUBFaY3RxCobLSWY6ezHIpq70KFMHVX7Creu3xY=;
        b=iAv3wuIw6R2mM5Zz+wfjNQxM5rMhfrv3KxavW7AUIYn1bngCQ4wnB4kFcYzQ0By1pR
         iiHBzHV6U1pwx4Le+QJGVUquXwGOsLKVPjy4AGYS5ciQcPlJJTDqwnGvq6EntZ7p9vjC
         pvy0w3zDbwavK4sMJkD1Ta0ONjY1lLcUUBoyzJeRG6KfMmMOUJ7/q6lUKEQ/APqXiv42
         /csB4j5L28tBko/hyDc/B5OduPr8cyIj/j8QyHsrQJB0NN/5Yu0PglI+MBTstIeZ85Zk
         c2wsI/xZpxMuhAYbQAB4AtDer2LFWP63HXx1aSdjNxDLBhqczOh8PlRiRjofCHfDLxWJ
         LHPg==
X-Gm-Message-State: APjAAAU0RniWcSMlSZ6Z5/eomsrjM6J2n7Y6/qfTD9k7XA/Bwry0+rBa
        XVncq+K/0qzW+pnpOa7HvvGtjfFe
X-Google-Smtp-Source: APXvYqxlrwhxIKVWlNQ7ixYMcdgg6dgKeY3gvd4VFR8tcQn2XN7LQ2/kB+G2FQ6W9Ih+eAYaOiW8xQ==
X-Received: by 2002:a1c:c5cb:: with SMTP id v194mr17149661wmf.150.1552293221482;
        Mon, 11 Mar 2019 01:33:41 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x17sm19683835wrd.95.2019.03.11.01.33.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 01:33:40 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/6] trace-cmd reset fixes
Date:   Mon, 11 Mar 2019 10:33:33 +0200
Message-Id: <20190311083339.21581-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 V4 changes:
   - An extra patch was inluded in v3 (not realeted to trace-cmd reset fixes), by mistake.
 V3 changes:
   - Refactored reset_max_latency() and reset_max_latency_instance(),
     as Steven Rostedt suggested.
 V2 changes:
   - Fixed subjects of the patches.
   - Refactored add_event_pid() and reset_event_pid(), 
     as Steven Rostedt suggested.
]

This patch series fixes "trace-cmd reset" command to 
restore default values of various ftrace configurations:
tracng_on, trace_clock, set_event_pid and tracing_max_latency.
It also fixes a segfault when the command is executed with 
"-a -d" options.

Tzvetomir Stoyanov (6):
  trace-cmd: Fix "trace-cmd reset" command to restore "tracng_on"
  trace-cmd: Fix "trace-cmd reset -a -d" segfault
  trace-cmd: Fix "trace-cmd reset" command to restore default clock
  trace-cmd: Reafctored add_event_pid()to utilize write_instance_file()
  trace-cmd: Fix "trace-cmd reset" command to restore the default value
    of set_event_pid
  trace-cmd: Reafctored reset_max_latency() to utilize
    write_instance_file()

 tracecmd/trace-record.c | 137 ++++++++++++++++++++++------------------
 1 file changed, 75 insertions(+), 62 deletions(-)

-- 
2.20.1

