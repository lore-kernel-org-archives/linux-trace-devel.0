Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFED4C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89DFB2085A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfCHOb3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:31:29 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39758 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfCHOb3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 09:31:29 -0500
Received: by mail-wr1-f67.google.com with SMTP id l12so5133640wrp.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 06:31:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Elqi1Oc4pysCxtrozQjmSlMTnm5ZVInYLlnHr7RtsiA=;
        b=sjoucVlPVNn1wg3HOgUjzwUZ+mW84O+6HY+uCzzBvFIaLCVFAenUXxX/jGY6NGiyUr
         g7xVgWy4iEyl8y8FgNZXGXWvDxJmFE/sdjVLeqJ/hD55DeuNG79lD05Uzto4wJVRoY36
         Gr9jQKpcWaYlAMfZ95pTJbDsH3/QBnHp8UilUANRLbPEvAJGYMKHXTzkCYH7mP+nrhYa
         k9ilia9xznYmYRkcirfNrn6jGcQ1mkP1yt0Az515nh6ZlRzxmdFiSM+wVtpFM4lzvl4W
         dsX8AmEp/YsbJ9kwRyG9BipVeIZQ6TYemkXSfPwCSaz/A6S87XzuBngmYTPsxFl782bx
         +xuA==
X-Gm-Message-State: APjAAAUFqhctGnM0u7nqFR8/JZOaOzuT8U6/wgz6WfxgEhp45ihNY6tb
        a4mGv0coyIYMAQqmr9SmiwL8vUJT
X-Google-Smtp-Source: APXvYqy0CDtGNV/mbJ+YTAPR6t0F3bRmyAWq1mWfzSeeWTFbufjVyooJETWX1CmSqWdxVNSmqDi/GQ==
X-Received: by 2002:adf:f089:: with SMTP id n9mr5574105wro.313.1552055487247;
        Fri, 08 Mar 2019 06:31:27 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t3sm13495654wmc.20.2019.03.08.06.31.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 06:31:26 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/7] trace-cmd reset fixes
Date:   Fri,  8 Mar 2019 16:31:18 +0200
Message-Id: <20190308143125.31168-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
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

Yordan Karadzhov (1):
  kernel-shark: Fix a bug in ksmodel_set_next_bin_edge()

 kernel-shark/src/libkshark-model.c |   9 --
 tracecmd/trace-record.c            | 137 ++++++++++++++++-------------
 2 files changed, 75 insertions(+), 71 deletions(-)

-- 
2.20.1

