Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6F5C10F12
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 10:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29F8720684
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 10:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfDOKnw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 06:43:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33523 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfDOKnv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 06:43:51 -0400
Received: by mail-wr1-f65.google.com with SMTP id q1so21309289wrp.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 03:43:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t/MbHsWEdui/G9blIqPB80dIGiCb/dQ8o0zBb3qoh2I=;
        b=EVxMYW8KiS/SzfpF/zDjkvb+xOofZ29JVExuBJ8ZOdZuUoFoN4SZQkFOjhdncqHB8u
         WC2IBVGkOggOlZ/lKoSttduxHbG/6BnIoXupVJiz3U2XaKyfv26jWxSw2S46HPJSnLPj
         jZaUQsmkeHJBT09x2EBdrSPdM3pz7I0OSLuTD+mKlAyA0u0uCwd/buAunte7GcmlI4rb
         H8O+e5+gIAEFdcpNosH4vHtKazOY6xfJBho3X6reGKSQ2fNSwFVe+Db1LgbyX086R9dM
         QM80AwxmCPNS7MGmWgjyR2KEPOxe5USa+Un2z+qFOUq0vDCZ3EWvq1imySBopTD+z3St
         ZEsw==
X-Gm-Message-State: APjAAAWmIpxWI0GJlWQV3lgDPrxq8JX5Da5vP6qGcYhC2AnjQve4R27h
        6R8aZ+h+r3s84TLmrnEmNg==
X-Google-Smtp-Source: APXvYqztC+q/TPp9i/qzSUYAPFRF8rWstLkL4zJj5G31eFDpQukC1JVm5C4BJAO7VsAixrq3pWugsA==
X-Received: by 2002:adf:e683:: with SMTP id r3mr50075368wrm.286.1555325030038;
        Mon, 15 Apr 2019 03:43:50 -0700 (PDT)
Received: from localhost.localdomain ([151.251.250.145])
        by smtp.gmail.com with ESMTPSA id y17sm60463430wrh.60.2019.04.15.03.43.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 03:43:49 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: [PATCH 0/2] Optimize pid filters and add --no-filter option
Date:   Mon, 15 Apr 2019 13:43:41 +0300
Message-Id: <20190415104343.31113-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset optimizes how pid filters are expressed and makes it less likely
that we overflow ftrace filters' size limit of one page.

Slavomir Kaslev (2):
  trace-cmd: Optimize how pid filters are expressed
  trace-cmd: Add --no-filter option to not filter recording processes

 tracecmd/trace-record.c | 126 +++++++++++++++++++++++++++-------------
 tracecmd/trace-usage.c  |   1 +
 2 files changed, 87 insertions(+), 40 deletions(-)

-- 
2.19.1

