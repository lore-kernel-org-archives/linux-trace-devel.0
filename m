Return-Path: <SRS0=pFV5=55=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99534C2BA19
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 08:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69DC6206E9
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Apr 2020 08:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n719eV9I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgDMI35 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 04:29:57 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:34198 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgDMI35 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 04:29:57 -0400
Received: by mail-wr1-f45.google.com with SMTP id d27so153053wra.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Apr 2020 01:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8uaOkRKdLJs3YM+Vb8851VPenW7Ew1FwCTl2rpf6wGE=;
        b=n719eV9Iz2GpefwxlvguiVzRqbnY0/V7wq5Yr9ZKazpm/d8AGbIuzy7rLfgqomLLhM
         D6jQCn/20dZU+JCjWniEPcIWpBykzaZceWyCLFrDDpIERxmwWT4nYEpT1fhGYQ5V9MGW
         9oFGvpJYR5XWb4NJLFMmF9qFDTYBni+1FwRbVFxYlIKKsIP0ewdxX9EtDoi7AGeaNXmw
         o1an9r0Z+O+fI0izrivywnnqJnSVa0eSwMRRnZRG/bShOCUBPvq4c4Pcdb0oolt3jqtD
         9quWT0cUJrmjwHpFZ98uSTEugngbkbrp61pAkLbIbWLPWpuyA2baR5k0V0e3tU2OJUI8
         I9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8uaOkRKdLJs3YM+Vb8851VPenW7Ew1FwCTl2rpf6wGE=;
        b=AZ+lMEzRVkbLdhU4+1IY7FibIURCDX4qHi33I3OCDMQNUtaI9QWQXoVPBMYGcQRv5L
         3IUYGeEEwYQW5lgHYL6AAaRS+uye7HyMQ2lOpdpazxeqkiC6oXIzZn8ByNVvAgcTcxUT
         L7cyCd5SCbKYjX1879tKvt53i9qEqLe3u5OaH7r7P7AFIpgkf6cSbW03TD/gAJqN6oxq
         w7wXQWCahnBbPhEmS8pA75w4z13QxXNqgY2sl3mCW+m5RDzHdnWlTN7u7fT7IBqiz7cP
         6JJAFkF/XndjwkEktjDX5grkUgYqbbKQovrnHVVDc92RTyGE3u6qIytamgUV4Brp6Q9y
         7CnA==
X-Gm-Message-State: AGi0PuZziBblKyjb9GiUF1Luenq6E6+aLjs1eaDCGjVwstj4/oDN76zg
        5dtORsKUnfRmPgwVxAt0cwpZM3cCA1s=
X-Google-Smtp-Source: APiQypJ1uAvaRgf/NjDqF1q2MsThc+IrRkRtPeyjDXa+ljt9HoI4xfe2EDy4b2PzQIPhSCh6Jwl57A==
X-Received: by 2002:a2e:9b41:: with SMTP id o1mr10099170ljj.145.1586766217344;
        Mon, 13 Apr 2020 01:23:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b9sm9463605lfp.27.2020.04.13.01.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 01:23:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/2] Useful APIs for merging tracing files
Date:   Mon, 13 Apr 2020 11:23:32 +0300
Message-Id: <20200413082334.164158-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Helper APIs, used when opening and merging files from same tracing
session.

[
 v2 changes:
  - Renamed tracecmd_set_merge_peer() to tracecmd_pair_peer()
    and introduced tracecmd_unpair_peer() 
]

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Add new APIs to pair and unpair tracing peers
  trace-cmd: Validate input parameters of tracecmd_get_guest_cpumap()
    API

 include/trace-cmd/trace-cmd.h |   3 +
 lib/trace-cmd/trace-input.c   | 104 +++++++++++++++++++++++++++++++---
 2 files changed, 100 insertions(+), 7 deletions(-)

-- 
2.25.1

