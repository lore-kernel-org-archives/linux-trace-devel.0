Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF921C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE3BF20661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfCHNoJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:09 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36748 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfCHNoJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:09 -0500
Received: by mail-wm1-f65.google.com with SMTP id j125so12508921wmj.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k73F13lU8ppdZbZeOvnmuLS3oYW+Ny1YgcKXHd7WV6A=;
        b=p596viDiaELYu63BrHQhRepi6bNy/u/Vbl83J/NKyaARZBvA9HFIILCJ/bv9/DjNnC
         FR2wx4ydM3fw0ZMMaQK9Xsr932hVnvye5m7vNpyqTY6670ulDvYTbSp1wlwNFtPUWY7M
         +rNhVEnOLwEcywCgot65AEQDaJU+pPRpFUwfoIIQioMTi2vywJEnCM6S0TKh7zIiZKdM
         V45aPNtjPe2BlFlRN4EE8AtmgsDDlKjdAHVvWQphsIE+FlUnEr+9v1ZiQ5OFDkctjv2n
         zGY3ao3WDAqJUGx2ygTm7Nl6YvTfLcrHNEMqZOkgXOsIeHJQ2Qo8yGlSCGWEvpcU65At
         QFNQ==
X-Gm-Message-State: APjAAAUabdLHl6f5hF0lcbIg0AVLDnkgz7OmS2UqUnIxa4+Y8g7k2ntU
        g+0RPI3EQ7mVujD1Di0JfCGtCRMp
X-Google-Smtp-Source: APXvYqxjhARYEqxUpQdYm07j2Y6I+MjP8Pk7Y6r3uHg6RBvRe2EJXCYWm2oBh/ykC9/z6/hcRpaEag==
X-Received: by 2002:a1c:e489:: with SMTP id b131mr9243211wmh.130.1552052647702;
        Fri, 08 Mar 2019 05:44:07 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t16sm5650943wmj.47.2019.03.08.05.44.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:06 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/6] trace-cmd reset fixes
Date:   Fri,  8 Mar 2019 15:43:59 +0200
Message-Id: <20190308134405.21921-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
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
  trace-cmd: Fix "trace-cmd reset" command to restore the default value
    of tracing_max_latency

 tracecmd/trace-record.c | 123 ++++++++++++++++++++++++----------------
 1 file changed, 73 insertions(+), 50 deletions(-)

-- 
2.20.1

