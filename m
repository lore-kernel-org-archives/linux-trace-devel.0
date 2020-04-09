Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F268C2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54E712072F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gudBge8W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgDIN22 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:28 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:35239 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgDIN22 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:28 -0400
Received: by mail-lf1-f53.google.com with SMTP id r17so7902966lff.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=58L4GpnaPjRNGVPhlUfyZpl00NbWoQq4gRnxUViPD3I=;
        b=gudBge8WDRdFwKHjVEf9jRBp1Tteo6i3A53gVDg+wfuL6EhQrwPR/vcIiYKQKAoJ2p
         OrO1o7rN1YjVpoc1Oh0eiOFCNeMFwIemcaaK258GMPhoiBeO8cG1G/8yUMOF4LGVI/a8
         FtAZntJBVIYSeZlhHr96SrDdmcpGl4oPJZ7a2bs73KST143tFdTWTDd6i0stZfuLsrMg
         Zb/Ca7Ns7OSmC6gEvrmxZIBR/C9iBGTxWk4iD3WJozQ029C/IAot7CAxhq6MEUc2XgU8
         Iki77FtE1jc2RR4iRXg18if/4VkOqAnoNkugNnQxklaRONVHzk6rZ5YhApw6rwTpUaeZ
         t2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=58L4GpnaPjRNGVPhlUfyZpl00NbWoQq4gRnxUViPD3I=;
        b=opo1xbf09b32gBiv006yjTNSXcJ+X2M+oCwOAxD4g6DrVA3M4NCSx9+O0nSX9bkjYv
         QzZWUQsiMZrWYjXmWTxPziDtqrdLcndA5BOCteM+45uNCH+EOohl+teBmv9EFhrTL331
         ku8jffUM2iDH7W/XxugRG76vaIkpcDkooBR6LDYB8KkT4YBrK2jKTHRGfDkDZQaZ7u1w
         FSWfvnCj/3pVSlq6U4Gx2sgM2Eis1T/eBZxIC7brrKcHjV8aSIoG3d99ywAhXD22Xgmz
         QT5V4oZZDKEf/dgDSgQoQwBUnClfu11/Hol9woO6uxny8Y72lpsRf0Yhc7WwR0Zl8kVp
         hMvg==
X-Gm-Message-State: AGi0PuZ6sV1tfHfzy1r/K2De/QOfnLWLockVWoOGLQFZ76oH9q2TBWzp
        0oXYY+pyqmCPJdjwqwnA9Hw=
X-Google-Smtp-Source: APiQypKc9cgpjDx+3l4LPQ3qrzOBDaFPkJUgZPslr7jtktUZ8q2mjFb94EwHED0Ow+KznweNRPnILg==
X-Received: by 2002:ac2:5192:: with SMTP id u18mr7716320lfi.114.1586438907544;
        Thu, 09 Apr 2020 06:28:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 64sm15237121ljj.41.2020.04.09.06.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:28:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Split reading the trace.dat options from trace data
Date:   Thu,  9 Apr 2020 16:28:23 +0300
Message-Id: <20200409132825.79475-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add functionality which allows to implement opening a trace file on
stages - reading the trace headers and reading the trace data.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Move reading of trace.dat options to
    tracecmd_read_headers()
  trace-cmd: Add new API tracecmd_open_head()

 include/trace-cmd/trace-cmd.h |   2 +
 lib/trace-cmd/trace-input.c   | 117 +++++++++++++++++++++++++---------
 2 files changed, 90 insertions(+), 29 deletions(-)

-- 
2.25.1

