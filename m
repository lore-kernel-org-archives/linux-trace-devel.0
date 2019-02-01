Return-Path: <SRS0=aEXj=QI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADECBC282D8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88CEB2084C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbfBANpj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Feb 2019 08:45:39 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46802 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbfBANpi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Feb 2019 08:45:38 -0500
Received: by mail-wr1-f66.google.com with SMTP id l9so7093478wrt.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Feb 2019 05:45:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p2//js79pLxhpVF9Jw51UC40lTtNJ2kFWRwT4sXdDec=;
        b=i5wlR48dGVqsUf4desMAfhEgG5aKqt6pamCM4sK8q5uG7UCClXjtR8IAt3/x6v7Bbf
         Zeg96K1l6Y5lJdt1pZSPFi8dPhL7p1GjG3k8y2ctW0r4EJZpIaJSIhm8Z7xINeWWRYux
         R41zqiUArvySlc4ZI2kIEFF35a8jVWOoE0OZLwnsF1Up/3BwEWdBeZQkEGwztlRu9FXi
         Kfjh/q3v3hmOZIwha3XA1ou9i+ySENmZF1H8NGoDhSWoBVe7tC8jhTatGANfZ5q4+KXk
         VFP3VTmJZvF22tqwIHRchTxkkS5h7cTVEfwCV8E3OxC+na7G22B6e8pK4xp+T8ey90hI
         mJ7A==
X-Gm-Message-State: AHQUAubkuzYi74QicHa8wGpPyGfWsGsrmRPFBS3TDrrkU3F3NOGUvqOj
        6BxnuQPHL2/1MdIeYTsZ+x9EhtYs
X-Google-Smtp-Source: AHgI3Ib2OzEy+SegRoKSEKWEMCb1diSHw8EJdlJFsCaW01+P8Xq/n9QRd0z0NZBl1WvJctcypneiFQ==
X-Received: by 2002:a05:6000:10d1:: with SMTP id b17mr24261282wrx.306.1549028737171;
        Fri, 01 Feb 2019 05:45:37 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v26sm1468732wrv.78.2019.02.01.05.45.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Feb 2019 05:45:36 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/6][POC] trace-cmd: Timetamps sync using PTP-like algorithm, relying on vsock events.
Date:   Fri,  1 Feb 2019 15:45:29 +0200
Message-Id: <20190201134535.2979-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[ V2 changes: 
   Addressed Steven Rostedt comments.
   Modified timestamps sync algorithm to gain more accuracy, with the 
   help of Yordan Karadzhov and Slavomir Kaslev. ]

This patch series is a POC for timestamps sync between guest and host machines.
It implelents PTP-like algorithm, using vsock events for getting the current time.

The patch series depends on Slavomir's changes, introduced by the patch series
"Add VM kernel tracing over vsock sockets"

Tzvetomir Stoyanov (6):
  trace-cmd: Implemented new lib API: tracecmd_local_events_system()
  trace-cmd: Added support for negative time offsets in trace.dat file
  trace-cmd: Fixed logic in tracecmd_read_page_record()
  trace-cmd: Added implementation of htonll() and ntohll()
  trace-cmd: Refactored make_instances() and tracecmd_remove_instances()
  trace-cmd [POC]: Implemented timestamps synch PTP-like algorithm,
    using vsock events.

 include/trace-cmd/trace-cmd.h  |   8 +-
 lib/trace-cmd/trace-input.c    |  18 +-
 lib/trace-cmd/trace-util.c     |  99 ++++++---
 tracecmd/include/trace-local.h |   5 +
 tracecmd/include/trace-msg.h   |  10 +
 tracecmd/trace-listen.c        |   3 +
 tracecmd/trace-msg.c           | 307 +++++++++++++++++++++++++-
 tracecmd/trace-read.c          |   4 +-
 tracecmd/trace-record.c        | 381 +++++++++++++++++++++++++--------
 9 files changed, 690 insertions(+), 145 deletions(-)

-- 
2.20.1

