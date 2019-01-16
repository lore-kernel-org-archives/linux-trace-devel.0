Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B9AC43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9512020866
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfAPTSm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 14:18:42 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43212 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730169AbfAPTSm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 14:18:42 -0500
Received: by mail-wr1-f65.google.com with SMTP id r10so8236701wrs.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 11:18:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pHy7RdBh6KmpLnrgx7ilUPigbQ8FsprILr4FZVLcDdY=;
        b=Q7RQ3gHJJd7URS5Pt9xyBXmvKcLmrS7a4J+Vyy3X4MTY5x5uzFCNtFJd0ShEI9ziWM
         Y4VBcuhhs0FBBFfNJBOqA7RvS2u9fvq2cfZdiYtsu+DZCMyiAyd+b/okL6Vi2rTBKrX3
         soZYohOpCCc0nEWegIJnuoE28nT+ybNWNJOYfefvjzE4WqY1Wr5E98u08eibOognmeZz
         KbRFWEDOaKLIO5XcaoDCGAxImj3rz872DD1aOj8+J3BAU7HgBzsFF4fxDmR+TRRAt/Yq
         uRldAAc514YDd9GDugpkPhayRJZvnVVJJbPUWclfVScPVdnBpQHYOI00Pwza3ET8wfI4
         bNBQ==
X-Gm-Message-State: AJcUukeaqGONNWLnp10RVdBKtV7zNgutXVF6y+2CNecyODRNkd/nYqDg
        4I3rqKUcTbugMtAvTlxtEs7po9RS
X-Google-Smtp-Source: ALg8bN77/l5hRjQXriQSLuujyXHyRQj7EI0c41k28cHJ6MNRXJaoJyxS3oafe06ijI8doWxBVFZjpg==
X-Received: by 2002:adf:bb8d:: with SMTP id q13mr8697636wrg.183.1547666320492;
        Wed, 16 Jan 2019 11:18:40 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm98393345wrx.50.2019.01.16.11.18.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 11:18:39 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/7] trace-cmd [POC]: Timestamps sync using PTP-like algorithm, relying on vsock events.
Date:   Wed, 16 Jan 2019 21:18:31 +0200
Message-Id: <20190116191838.32127-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch series is a POC for timestamps sync between guest and host machines. 
It implelents PTP-like algorithm, using vsock events for getting the current time. 
Best results are achieved when "boot" clock is used on both host and guest when
recording the events.
The patch series depends on Slavomir's changes, introduced by the patch series
"Add VM kernel tracing over vsock sockets"

Tzvetomir Stoyanov (7):
  trace-cmd: Implemented new lib API: tracecmd_local_events_system()
  trace-cmd: Added new option in trace.dat file for negative time
    offsets
  trace-cmd: Fixed logic in tracecmd_read_page_record()
  trace-cmd: Added implementation of htonll() and ntohll()
  trace-cmd: Added user configured clock to the record context
  trace-cmd: Refactored make_instances() and tracecmd_remove_instances()
  trace-cmd [POC]: Implemented timestamps synch PTP-like algorithm,
    using vsock events.

 include/trace-cmd/trace-cmd.h  |   7 +
 lib/trace-cmd/trace-input.c    |  19 +-
 lib/trace-cmd/trace-util.c     |  89 +++++---
 tracecmd/include/trace-local.h |   5 +
 tracecmd/include/trace-msg.h   |  10 +
 tracecmd/trace-listen.c        |   3 +
 tracecmd/trace-msg.c           | 311 ++++++++++++++++++++++++++-
 tracecmd/trace-record.c        | 380 +++++++++++++++++++++++++--------
 8 files changed, 685 insertions(+), 139 deletions(-)

-- 
2.20.1

