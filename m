Return-Path: <SRS0=hb2W=TX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0218C282DE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 942A920665
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbfEWPSm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 May 2019 11:18:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39436 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730741AbfEWPSl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 May 2019 11:18:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id w8so6729065wrl.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 May 2019 08:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xeh88u0n9Dgpc1TEnoPPgtoL4N2PgN32rPw/sHtcX/M=;
        b=LC6Um7RpkwqGAuBcujPdqgHN9Ij9J8zgZgxGKOhC93JrN3Aaues4kWbSFA5VdKVaet
         6Z/bKiSi12Vl8+QGGE68pZG/8ZLEVnuSQzTeYCN6D6VH/F6xl9AF36LJsN5iRKHKC4y+
         ap/kWblf1eFhrrsZ0iL1epjDPzk00g+Iu1jrPH7L0FYlCtThUjgwF27ACGV4drKZgJ4A
         mdhTnsIPBpTOx00+VJwEbFrLpdhl54tAj8io+iStQfeeXhpbIYfB5MoPwWXWZF0Li+fs
         gZ+s1XgEjfnCkemzMmaUyhUBbvEjLAIzlOpIYL2GzopKj823d8YYIB0Fs9C1r8uRxvhH
         KM8A==
X-Gm-Message-State: APjAAAWvGh5NVybr6uGOLZ2jATPNtI46tiBOIL6vjIaeQt8CuG2TAfbj
        n2SQJn0vwyGOEM1XgrvriYo=
X-Google-Smtp-Source: APXvYqwAgx7YbLqhDMnAP0iB6tDr5HM5U9mGIchwE5mBI73ZO8Nq2l9SUfRPBcaiD4WWZvQ0sOb73w==
X-Received: by 2002:adf:eb09:: with SMTP id s9mr1786550wrn.127.1558624720106;
        Thu, 23 May 2019 08:18:40 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x9sm12687071wmf.27.2019.05.23.08.18.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:18:39 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/5] Nodifications needed by the NumPy interface
Date:   Thu, 23 May 2019 18:18:07 +0300
Message-Id: <20190523151812.31391-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set contains various modifications needed in order to implement
a standalone version of the NumPy data interface. Although those changes
are not strictly required for KS 1.0 it will be great if at least
patches 1-3 can go upstream befor the release. 

Yordan Karadzhov (5):
  kernel-shark: Add new dataloading method to be used by the NumPu
    interface
  kernel-shark: Use full paths for non-standard library headers
  kernel-shark: Use the shared versions of the trace-cmd libraries.
  trace-cmd: Install public interface headers
  kernel-shark: Install public interface headers

 Makefile                              |  26 +++--
 include/trace-cmd/trace-cmd.h         |   2 +-
 include/traceevent/event-parse.h      |   2 +-
 kernel-shark/CMakeLists.txt           |   3 +-
 kernel-shark/README                   |   4 +
 kernel-shark/build/FindTraceCmd.cmake |  40 +++----
 kernel-shark/src/CMakeLists.txt       |  42 ++++++-
 kernel-shark/src/libkshark-plugin.h   |   2 +-
 kernel-shark/src/libkshark.c          | 155 ++++++++++++++++++++++++++
 kernel-shark/src/libkshark.h          |  16 ++-
 10 files changed, 250 insertions(+), 42 deletions(-)

-- 
2.20.1

