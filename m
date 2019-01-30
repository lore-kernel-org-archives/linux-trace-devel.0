Return-Path: <SRS0=bjmZ=QG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C700C282D7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 680A320857
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfA3Koa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:44:30 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:39966 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfA3Ko3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jan 2019 05:44:29 -0500
Received: by mail-wr1-f48.google.com with SMTP id p4so25486530wrt.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jan 2019 02:44:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hi1EwgWkkryxcFhn6fonOYI9HW+p2QPW9vfnHELXjmE=;
        b=f6M1E/IbfP/xmp7epQ4aM5g3+showKd4ubXWoKtkyK8Q0CwKYCOFAXNT7ELLWqpe+5
         svHYuPEavPW3KooQZzANqP7GJCaWnWpC0Ya/33XS4UzVStfxhHo2j8Qu2myeFAi3UwaP
         EP5jQ8poM9FwcTSEU3e8RIGikeVuHswajqhd3SwYNM7j9ZH6l0Ev7IPbPq93kfBJhPiZ
         IGMnpeOr6t/ocZKuTJVG9bUHBCb6ib+JbJDwPlFT2kmtl6ar9taP2N6+7wOcYvImS8LD
         DCbO1r/xTeHk2XgerkBWCTBTE0mRHdmYqTfJocC05+lzjI9Coh8CnBcqJEQKcEqR0cs1
         j+Yw==
X-Gm-Message-State: AJcUukdGmM4Lt87GDe2UCQzpRE9PBpZpkC7FmItgZwCMU/51bmkCdEBg
        EFWGjXg5q7oOzngnMgg3cYignczx
X-Google-Smtp-Source: ALg8bN6K9C7avK80+I26VKrRZwbPWQkksjfyB3v18x/ho6snte5EPp2lVkuE4+wMYZhrcMHyaVocRQ==
X-Received: by 2002:adf:f449:: with SMTP id f9mr30306021wrp.40.1548845067254;
        Wed, 30 Jan 2019 02:44:27 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w12sm503079wrr.23.2019.01.30.02.44.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 02:44:26 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/6] Few patches, backported from Arnaldo's kernel repo
Date:   Wed, 30 Jan 2019 12:44:19 +0200
Message-Id: <20190130104425.8813-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Few patches, backported from Arnaldo's kernel repo. The patch series 
was merged upstream on 8th of Januari.

Tzvetomir Stoyanov (6):
  trace-cmd: Initialize host_bigendian at tep_handle allocation
  trace_cmd: Rename struct cmdline to struct tep_cmdline
  trace-cmd: Changed return logic of trace_seq_printf() and
    trace_seq_vprintf() APIs
  trace-cmd: Changed return logic of tep_register_event_handler() API
  trace-cmd: Rename tep_is_file_bigendian() to tep_file_bigendian()
  trace-cmd: Remove tep_data_event_from_type() API

 include/traceevent/event-parse.h   | 16 +++++---
 kernel-shark/src/libkshark.c       |  7 ++--
 lib/trace-cmd/trace-input.c        |  8 ++--
 lib/traceevent/event-parse-api.c   |  4 +-
 lib/traceevent/event-parse-local.h |  4 +-
 lib/traceevent/event-parse.c       | 62 ++++++++++++++----------------
 lib/traceevent/trace-seq.c         | 17 +++++---
 plugins/plugin_kvm.c               |  2 +-
 python/tracecmd.py                 | 10 ++---
 tracecmd/trace-hist.c              |  4 +-
 tracecmd/trace-mem.c               |  2 +-
 tracecmd/trace-output.c            |  2 +-
 tracecmd/trace-read.c              |  7 ++--
 tracecmd/trace-record.c            |  2 +-
 tracecmd/trace-split.c             |  2 +-
 15 files changed, 78 insertions(+), 71 deletions(-)

-- 
2.20.1

